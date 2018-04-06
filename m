Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33938 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756297AbeDFNka (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Apr 2018 09:40:30 -0400
Date: Fri, 6 Apr 2018 15:38:00 +0200
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix loss of prealloc extents past i_size after
 fsync log replay
Message-ID: <20180406133800.GE8557@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180405215512.513-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180405215512.513-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 05, 2018 at 10:55:12PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Currently if we allocate extents beyond an inode's i_size (through the
> fallocate system call) and then fsync the file, we log the extents but
> after a power failure we replay them and then immediately drop them.
> This behaviour happens since about 2009, commit c71bf099abdd ("Btrfs:
> Avoid orphan inodes cleanup while replaying log"), because it marks
> the inode as an orphan instead of dropping any extents beyond i_size
> before replaying logged extents, so after the log replay, and while
> the mount operation is still ongoing, we find the inode marked as an
> orphan and then perform a truncation (drop extents beyond the inode's
> i_size). Because the processing of orphan inodes is still done
> right after replaying the log and before the mount operation finishes,
> the intention of that commit does not make any sense (at least as
> of today). However reverting that behaviour is not enough, because
> we can not simply discard all extents beyond i_size and then replay
> logged extents, because we risk dropping extents beyond i_size created
> in past transactions, for example:
> 
>   add prealloc extent beyond i_size
>   fsync - clears the flag BTRFS_INODE_NEEDS_FULL_SYNC from the inode
>   transaction commit
>   add another prealloc extent beyond i_size
>   fsync - triggers the fast fsync path
>   power failure
> 
> In that scenario, we would drop the first extent and then replay the
> second one. To fix this just make sure that all prealloc extents
> beyond i_size are logged, and if we find too many (which is far from
> a common case), fallback to a full transaction commit (like we do when
> logging regular extents in the fast fsync path).
> 
> Trivial reproducer:
> 
>  $ mkfs.btrfs -f /dev/sdb
>  $ mount /dev/sdb /mnt
>  $ xfs_io -f -c "pwrite -S 0xab 0 256K" /mnt/foo
>  $ sync
>  $ xfs_io -c "falloc -k 256K 1M" /mnt/foo
>  $ xfs_io -c "fsync" /mnt/foo
>  <power failure>
> 
>  # mount to replay log
>  $ mount /dev/sdb /mnt
>  # at this point the file only has one extent, at offset 0, size 256K
> 
> A test case for fstests follows soon, covering multiple scenarios that
> involve adding prealloc extents with previous shrinking truncates and
> without such truncates.
> 
> Fixes: c71bf099abdd ("Btrfs: Avoid orphan inodes cleanup while replaying log")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Added to next, thanks.
