Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-out14.tpgi.com.au ([220.244.226.124]:34403 "EHLO
	mail14.tpgi.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964966AbbBDKUk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Feb 2015 05:20:40 -0500
From: Paul Jones <paul@pauljones.id.au>
To: Martin Steigerwald <martin@lichtvoll.de>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: [PATCH 0/7] Allow btrfsck to reset csum of all tree blocks, AKA
 dangerous mode.
Date: Wed, 4 Feb 2015 10:07:07 +0000
Message-ID: <B7F2379062E32745A8651FBDB20F645940A8D157@Server.waterlogic.com.au>
References: <1423034213-14018-1-git-send-email-quwenruo@cn.fujitsu.com>
 <4749287.qr2O8ff0qM@merkaba>
In-Reply-To: <4749287.qr2O8ff0qM@merkaba>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of Martin Steigerwald
> Sent: Wednesday, 4 February 2015 8:16 PM
> To: Qu Wenruo
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: [PATCH 0/7] Allow btrfsck to reset csum of all tree blocks, AKA
> dangerous mode.
> 
> Am Mittwoch, 4. Februar 2015, 15:16:44 schrieb Qu Wenruo:
> > Btrfs's metadata csum is a good mechanism, keeping bit error away from
> > sensitive kernel. But such mechanism will also be too sensitive, like
> > bit error in csum bytes or low all zero bits in nodeptr.
> > It's a trade using "error tolerance" for stable, and is reasonable for
> > most cases since there is DUP/RAID1/5/6/10 duplication level.
> >
> > But in some case, whatever for development purpose or despair user who
> > can't tolerant all his/her inline data lost, or even crazy QA team
> > hoping btrfs can survive heavy random bits bombing, there are some
> > guys want to get rid of the csum protection and face the crucial raw
> > data no matter what disaster may happen.
> >
> > So, introduce the new '--dangerous' (or "destruction"/"debug" if you
> > like) option for btrfsck to reset all csum of tree blocks.
> 
> I often wondered about this: AFAIK if you get a csum error BTRFS makes this
> an input/output error. For being able to access the data in place, how about a
> "iwantmycorrupteddataback" mount option where BTRFS just logs csum
> errors but allows one to access the files nonetheless. This could even work
> together with remount. Maybe it would be good not to allow writing to
> broken csum blocks, i.e. fail these with input/output error.
> 
> This way, the csum would not be automatically fixed, *but* one is able to
> access the broken data, *while* knowing it is broken.


I seriously could have used that yesterday - I had a raw VM image with a csum error that wouldn't go away. The VM worked fine (even rebooting) so I figured I would just copy the file to another filesystem and then copy it back. Rsync doesn't play nicely with errors so I used dd if=disk1 of=/elsewhere/disk1 bs=4096 conv=notrunc,noerror but after waiting for 100G to copy twice it no longer booted. 
The backup was only 8 hours old so no big deal, but if it was a busy day that could have been nasty! (Why I didn't press the backup button before I did the above I don't know...)

Paul.
