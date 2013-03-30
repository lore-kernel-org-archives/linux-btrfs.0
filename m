Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:52633 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754360Ab3C3XkZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Mar 2013 19:40:25 -0400
Received: from mailout-de.gmx.net ([10.1.76.35]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0MUBlU-1UCdAT3xy6-00R4Gj for
 <linux-btrfs@vger.kernel.org>; Sun, 31 Mar 2013 00:40:23 +0100
Message-ID: <51577832.1080908@gmx.net>
Date: Sun, 31 Mar 2013 00:41:38 +0100
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: linux-btrfs@vger.kernel.org, miaox@cn.fujitsu.com,
        wangsl-fnst@cn.fujitsu.com
Subject: Re: [PATCH V2 2/6] Btrfs: remove some unnecessary spin_lock usages
References: <1364468087-1702-1-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1364468087-1702-1-git-send-email-wangshilong1991@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/28/13 11:54, Wang Shilong wrote:
> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> 
> We use mutex_lock to protect all the user change operaions.
> So when we are calling find_qgroup_rb() to check whether
> qgroup exists, we don't have to hold spin_lock.
> 
> Besides, when enabling/disabling quota,it must be single
> thread when operations come to here.Spin_lock must be fistly
> used to clear quota_root when disabling quota,while enabling
> quota spin_lock must be used to complete the last assign work.
> 
> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/qgroup.c |   42 +++++++++++++++---------------------------
>  1 files changed, 15 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index e3598fa..7df372a 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -42,7 +42,6 @@
>   *  - limit
>   *  - caches fuer ulists
>   *  - performance benchmarks
> - *  - check all ioctl parameters
>   */
>  
>  /*
> @@ -98,7 +97,11 @@ struct btrfs_qgroup_list {
>  	struct btrfs_qgroup *member;
>  };
>  
> -/* must be called with qgroup_lock held */

instead it must be called with quota_lock held. The rest looks
correct to me.

-Arne

> +/*
> + * don't need to be held by spin_lock since
> + * all the quota configurations on memory has been protected
> + * by mutex quota_lock.
> + */


>  static struct btrfs_qgroup *find_qgroup_rb(struct btrfs_fs_info *fs_info,
>  					   u64 qgroupid)
>  {
> @@ -793,13 +796,10 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
>  	int ret = 0;
>  	int slot;
>  
> -	spin_lock(&fs_info->qgroup_lock);
>  	if (fs_info->quota_root) {
>  		fs_info->pending_quota_state = 1;
> -		spin_unlock(&fs_info->qgroup_lock);
> -		goto out;
> +		return ret;
>  	}
> -	spin_unlock(&fs_info->qgroup_lock);
>  
>  	/*
>  	 * initially create the quota tree
> @@ -808,7 +808,7 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
>  				       BTRFS_QUOTA_TREE_OBJECTID);
>  	if (IS_ERR(quota_root)) {
>  		ret =  PTR_ERR(quota_root);
> -		goto out;
> +		return ret;
>  	}
>  
>  	path = btrfs_alloc_path();
> @@ -861,14 +861,11 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
>  			if (ret)
>  				goto out_free_path;
>  
> -			spin_lock(&fs_info->qgroup_lock);
>  			qgroup = add_qgroup_rb(fs_info, found_key.offset);
>  			if (IS_ERR(qgroup)) {
> -				spin_unlock(&fs_info->qgroup_lock);
>  				ret = PTR_ERR(qgroup);
>  				goto out_free_path;
>  			}
> -			spin_unlock(&fs_info->qgroup_lock);
>  		}
>  		ret = btrfs_next_item(tree_root, path);
>  		if (ret < 0)
> @@ -883,13 +880,12 @@ out_add_root:
>  	if (ret)
>  		goto out_free_path;
>  
> -	spin_lock(&fs_info->qgroup_lock);
>  	qgroup = add_qgroup_rb(fs_info, BTRFS_FS_TREE_OBJECTID);
>  	if (IS_ERR(qgroup)) {
> -		spin_unlock(&fs_info->qgroup_lock);
>  		ret = PTR_ERR(qgroup);
>  		goto out_free_path;
>  	}
> +	spin_lock(&fs_info->qgroup_lock);
>  	fs_info->quota_root = quota_root;
>  	fs_info->pending_quota_state = 1;
>  	spin_unlock(&fs_info->qgroup_lock);
> @@ -901,7 +897,6 @@ out_free_root:
>  		free_extent_buffer(quota_root->commit_root);
>  		kfree(quota_root);
>  	}
> -out:
>  	return ret;
>  }
>  
> @@ -912,11 +907,10 @@ int btrfs_quota_disable(struct btrfs_trans_handle *trans,
>  	struct btrfs_root *quota_root;
>  	int ret = 0;
>  
> -	spin_lock(&fs_info->qgroup_lock);
> -	if (!fs_info->quota_root) {
> -		spin_unlock(&fs_info->qgroup_lock);
> +	if (!fs_info->quota_root)
>  		return 0;
> -	}
> +
> +	spin_lock(&fs_info->qgroup_lock);
>  	fs_info->quota_enabled = 0;
>  	fs_info->pending_quota_state = 0;
>  	quota_root = fs_info->quota_root;
> @@ -1041,15 +1035,12 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
>  		return -EINVAL;
>  
>  	/* check if there are no relations to this qgroup */
> -	spin_lock(&fs_info->qgroup_lock);
>  	qgroup = find_qgroup_rb(fs_info, qgroupid);
>  	if (qgroup) {
> -		if (!list_empty(&qgroup->groups) || !list_empty(&qgroup->members)) {
> -			spin_unlock(&fs_info->qgroup_lock);
> +		if (!list_empty(&qgroup->groups) ||
> +		    !list_empty(&qgroup->members))
>  			return -EBUSY;
> -		}
>  	}
> -	spin_unlock(&fs_info->qgroup_lock);
>  
>  	ret = del_qgroup_item(trans, quota_root, qgroupid);
>  
> @@ -1081,20 +1072,17 @@ int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
>  		       (unsigned long long)qgroupid);
>  	}
>  
> -	spin_lock(&fs_info->qgroup_lock);
> -
>  	qgroup = find_qgroup_rb(fs_info, qgroupid);
>  	if (!qgroup) {
>  		ret = -ENOENT;
> -		goto unlock;
> +		return ret;
>  	}
> +	spin_lock(&fs_info->qgroup_lock);
>  	qgroup->lim_flags = limit->flags;
>  	qgroup->max_rfer = limit->max_rfer;
>  	qgroup->max_excl = limit->max_excl;
>  	qgroup->rsv_rfer = limit->rsv_rfer;
>  	qgroup->rsv_excl = limit->rsv_excl;
> -
> -unlock:
>  	spin_unlock(&fs_info->qgroup_lock);
>  
>  	return ret;
> 

