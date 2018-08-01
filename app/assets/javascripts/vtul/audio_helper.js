AudioHelper = {
  audioPlayer: null,
  $audioList: null,
  init: function() {
    this.audioPlayer = document.getElementById("audio-player");
    this.$audioList = $('#compel-audio-controls > li > a.play-trigger');
    this.setListener();
  },
  setListener: function() {
    var _this = this;
    this.$audioList.click(function(event){
      event.preventDefault();
      var audioID = $(event.target).data('audio_id');
      _this.playAudio(audioID);
    });
  },

  playAudio: function(audioID) {
    var link = "/downloads/" + audioID;
    this.audioPlayer.src = link;
    this.audioPlayer.pause();
    this.audioPlayer.load();
    this.audioPlayer.play();
  }
}
