# back_end
Empylo backend code base.

## Getting Started
To upgrade `brew upgrade supabase`

Make sure to have docker running on your machine.
`supabase start` will start the supabase server and the postgres database.
`supabase start --ignore-health-check` will start the supabase server and the postgres database without checking the health of the database.

`supabase link --project-ref <project_ref>` will link the local database to the remote database.

Dump the schema from the remote database to the local database.
`supabase db dump -f <file_name.sql>`

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

This updates the local database adding the trigger or whatever new changes you made.
**Note:** This is when you would run the app locally connecting to the local 
database and test the changes.
<br>

To apply the migration to the remote database
```
supabase db push
```
**Note:** If the push fails, you can make changes to the migration file and `supabase db reset` to reset the local database and try `supabase db push` again.

If the `push` is successful but issues arise, such as missing procedures, functions, tables or columns, a new migration file must be created. Any previously created elements should be dropped and modifications made in the new migration file until the issues are resolved.

<br>

---
### Linking to remote database and pushing changes

The supabase project has to be linked and the password is added to the push
command through a flag.
```
supabase db link --project-ref <project_ref>
supabase db push --p <password>
```

### Dump Remote Schema

To dump the remote schema, run the following command:

```
supabase db dump -f <file_name.sql>
```

## User Management CLI Tool

### Usage

This CLI tool provides two commands:

### Create User

To create a user, run the following command:
`python bin/manage_user.py create`

### Delete User

To delete a user, run the following command:
`python bin/manage_user.py delete`
