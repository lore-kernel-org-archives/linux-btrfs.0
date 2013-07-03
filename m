Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41680 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab3GCJrb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jul 2013 05:47:31 -0400
Date: Wed, 3 Jul 2013 17:47:21 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix a bug of snapshot-aware defrag to make it
 work on partial extents
Message-ID: <20130703094721.GC15921@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1372688006-18176-1-git-send-email-bo.li.liu@oracle.com>
 <20130701202206.GG4288@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130701202206.GG4288@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 01, 2013 at 04:22:06PM -0400, Josef Bacik wrote:
> On Mon, Jul 01, 2013 at 10:13:26PM +0800, Liu Bo wrote:
> > For partial extents, snapshot-aware defrag does not work as expected,
> > since
> > a) we use the wrong logical offset to search for parents, which should be
> >    disk_bytenr + extent_offset, not just disk_bytenr,
> > b) 'offset' returned by the backref walking just refers to key.offset, not
> >    the 'offset' stored in btrfs_extent_data_ref which is
> >    (key.offset - extent_offset).
> > 
> > The reproducer:
> > $ mkfs.btrfs sda
> > $ mount sda /mnt
> > $ btrfs sub create /mnt/sub
> > $ for i in `seq 5 -1 1`; do dd if=/dev/zero of=/mnt/sub/foo bs=5k count=1 seek=$i conv=notrunc oflag=sync; done
> > $ btrfs sub snap /mnt/sub /mnt/snap1
> > $ btrfs sub snap /mnt/sub /mnt/snap2
> > $ sync; btrfs filesystem defrag /mnt/sub/foo;
> > $ umount /mnt
> > $ btrfs-debug-tree sda (Here we can check whether the defrag operation is snapshot-awared.
> > 
> > This addresses the above two problems.
> > 
> 
> Can this be turned into a xfstest somehow?  Like do fiemap and make sure the
> block numbers match up right?  Thanks,

Yeah, I've sent a patch for this :)

- liubo
