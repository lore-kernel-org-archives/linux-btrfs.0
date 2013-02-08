Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36052 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946263Ab3BHPXJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Feb 2013 10:23:09 -0500
Date: Fri, 8 Feb 2013 16:23:07 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Kastorff <encryptio@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Kernel Panic while defragging a large file
Message-ID: <20130208152307.GH12339@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAOOVQY+pXRQgfx2U0U31sodKYwqPDwu9wkZ6a7=CEyBcy4X0YA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAOOVQY+pXRQgfx2U0U31sodKYwqPDwu9wkZ6a7=CEyBcy4X0YA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 05, 2013 at 03:35:15PM -0800, Chris Kastorff wrote:
> The machine is old and underpowered; a 32-bit Atom box with 2GB of RAM.

(underpowered)

> Running:
> btrfs fi defrag /media/lake/pu9

(will generate lots of dirty buffers to write and will stress memory
subsystem)

> block group 8580959109120 has an wrong amount of free space
> btrfs: failed to load free space cache for block group 8580959109120
> BUG: unable to handle kernel paging request at 80000829
> IP: [<c022f968>] __kmalloc+0x58/0x160

Crash inside __kmalloc, probably touching unmapped/unallocated memory,
we'd need to see where exactly, I cant' tell from what I see in the
trace.

The address 80000829 may be part of the page tables or other internal
structures, or it's a bitflip (underpowered and overloaded machine may
trigger such things).

> Several other kernel BUG lines and stack traces about "unable to
> handle paging request at %x" occur soon after, on various PIDs and
> various stack traces (including some from a writev to a socket, a
> fairly well-tested operation.)

I guess all the reported addresses are the same or very similar,
provided that it's a bug in memory management code and any process that
tried to kmalloc memory woudl trip over the same code.

> Eventually (~10 seconds) the kernel panics. My screen is too small to
> see the whole message, but I can probably scrounge it up with some
> effort if that's desired.
> 
> This feels like a kernel running out of ram problem. I'm running rsync
> -avPS to defragment the file more manually, but will keep the old
> version around in case further testing is desired.

My conclusion that it's result of high load that provoked a MM bug.


david
