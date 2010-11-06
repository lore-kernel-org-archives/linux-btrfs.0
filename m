From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Log parent inode if it is newer than the last commit
Date: Sat, 6 Nov 2010 10:19:05 -0400
Message-ID: <20101106141905.GE9728@dhcp231-156.rdu.redhat.com>
References: <20101106200305.5d9eb7e0.kitayama@cl.bb4u.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101106200305.5d9eb7e0.kitayama@cl.bb4u.ne.jp>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 06, 2010 at 08:03:05PM +0900, Itaru Kitayama wrote:
> 
> In the file sync path, file's parent inode is logged if it is newer than the last
> commit. This patch checks also the last_trans field as well as generation.
> 
> As btrfs_log_inode updates the logged_trans field of parent dir's inode, tree-log
> lookup operations are suppressed upon unlink.
> 
> The patch is for the latest btrfs-unstable tree.
> 
> Signed-off-by: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
> 
> ---
>  fs/btrfs/tree-log.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index a29f193..db63ae4 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -3007,7 +3007,7 @@ int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
>                 if (root != BTRFS_I(inode)->root)
>                         break;
>  
> -               if (BTRFS_I(inode)->generation >
> +               if (max(BTRFS_I(inode)->generation, BTRFS_I(inode)->last_trans) >
>                     root->fs_info->last_trans_committed) {
>                         ret = btrfs_log_inode(trans, root, inode, inode_only);
>                         if (ret)

Looks good to me,

Reviewed-by: Josef Bacik <josef@redhat.com>

Thanks,

Josef
