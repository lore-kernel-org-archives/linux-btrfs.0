Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:46598 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965431AbaCSPkc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Mar 2014 11:40:32 -0400
Date: Wed, 19 Mar 2014 08:40:31 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: How to handle a RAID5 arrawy with a failing drive? -> raid5 mostly works, just no rebuilds
Message-ID: <20140319154031.GP6143@merlins.org>
References: <1394983430-20440-1-git-send-email-fdmanana@gmail.com> <1395002246-3840-1-git-send-email-fdmanana@gmail.com> <20140316222026.GU16946@merlins.org> <pan$2239d$446ec5c7$d67506b7$f25a7c65@cox.net> <20140319060902.GM6143@merlins.org> <CD1D8CED-8BC2-4C16-AE9E-0C47DC954CFA@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CD1D8CED-8BC2-4C16-AE9E-0C47DC954CFA@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 19, 2014 at 12:32:55AM -0600, Chris Murphy wrote:
> 
> On Mar 19, 2014, at 12:09 AM, Marc MERLIN <marc@merlins.org> wrote:
> > 
> > 7) you can remove a drive from an array, add files, and then if you plug
> >   the drive in, it apparently gets auto sucked in back in the array.
> > There is no rebuild that happens, you now have an inconsistent array where
> > one drive is not at the same level than the other ones (I lost all files I added 
> > after the drive was removed when I added the drive back).
> 
> Seems worthy of a dedicated bug report and keeping an eye on in the future, not good.
 
Since it's not supposed to be working, I didn't file a bug, but I figured
it'd be good for people to know about it in the meantime.

> >> polgara:/mnt/btrfs_backupcopy# btrfs device add -f /dev/mapper/crypt_sdm1 /mnt/btrfs_backupcopy/
> >> polgara:/mnt/btrfs_backupcopy# df -h .
> >> Filesystem              Size  Used Avail Use% Mounted on
> >> /dev/mapper/crypt_sdb1  4.6T  3.0M  4.6T   1% /mnt/btrfs_backupcopy
> > 
> > Oh look it's bigger now. We need to manual rebalance to use the new drive:
> 
> You don't have to. As soon as you add the additional drive, newly allocated chunks will stripe across all available drives. e.g. 1 GB allocations striped across 3x drives, if I add a 4th drive, initially any additional writes are only to the first three drives but once a new data chunk is allocated it gets striped across 4 drives.
 
That's the thing though. If the bad device hadn't been forcibly removed, and
apparently the only way to do this was to unmount, make the device node
disappear, and remount in degraded mode, it looked to me like btrfs was
still consideing that the drive was part of the array and trying to write to
it.
After adding a drive, I couldn't quite tell if it was striping over 11
drive2 or 10, but it felt that at least at times, it was striping over 11
drives with write failures on the missing drive.
I can't prove it, but I'm thinking the new data I was writing was being
striped in degraded mode.

> Sure the whole thing isn't corrupt. But if anything written while degraded vanishes once the missing device is reattached, and you remount normally (non-degraded), that's data loss. Yikes!

Yes, although it's limited, you apparently only lose new data that was added
after you went into degraded mode and only if you add another drive where
you write more data.
In real life this shouldn't be too common, even if it is indeed a bug.

Cheers,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
