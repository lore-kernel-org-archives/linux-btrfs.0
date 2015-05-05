Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62876 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750990AbbEEA1g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 May 2015 20:27:36 -0400
Message-ID: <55480E74.80404@cn.fujitsu.com>
Date: Tue, 5 May 2015 08:27:32 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Christian Engelmayer <cengelma@gmx.at>, <linux-btrfs@vger.kernel.org>
CC: <clm@fb.com>, <jbacik@fb.com>, <dsterba@suse.cz>
Subject: Re: [PATCH] btrfs: qgroup: Fix possible leak in btrfs_add_qgroup_relation()
References: <1430579995-24551-1-git-send-email-cengelma@gmx.at>
In-Reply-To: <1430579995-24551-1-git-send-email-cengelma@gmx.at>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



-------- Original Message  --------
Subject: [PATCH] btrfs: qgroup: Fix possible leak in 
btrfs_add_qgroup_relation()
From: Christian Engelmayer <cengelma@gmx.at>
To: <linux-btrfs@vger.kernel.org>
Date: 2015年05月02日 23:19

> Commit 9c8b35b1ba21 ("btrfs: quota: Automatically update related qgroups or
> mark INCONSISTENT flags when assigning/deleting a qgroup relations.")
> introduced the allocation of a temporary ulist in function
> btrfs_add_qgroup_relation() and added the corresponding cleanup to the out
> path. However, the allocation was introduced before the src/dst level check
> that directly returns. Fix the possible leakage of the ulist by moving the
> allocation after the input validation. Detected by Coverity CID 1295988.
>
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
> ---
> Compile tested only. Applies against linux-next.
> ---
>   fs/btrfs/qgroup.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 3d6546581bb9..842ff86d4ae8 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1115,14 +1115,14 @@ int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans,
>   	struct ulist *tmp;
>   	int ret = 0;
>
> -	tmp = ulist_alloc(GFP_NOFS);
> -	if (!tmp)
> -		return -ENOMEM;
> -
>   	/* Check the level of src and dst first */
>   	if (btrfs_qgroup_level(src) >= btrfs_qgroup_level(dst))
>   		return -EINVAL;
>
> +	tmp = ulist_alloc(GFP_NOFS);
> +	if (!tmp)
> +		return -ENOMEM;
> +
>   	mutex_lock(&fs_info->qgroup_ioctl_lock);
>   	quota_root = fs_info->quota_root;
>   	if (!quota_root) {
>
Oh, my fault.
Thanks for catching it.

Qu
