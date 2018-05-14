Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53956 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753822AbeENNx6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 09:53:58 -0400
Date: Mon, 14 May 2018 15:51:18 +0200
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix xattr loss after power failure
Message-ID: <20180514135118.GJ6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180511154242.12904-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180511154242.12904-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 11, 2018 at 04:42:42PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If a file has xattrs, we fsync it, to ensure we clear the flags
> BTRFS_INODE_NEEDS_FULL_SYNC and BTRFS_INODE_COPY_EVERYTHING from its
> inode, the current transaction commits and then we fsync it (without
> either of those bits being set in its inode), we end up not logging
> all its xattrs. This results in deleting all xattrs when replying the
> log after a power failure.
> 
> Trivial reproducer
> 
>   $ mkfs.btrfs -f /dev/sdb
>   $ mount /dev/sdb /mnt
> 
>   $ touch /mnt/foobar
>   $ setfattr -n user.xa -v qwerty /mnt/foobar
>   $ xfs_io -c "fsync" /mnt/foobar
> 
>   $ sync
> 
>   $ xfs_io -c "pwrite -S 0xab 0 64K" /mnt/foobar
>   $ xfs_io -c "fsync" /mnt/foobar
>   <power failure>
> 
>   $ mount /dev/sdb /mnt
>   $ getfattr --absolute-names --dump /mnt/foobar
>   <empty output>
>   $
> 
> So fix this by making sure all xattrs are logged if we log a file's inode
> item and neither the flags BTRFS_INODE_NEEDS_FULL_SYNC nor
> BTRFS_INODE_COPY_EVERYTHING were set in the inode.
> 
> Fixes: 36283bf777d9 ("Btrfs: fix fsync xattr loss in the fast fsync path")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Added to next, thanks, and I'll probably add that to 4.17-rc too.
