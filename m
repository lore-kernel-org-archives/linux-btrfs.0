Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32893 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753907AbbK3Nuk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 08:50:40 -0500
Date: Mon, 30 Nov 2015 14:48:51 +0100
From: David Sterba <dsterba@suse.cz>
To: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: BUG: failure at fs/btrfs/ctree.h:337/btrfs_chunk_item_size()!
Message-ID: <20151130134851.GZ31035@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5648CD1D.9070804@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5648CD1D.9070804@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 15, 2015 at 07:21:17PM +0100, Vegard Nossum wrote:
> With the attached btrfs image, I get the following splat when mounting:
> 
> """
> # mount -o loop -t btrfs ./btrfs.0 /mnt/0/
> BTRFS: device fsid 9006933e-2a9a-44f0-917f-514252aeec2c devid 1 transid 
> 7 /dev/loop0
> BTRFS info (device loop0): disk space caching is enabled
> BUG: failure at fs/btrfs/ctree.h:337/btrfs_chunk_item_size()!

Looks like a fuzzed image, it blows when num_stripes is 0

 335 static inline unsigned long btrfs_chunk_item_size(int num_stripes)
 336 {
 337         BUG_ON(num_stripes == 0);
 338         return sizeof(struct btrfs_chunk) +
 339                 sizeof(struct btrfs_stripe) * (num_stripes - 1);
 340 }

called from btrfs_read_sys_array. The check for num_stripes == 0 seems to be
missing from kernel code, 'btrfs check' detects that and does not crash.

The userspace code has some more validations so I'll port them to kernel
and this should fix the mount crash.
