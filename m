Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43017 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026Ab3AGQdd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Jan 2013 11:33:33 -0500
Date: Mon, 7 Jan 2013 17:33:27 +0100
From: David Sterba <dsterba@suse.cz>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: util-linux@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>,
        Chris Murphy <lists@colorremedies.com>
Subject: Re: Btrfs: wipe all the superblock [redhat bugzilla 889888]
Message-ID: <20130107163327.GK20089@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <50E9C267.3050302@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50E9C267.3050302@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 06, 2013 at 07:28:55PM +0100, Goffredo Baroncelli wrote:
> Currently wipefs doesn't clear all the superblock of btrfs. Only the first 
> one is cleared.
> 
> Btrfs has three superblocks. The first one is placed at 64KB, the second 
> one at 64MB, the third one at 256GB.

It can have as much as 4 superblock backup copies:

Superblock offset 0 is 65536 (0x10000, block=16/0x10)
Superblock offset 1 is 67108864 (0x4000000, block=16384/0x4000)
Superblock offset 2 is 274877906944 (0x4000000000, block=67108864/0x4000000)
Superblock offset 3 is 1125899906842624 (0x4000000000000, block=274877906944/0x4000000000)
Superblock offset 4 is 4611686018427387904 (0x4000000000000000, block=1125899906842624/0x4000000000000)

> If the first superblock is valid except that the "magic field" is zeroed,
> btrfs skips the check of the other superblocks.
> If the first superblock is fully invalid, btrfs checks for the other
> superblock.
> 
> So zeroing the first superblock "magic field" at the beginning seems
> that the filesystem is wiped. But when the first superblock is overwritten
> (e.g. by another filesystem), then the other two superblocks may be considered
> valid, and the filesystem may resurrect.

And for that purpose all the superblock copies should be taken into
account, regardless of the tricks that btrfs_mount applies.


david
