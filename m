From: C Anthony Risinger <anthony@extof.me>
Subject: Re: Synching a Backup Server
Date: Thu, 6 Jan 2011 14:07:17 -0600
Message-ID: <AANLkTimB8vLf3_apgFc1t=7xN5ab+Sw_u8Wp2NZL=xkd@mail.gmail.com>
References: <201101060935.14059.CACook@quantum-sci.com>
	<AANLkTi=iWyKFOoaY6JjTuhg_0CyAtOh=s2gcBUuHGwau@mail.gmail.com>
	<AANLkTik-rhXAHW18id4WMMtdqXkicvzTZ47+2r6YMuY0@mail.gmail.com>
	<AANLkTi=8zq-=ZG2sJBaV4JJbd-SnPpV3BQHg7dZA6Yoo@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Marcin Kuk <marcin.kuk@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Freddie Cash <fjwcash@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=8zq-=ZG2sJBaV4JJbd-SnPpV3BQHg7dZA6Yoo@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 6, 2011 at 1:47 PM, Freddie Cash <fjwcash@gmail.com> wrote:
> On Thu, Jan 6, 2011 at 11:33 AM, Marcin Kuk <marcin.kuk@gmail.com> wr=
ote:
>> Rsync is good, but not for all cases. Be aware of databases files -
>> you should do snapshot filesystem before rsyncing.
>
> We script a dump of all databases before the rsync runs, so we get
> both text and binary backups. =A0If restoring the binary files doesn'=
t
> work, then we just suck in the text dumps.
>
> If the remote system supports snapshots, doing a snapshot before the
> rsync runs is a good idea, though. =A0It'll be nice when more
> filesystems support in-line snapshots. =A0The LVM method is pure crap=
=2E

do you also use the --in-place option for rsync?  i would think this
is critical to getting the most out of "btrfs folding backups", ie.
the most reuse between snapshots?  im able to set this exact method up
for my home network, thats why i ask... i have a central server that
runs everything, and i want to sync a couple laptops and netbooks
nightly, and a few specific directories whenever they change.  btrfs
on both ends.

better yet, any chance you'd share some scripts? :-)

as for the DB stuff, you definitely need to snapshot _before_ rsync.  r=
oughly:

) read lock and flush tables
) snapshot
) unlock tables
) mount snapshot
) rsync from snapshot

ie. the same as whats needed for LVM:

http://blog.dbadojo.com/2007/09/mysql-backups-using-lvm-snapshots.html

to get the DB file on disk consistent prior to archiving.

C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
