Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:47240 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbcBGU7u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Feb 2016 15:59:50 -0500
From: Martin Steigerwald <martin@lichtvoll.de>
To: Kai Krakow <hurikhan77@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Use fast device only for metadata?
Date: Sun, 07 Feb 2016 21:59:48 +0100
Message-ID: <1507413.RERLDqpHyU@merkaba>
In-Reply-To: <20160207210713.7e4661a8@jupiter.sol.kaishome.de>
References: <874mdktk4t.fsf@vostro.rath.org> <20160207210713.7e4661a8@jupiter.sol.kaishome.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 7. Februar 2016, 21:07:13 CET schrieb Kai Krakow:
> Am Sun, 07 Feb 2016 11:06:58 -0800
> 
> schrieb Nikolaus Rath <Nikolaus@rath.org>:
> > Hello,
> > 
> > I have a large home directory on a spinning disk that I regularly
> > synchronize between different computers using unison. That takes ages,
> > even though the amount of changed files is typically small. I suspect
> > most if the time is spend walking through the file system and checking
> > mtimes.
> > 
> > So I was wondering if I could possibly speed-up this operation by
> > storing all btrfs metadata on a fast, SSD drive. It seems that
> > mkfs.btrfs allows me to put the metadata in raid1 or dup mode, and the
> > file contents in single mode. However, I could not find a way to tell
> > btrfs to use a device *only* for metadata. Is there a way to do that?
> > 
> > Also, what is the difference between using "dup" and "raid1" for the
> > metadata?
> 
> You may want to try bcache. It will speedup random access which is
> probably the main cause for your slow sync. Unfortunately it requires
> you to reformat your btrfs partitions to add a bcache superblock. But
> it's worth the efforts.
> 
> I use a nightly rsync to USB3 disk, and bcache reduced it from 5+ hours
> to typically 1.5-3 depending on how much data changed.

An alternative is using dm-cache, I think it doesn´t need to recreate the 
filesystem.

I wonder what happened to the VFS hot data tracking stuff patchset floating 
around here quite some time ago.

-- 
Martin
