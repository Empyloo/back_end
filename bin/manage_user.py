import os
import json
import requests
import click
from dotenv import load_dotenv

load_dotenv()

url = os.getenv("SUPABASE_URL") + "/auth/v1/signup"
headers = {
    "apikey": os.getenv("ANON_KEY"),
    "Content-Type": "application/json"
}


def get_user_by_email(email):
    response = requests.get(os.getenv(
        "SUPABASE_URL") + f"/rest/v1/users?select=id&email=eq.{email}", headers=headers)
    users = response.json()
    if len(users) == 0:
        return None
    return users[0]


@click.group()
def cli():
    pass


@cli.command()
@click.option("--email", default="someone@email.com", help="Email of the user to create.")
@click.option("--password", default="password123", help="Password for the user.")
def create(email, password):
    response = requests.get(os.getenv(
        "SUPABASE_URL") + "/rest/v1/companies?select=id&name=eq.Empylo", headers=headers)
    empylo_id = response.json()[0]["id"]

    data = {
        "email": email,
        "password": password,
        "data": {
            "role": "super_admin",
            "company_name": "Empylo",
            "company_id": empylo_id
        }
    }

    response = requests.post(url, headers=headers, data=json.dumps(data))
    print(response.text)


@cli.command()
@click.option("--email", default="someone@email.com", help="Email of the user to delete.")
def delete(email):
    user = get_user_by_email(email)
    if user is None:
        print(f"User with email '{email}' not found.")
        return
    headers.update(
        {"Authorization": f"Bearer {os.getenv('SERVICE_ROLE_KEY')}"}
    )
    print(user)
    response = requests.delete(
        os.getenv("SUPABASE_URL") + f"/auth/v1/admin/users/{user['id']}", headers=headers)
    print(response.text)


if __name__ == "__main__":
    cli()
