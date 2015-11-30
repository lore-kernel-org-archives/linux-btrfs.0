Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48834 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896AbbK3Qf4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 11:35:56 -0500
Date: Mon, 30 Nov 2015 17:34:07 +0100
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Vegard Nossum <vegard.nossum@oracle.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: BUG: failure at fs/btrfs/ctree.h:337/btrfs_chunk_item_size()!
Message-ID: <20151130163407.GA31035@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5648CD1D.9070804@oracle.com>
 <20151130134851.GZ31035@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151130134851.GZ31035@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 30, 2015 at 02:48:51PM +0100, David Sterba wrote:
> On Sun, Nov 15, 2015 at 07:21:17PM +0100, Vegard Nossum wrote:
> > With the attached btrfs image, I get the following splat when mounting:
> > 
> > """
> > # mount -o loop -t btrfs ./btrfs.0 /mnt/0/
> > BTRFS: device fsid 9006933e-2a9a-44f0-917f-514252aeec2c devid 1 transid 
> > 7 /dev/loop0
> > BTRFS info (device loop0): disk space caching is enabled
> > BUG: failure at fs/btrfs/ctree.h:337/btrfs_chunk_item_size()!

The fix, worked for me on the provided image:
https://patchwork.kernel.org/patch/7728051/

I'll add the attached image to btrfs-progs testsuite as it triggers
crashes in other tools.
