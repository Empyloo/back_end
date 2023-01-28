# back_end
Empylo backend code base.

## Getting Started
Diff between remote and local
```
supabase db diff --use-migra -f new_migration
```

### Manually write a migration file

Create a new migration file
```
supabase migration new <add_trigger>
```

Add changes to the migration file
```
create trigger <trigger_name> after insert on <table_name> for each row execute
procedure <function_name>();
```

Apply the migration
```
supabase db reset
```
---
This updates the local database adding the trigger or whatever new changes you made.
**Note:** This is when you would run the app locally connecting to the local 
database and test the changes.
---

To apply the migration to the remote database
```
supabase db push
```

### Linking to remote database and pushing changes

The supabase project has to be linked and the password is added to the push
command through a flag.
```
supabase db link --project-ref <project_ref>
supabase db push --p <password>
```