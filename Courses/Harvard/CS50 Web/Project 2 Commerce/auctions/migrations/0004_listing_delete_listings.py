# Generated by Django 4.2.4 on 2023-09-13 17:33

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('auctions', '0003_listings_category_alter_listings_image_url'),
    ]

    operations = [
        migrations.CreateModel(
            name='Listing',
            fields=[
                ('id', models.BigAutoField(primary_key=True, serialize=False)),
                ('title', models.CharField(max_length=128)),
                ('description', models.TextField(max_length=1000)),
                ('bid', models.DecimalField(decimal_places=2, max_digits=10)),
                ('image_url', models.TextField(blank=True, max_length=1000, null=True)),
                ('category', models.CharField(blank=True, max_length=64, null=True)),
                ('user_id', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.DeleteModel(
            name='Listings',
        ),
    ]
