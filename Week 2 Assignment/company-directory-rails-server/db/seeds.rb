d = Department.create(:name => "Sales")

d.employees.create(:name => "Test Employee", :job_title => "Foobar", :birthday => Date.today, :salary => 100000)