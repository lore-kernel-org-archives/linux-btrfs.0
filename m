Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:59722 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbcCMQ4k (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Mar 2016 12:56:40 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.84)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1af9Jm-0003i3-8T
	for linux-btrfs@vger.kernel.org; Sun, 13 Mar 2016 17:56:38 +0100
Date: Sun, 13 Mar 2016 17:56:38 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: New file system with same issue (was: Again, no space left on
 device while rebalancing and recipe doesnt work)
Message-ID: <20160313165638.GS2334@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
 <20160305143934.GE1902@torres.zugschlus.de>
 <CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
 <20160313115809.GQ2334@torres.zugschlus.de>
 <CALxwgb5oMZWT3v7vLvs_nqZ+eNzUns78yW51mj+N7zbsMf1_MQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CALxwgb5oMZWT3v7vLvs_nqZ+eNzUns78yW51mj+N7zbsMf1_MQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 14, 2016 at 12:17:24AM +1100, Andrew Vaughan wrote:
> On 13 March 2016 at 22:58, Marc Haber <mh+linux-btrfs@zugschlus.de> wrote:
> > Hi,
> >
> > On Sat, Mar 05, 2016 at 12:34:09PM -0700, Chris Murphy wrote:
> >> The alternative if this can't be fixed, is to recreate the filesystem
> >> because there's no practical way yet to migrate so many snapshots to a
> >> new file system.
> >
> > I recreated the file system on March 7, with 200 GiB in size, using
> > btrfs-tools 4.4. The snapshot-taking process has been running since
> > then, but I also regularly cleaned up. The number of snapshots on the
> > new filesystem has never exceeded 1000, with the current count being
> > at 148.
> >
> <snip>
> 
> 
> I'm not a dev, so I'll just thouw out a random, and possibly naive idea.
> 
> How much i/o load is this filesystem under?
> What type of access pattern(s), how frequent and large are the changes?

Nearly none. It's a workstation which I have avoided using in the last
days due to the filesystem trouble and to avoid impact of local work
to the filesystem behavior. I even log out after working on the box
for a few minutes.

There is a Debian apt-cacher running on the box and writing its cache
to this btrfs, but /var is on its own subvolume that is only
snapshotted once a day. I'll move /var/cache to its own subvolume and
set this subvolume on a "no snapshots" schedule.

The box itself is running a couple of KVM VMs, but the virtual disks
of the VMs are on dedicated LVs.

> Are you still making snapshots every 10m?

I am snapshotting the subvolume /home/mh, with the obvious contents,
every ten minutes, yes. Most of the other subvolumes is snapshotted
once daily, with some of them not getting snapshotted at all.

> How often do you delete old snapshots?  Also every 10m, or do you
> delete them in batchs every hour or so?

I delete them in batches about every ohter day.

> How long does "btrfs subvolume delete -c <one_snapshot>" take?
> What does "time btrfs subvolume delete -C <one_snapshot> ;

[4/504]mh@fan:~$ time sudo btrfs subvolume delete -c /mnt/snapshots/fanbtr/user/subdaily/2016/03/13/07/5001/-home-mh
Delete subvolume (commit): '/mnt/snapshots/fanbtr/user/subdaily/2016/03/13/07/5001/-home-mh'

real    0m0.100s
user    0m0.000s
sys     0m0.016s
[5/505]mh@fan:~$ time sudo btrfs subvolume delete -C /mnt/snapshots/fanbtr/user/subdaily/2016/03/13/07/4001/-home-mh
Delete subvolume (commit): '/mnt/snapshots/fanbtr/user/subdaily/2016/03/13/07/4001/-home-mh'

real    0m0.079s
user    0m0.012s
sys     0m0.000s
[6/506]mh@fan:~$

The difference between -c and -C does only show when there is more
than one snapshot to be deleted.

>  time btrfs subvolume sync <mount_point>" print ?

[8/508]mh@fan:~$ time sudo btrfs subvolume sync /

real    0m0.030s
user    0m0.004s
sys     0m0.008s
[9/509]mh@fan:~$

> The reason for asking is that even on a lightly loaded filesystem I
> have seen btrfs subvolume delete take more than 30 seconds.  On a more
> heavily load filesystem  I have seen 5+ minutes before btrfs subvolume
> delete had finished.

In my experience, deleting snapshot in huge batches slows down quite a
bit, but this btrfs does not suffer from this disease.

> If you have a high enough i/o load, plus large enough changes per
> snapshot, it might be possible to get btrfs into a situation were it
> never actually finishes cleaning up deleted snapshots.  (I'm also not
> sure what happens if you shutdown or unmount whilst btrfs is still
> cleaning up, but I expect the devs thought of that).

It is a COW filesystem, I'd expect it to be consistent no matter what.
But that's the theory.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
