Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:57475 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbaCWTWE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Mar 2014 15:22:04 -0400
Date: Sun, 23 Mar 2014 12:22:02 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: How to handle a RAID5 arrawy with a failing drive? -> raid5 mostly works, just no rebuilds
Message-ID: <20140323192202.GC3732@merlins.org>
References: <1394983430-20440-1-git-send-email-fdmanana@gmail.com> <1395002246-3840-1-git-send-email-fdmanana@gmail.com> <20140316222026.GU16946@merlins.org> <pan$2239d$446ec5c7$d67506b7$f25a7c65@cox.net> <20140319060902.GM6143@merlins.org> <CD1D8CED-8BC2-4C16-AE9E-0C47DC954CFA@colorremedies.com> <20140319154031.GP6143@merlins.org> <EBE67530-BDC7-487C-826D-A0E65259BCBA@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <EBE67530-BDC7-487C-826D-A0E65259BCBA@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 19, 2014 at 10:53:33AM -0600, Chris Murphy wrote:
> 
> On Mar 19, 2014, at 9:40 AM, Marc MERLIN <marc@merlins.org> wrote:
> > 
> > After adding a drive, I couldn't quite tell if it was striping over 11
> > drive2 or 10, but it felt that at least at times, it was striping over 11
> > drives with write failures on the missing drive.
> > I can't prove it, but I'm thinking the new data I was writing was being
> > striped in degraded mode.
> 
> Well it does sound fragile after all to add a drive to a degraded array, especially when it's not expressly treating the faulty drive as faulty. I think iotop will show what block devices are being written to. And in a VM it's easy (albeit rudimentary) with sparse files, as you can see them grow.
> 
> > 
> > Yes, although it's limited, you apparently only lose new data that was added
> > after you went into degraded mode and only if you add another drive where
> > you write more data.
> > In real life this shouldn't be too common, even if it is indeed a bug.
> 
> It's entirely plausible a drive power/data cable becomes lose, runs for hours degraded before the wayward device is reseated. It'll be common enough. It's definitely not OK for all of that data in the interim to vanish just because the volume has resumed from degraded to normal. Two states of data, normal vs degraded, is scary. It sounds like totally silent data loss. So yeah if it's reproducible it's worthy of a separate bug.

I just got around to filing that bug:
https://bugzilla.kernel.org/show_bug.cgi?id=72811

In other news, I was able to
1) remove a drive
2) mount degraded
3) add a new drive
4) rebalance (that took 2 days with little data, 4 deadlocks and reboots
though)
5) remove the missing drive from the filesystem
6) remount the array without -o degraded

Now, I'm testing
1) add a new drive
2 remove a working drive
3) automatic rebalance from #2 should rebuild on the new drive automatically

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
