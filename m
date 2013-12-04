Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54235 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139Ab3LDAGq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Dec 2013 19:06:46 -0500
Date: Wed, 4 Dec 2013 01:06:44 +0100
From: David Sterba <dsterba@suse.cz>
To: chandan <chandan@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] Btrfs: Add linear chunk allocation support.
Message-ID: <20131204000644.GX25312@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1674620.BNzKaL6CNE@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1674620.BNzKaL6CNE@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 02, 2013 at 12:23:02PM +0630, chandan wrote:
> This patch implements the *core* of the idea suggested at
> https://btrfs.wiki.kernel.org/index.php/Project_ideas#Linear_chunk_allocation_mode.
> Other required changes (e.g. balance/restripe) will be made based on
> the reviews obtained for this patch.
> 
> On a multi-disk filesystem instance using single mode storage, we could
> minimize the data loss (due to a hard drive failure) by filling up a disk
> completely before starting to use another disk.

The usecase sounds ok, but I don't agree the incompat bit is the way to
implement that, this is not a format change that would make it
impossible to read the data on older kernels.

I assume you want to make the allocation policy permanent and nothing
else was available. We're in the process of getting the per-object
properties ready and I think this will fit your needs.

You can use a temporary mount option to set the allocator policy for
now. There's a related project idea that would build upon the same
infrastructure:

https://btrfs.wiki.kernel.org/index.php/Project_ideas#Better_data_balancing_over_multiple_devices_for_raid1.2F10_.28allocation.29

> Chunk allocation is performed based on the increasing order of devid i.e.
> the device with the lowest devid will be used for allocating the new chunk.

This does not look very flexible and highly depends on the order in
which the devices are added. I think a device property like 'allocation
priority' would let the user chose the device order.


david
