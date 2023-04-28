desc "Populate database from user records!"

task populate_users: :environment do
  PopulateUsersJob.perform_later
end