Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36600 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752583AbdDXDmd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 23 Apr 2017 23:42:33 -0400
Subject: Re: [PATCH 1/2] btrfs: add quota override attribute
To: Sargun Dhillon <sargun@sargun.me>, <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <8b6ffc4e-c5e6-3511-a8b7-2de28cc48bac@cn.fujitsu.com>
Date: Mon, 24 Apr 2017 11:42:25 +0800
MIME-Version: 1.0
In-Reply-To: <20170421231246.GA3778@ircssh-2.c.rugged-nimbus-611.internal>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20170421231246.GA3778@ircssh-2.c.rugged-nimbus-611.internal>



At 04/22/2017 07:12 AM, Sargun Dhillon wrote:
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

Indeed simplest method yet.

But considering that reserved data space can be used by none privileged 
user, I'm not sure if it's a good idea.

For example:

If root want to write a 64M file with new data, then it reserved 64M 
data space.

And another none privileged user also want to write that 64M file with 
different data, then the user won't need to reserve data space.
(Although metadata space is still needed).

Won't this cause some method to escaping the qgroup limit?

> 
> Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> ---
>   fs/btrfs/ctree.h  | 3 +++
>   fs/btrfs/qgroup.c | 9 +++++++--
>   2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index c411590..01a095b 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1098,6 +1098,9 @@ struct btrfs_fs_info {
>   	u32 nodesize;
>   	u32 sectorsize;
>   	u32 stripesize;
> +
> +	/* Allow tasks with cap_sys_resource to override the quota */
> +	bool quota_override;

Why not use existing fs_info->qgroup_flags?

Thanks,
Qu

>   };
>   
>   static inline struct btrfs_fs_info *btrfs_sb(struct super_block *sb)
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index a59801d..0328492 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2347,8 +2347,12 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
>   	return ret;
>   }
>   
> -static bool qgroup_check_limits(const struct btrfs_qgroup *qg, u64 num_bytes)
> +static bool qgroup_check_limits(const struct btrfs_qgroup *qg,
> +				u64 num_bytes, bool quota_override)
>   {
> +	if (quota_override && capable(CAP_SYS_RESOURCE))
> +		return true;
> +
>   	if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
>   	    qg->reserved + (s64)qg->rfer + num_bytes > qg->max_rfer)
>   		return false;
> @@ -2366,6 +2370,7 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce)
>   	struct btrfs_qgroup *qgroup;
>   	struct btrfs_fs_info *fs_info = root->fs_info;
>   	u64 ref_root = root->root_key.objectid;
> +	bool qo = fs_info->quota_override;
>   	int ret = 0;
>   	struct ulist_node *unode;
>   	struct ulist_iterator uiter;
> @@ -2401,7 +2406,7 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce)
>   
>   		qg = unode_aux_to_qgroup(unode);
>   
> -		if (enforce && !qgroup_check_limits(qg, num_bytes)) {
> +		if (enforce && !qgroup_check_limits(qg, num_bytes, qo)) {
>   			ret = -EDQUOT;
>   			goto out;
>   		}
> 


