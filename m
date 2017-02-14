Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31834 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751736AbdBNWHL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Feb 2017 17:07:11 -0500
Date: Tue, 14 Feb 2017 14:06:13 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix data loss after truncate when using the
 no-holes feature
Message-ID: <20170214220613.GJ31091@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1487104526-13617-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1487104526-13617-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 14, 2017 at 08:35:26PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If we have a file with an implicit hole (NO_HOLES feature enabled) that
> has an extent following the hole, delayed writes against regions of the
> file behind the hole happened before but were not yet flushed and then
> we truncate the file to a smaller size that lies inside the hole, we
> end up persisting a wrong disk_i_size value for our inode that leads to
> data loss after umounting and mounting again the filesystem or after
> the inode is evicted and loaded again.
> 
> This happens because at inode.c:btrfs_truncate_inode_items() we end up
> setting last_size to the offset of the extent that we deleted and that
> followed the hole. We then pass that value to btrfs_ordered_update_i_size()
> which updates the inode's disk_i_size to a value smaller then the offset
> of the buffered (delayed) writes.
> 
> Example reproducer:
> 
>  $ mkfs.btrfs -f /dev/sdb
>  $ mount /dev/sdb /mnt
> 
>  $ xfs_io -f -c "pwrite -S 0x01 0K 32K" /mnt/foo
>  $ xfs_io -d -c "pwrite -S 0x02 -b 32K 64K 32K" /mnt/foo
>  $ xfs_io -c "truncate 60K" /mnt/foo
>    --> inode's disk_i_size updated to 0
> 
>  $ md5sum /mnt/foo
>  3c5ca3c3ab42f4b04d7e7eb0b0d4d806  /mnt/foo
> 
>  $ umount /dev/sdb
>  $ mount /dev/sdb /mnt
> 
>  $ md5sum /mnt/foo
>  d41d8cd98f00b204e9800998ecf8427e  /mnt/foo
>    --> Empty file, all data lost!
> 
> Cc: <stable@vger.kernel.org>  # 3.14+
> Fixes: 16e7549f045d ("Btrfs: incompatible format change to remove hole extents")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/inode.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 8eb6703..a0a38ce 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4703,8 +4703,12 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
>  			btrfs_abort_transaction(trans, ret);
>  	}
>  error:
> -	if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID)
> +	if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID) {
> +		if (last_size > new_size &&
> +		    btrfs_fs_incompat(fs_info, NO_HOLES))
> +			last_size = new_size;
>  		btrfs_ordered_update_i_size(inode, last_size, NULL);
> +	}
>

Looks good to me.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

We can also remove the code that sets last_size = new_size in the case of
NO_HOLES inside the while loop, as I think this patch covers that, too.

Because we've held the inode mutex and wait for the dirty pages beyond the
current i_size, in fact, I couldn't think of a case that with NO_HOLE last_size
< new_size, maybe we could use new_size directly and add a ASSERT just in case?

Thanks,

-liubo
>  	btrfs_free_path(path);
>  
> -- 
> 2.7.0.rc3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
