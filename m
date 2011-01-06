From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Synching a Backup Server
Date: Fri, 7 Jan 2011 06:15:11 +0700
Message-ID: <AANLkTimGhj_uuUwRnKjkcEbQLijZ48C6k_px4zzRU+SV@mail.gmail.com>
References: <201101060935.14059.CACook@quantum-sci.com>
	<201101061344.55407.CACook@quantum-sci.com>
	<AANLkTimvyZ-jNCk9FVav8kw8oYUzE1iYpb-5tsuzoz+B@mail.gmail.com>
	<201101061426.30791.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Carl Cook <CACook@quantum-sci.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101061426.30791.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 7, 2011 at 5:26 AM, Carl Cook <CACook@quantum-sci.com> wrot=
e:
> On Thu 06 January 2011 13:58:41 Freddie Cash wrote:
>> Simplest solution is to write a script to create a mysqldump of all
>> databases into a directory, add that to cron so that it runs at the
>> same time everyday, 10-15 minutes before the rsync run is done. =A0T=
hat
>> way, rsync to the backup server picks up both the text dump of the
>> database(s), along with the binary files under /var/lib/mysql/* (the
>> actual running database).
>
> I am sure glad you guys mentioned database backup in relation to rsyn=
c. =A0I would never have guessed.
>
> When I do my regular backups I back up the export dump and binary of =
the database.

When dealing with database, binary backup is only usable if all the
files backed up is from the same point in time. That means you need
either:
- tell the database server you're going to do backup, so it doesn't
change the datafile and store changes temporarily elsewhere (Oracle DB
can do this), or
- snapshot the storage, whether at block level (e.g. using LVM) or
filesystem level (e.g. btrfs and zfs have snapshot capability)
- shutdown the database before backup, or

The first two options will require some kind of log replay during
restore operation, but it doesn't need downtime on the source, and is
much faster than restoring from export dump.

>
> So overall I do the export dump of the database 15 minutes before rsy=
nc.

If you're talking about MySQL, add snapshot the source before rsync.
Otherwise your binary backup will be useless.

> Then snapshot the destination array.
> Then do the rsync.
> Right?
>

Don't forget --inplace. Very important if you're using snapshot on
destination. Otherwise disk usage will skyrocket.

> But how does merely backing up the database prevent it from being hos=
ed in the rsync? =A0Or does snapshot do that? =A0Or does snapshot preve=
nt other data on the disk from getting hosed?

what do you mean "being hosed in the rsync"? Rsync shouldn't destroy an=
ything.
Snapshot in the source is necessary to have a consistent point-in-time
view of database files.

>
> I'm about to install the two new 2TB drives in the HTPC to make a BTR=
=46S Raid0 array. =A0Hope it goes According To Doyle...

Generally I'd not recommed using Raid0; It's asking for trouble. Use
btrfs raid 10, or use Linux md raid.

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
