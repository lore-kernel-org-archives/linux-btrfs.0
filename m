Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:58029 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337Ab2JNSen (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Oct 2012 14:34:43 -0400
Received: from mail.lysator.liu.se (localhost [127.0.0.1])
	by mail.lysator.liu.se (Postfix) with ESMTP id 485044000D
	for <linux-btrfs@vger.kernel.org>; Sun, 14 Oct 2012 20:34:41 +0200 (CEST)
Date: Sun, 14 Oct 2012 20:35:03 +0200
From: Tommy Pettersson <ptp@lysator.liu.se>
To: linux-btrfs@vger.kernel.org
Cc: Goffredo Baroncelli <kreijack@gmail.com>,
        Tommy Pettersson <ptp@lysator.liu.se>
Subject: Re: btrfs suddenly lost all om my huge free space
Message-ID: <20121014183503.GA7616@fruity>
References: <20121014001912.GA1247@fruity>
 <507AE44E.4040008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <507AE44E.4040008@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The problem has been resolved, but I think it will be impossible
to figure out what went wrong. The root cause was I accidentally
messed up my initrd so that btrfs was mounted without prior dev
scan (which I think didn't work with earlier kernels, but now
(3.4.9-gentoo) it "worked" in a very bad way it seems), and
possibly that I also mounted subvolid=0 (containing the subvol I
previously mounted as / ) with conflicting mount options for
space_cache.

But after I had realized and fixed that, it was too late. Both
Scrub and Balance, and reading from the filesystem, behaved
strange. The output of df jumped between 95 % and 12 %, while I
got many lines about wrong checksums, unexpected tree parent
generation something, and free space inode generation (0) did
not match free space cache. It sometimes said it corrected
things, but it didn't seem to help, and at random points I would
get a kernel panic.

# uname -a
Linux fruit64 3.4.9-gentoo #2 SMP PREEMPT Sat Sep 1 17:34:38 CEST 2012 x86_64 AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ AuthenticAMD GNU/Linux

# btrfs --version
Btrfs Btrfs v0.19

It would have been nice to debug this mess so that btrfs could
handled it in the future, and not do all the strange things with
the free space and cause kernel panics, but I had to get my
system back up.

The good news is that even this torture of my bits didn't
actually kill them. I eventually cleared the btrfs master record
on one of the disks, mounted in degraded mode, added it back,
waited seven hours for balance to finish, and now my filesystem
is consistent again, and everything is back to normal. So no
need to restore from my daily backup yet. :-)


Regards,
Tommy


On Sun, Oct 14, 2012 at 06:11:58PM +0200, Goffredo Baroncelli wrote:
> Hi,
> 
> did you used the latest kernel version ?
> The other thing that you could try is a scrub looking for a defective 
> page.. but I don't think so....
> 
> BR
> G.Baroncelli
> 
> 
> 
> On 2012-10-14 02:19, Tommy Pettersson wrote:
> > Hi,
> >
> > (I'm not subscribed to the list, so please CC me.)
> >
> > I have a btrfs with raid1 on two identical unpartitioned disks.
> > Today I noticed that df (normal df) said I am 77 % full. This
> > was a chock, because since forever it has been around 12 %.
> >
> >
> > # btrfs fi show
> > Label: 'green'  uuid: dd83031c-2447-4736-a8f6-9bd9cdeea879
> >          Total devices 2 FS bytes used 212.88GB
> >          devid    2 size 1.82TB used 356.04GB path /dev/sdb
> >          devid    1 size 1.82TB used 356.06GB path /dev/sda
> >
> > # btrfs fi df /
> > Data, RAID1: total=276.00GB, used=209.02GB
> > Data: total=8.00M, used=0.00
> > System, RAID1: total=40.00MB, used=64.00KB
> > System: total=4.00MB, used=0.00
> > Metadata, RAID1: total=80.00GB, used=3.88GB
> > Metadata: total=8.00MB, used=0.00
> >
> > # df -h
> > Filesystem      Size  Used Avail Use% Mounted on
> > rootfs          3.7T  426G   134G  77% /
> >
> >
> > The thing that has drastically changed is Avail in the output
> > from df.
> >
> > I tried a btrfs balance, which self-aborted after some hours
> > with No space left on device. I deleted two snapshots, so I got
> > some free space and could use the system again.
> >
> > The balance, although it didn't finish, seems to have reduced
> > the used space, but it also reduced the "available" space:
> >
> >
> > # btrfs fi show
> > Label: 'green'  uuid: dd83031c-2447-4736-a8f6-9bd9cdeea879
> >          Total devices 2 FS bytes used 212.88GB
> >          devid    2 size 1.82TB used 356.04GB path /dev/sdb
> >          devid    1 size 1.82TB used 215.01GB path /dev/sda
> >
> > # btrfs fi df /
> > Data, RAID1: total=210.00GB, used=197.97GB
> > System, RAID1: total=8.00MB, used=44.00KB
> > System: total=4.00MB, used=0.00
> > Metadata, RAID1: total=5.00GB, used=3.41GB
> >
> > # df -h
> > Filesystem      Size  Used Avail Use% Mounted on
> > rootfs          3.7T  403G   25G  95% /
> >
> >
> > I made an unqualified guess that the space cache was corrupted,
> > and tried to mount with option clear_cache and nospace_cache.
> > Both of them caused btrfs to scan my disks for a couple of
> > minutes at boot, but the amount of available space did not
> > improve.
> >
> > What can I do to help locate the cause of this problem?
> >
> >
> > Regards,
> > Tommy
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
