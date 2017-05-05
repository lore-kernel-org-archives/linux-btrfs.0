Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55607 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752749AbdEESu4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 May 2017 14:50:56 -0400
Date: Fri, 5 May 2017 20:50:48 +0200
From: David Sterba <dsterba@suse.cz>
To: Sargun Dhillon <sargun@sargun.me>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: add quota override attribute
Message-ID: <20170505185048.GN10575@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170421231232.GA3769@ircssh-2.c.rugged-nimbus-611.internal>
 <20170421231246.GA3778@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170421231246.GA3778@ircssh-2.c.rugged-nimbus-611.internal>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 21, 2017 at 11:12:47PM +0000, Sargun Dhillon wrote:
> This patch introduces the quota override flag to btrfs_fs_info, and
> a change to quota limit checking code to temporarily allow for quota
> to be overridden for processes with cap_sys_resource.
> 
> It's useful for administrative programs, such as log rotation,
> that may need to temporarily use more disk space in order to free up
> a greater amount of overall disk space without yielding more disk
> space to the rest of userland.
> 
> Eventually, we may want to add the idea of an operator-specific
> quota, operator reserved space, or something else to allow for
> administrative override, but this is perhaps the simplest
> solution.
> 
> Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> ---
>  fs/btrfs/ctree.h  | 3 +++
>  fs/btrfs/qgroup.c | 9 +++++++--
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index c411590..01a095b 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1098,6 +1098,9 @@ struct btrfs_fs_info {
>  	u32 nodesize;
>  	u32 sectorsize;
>  	u32 stripesize;
> +
> +	/* Allow tasks with cap_sys_resource to override the quota */
> +	bool quota_override;

As mentioned, please define bitmask for the existing on-disk flags,
add a new one

#define BTRFS_QGROUP_OVERRIDE_LIMITS             (1ULL << 32)

and modify update_qgroup_status_item to use the bitmask.

>  };
>  
>  static inline struct btrfs_fs_info *btrfs_sb(struct super_block *sb)
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index a59801d..0328492 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2347,8 +2347,12 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
>  	return ret;
>  }
>  
> -static bool qgroup_check_limits(const struct btrfs_qgroup *qg, u64 num_bytes)
> +static bool qgroup_check_limits(const struct btrfs_qgroup *qg,
> +				u64 num_bytes, bool quota_override)
>  {
> +	if (quota_override && capable(CAP_SYS_RESOURCE))
> +		return true;
> +
>  	if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
>  	    qg->reserved + (s64)qg->rfer + num_bytes > qg->max_rfer)
>  		return false;
> @@ -2366,6 +2370,7 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce)
>  	struct btrfs_qgroup *qgroup;
>  	struct btrfs_fs_info *fs_info = root->fs_info;
>  	u64 ref_root = root->root_key.objectid;
> +	bool qo = fs_info->quota_override;
>  	int ret = 0;
>  	struct ulist_node *unode;
>  	struct ulist_iterator uiter;
> @@ -2401,7 +2406,7 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce)
>  
>  		qg = unode_aux_to_qgroup(unode);
>  
> -		if (enforce && !qgroup_check_limits(qg, num_bytes)) {
> +		if (enforce && !qgroup_check_limits(qg, num_bytes, qo)) {

I suggest to put the override check as a separate condition, no need to
pass it down to qgroup_check_limits.

>  			ret = -EDQUOT;
>  			goto out;
>  		}
> -- 
> 2.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
