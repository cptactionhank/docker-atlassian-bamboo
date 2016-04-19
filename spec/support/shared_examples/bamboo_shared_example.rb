shared_examples 'an acceptable Atlassian Bamboo instance' do |database_examples|
  describe 'Going through the setup process' do
    before :all do
      until current_path =~ %r{/setup/setupLicense.action}
        visit '/'
        sleep 1
      end
    end

    subject { page }

    context 'when visiting the root page' do
      it { is_expected.to have_current_path %r{/setup/setupLicense.action} }
      it { is_expected.to have_css 'form#validateLicense' }
      it { is_expected.to have_field 'licenseString' }
      it { is_expected.to have_button 'Custom installation' }
    end

    context 'when processing license setup' do
      before :all do
        within 'form#validateLicense' do
          fill_in 'licenseString', with: 'AAACLg0ODAoPeNqNVEtv4jAQvudXRNpbpUSEx6FIOQBxW3ZZiCB0V1WllXEG8DbYke3A8u/XdUgVQyg9ZvLN+HuM/e1BUHdGlNvuuEHQ73X73Y4bR4nbbgU9ZwFiD2IchcPH+8T7vXzuej9eXp68YSv45UwoASYhOeYwxTsIE7RIxtNHhwh+SP3a33D0XnntuxHsIeM5CIdwtvYxUXQPoRIF6KaC0FUGVlEB3v0hOAOWYiH9abFbgZith3i34nwOO65gsAGmZBhUbNC/nIpjhBWEcefJWelzqIDPWz/OtjmXRYv2XyqwnwueFkT57x8e4cLmbCD1QnX0UoKQoRc4EUgiaK4oZ2ECUrlZeay75sLNs2JDmZtWR8oPCfWZGwHAtjzXgIo0SqmZiKYJmsfz8QI5aI+zApuq6fqJKVPAMCPnNpk4LPW6kBWgkZb+kQAzzzS2g6Dnte69Tqvsr4SOskIqEFOeggz1v4zrHbr0yLJR8rU64FpQpVtBy1mZxM4CnHC9Faf8tKMnTF1AiXORFixyQaWto3RZ+ncWLXtMg6EnKZZRpmQNb2R8tnJXFulCfXmXLry7TrHBWn2HNVyH8WYxj9AzmsxiNL/R88Xg6rA1lVs4QpO5titxhplJcCY2mFFZLutAZVhKipm15/VhJx36YVqyN8YP7IaGC1+lwnJ7Q5pJpNmxk5hP3qovutY8Pi4E2WIJ59esnr1p+T6eD67teBVCHf+ga+ho4/4D9YItZDAsAhQ5qQ6pASJ+SA7YG9zthbLxRoBBEwIURQr5Zy1B8PonepyLz3UhL7kMVEs=X02q6'
          click_button 'Custom installation'
        end
      end

      it { is_expected.to have_current_path %r{/setup/setupGeneralConfiguration.action} }
      it { is_expected.to have_css 'form#setupGeneralConfiguration' }
      it { is_expected.to have_css 'input#setupGeneralConfiguration_save' }
    end

    context 'when processing general setup' do
      before :all do
        within 'form#setupGeneralConfiguration' do
          find('input#setupGeneralConfiguration_save').trigger('click')
        end
      end

      it { is_expected.to have_current_path %r{/setup/setupDatabase.action} }
      it { is_expected.to have_css 'form#chooseDatabaseType' }
      it { is_expected.to have_css 'input#chooseDatabaseType_save' }
      it { is_expected.to have_button 'Continue' }
    end

    context 'when processing database setup' do
      include_examples database_examples
    end

    context 'when selecting data to import' do
      before :all do
        within 'form#performImportData' do
          choose 'performImportData_dataOptionclean'
          find('input#performImportData_save').trigger('click')
        end
      end

      it { is_expected.to have_current_path %r{/setup/setupAdminUser.action} }
      it { is_expected.to have_field 'fullName' }
      it { is_expected.to have_field 'email' }
      it { is_expected.to have_field 'username' }
      it { is_expected.to have_field 'password' }
      it { is_expected.to have_field 'confirmPassword' }
      it { is_expected.to have_button 'Finish' }
      it { is_expected.to have_css 'form#performSetupAdminUser' }
      it { is_expected.to have_css 'input#performSetupAdminUser_save' }
    end

    context 'when processing administrative account setup' do
      before :all do
        within 'form#performSetupAdminUser' do
          fill_in 'fullName', with: 'Continuous Integration Administrator'
          fill_in 'email', with: 'jira@circleci.com'
          fill_in 'username', with: 'admin'
          fill_in 'password', with: 'admin'
          fill_in 'confirmPassword', with: 'admin'
          find('input#performSetupAdminUser_save').trigger('click')
        end
      end

      it { is_expected.to have_current_path %r{/setup/finishsetup.action} }
    end

    context 'when finishing the setup' do
      it { is_expected.to have_current_path %r{/start.action} }

      # The acceptance testing comes to an end here since we got to the
      # Bamboo without any trouble through the setup.
    end
  end

  describe 'Stopping the Atlassian Bamboo instance' do
    before(:all) { @container.kill_and_wait signal: 'SIGTERM' }

    subject { @container }

    it 'should shut down successful' do
      # give the container up to 5 minutes to successfully shutdown
      # exit code: 128+n Fatal error signal "n", ie. 143 = fatal error signal
      # SIGTERM.
      #
      # The following state check has been left out 'ExitCode' => 143 to
      # suppor CircleCI as CI builder. For some reason whether you send SIGTERM
      # or SIGKILL, the exit code is always 0, perhaps it's the container
      # driver
      is_expected.to include_state 'Running' => false
    end

    include_examples 'a clean console'
    include_examples 'a clean logfile', '/var/atlassian/bamboo/logs/atlassian-bamboo.log'
    include_examples 'a clean logfile', '/var/atlassian/bamboo/logs/emergency-atlassian-bamboo.log'
  end
end
