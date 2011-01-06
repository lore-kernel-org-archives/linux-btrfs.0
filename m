From: Gordan Bobic <gordan@bobich.net>
Subject: Re: Synching a Backup Server
Date: Thu, 06 Jan 2011 22:29:40 +0000
Message-ID: <4D264254.3030109@bobich.net>
References: <201101060935.14059.CACook@quantum-sci.com>	<201101061344.55407.CACook@quantum-sci.com>	<AANLkTimvyZ-jNCk9FVav8kw8oYUzE1iYpb-5tsuzoz+B@mail.gmail.com> <201101061426.30791.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101061426.30791.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/06/2011 10:26 PM, Carl Cook wrote:
> On Thu 06 January 2011 13:58:41 Freddie Cash wrote:
>> Simplest solution is to write a script to create a mysqldump of all
>> databases into a directory, add that to cron so that it runs at the
>> same time everyday, 10-15 minutes before the rsync run is done.  That
>> way, rsync to the backup server picks up both the text dump of the
>> database(s), along with the binary files under /var/lib/mysql/* (the
>> actual running database).
>
> I am sure glad you guys mentioned database backup in relation to rsync.  I would never have guessed.
>
> When I do my regular backups I back up the export dump and binary of the database.
>
> So overall I do the export dump of the database 15 minutes before rsync.
> Then snapshot the destination array.
> Then do the rsync.
> Right?

Yes, that should be fine. Not sure there's much point in backing up the 
binary if you're backing up the dump. Note that you should be locking 
all tables before doing a full dump. Otherwise, the dumped tables may be 
inconsistent with each other (orphaned records).

> But how does merely backing up the database prevent it from being
> hosed in the rsync?  Or does snapshot do that?  Or does snapshot
> prevent other data on the disk from getting hosed?

The data on the disk is only being read, it won't be damaged. The 
snapshot ensure that the image you get of the DB is consistent with 
itself (i.e. no records got written to table A while you were backing up 
table B). As I said, the consistency with a snapshot is equivalent to 
the degree of consistency you will get if you just yank the power.

Gordan
