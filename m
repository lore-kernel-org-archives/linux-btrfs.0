Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18363 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbbGPKyU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jul 2015 06:54:20 -0400
Date: Thu, 16 Jul 2015 18:54:06 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix lockdep warning of btrfs_run_delayed_iputs()
Message-ID: <20150716105405.GA6343@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <0cfb4c4a8ecd33b57dc0c8af2561afbc11a1fe42.1436932019.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0cfb4c4a8ecd33b57dc0c8af2561afbc11a1fe42.1436932019.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 15, 2015 at 11:48:14AM +0800, Zhaolei wrote:
> From: Zhao Lei <zhaolei@cn.fujitsu.com>
> 
> Liu Bo <bo.li.liu@oracle.com> reported a lockdep warning of
> delayed_iput_sem in xfstests generic/241:
>   [ 2061.345955] =============================================
>   [ 2061.346027] [ INFO: possible recursive locking detected ]
>   [ 2061.346027] 4.1.0+ #268 Tainted: G        W
>   [ 2061.346027] ---------------------------------------------
>   [ 2061.346027] btrfs-cleaner/3045 is trying to acquire lock:
>   [ 2061.346027]  (&fs_info->delayed_iput_sem){++++..}, at:
>   [<ffffffff814063ab>] btrfs_run_delayed_iputs+0x6b/0x100
>   [ 2061.346027] but task is already holding lock:
>   [ 2061.346027]  (&fs_info->delayed_iput_sem){++++..}, at: [<ffffffff814063ab>] btrfs_run_delayed_iputs+0x6b/0x100
>   [ 2061.346027] other info that might help us debug this:
>   [ 2061.346027]  Possible unsafe locking scenario:
> 
>   [ 2061.346027]        CPU0
>   [ 2061.346027]        ----
>   [ 2061.346027]   lock(&fs_info->delayed_iput_sem);
>   [ 2061.346027]   lock(&fs_info->delayed_iput_sem);
>   [ 2061.346027]
>    *** DEADLOCK ***
> It is rarely happened, about 1/400 in my test env.
> 
> The reason is recursion of btrfs_run_delayed_iputs():
>   cleaner_kthread
>   -> btrfs_run_delayed_iputs() *1
>   -> get delayed_iput_sem lock *2
>   -> iput()
>   -> ...
>   -> btrfs_commit_transaction()
>   -> btrfs_run_delayed_iputs() *1
>   -> get delayed_iput_sem lock (dead lock) *2
>   *1: recursion of btrfs_run_delayed_iputs()
>   *2: warning of lockdep about delayed_iput_sem
> 
> When fs is in high stress, new iputs may added into fs_info->delayed_iputs
> list when btrfs_run_delayed_iputs() is running, which cause
> second btrfs_run_delayed_iputs() run into down_read(&fs_info->delayed_iput_sem)
> again, and cause above lockdep warning.
> 
> Actually, it will not cause real problem because both locks are read lock,
> but to avoid lockdep warning, we can do a fix.
> 
> Fix:
>   Don't do btrfs_run_delayed_iputs() in btrfs_commit_transaction() for
>   cleaner_kthread thread to break above recursion path.
>   cleaner_kthread is calling btrfs_run_delayed_iputs() explicitly in code,
>   and don't need to call btrfs_run_delayed_iputs() again in
>   btrfs_commit_transaction(), it also give us a bonus to avoid stack overflow.
> 
> Test:
>   No above lockdep warning after patch in 1200 generic/241 tests.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo

> 
> Reported-by: Liu Bo <bo.li.liu@oracle.com>
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  fs/btrfs/transaction.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index c0f18e7..31248ad 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -2152,7 +2152,8 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>  
>  	kmem_cache_free(btrfs_trans_handle_cachep, trans);
>  
> -	if (current != root->fs_info->transaction_kthread)
> +	if (current != root->fs_info->transaction_kthread &&
> +	    current != root->fs_info->cleaner_kthread)
>  		btrfs_run_delayed_iputs(root);
>  
>  	return ret;
> -- 
> 1.8.5.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
