Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25167 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315Ab3EPDVE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 23:21:04 -0400
Date: Thu, 16 May 2013 11:20:39 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, alex.btrfs@zadarastorage.com
Subject: Re: [PATCH 10/17] Btrfs: just flush the delalloc inodes in the
 source tree before snapshot creation
Message-ID: <20130516032034.GE20202@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
 <1368604111-25073-11-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1368604111-25073-11-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 15, 2013 at 03:48:24PM +0800, Miao Xie wrote:
> Before applying this patch, we need flush all the delalloc inodes in
> the fs when we want to create a snapshot, it wastes time, and make
> the transaction commit be blocked for a long time. It means some other
> user operation would also be blocked for a long time.
> 
> This patch improves this problem, we just flush the delalloc inodes that
> in the source trees before snapshot creation, so the transaction commit
> will complete quickly.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/ioctl.c       |  6 ++++++
>  fs/btrfs/transaction.c | 10 +---------
>  2 files changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 0de4a2f..2677dcc 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -555,6 +555,12 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
>  	if (!root->ref_cows)
>  		return -EINVAL;
>  
> +	ret = btrfs_start_delalloc_inodes(root, 0);
> +	if (ret)
> +		return ret;
> +
> +	btrfs_wait_ordered_extents(root, 0);
> +

Does this look too radical?  Does this snapshot creation ioctl block all
writes on its src root?
No, we can only be sure that there is no ordered extents being added until
setting trans_no_join, and then it's safe to create pending snapshots.

thanks,
liubo

>  	pending_snapshot = kzalloc(sizeof(*pending_snapshot), GFP_NOFS);
>  	if (!pending_snapshot)
>  		return -ENOMEM;
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 2b17213..bc22be9 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1491,17 +1491,9 @@ static int btrfs_flush_all_pending_stuffs(struct btrfs_trans_handle *trans,
>  					  struct btrfs_root *root)
>  {
>  	int flush_on_commit = btrfs_test_opt(root, FLUSHONCOMMIT);
> -	int snap_pending = 0;
>  	int ret;
>  
> -	if (!flush_on_commit) {
> -		spin_lock(&root->fs_info->trans_lock);
> -		if (!list_empty(&trans->transaction->pending_snapshots))
> -			snap_pending = 1;
> -		spin_unlock(&root->fs_info->trans_lock);
> -	}
> -
> -	if (flush_on_commit || snap_pending) {
> +	if (flush_on_commit) {
>  		ret = btrfs_start_all_delalloc_inodes(root->fs_info, 1);
>  		if (ret)
>  			return ret;
> -- 
> 1.8.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
