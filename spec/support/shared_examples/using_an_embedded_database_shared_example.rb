shared_examples 'using an embedded database' do
  before :all do
    choose 'chooseDatabaseType_dbChoiceembeddedDb'
    find('input#chooseDatabaseType_save').trigger('click')
  end

  it { is_expected.to have_current_path %r{/setup/setupEmbeddedDatabase.action} }

  it { is_expected.to have_current_path %r{/setup/setupSelectImport.action} }
  it { is_expected.to have_css 'form#performImportData' }
  it { is_expected.to have_css 'input#performImportData_save' }
  it { is_expected.to have_selector :radio_button, 'performImportData_dataOptionclean' }
  it { is_expected.to have_button 'Continue' }
end
