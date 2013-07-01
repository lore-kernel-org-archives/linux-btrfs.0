Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:47319 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885Ab3GAUWK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jul 2013 16:22:10 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 91D337C042F
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Jul 2013 14:22:09 -0600 (MDT)
Date: Mon, 1 Jul 2013 16:22:06 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix a bug of snapshot-aware defrag to make it
 work on partial extents
Message-ID: <20130701202206.GG4288@localhost.localdomain>
References: <1372688006-18176-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1372688006-18176-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 01, 2013 at 10:13:26PM +0800, Liu Bo wrote:
> For partial extents, snapshot-aware defrag does not work as expected,
> since
> a) we use the wrong logical offset to search for parents, which should be
>    disk_bytenr + extent_offset, not just disk_bytenr,
> b) 'offset' returned by the backref walking just refers to key.offset, not
>    the 'offset' stored in btrfs_extent_data_ref which is
>    (key.offset - extent_offset).
> 
> The reproducer:
> $ mkfs.btrfs sda
> $ mount sda /mnt
> $ btrfs sub create /mnt/sub
> $ for i in `seq 5 -1 1`; do dd if=/dev/zero of=/mnt/sub/foo bs=5k count=1 seek=$i conv=notrunc oflag=sync; done
> $ btrfs sub snap /mnt/sub /mnt/snap1
> $ btrfs sub snap /mnt/sub /mnt/snap2
> $ sync; btrfs filesystem defrag /mnt/sub/foo;
> $ umount /mnt
> $ btrfs-debug-tree sda (Here we can check whether the defrag operation is snapshot-awared.
> 
> This addresses the above two problems.
> 

Can this be turned into a xfstest somehow?  Like do fiemap and make sure the
block numbers match up right?  Thanks,

Josef
