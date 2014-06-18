$(document).ready(function(){
  if($('#editor').length !== 0){
    editor = ace.edit("editor");
    var textarea = $('.ace_text_area');
    editor.getSession().setValue(textarea.val());
    editor.getSession().setMode("ace/mode/sql");
    textarea.hide();
    editor.getSession().on('change', function(){
      textarea.val(editor.getSession().getValue());
    });
  }

  $('input.datepicker').datepicker();

  $('.show_add_tag_form').on("click", function(){
    $(this).hide();
    $('.add_tag_form').show();
  });

});