Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57308 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756917AbdEVBUw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 May 2017 21:20:52 -0400
Subject: Re: [PATCH 4/8] btrfs: autoremove qgroup by default, and add a mount
 flag to override
To: Sargun Dhillon <sargun@sargun.me>, <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <b4f83285-3ca1-e92d-1b6a-e2b3b68d0a6a@cn.fujitsu.com>
Date: Mon, 22 May 2017 09:20:48 +0800
MIME-Version: 1.0
In-Reply-To: <20170520083920.GA4222@ircssh-2.c.rugged-nimbus-611.internal>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20170520083920.GA4222@ircssh-2.c.rugged-nimbus-611.internal>



At 05/20/2017 04:39 PM, Sargun Dhillon wrote:
> This change follows the change to automatically remove qgroups
> if the associated subvolume has also been removed. It changes
> the default behaviour to automatically remove qgroups when
> a subvolume is deleted, but this can be override with the
> qgroup_keep mount flag.
> 
> Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> ---
>   fs/btrfs/ctree.h |  1 +
>   fs/btrfs/ioctl.c | 14 ++++++++++++++
>   fs/btrfs/super.c | 16 +++++++++++++++-
>   3 files changed, 30 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 643c70d..4d57eb6 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1348,6 +1348,7 @@ static inline u32 BTRFS_MAX_XATTR_SIZE(const struct btrfs_fs_info *info)
>   #define BTRFS_MOUNT_FRAGMENT_METADATA	(1 << 25)
>   #define BTRFS_MOUNT_FREE_SPACE_TREE	(1 << 26)
>   #define BTRFS_MOUNT_NOLOGREPLAY		(1 << 27)
> +#define BTRFS_MOUNT_QGROUP_KEEP		(1 << 28)
>   
>   #define BTRFS_DEFAULT_COMMIT_INTERVAL	(30)
>   #define BTRFS_DEFAULT_MAX_INLINE	(2048)
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index e176375..b10d7bb 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2544,6 +2544,20 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
>   		}
>   	}
>   
> +	/*
> +	 * Attempt to automatically remove the automatically attached qgroup
> +	 * setup in btrfs_qgroup_inherit. As a matter of convention, the id
> +	 * is the same as the subvolume id.
> +	 *
> +	 * This can fail non-fatally for level 0 qgroups, and potentially
> +	 * leave the filesystem in an awkward, (but working) state.
> +	 */
> +	if (!btrfs_test_opt(fs_info, QGROUP_KEEP)) {
> +		ret = btrfs_remove_qgroup(trans, fs_info,
> +					  dest->root_key.objectid);
> +		if (ret && ret != -ENOENT)
> +			pr_info("Could not automatically delete qgroup: %d\n", ret);
> +	}
>   out_end_trans:
>   	trans->block_rsv = NULL;
>   	trans->bytes_reserved = 0;
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 4f1cdd5..232e1b8 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -321,7 +321,7 @@ enum {
>   	Opt_commit_interval, Opt_barrier, Opt_nodefrag, Opt_nodiscard,
>   	Opt_noenospc_debug, Opt_noflushoncommit, Opt_acl, Opt_datacow,
>   	Opt_datasum, Opt_treelog, Opt_noinode_cache, Opt_usebackuproot,
> -	Opt_nologreplay, Opt_norecovery,
> +	Opt_nologreplay, Opt_norecovery, Opt_qgroup_keep, Opt_qgroup_nokeep,

I prefer to add new meanings for btrfs_ioctl_qgroup_create_args->create.

It's a u64 value while we only checks if it's zero or not, to determine 
if it's creation or deletion.

We could reuse it to extent the create/delete behavior, other than a new 
mount option, which is a global flag, just to alter qgroup behavior.

Thanks,
Qu

>   #ifdef CONFIG_BTRFS_DEBUG
>   	Opt_fragment_data, Opt_fragment_metadata, Opt_fragment_all,
>   #endif
> @@ -381,6 +381,8 @@ static const match_table_t tokens = {
>   	{Opt_rescan_uuid_tree, "rescan_uuid_tree"},
>   	{Opt_fatal_errors, "fatal_errors=%s"},
>   	{Opt_commit_interval, "commit=%d"},
> +	{Opt_qgroup_keep, "qgroup_keep"},
> +	{Opt_qgroup_nokeep, "qgroup_nokeep"},
>   #ifdef CONFIG_BTRFS_DEBUG
>   	{Opt_fragment_data, "fragment=data"},
>   	{Opt_fragment_metadata, "fragment=metadata"},
> @@ -808,6 +810,14 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
>   				info->commit_interval = BTRFS_DEFAULT_COMMIT_INTERVAL;
>   			}
>   			break;
> +		case Opt_qgroup_keep:
> +			btrfs_set_and_info(info, QGROUP_KEEP,
> +					   "do not automatically delete qgroups");
> +			break;
> +		case Opt_qgroup_nokeep:
> +			btrfs_clear_and_info(info, QGROUP_KEEP,
> +					     "automatically delete qgroups");
> +			break;
>   #ifdef CONFIG_BTRFS_DEBUG
>   		case Opt_fragment_all:
>   			btrfs_info(info, "fragmenting all space");
> @@ -1299,6 +1309,10 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
>   		seq_puts(seq, ",fatal_errors=panic");
>   	if (info->commit_interval != BTRFS_DEFAULT_COMMIT_INTERVAL)
>   		seq_printf(seq, ",commit=%d", info->commit_interval);
> +	if (btrfs_test_opt(info, QGROUP_KEEP))
> +		seq_puts(seq, ",qgroup_keep");
> +	else
> +		seq_puts(seq, ",qgroup_nokeep");
>   #ifdef CONFIG_BTRFS_DEBUG
>   	if (btrfs_test_opt(info, FRAGMENT_DATA))
>   		seq_puts(seq, ",fragment=data");
> 


