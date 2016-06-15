Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16628 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932882AbcFOUt0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jun 2016 16:49:26 -0400
Date: Wed, 15 Jun 2016 13:50:55 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add missing check for writeback errors on fsync
Message-ID: <20160615205055.GA8071@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1465933822-25805-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1465933822-25805-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 14, 2016 at 08:50:22PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> When we start an fsync we start ordered extents for all delalloc ranges.
> However before attempting to log the inode, we only wait for those ordered
> extents if we are not doing a full sync (bit BTRFS_INODE_NEEDS_FULL_SYNC
> is set in the inode's flags). This means that if an ordered extent
> completes with an IO error before we check if we can skip logging the
> inode, we will not catch and report the IO error to user space. This is
> because on an IO error, when the ordered extent completes we do not
> update the inode, so if the inode was not previously updated by the
> current transaction we end up not logging it through calls to fsync and
> therefore not check its mapping flags for the presence of IO errors.
> 
> Fix this by checking for errors in the flags of the inode's mapping when
> we notice we can skip logging the inode.
> 
> This caused sporadic failures in the test generic/331 (which explicitly
> tests for IO errors during an fsync call).

Good catch.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo

> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/file.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 159a934..6c6863a 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -2039,6 +2039,14 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  		 */
>  		clear_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
>  			  &BTRFS_I(inode)->runtime_flags);
> +		/*
> +		 * An ordered extent might have started before and completed
> +		 * already with io errors, in which case the inode was not
> +		 * updated and we end up here. So check the inode's mapping
> +		 * flags for any errors that might have happened while doing
> +		 * writeback of file data.
> +		 */
> +		ret = btrfs_inode_check_errors(inode);
>  		inode_unlock(inode);
>  		goto out;
>  	}
> -- 
> 2.7.0.rc3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
