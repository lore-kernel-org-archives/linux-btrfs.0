Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:40469 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaCXVwl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Mar 2014 17:52:41 -0400
Date: Mon, 24 Mar 2014 14:52:39 -0700
From: Marc MERLIN <marc@merlins.org>
To: Martin <m_btrfs@ml1.co.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs and raid5 status with kernel 3.14, documentation, and howto
Message-ID: <20140324215239.GC11533@merlins.org>
References: <20140323225657.GA17039@merlins.org> <lgq0b9$e5r$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <lgq0b9$e5r$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 24, 2014 at 07:17:12PM +0000, Martin wrote:
> Thanks for the very good summary.
> 
> So... In very brief summary, btrfs raid5 is very much a work in progress.

If you know how to use it, which I didn't know do now, it's technically very
usable as is. The corner cases are in having a failing drive which you can't
hot remove because you can't write to it.
It's unfortunate that you can't just "kill" a drive without umounting,
making the drive disappear so that btrfs can't see it (dmsetup remove
cryptname for me, so it's easy to do remotely), and remounting in degraded
mode.
 
> Question: Is the raid5 going to be seamlessly part of the
> error-correcting raids whereby raid5, raid6,
> raid-with-n-redundant-drives are all coded as one configurable raid?

I'm not sure I parse your question. As far as btrfs is concerned you can
switch from non raid to raid5 to raid6 by adding a drive and rebalancing
which effectively reads and re-writes all the blocks in the new format.

> Also (second question): What happened to the raid naming scheme that
> better described the btrfs-style of raid by explicitly numbering the
> number of devices used for mirroring, striping, and error-correction?

btrfs fi show kind of tells you that if you know how to read it (I didn't
initially). What's missing for you?

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
