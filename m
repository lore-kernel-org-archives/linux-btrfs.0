Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:51701 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756863Ab3BVNSP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 08:18:15 -0500
Received: from mailout-de.gmx.net ([10.1.76.28]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0MKwO6-1U8sVv1pkO-0008RN for
 <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2013 14:18:11 +0100
Message-ID: <5127705B.7080705@gmx.net>
Date: Fri, 22 Feb 2013 14:19:23 +0100
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: create the qgroup that limits root subvolume
 automatically
References: <1361534540-2381-1-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1361534540-2381-1-git-send-email-wangshilong1991@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/22/13 13:02, Wang Shilong wrote:
> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> 
> Creating the root subvolume qgroup when enabling quota,with

Why only create a qgroup for the root subvolume and not for
every existing subvolume?

> this patch,it will be ok to limit the whole filesystem size.

This will not limit the whole filesystem, but only the root
subvolume. To limit the whole filesystem you'd have to create
a level 1 qgroup and add all subvolumes to it.

-Arne

> 
> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
> Cc: Arne Jansen <sensille@gmx.net>
> ---
>  fs/btrfs/qgroup.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index a5c8562..c409096 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -777,6 +777,7 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
>  	struct extent_buffer *leaf;
>  	struct btrfs_key key;
>  	int ret = 0;
> +	struct btrfs_qgroup *qgroup = NULL;
>  
>  	spin_lock(&fs_info->qgroup_lock);
>  	if (fs_info->quota_root) {
> @@ -823,7 +824,18 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
>  
>  	btrfs_mark_buffer_dirty(leaf);
>  
> +	btrfs_release_path(path);
> +	ret = add_qgroup_item(trans, quota_root, BTRFS_FS_TREE_OBJECTID);
> +	if (ret)
> +		goto out;
> +
>  	spin_lock(&fs_info->qgroup_lock);
> +	qgroup = add_qgroup_rb(fs_info, BTRFS_FS_TREE_OBJECTID);
> +	if (IS_ERR(qgroup)) {
> +		spin_unlock(&fs_info->qgroup_lock);
> +		ret = PTR_ERR(qgroup);
> +		goto out;
> +	}
>  	fs_info->quota_root = quota_root;
>  	fs_info->pending_quota_state = 1;
>  	spin_unlock(&fs_info->qgroup_lock);
> 

