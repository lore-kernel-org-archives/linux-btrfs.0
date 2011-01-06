From: Freddie Cash <fjwcash@gmail.com>
Subject: Re: Synching a Backup Server
Date: Thu, 6 Jan 2011 13:58:41 -0800
Message-ID: <AANLkTimvyZ-jNCk9FVav8kw8oYUzE1iYpb-5tsuzoz+B@mail.gmail.com>
References: <201101060935.14059.CACook@quantum-sci.com>
	<AANLkTi=8zq-=ZG2sJBaV4JJbd-SnPpV3BQHg7dZA6Yoo@mail.gmail.com>
	<AANLkTimB8vLf3_apgFc1t=7xN5ab+Sw_u8Wp2NZL=xkd@mail.gmail.com>
	<201101061344.55407.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Carl Cook <CACook@quantum-sci.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101061344.55407.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 6, 2011 at 1:44 PM, Carl Cook <CACook@quantum-sci.com> wrot=
e:
> On Thu 06 January 2011 12:07:17 C Anthony Risinger wrote:
>> as for the DB stuff, you definitely need to snapshot _before_ rsync.=
 =C2=A0roughly:
>>
>> ) read lock and flush tables
>> ) snapshot
>> ) unlock tables
>> ) mount snapshot
>> ) rsync from snapshot
>>
>> ie. the same as whats needed for LVM:
>>
>> http://blog.dbadojo.com/2007/09/mysql-backups-using-lvm-snapshots.ht=
ml
>>
>> to get the DB file on disk consistent prior to archiving.
>
> I'm a little alarmed by this. =C2=A0Running a mysql server for MythTV=
 database. =C2=A0 Do these operations need to somehow be done before rs=
ync? =C2=A0Or Else?
>
> I don't understand what you're saying.

Simplest solution is to write a script to create a mysqldump of all
databases into a directory, add that to cron so that it runs at the
same time everyday, 10-15 minutes before the rsync run is done.  That
way, rsync to the backup server picks up both the text dump of the
database(s), along with the binary files under /var/lib/mysql/* (the
actual running database).

When you need to restore the HTPC due to failed harddrive or what not,
you just rsync everything back to the new harddrive and try to run
MythTV.  If things work, great, done.  If something is wonky, then
delete all the MySQL tables/databases, and use the dump file to
recreate things.

Something like this:
#!/bin/bash
# Backup mysql databases.
#
# Take a list of databases, and dump each one to a separate file.

debug=3D0

while getopts "hv" OPTION; do
        case "${OPTION}" in
                h)
                        echo "Usage: $0 [-h] [-v]"
                        echo ""
                        echo "-h  show this help blurb"
                        echo "-v  be verbose about what's happening"
                        exit 0
                        ;;
                v)
                        debug=3D1
                        ;;
        esac
done

for I in $( mysql -u root --password=3Dblahblahblah -Bse "show database=
s" ); do
        OUTFILE=3D/var/backups/$I.sql
        if [ $debug =3D 1 ]; then
                echo -n "Doing backup for $I:"
        fi

        /usr/bin/mysqldump -u root --password=3Dblahblahblah --opt $I >=
 "$OUTFILE"
        /bin/chmod 600 $OUTFILE

        if [ $debug =3D 1 ]; then
                echo " done."
        fi
done

exit 0

That will create a text dump of everything in each database, creating
a separate file per database.  It can be used via the "mysql" command
to recreate the database at a later date.

--=20
=46reddie Cash
fjwcash@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
