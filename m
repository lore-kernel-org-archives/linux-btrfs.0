Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-he1eur01on0053.outbound.protection.outlook.com ([104.47.0.53]:42067
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727805AbeIODGa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 23:06:30 -0400
Subject: Re: state of btrfs snapshot limitations?
To: "James A. Robinson" <jim.robinson@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAPd04b4nXw_qe7+8msY26UDr-m+MBpzYn_UdqGQX8Z-KxNN_0w@mail.gmail.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <314a1441-9390-2e9c-50c0-07e3a6b103a9@mendix.com>
Date: Fri, 14 Sep 2018 23:50:00 +0200
MIME-Version: 1.0
In-Reply-To: <CAPd04b4nXw_qe7+8msY26UDr-m+MBpzYn_UdqGQX8Z-KxNN_0w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 09/14/2018 11:05 PM, James A. Robinson wrote:
> The mail archive seems to indicate this list is appropriate
> for not only the technical coding issues, but also for user
> questions, so I wanted to pose a question here.  If I'm
> wrong about that, I apologize in advance.

It's fine. Your observation is correct.

> The page
> 
> https://btrfs.wiki.kernel.org/index.php/Incremental_Backup
> 
> talks about the basic snapshot capabilities of btrfs and led
> me to look up what, if any, limits might apply.  I find some
> threads from a few years ago that talk about limiting the
> number of snapshots for a volume to 100.
> 
> The reason I'm curious is I wanted to try and use the
> snapshot capability as a way of keeping a 'history' of a
> backup volume I maintain.  The backup doesn't change a
> lot overtime, but small changes are made to files within
> it daily.

The 100 above is just a number because users ask "ok, but *how* many?".

As far as I know, the real thing that is causing complexity for the
filesystem is how much actual changes are being done to the subvolume
all the time, after it's being snapshotted.

Creating btrfs snapshots is cheap. Only as soon as you start making
modifications, the subvolume in which you make the changes is going to
diverge from the other ones which share the same history. And changes
mean not only changes to data (changing, adding removing files), but
also pure metadata changes (e.g. using touch command on a file).

When just using the snapshots, opening and reading files etc, this
should however not be a big problem.

But, other btrfs specific actions are affected, like balance and device
remove, using quota.

In any case, make sure:
- you are not using quota / qgroups (highly affected by this sort of
complexity)
- you *always* mount with noatime (which is not the default, and yes,
noatime, not relatime or anything else) to prevent unnessary changes on
metadata which unnecessarily cause exactly this kind of complexity to
happen.

When doing this, and not having to use btrfs balance and add/remove
disks, and if the data doesn't change much over time (especially if it's
just adding new stuff all the time), you are likely able to have far
more snapshots of the thing.

> The Plan 9 OS has a nice archival filesystem that lets you
> easily maintain snapshots, and has various tools that make
> it simple to keep a /snapshot/yyyy/mmdd snapshot going back
> for the life of the filesystem.
> 
> I wanted to try and replicate the basic functionality of
> that history using a non-plan-9 filesystem.  At first I
> tried rsnapshot but I find its technique of rotating and
> deleting backups is thrashing the disks to the point that it
> can't keep up with the rotations (the cp -al is fast, but
> the periodic rm -rf of older snapshots kills the disk).

Yes, btrfs snapshots are already a huge improvement compared to that.
(Also, cp -l causes a modifications to also be done in the "snapshots",
because it's still the same file, brrrr)

> With btrfs I was thinking perhaps I could more efficiently
> maintain the archive of changes over time using a snapshot.
> If this is an awful thought and I should just go away,
> please let me know.
> 
> If the limit is 100 or less I'd need use a more complicated
> rotation scheme.  For example with a layout like the
> following:
> 
> min/<mm>
> hour/<hh>
> day/<dd>
> month/<mm>
> year/<yyy>
> 
> The idea being each bucket, min, hour, day, month, would
> be capped and older snapshots would be removed and replaced
> with newer ones over time.
> 
> so with a 15-minute snapshot cycle I'd end up with
> 
> min/[00,15,30,45]
> hour/[00-23]
> day/[01-31]
> month/[01-12]
> year/[2018,2019,...]
> 
> (72+ snapshots with room for a few years worth of yearly's).
> 
> But if things have changed with btrfs over the past few
> years and number of snapshots scales much higher, I would
> use the easier scheme:
> 
> /min/[00,15,30,45]
> /hourly/[00-23]
> /daily/<yyyy>/<mmdd>
> 
> with 365 snapshots added per additional year.

There are tools available that can do this for you. The one I use is
btrbk, https://github.com/digint/btrbk (probably packaged in your
favorite linux distro).

I'd say, just try it. Add a snapshot schedule in your btrbk config, and
set it to never expire older ones. Then, just see what happens, and only
if you start seeing things slow down a lot, start worrying about what to
do, and let us know how far you got.

Have fun,

P.S. Here's an unfinished page from a tutorial that I'm writing that is
still heavily under construction, which touches the subject of
snapshotting data and metadata. Maybe it might help to explain
"complexity starts when changing things" more:

https://github.com/knorrie/python-btrfs/blob/tutorial/tutorial/cows.md

-- 
Hans van Kranenburg
