Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:52428 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898Ab3DWOzD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Apr 2013 10:55:03 -0400
Received: by mail-pb0-f44.google.com with SMTP id wz17so182221pbc.3
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Apr 2013 07:55:03 -0700 (PDT)
Content-Type: text/plain; charset=GB2312
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH v3 2/3] Btrfs: rescan for qgroups
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <1366716411-9750-3-git-send-email-list.btrfs@jan-o-sch.net>
Date: Tue, 23 Apr 2013 22:54:49 +0800
Cc: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org, dsterba@suse.cz,
        Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Message-Id: <28CF59DE-A74D-4CC4-BBA1-FCD0503EE7BD@gmail.com>
References: <1366716411-9750-1-git-send-email-list.btrfs@jan-o-sch.net> <1366716411-9750-3-git-send-email-list.btrfs@jan-o-sch.net>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hello Jan,

>  
> +static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
> +{
> +	struct qgroup_rescan *qscan = container_of(work, struct qgroup_rescan,
> +						   work);
> +	struct btrfs_path *path;
> +	struct btrfs_trans_handle *trans = NULL;
> +	struct btrfs_fs_info *fs_info = qscan->fs_info;
> +	struct ulist *tmp = NULL;
> +	struct extent_buffer *scratch_leaf = NULL;
> +	int err = -ENOMEM;
> +
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		goto out;
> +	tmp = ulist_alloc(GFP_NOFS);
> +	if (!tmp)
> +		goto out;
> +	scratch_leaf = kmalloc(sizeof(*scratch_leaf), GFP_NOFS);
> +	if (!scratch_leaf)
> +		goto out;
> +
> +	err = 0;
> +	while (!err) {
> +		trans = btrfs_start_transaction(fs_info->fs_root, 0);
> +		if (IS_ERR(trans)) {
> +			err = PTR_ERR(trans);
> +			break;
> +		}
> +		if (!fs_info->quota_enabled) {
> +			err = EINTR;'
				Why not -EINTR?

> +		} else {
> +			err = qgroup_rescan_leaf(qscan, path, trans,
> +						 tmp, scratch_leaf);
> +		}
> +		if (err > 0)
> +			btrfs_commit_transaction(trans, fs_info->fs_root);
> +		else
> +			btrfs_end_transaction(trans, fs_info->fs_root);
> +	}
> +
> +out:
> +	kfree(scratch_leaf);
> +	ulist_free(tmp);
> +	btrfs_free_path(path);
> +	kfree(qscan);
> +
> +	mutex_lock(&fs_info->qgroup_rescan_lock);
> +	fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_RESCAN;
> +
> +	if (err == 2 &&
> +	    fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT) {
> +		fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
> +	} else if (err < 0) {

It -EINTR happens, quota has been disabled, i don't think we should set INCONSISTENT flag¡­


Thanks,
Wang

> +		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
> +	}
> +	mutex_unlock(&fs_info->qgroup_rescan_lock);
> +
> +	if (err >= 0) {
> +		pr_info("btrfs: qgroup scan completed%s\n",
> +			err == 2 ? " (inconsistency flag cleared)" : "");
> +	} else {
> +		pr_err("btrfs: qgroup scan failed with %d\n", err);
> +	}
> +}
> +
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

