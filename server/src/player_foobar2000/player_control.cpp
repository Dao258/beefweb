#include "player.hpp"

namespace msrv {
namespace player_foobar2000 {

namespace {

class TrackQueryImpl : public TrackQuery
{
public:
    TrackQueryImpl(TitleFormatVector columnsVal)
        : columns(std::move(columnsVal))
    {
    }

    TitleFormatVector columns;
};

}

std::vector<std::string> PlayerImpl::evaluatePlaybackColumns(const TitleFormatVector& compiledColumns)
{
    std::vector<std::string> result;
    result.reserve(compiledColumns.size());

    pfc::string8 buffer;

    for (auto& compiledColumn : compiledColumns)
    {
        auto ret = playbackControl_->playback_format_title(
            nullptr,
            buffer,
            compiledColumn,
            nullptr,
            playback_control::display_level_all);

        if (!ret)
        {
            result.clear();
            return result;
        }

        result.emplace_back(buffer.get_ptr(), buffer.get_length());
    }

    return result;
}

PlaybackState PlayerImpl::getPlaybackState()
{
    if (playbackControl_->is_paused())
       return PlaybackState::PAUSED;
    
    if (playbackControl_->is_playing())
        return PlaybackState::PLAYING;

    return PlaybackState::STOPPED;
}

void PlayerImpl::queryVolume(VolumeInfo* volume)
{
    volume->db = playbackControl_->get_volume();
    volume->dbMin = playback_control::volume_mute;
    volume->isMuted = playbackControl_->is_muted();
}

void PlayerImpl::queryActiveItem(ActiveItemInfo* info, TrackQuery* queryPtr)
{
    t_size activePlaylist;
    t_size activeItem;

    info->position = playbackControl_->playback_get_position();
    info->duration = playbackControl_->playback_get_length_ex();

    if (queryPtr)
    {
        info->columns = evaluatePlaybackColumns(
            static_cast<TrackQueryImpl*>(queryPtr)->columns);
    }

    if (playlistManager_->get_playing_item_location(&activePlaylist, &activeItem))
    {
        info->playlistId = playlists_.getId(activePlaylist);
        info->playlistIndex = activePlaylist;
        info->index = activeItem;
    }
    else
    {
        info->playlistIndex = -1;
        info->index = -1;
    }
}

PlayerStatePtr PlayerImpl::queryPlayerState(TrackQuery* activeItemQuery)
{
    playlists_.ensureInitialized();

    auto state = std::make_unique<PlayerState>();

    state->playbackState = getPlaybackState();
    queryVolume(&state->volume);
    queryActiveItem(&state->activeItem, activeItemQuery);

    return state;
}

void PlayerImpl::playCurrent()
{
    playbackControl_->play_or_unpause();
}

void PlayerImpl::playItem(const PlaylistRef& playlist, int32_t itemIndex)
{
}

void PlayerImpl::playRandom()
{
    playbackControl_->start(playback_control::track_command_rand);
}

void PlayerImpl::playNext()
{
    playbackControl_->next();
}

void PlayerImpl::playPrevious()
{
    playbackControl_->previous();
}

void PlayerImpl::stop()
{
    playbackControl_->stop();
}

void PlayerImpl::pause()
{
    playbackControl_->pause(true);
}

void PlayerImpl::togglePause()
{
    playbackControl_->toggle_pause();
}

void PlayerImpl::setMuted(Switch val)
{
    switch (val)
    {
    case Switch::FALSE:
        if (playbackControl_->is_muted())
            playbackControl_->volume_mute_toggle();
        break;

    case Switch::TRUE:
        if (!playbackControl_->is_muted())
            playbackControl_->volume_mute_toggle();
        break;

    case Switch::TOGGLE:
        playbackControl_->volume_mute_toggle();
        break;
    }
}

void PlayerImpl::seekAbsolute(double offsetSeconds)
{
    playbackControl_->playback_seek(offsetSeconds);
}

void PlayerImpl::seekRelative(double offsetSeconds)
{
    playbackControl_->playback_seek_delta(offsetSeconds);
}

void PlayerImpl::setVolumeDb(double val)
{
    playbackControl_->set_volume(static_cast<float>(val));
}

void PlayerImpl::setVolumeAmp(double val)
{
}

TrackQueryPtr PlayerImpl::createTrackQuery(const std::vector<std::string>& columns)
{
    return std::make_unique<TrackQueryImpl>(compileColumns(columns));
}

}}