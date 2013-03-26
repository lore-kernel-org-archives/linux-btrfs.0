Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f52.google.com ([209.85.210.52]:62801 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757801Ab3CZMB4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 08:01:56 -0400
Received: by mail-da0-f52.google.com with SMTP id f10so3657863dak.11
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 05:01:56 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH 4/7] Btrfs: add a necessary check before assigning/removing qgroup relations
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <1364298930-4507-4-git-send-email-wangshilong1991@gmail.com>
Date: Tue, 26 Mar 2013 20:01:49 +0800
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-Id: <547E410B-A99E-496E-B662-25DC36D4FA93@gmail.com>
References: <1364298930-4507-1-git-send-email-wangshilong1991@gmail.com> <1364298930-4507-4-git-send-email-wangshilong1991@gmail.com>
To: "sensille@gmx.net Jansen" <sensille@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Arne,

I have sent a patch-set about btrfs quota,
would you please review them for me. Any comment is welcome.

Thanks,
Wang

> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> 
> This is one of most important reason why we introduce a mutex here,
> the previous code dosen't check 'src' and 'dst' before assigning/removing
> a qgroup relations. Without the mutex lock, and checks may leads
> a race conditon.
> 
> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
> fs/btrfs/ioctl.c |   81 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
> 1 files changed, 80 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 8a01326..1cd96f6 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3735,6 +3735,82 @@ drop_write:
> 	return ret;
> }
> 
> +static int may_qgroup_assign(struct btrfs_root *root,
> +			     struct btrfs_ioctl_qgroup_assign_args *sa)
> +{
> +	int ret = 0;
> +	struct btrfs_key key;
> +	struct btrfs_path *path;
> +
> +	if (!root->fs_info->quota_root)
> +		return -EINVAL;
> +
> +	path = btrfs_alloc_path();
> +	if (!path) {
> +		ret = -ENOMEM;
> +		return ret;
> +	}
> +
> +	key.objectid = 0;
> +	key.type = BTRFS_QGROUP_INFO_KEY;
> +	key.offset = sa->src;
> +	ret = btrfs_search_slot(NULL, root->fs_info->quota_root,
> +				&key, path, 0, 0);
> +	if (ret > 0)
> +		ret = -ENOENT;
> +	if (ret < 0)
> +		goto out;
> +
> +	btrfs_release_path(path);
> +	key.objectid = 0;
> +	key.type = BTRFS_QGROUP_INFO_KEY;
> +	key.offset = sa->dst;
> +	ret = btrfs_search_slot(NULL, root->fs_info->quota_root,
> +				&key, path, 0, 0);
> +	if (ret > 0)
> +		ret = -ENOENT;
> +	if (ret < 0)
> +		goto out;
> +
> +	btrfs_release_path(path);
> +	key.objectid = sa->src;
> +	key.type = BTRFS_QGROUP_RELATION_KEY;
> +	key.offset = sa->dst;
> +	ret = btrfs_search_slot(NULL, root->fs_info->quota_root,
> +				&key, path, 0, 0);
> +	if (sa->assign) {
> +		if (!ret)
> +			ret = -EEXIST;
> +		if (ret < 0)
> +			goto out;
> +	} else {
> +		if (ret > 0)
> +			ret = -ENOENT;
> +		if (ret < 0)
> +			goto out;
> +	}
> +
> +	btrfs_release_path(path);
> +	key.objectid = sa->dst;
> +	key.type = BTRFS_QGROUP_RELATION_KEY;
> +	key.offset = sa->src;
> +	if (sa->assign) {
> +		if (!ret)
> +			ret = -EEXIST;
> +		if (ret < 0)
> +			goto out;
> +	} else {
> +		if (ret > 0)
> +			ret = -ENOENT;
> +		if (ret < 0)
> +			goto out;
> +	}
> +	ret = 0;
> +out:
> +	btrfs_free_path(path);
> +	return ret;
> +}
> +
> static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
> {
> 	struct btrfs_root *root = BTRFS_I(file_inode(file))->root;
> @@ -3757,13 +3833,16 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
> 	}
> 
> 	mutex_lock(&root->fs_info->quota_lock);
> +	ret = may_qgroup_assign(root, sa);
> +	if (ret)
> +		goto out;
> +
> 	trans = btrfs_join_transaction(root);
> 	if (IS_ERR(trans)) {
> 		ret = PTR_ERR(trans);
> 		goto out;
> 	}
> 
> -	/* FIXME: check if the IDs really exist */
> 	if (sa->assign) {
> 		ret = btrfs_add_qgroup_relation(trans, root->fs_info,
> 						sa->src, sa->dst);
> -- 
> 1.7.7.6
> 

