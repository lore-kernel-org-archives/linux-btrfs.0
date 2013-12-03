Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from postfix.iai.uni-bonn.de ([131.220.8.4]:61426 "EHLO
	postfix.iai.uni-bonn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab3LCTPB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Dec 2013 14:15:01 -0500
Message-ID: <529E2DB1.10206@informatik.uni-bonn.de>
Date: Tue, 03 Dec 2013 20:14:57 +0100
From: Sebastian Ochmann <ochmann@informatik.uni-bonn.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v3] Btrfs: fix wrong super generation mismatch when scrubbing
 supers
References: <1386005619-7750-1-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1386005619-7750-1-git-send-email-wangshilong1991@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I know, the discussion on how to fix the problem best is still on-going, 
but I wanted to add that I tried v3 of the patch against btrfs-next on 
my machine. Without the patch, I was able to reproduce the problem 
within a few minutes; after applying it, I wasn't able to trigger it for 
50 minutes now.

I can't tell whether the problem would reoccur when running my little 
test for another week or so, but I can tell that my machine did not 
catch fire either. So it seems like you're on the right track. :)

I can also try another version of the patch when it becomes available.

Thanks,
Sebastian

On 02.12.2013 18:33, Wang Shilong wrote:
> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>
> We came a race condition when scrubbing superblocks, the story is:
>
> In commiting transaction, we will update last_trans_commited after
> writting superblocks. if a scrub start after writting superblocks
> and before last_trans_commited, generation mismatch happens!
>
> We fix it by protecting writting superblock and updating last_trans_commited
> with tree_log_mutex.
>
> Reported-by: Sebastian Ochmann <ochmann@informatik.uni-bonn.de>
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> ---
> Changelog:
> 	v2->v3:move tree_log_mutex out of device_list_mutex.
> 	v1->v2: use right way to fix the problem.
> ---
>   fs/btrfs/scrub.c       | 11 +++++++----
>   fs/btrfs/transaction.c | 13 ++++++++++---
>   2 files changed, 17 insertions(+), 7 deletions(-)
>
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 561e2f1..a9ed102 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -2887,6 +2887,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
>   	}
>
>
> +	mutex_lock(&fs_info->tree_log_mutex);
>   	mutex_lock(&fs_info->fs_devices->device_list_mutex);
>   	dev = btrfs_find_device(fs_info, devid, NULL, NULL);
>   	if (!dev || (dev->missing && !is_dev_replace)) {
> @@ -2932,14 +2933,16 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
>   	atomic_inc(&fs_info->scrubs_running);
>   	mutex_unlock(&fs_info->scrub_lock);
>
> +	/*
> +	 * holding tree_log_mutex we can avoid generation mismatch while
> +	 * scrubbing superblocks, see comments in commiting transaction
> +	 * when updating last_trans_commited.
> +	 */
>   	if (!is_dev_replace) {
> -		/*
> -		 * by holding device list mutex, we can
> -		 * kick off writing super in log tree sync.
> -		 */
>   		ret = scrub_supers(sctx, dev);
>   	}
>   	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
> +	mutex_unlock(&fs_info->tree_log_mutex);
>
>   	if (!ret)
>   		ret = scrub_enumerate_chunks(sctx, dev, start, end,
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index c6a872a..052eb22 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1898,15 +1898,22 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>   		goto cleanup_transaction;
>   	}
>
> +	btrfs_finish_extent_commit(trans, root);
> +
> +	/*
> +	 * we must gurantee last_trans_commited update is protected by
> +	 * tree_log_mutex with write_ctree_super together, otherwise,
> +	 * scubbing super will come in before updating last_trans_commited
> +	 * and we will get generation mismatch when scrubbing superblocks.
> +	 */
> +	root->fs_info->last_trans_committed = cur_trans->transid;
> +
>   	/*
>   	 * the super is written, we can safely allow the tree-loggers
>   	 * to go about their business
>   	 */
>   	mutex_unlock(&root->fs_info->tree_log_mutex);
>
> -	btrfs_finish_extent_commit(trans, root);
> -
> -	root->fs_info->last_trans_committed = cur_trans->transid;
>   	/*
>   	 * We needn't acquire the lock here because there is no other task
>   	 * which can change it.
>

