Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:24922 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755181Ab3HGFR1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Aug 2013 01:17:27 -0400
Message-ID: <5201D811.6030500@cn.fujitsu.com>
Date: Wed, 07 Aug 2013 13:16:01 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: sensille@gmx.net
CC: linux-btrfs@vger.kernel.org, miaox@cn.fujitsu.com
Subject: Re: [PATCH 1/3] Btrfs: fix oops when writing dirty qgroups to disk
References: <1375852351-11919-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1375852351-11919-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/07/2013 01:12 PM, Wang Shilong wrote:
> When disabling quota, we should clear out list 'dirty_qgroups',otherwise,
> we will get oops if enabling quota again. Fix this by abstracting similar
> code from del_qgroup_rb().

Hello Arne,

Would you pleae review this patch and other cleanup patches,
i just hit this oops when i want to reproduce memory leak of qgroups.


Thanks,
Wang
> 
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/qgroup.c | 43 ++++++++++++++-----------------------------
>  1 file changed, 14 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 64a9e3c..3b103e2 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -157,18 +157,11 @@ static struct btrfs_qgroup *add_qgroup_rb(struct btrfs_fs_info *fs_info,
>  	return qgroup;
>  }
>  
> -/* must be called with qgroup_lock held */
> -static int del_qgroup_rb(struct btrfs_fs_info *fs_info, u64 qgroupid)
> +static void __del_qgroup_rb(struct btrfs_qgroup *qgroup)
>  {
> -	struct btrfs_qgroup *qgroup = find_qgroup_rb(fs_info, qgroupid);
> -	struct btrfs_qgroup_list *list;
> +	struct btrfs_qgroup_list *list = NULL;
>  
> -	if (!qgroup)
> -		return -ENOENT;
> -
> -	rb_erase(&qgroup->node, &fs_info->qgroup_tree);
>  	list_del(&qgroup->dirty);
> -
>  	while (!list_empty(&qgroup->groups)) {
>  		list = list_first_entry(&qgroup->groups,
>  					struct btrfs_qgroup_list, next_group);
> @@ -185,7 +178,18 @@ static int del_qgroup_rb(struct btrfs_fs_info *fs_info, u64 qgroupid)
>  		kfree(list);
>  	}
>  	kfree(qgroup);
> +}
> +
> +/* must be called with qgroup_lock held */
> +static int del_qgroup_rb(struct btrfs_fs_info *fs_info, u64 qgroupid)
> +{
> +	struct btrfs_qgroup *qgroup = find_qgroup_rb(fs_info, qgroupid);
>  
> +	if (!qgroup)
> +		return -ENOENT;
> +
> +	rb_erase(&qgroup->node, &fs_info->qgroup_tree);
> +	__del_qgroup_rb(qgroup);
>  	return 0;
>  }
>  
> @@ -435,30 +439,11 @@ void btrfs_free_qgroup_config(struct btrfs_fs_info *fs_info)
>  {
>  	struct rb_node *n;
>  	struct btrfs_qgroup *qgroup;
> -	struct btrfs_qgroup_list *list;
>  
>  	while ((n = rb_first(&fs_info->qgroup_tree))) {
>  		qgroup = rb_entry(n, struct btrfs_qgroup, node);
>  		rb_erase(n, &fs_info->qgroup_tree);
> -
> -		while (!list_empty(&qgroup->groups)) {
> -			list = list_first_entry(&qgroup->groups,
> -						struct btrfs_qgroup_list,
> -						next_group);
> -			list_del(&list->next_group);
> -			list_del(&list->next_member);
> -			kfree(list);
> -		}
> -
> -		while (!list_empty(&qgroup->members)) {
> -			list = list_first_entry(&qgroup->members,
> -						struct btrfs_qgroup_list,
> -						next_member);
> -			list_del(&list->next_group);
> -			list_del(&list->next_member);
> -			kfree(list);
> -		}
> -		kfree(qgroup);
> +		__del_qgroup_rb(qgroup);
>  	}
>  	/*
>  	 * we call btrfs_free_qgroup_config() when umounting
> 

