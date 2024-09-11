program medTest;

uses
  Vcl.Forms,
  unMain in 'unMain.pas' {FormMain},
  unMedCart in 'model\unMedCart.pas',
  unRepository in 'model\unRepository.pas',
  unFrameMedCart in 'unFrameMedCart.pas' {FrameMedCart: TFrame},
  unGlobalConst in 'unGlobalConst.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
