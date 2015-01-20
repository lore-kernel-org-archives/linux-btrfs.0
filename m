Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34259 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751633AbbATEYo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Jan 2015 23:24:44 -0500
Message-ID: <54BDD888.3090903@cn.fujitsu.com>
Date: Tue, 20 Jan 2015 12:24:40 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/6] btrfs: add support for processing pending changes
References: <cover.1415894837.git.dsterba@suse.cz> <572d9ab7845ea0e043ec34cd733a75228130ad03.1415894837.git.dsterba@suse.cz>
In-Reply-To: <572d9ab7845ea0e043ec34cd733a75228130ad03.1415894837.git.dsterba@suse.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: [PATCH 1/6] btrfs: add support for processing pending changes
From: David Sterba <dsterba@suse.cz>
To: <linux-btrfs@vger.kernel.org>
Date: 2014年11月14日 18:33
> There are some actions that modify global filesystem state but cannot be
> performed at the time of request, but later at the transaction commit
> time when the filesystem is in a known state.
>
> For example enabling new incompat features on-the-fly or issuing
> transaction commit from unsafe contexts (sysfs handlers).
>
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
>   fs/btrfs/ctree.h       | 45 +++++++++++++++++++++++++++++++++++++++++++++
>   fs/btrfs/disk-io.c     |  6 ++++++
>   fs/btrfs/transaction.c | 16 ++++++++++++++++
>   fs/btrfs/transaction.h |  2 ++
>   4 files changed, 69 insertions(+)
>
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index fe69edda11fb..f30b061ef77d 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1402,6 +1402,11 @@ struct btrfs_fs_info {
>   	 */
>   	u64 last_trans_log_full_commit;
>   	unsigned long mount_opt;
> +	/*
> +	 * Track requests for actions that need to be done during transaction
> +	 * commit (like for some mount options).
> +	 */
> +	unsigned long pending_changes;
>   	unsigned long compress_type:4;
>   	int commit_interval;
>   	/*
> @@ -2103,6 +2108,7 @@ struct btrfs_ioctl_defrag_range_args {
>   #define btrfs_raw_test_opt(o, opt)	((o) & BTRFS_MOUNT_##opt)
>   #define btrfs_test_opt(root, opt)	((root)->fs_info->mount_opt & \
>   					 BTRFS_MOUNT_##opt)
> +
>   #define btrfs_set_and_info(root, opt, fmt, args...)			\
>   {									\
>   	if (!btrfs_test_opt(root, opt))					\
> @@ -2118,6 +2124,45 @@ struct btrfs_ioctl_defrag_range_args {
>   }
>   
>   /*
> + * Requests for changes that need to be done during transaction commit.
> + *
> + * Internal mount options that are used for special handling of the real
> + * mount options (eg. cannot be set during remount and have to be set during
> + * transaction commit)
> + */
> +
> +#define btrfs_test_pending(info, opt)	\
> +	test_bit(BTRFS_PENDING_##opt, &(info)->pending_changes)
> +#define btrfs_set_pending(info, opt)	\
> +	set_bit(BTRFS_PENDING_##opt, &(info)->pending_changes)
> +#define btrfs_clear_pending(info, opt)	\
> +	clear_bit(BTRFS_PENDING_##opt, &(info)->pending_changes)
> +
> +/*
> + * Helpers for setting pending mount option changes.
> + *
> + * Expects corresponding macros
> + * BTRFS_PENDING_SET_ and CLEAR_ + short mount option name
> + */
> +#define btrfs_set_pending_and_info(info, opt, fmt, args...)            \
> +do {                                                                   \
> +       if (!btrfs_raw_test_opt((info)->mount_opt, opt)) {              \
> +               btrfs_info((info), fmt, ##args);                        \
> +               btrfs_set_pending((info), SET_##opt);                   \
> +               btrfs_clear_pending((info), CLEAR_##opt);               \
> +       }                                                               \
> +} while(0)
> +
> +#define btrfs_clear_pending_and_info(info, opt, fmt, args...)          \
> +do {                                                                   \
> +       if (btrfs_raw_test_opt((info)->mount_opt, opt)) {               \
> +               btrfs_info((info), fmt, ##args);                        \
> +               btrfs_set_pending((info), CLEAR_##opt);                 \
> +               btrfs_clear_pending((info), SET_##opt);                 \
> +       }                                                               \
> +} while(0)
> +
> +/*
>    * Inode flags
>    */
>   #define BTRFS_INODE_NODATASUM		(1 << 0)
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 1bf9f897065d..fd80c0d98421 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2834,6 +2834,12 @@ retry_root_backup:
>   	if (btrfs_test_opt(tree_root, CHANGE_INODE_CACHE))
>   		btrfs_set_opt(tree_root->fs_info->mount_opt, INODE_MAP_CACHE);
>   
> +	/*
> +	 * Mount does not set all options immediatelly, we can do it now and do
> +	 * not have to wait for transaction commit
> +	 */
> +	btrfs_apply_pending_changes(fs_info);
> +
>   #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
>   	if (btrfs_test_opt(tree_root, CHECK_INTEGRITY)) {
>   		ret = btrfsic_mount(tree_root, fs_devices,
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index dcaae3616728..7a4024a55e5c 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1850,6 +1850,8 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>   	else
>   		btrfs_clear_opt(root->fs_info->mount_opt, INODE_MAP_CACHE);
>   
> +	btrfs_apply_pending_changes(root->fs_info);
> +
>   	/* commit_fs_roots gets rid of all the tree log roots, it is now
>   	 * safe to free the root of tree log roots
>   	 */
> @@ -2019,3 +2021,17 @@ int btrfs_clean_one_deleted_snapshot(struct btrfs_root *root)
>   
>   	return (ret < 0) ? 0 : 1;
>   }
> +
> +void btrfs_apply_pending_changes(struct btrfs_fs_info *fs_info)
> +{
> +	unsigned long prev;
> +	unsigned long bit;
> +
> +	prev = cmpxchg(&fs_info->pending_changes, 0, 0);
Another HUGE problem here.
cmpxchg will only change the pending_changes to 0 if it's already 0.
If it not 0, it will not change pending_changes to 0.

So pending_changes will always be non-zero if set_pending....

Thanks,
Qu
> +	if (!prev)
> +		return;
> +
> +	if (prev)
> +		btrfs_warn(fs_info,
> +			"unknown pending changes left 0x%lx, ignoring", prev);
> +}
> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
> index d8f40e1a5d2d..75ebcfce9d57 100644
> --- a/fs/btrfs/transaction.h
> +++ b/fs/btrfs/transaction.h
> @@ -170,4 +170,6 @@ int btrfs_wait_marked_extents(struct btrfs_root *root,
>   int btrfs_transaction_blocked(struct btrfs_fs_info *info);
>   int btrfs_transaction_in_commit(struct btrfs_fs_info *info);
>   void btrfs_put_transaction(struct btrfs_transaction *transaction);
> +void btrfs_apply_pending_changes(struct btrfs_fs_info *fs_info);
> +
>   #endif

