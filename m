Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:42602 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758289Ab2IMPmX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Sep 2012 11:42:23 -0400
Date: Thu, 13 Sep 2012 17:42:15 +0200
From: David Sterba <dave@jikos.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, jbacik@fusionio.com
Subject: Re: [PATCH v3] Btrfs: fix a bug of per-file nocow
Message-ID: <20120913154215.GC17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1347374030-5832-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1347374030-5832-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 11, 2012 at 10:33:50PM +0800, Liu Bo wrote:
> Users report a bug, the reproducer is:
> $ mkfs.btrfs /dev/loop0
> $ mount /dev/loop0 /mnt/btrfs/
> $ mkdir /mnt/btrfs/dir
> $ chattr +C /mnt/btrfs/dir/
> $ dd if=/dev/zero of=/mnt/btrfs/dir/foo bs=4K count=10;
> $ lsattr /mnt/btrfs/dir/foo
> ---------------C- /mnt/btrfs/dir/foo
> $ filefrag /mnt/btrfs/dir/foo
> /mnt/btrfs/dir/foo: 1 extent found    ---> an extent
> $ dd if=/dev/zero of=/mnt/btrfs/dir/foo bs=4K count=1 seek=5 conv=notrunc,nocreat; sync
> $ filefrag /mnt/btrfs/dir/foo
> /mnt/btrfs/dir/foo: 3 extents found   ---> with nocow, btrfs breaks the extent into three parts
> 
> The new created file should not only inherit the NODATACOW flag, but also
> honor NODATASUM flag, because we must do COW on a file extent with checksum.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
