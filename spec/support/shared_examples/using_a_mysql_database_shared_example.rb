shared_examples 'using a MySQL database' do
  describe 'choosing MySQL as external database' do
    before :all do
      choose 'chooseDatabaseType_dbChoicestandardDb'
      select 'MySQL', from: 'selectedDatabase'
      find('input#chooseDatabaseType_save').trigger('click')
    end

    it { is_expected.to have_current_path %r{/setupDatabaseConnection.action} }
    it { is_expected.to have_css 'form#performSetupDatabaseConnection' }
    it { is_expected.to have_css 'input#performSetupDatabaseConnection_save' }
    it { is_expected.to have_field 'dbConfigInfo.databaseUrl' }
    it { is_expected.to have_field 'dbConfigInfo.userName' }
    it { is_expected.to have_field 'dbConfigInfo.password' }
    it { is_expected.to have_button 'Continue' }
  end

  describe 'setting up JDBC Configuration' do
    before :all do
      within 'form#performSetupDatabaseConnection' do
        fill_in 'dbConfigInfo.databaseUrl', with: "jdbc:mysql://#{@container_db.host}/bamboodb??autoReconnect=true&sessionVariables=storage_engine%3DInnoDB&useUnicode=true&characterEncoding=utf8"
        fill_in 'dbConfigInfo.userName', with: 'root'
        fill_in 'dbConfigInfo.password', with: 'mysecretpassword'
        find('input#performSetupDatabaseConnection_save').trigger('click')
      end
    end

    it { is_expected.to have_current_path %r{/setup/setupSelectImport.action} }
    it { is_expected.to have_css 'form#performImportData' }
    it { is_expected.to have_css 'input#performImportData_save' }
    it { is_expected.to have_button 'Continue' }
    it { is_expected.to have_selector :radio_button, 'performImportData_dataOptionclean' }
  end
end
