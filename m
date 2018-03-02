Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:51656 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423170AbeCBSnD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Mar 2018 13:43:03 -0500
Date: Fri, 2 Mar 2018 10:40:24 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: fix log replay failure after linking special
 file and fsync
Message-ID: <20180302174024.GD30920@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Reply-To: bo.li.liu@oracle.com
References: <20180228155540.5766-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180228155540.5766-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 28, 2018 at 03:55:40PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If in the same transaction we rename a special file (fifo, character/block
> device or symbolic link), create a hard link for it having its old name
> then sync the log, we will end up with a log that can not be replayed and
> at when attempting to replay it, an EEXIST error is returned and mounting
> the filesystem fails. Example scenario:
> 
>   $ mkfs.btrfs -f /dev/sdc
>   $ mount /dev/sdc /mnt
>   $ mkdir /mnt/testdir
>   $ mkfifo /mnt/testdir/foo
>   # Make sure everything done so far is durably persisted.
>   $ sync
> 
>   # Create some unrelated file and fsync it, this is just to create a log
>   # tree. The file must be in the same directory as our special file.
>   $ touch /mnt/testdir/f1
>   $ xfs_io -c "fsync" /mnt/testdir/f1
> 
>   # Rename our special file and then create a hard link with its old name.
>   $ mv /mnt/testdir/foo /mnt/testdir/bar
>   $ ln /mnt/testdir/bar /mnt/testdir/foo
> 
>   # Create some other unrelated file and fsync it, this is just to persist
>   # the log tree which was modified by the previous rename and link
>   # operations. Alternatively we could have modified file f1 and fsync it.
>   $ touch /mnt/f2
>   $ xfs_io -c "fsync" /mnt/f2
> 
>   <power failure>
> 
>   $ mount /dev/sdc /mnt
>   mount: mount /dev/sdc on /mnt failed: File exists
> 
> This happens because when both the log tree and the subvolume's tree have
> an entry in the directory "testdir" with the same name, that is, there
> is one key (258 INODE_REF 257) in the subvolume tree and another one in
> the log tree (where 258 is the inode number of our special file and 257
> is the inode for directory "testdir"). Only the data of those two keys
> differs, in the subvolume tree the index field for inode reference has
> a value of 3 while the log tree it has a value of 5. Because the same key
> exists in both trees, but have different index, the log replay fails with
> an -EEXIST error when attempting to replay the inode reference from the
> log tree.
> 
> Fix this by setting the last_unlink_trans field of the inode (our special
> file) to the current transaction id when a hard link is created, as this
> forces logging the parent directory inode, solving the conflict at log
> replay time.
> 

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> A new generic test case for fstests was also submitted.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/tree-log.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 28d0de199b05..411a022489e4 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -5841,7 +5841,7 @@ int btrfs_log_new_name(struct btrfs_trans_handle *trans,
>  	 * this will force the logging code to walk the dentry chain
>  	 * up for the file
>  	 */
> -	if (S_ISREG(inode->vfs_inode.i_mode))
> +	if (!S_ISDIR(inode->vfs_inode.i_mode))
>  		inode->last_unlink_trans = trans->transid;
>  
>  	/*
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
