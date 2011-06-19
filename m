From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: Re: please review snapshot corruption path with delayed metadata
 insertion
Date: Sun, 19 Jun 2011 13:34:43 +0900
Message-ID: <4DFD7C63.6040902@jp.fujitsu.com>
References: <1308345034-sup-1969@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Miao Xie <miaox@cn.fujitsu.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1308345034-sup-1969@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Chris,

(2011/06/18 6:12), Chris Mason wrote:
> Hi everyone,
>
> I think I tracked down the oops we were seeing Tsutomu Itoh's balance
> test.  The delayed metadata insertion code was allowing delayed updates
> to queue up and be process after the snapshot was created.
>
> I've fixed this up by moving the delayed metadata run down into the
> snapshot creation code, please take a look.  If nobody objects I'll have
> this in the pull I send to Linus this weekend.

I ran my balance test script about 12 hours, any problem didn't occur.

Thanks,
Tsutomu

>
> commit e999376f094162aa425ae749aa1df95ab928d010
> Author: Chris Mason<chris.mason@oracle.com>
> Date:   Fri Jun 17 16:14:09 2011 -0400
>
>      Btrfs: avoid delayed metadata items during commits
>
>      Snapshot creation has two phases.  One is the initial snapshot setup,
>      and the second is done during commit, while nobody is allowed to modify
>      the root we are snapshotting.
>
>      The delayed metadata insertion code can break that rule, it does a
>      delayed inode update on the inode of the parent of the snapshot,
>      and delayed directory item insertion.
>
>      This makes sure to run the pending delayed operations before we
>      record the snapshot root, which avoids corruptions.
>
>      Signed-off-by: Chris Mason<chris.mason@oracle.com>
>
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index fc515b7..f1cbd02 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -1237,6 +1237,13 @@ again:
>   	return 0;
>   }
>
> +void btrfs_assert_delayed_root_empty(struct btrfs_root *root)
> +{
> +	struct btrfs_delayed_root *delayed_root;
> +	delayed_root = btrfs_get_delayed_root(root);
> +	WARN_ON(btrfs_first_delayed_node(delayed_root));
> +}
> +
>   void btrfs_balance_delayed_items(struct btrfs_root *root)
>   {
>   	struct btrfs_delayed_root *delayed_root;
> diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
> index cb79b67..d1a6a29 100644
> --- a/fs/btrfs/delayed-inode.h
> +++ b/fs/btrfs/delayed-inode.h
> @@ -137,4 +137,8 @@ int btrfs_readdir_delayed_dir_index(struct file *filp, void *dirent,
>   /* for init */
>   int __init btrfs_delayed_inode_init(void);
>   void btrfs_delayed_inode_exit(void);
> +
> +/* for debugging */
> +void btrfs_assert_delayed_root_empty(struct btrfs_root *root);
> +
>   #endif
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index c073d85..51dcec8 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -957,6 +957,15 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>   	ret = btrfs_update_inode(trans, parent_root, parent_inode);
>   	BUG_ON(ret);
>
> +	/*
> +	 * pull in the delayed directory update
> +	 * and the delayed inode item
> +	 * otherwise we corrupt the FS during
> +	 * snapshot
> +	 */
> +	ret = btrfs_run_delayed_items(trans, root);
> +	BUG_ON(ret);
> +
>   	record_root_in_trans(trans, root);
>   	btrfs_set_root_last_snapshot(&root->root_item, trans->transid);
>   	memcpy(new_root_item,&root->root_item, sizeof(*new_root_item));
> @@ -1018,14 +1027,6 @@ static noinline int create_pending_snapshots(struct btrfs_trans_handle *trans,
>   	int ret;
>
>   	list_for_each_entry(pending, head, list) {
> -		/*
> -		 * We must deal with the delayed items before creating
> -		 * snapshots, or we will create a snapthot with inconsistent
> -		 * information.
> -		*/
> -		ret = btrfs_run_delayed_items(trans, fs_info->fs_root);
> -		BUG_ON(ret);
> -
>   		ret = create_pending_snapshot(trans, fs_info, pending);
>   		BUG_ON(ret);
>   	}
> @@ -1319,15 +1320,21 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>   	 */
>   	mutex_lock(&root->fs_info->reloc_mutex);
>
> -	ret = create_pending_snapshots(trans, root->fs_info);
> +	ret = btrfs_run_delayed_items(trans, root);
>   	BUG_ON(ret);
>
> -	ret = btrfs_run_delayed_items(trans, root);
> +	ret = create_pending_snapshots(trans, root->fs_info);
>   	BUG_ON(ret);
>
>   	ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
>   	BUG_ON(ret);
>
> +	/*
> +	 * make sure none of the code above managed to slip in a
> +	 * delayed item
> +	 */
> +	btrfs_assert_delayed_root_empty(root);
> +
>   	WARN_ON(cur_trans != trans->transaction);
>
>   	btrfs_scrub_pause(root);
>
>

