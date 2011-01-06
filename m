From: Carl Cook <CACook@quantum-sci.com>
Subject: Re: Synching a Backup Server
Date: Thu, 6 Jan 2011 14:26:30 -0800
Message-ID: <201101061426.30791.CACook@quantum-sci.com>
References: <201101060935.14059.CACook@quantum-sci.com> <201101061344.55407.CACook@quantum-sci.com> <AANLkTimvyZ-jNCk9FVav8kw8oYUzE1iYpb-5tsuzoz+B@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimvyZ-jNCk9FVav8kw8oYUzE1iYpb-5tsuzoz+B@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu 06 January 2011 13:58:41 Freddie Cash wrote:
> Simplest solution is to write a script to create a mysqldump of all
> databases into a directory, add that to cron so that it runs at the
> same time everyday, 10-15 minutes before the rsync run is done.  That
> way, rsync to the backup server picks up both the text dump of the
> database(s), along with the binary files under /var/lib/mysql/* (the
> actual running database).

I am sure glad you guys mentioned database backup in relation to rsync.  I would never have guessed.

When I do my regular backups I back up the export dump and binary of the database.

So overall I do the export dump of the database 15 minutes before rsync.  
Then snapshot the destination array.
Then do the rsync.
Right?

But how does merely backing up the database prevent it from being hosed in the rsync?  Or does snapshot do that?  Or does snapshot prevent other data on the disk from getting hosed?

I'm about to install the two new 2TB drives in the HTPC to make a BTRFS Raid0 array.  Hope it goes According To Doyle...




