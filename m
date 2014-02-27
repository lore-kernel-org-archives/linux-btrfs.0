Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:52713 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753503AbaB0T1f convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Feb 2014 14:27:35 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Help with space
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAAmRLYx1L=o7a2PMSAiJbr7qH_JiuYG2-ncHG-mHLyLcM3Z-GQ@mail.gmail.com>
Date: Thu, 27 Feb 2014 12:27:29 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <DCDC90E8-4834-416A-AC00-B11FC9A66281@colorremedies.com>
References: <CAAmRLYx1L=o7a2PMSAiJbr7qH_JiuYG2-ncHG-mHLyLcM3Z-GQ@mail.gmail.com>
To: Justin Brown <otakujunction@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 27, 2014, at 11:19 AM, Justin Brown <otakujunction@gmail.com> wrote:

> I've a 18 tera hardware raid 5 (areca ARC-1170 w/ 8 3 gig drives) in
> need of help.  Disk usage (du) shows 13 tera allocated yet strangely
> enough df shows approx. 780 gigs are free.  It seems, somehow, btrfs
> has eaten roughly 4 tera internally.  I've run a scrub and a balance
> usage=5 with no success, in fact I lost about 20 gigs after the
> balance attempt.  Some numbers:
> 
> terra:/var/lib/nobody/fs/ubfterra # uname -a
> Linux terra 3.12.4-2.44-desktop #1 SMP PREEMPT Mon Dec 9 03:14:51 CST
> 2013 i686 i686 i386 GNU/Linux

This is on i686?

The kernel page cache is limited to 16TB on i686, so effectively your block device is limited to 16TB. While the file system successfully creates, I think it's a bug that the mount -t btrfs command is probably a btrfs bug.

The way this works for XFS and ext4 is mount fails.

EXT4-fs (sdc): filesystem too large to mount safely on this system
XFS (sdc): file system too large to be mounted on this system.

If you're on a 32-bit OS, the file system might be toast, I'm not really sure. But I'd immediately stop using it and only use 64-bit OS for file systems of this size.



Chris Murphy

