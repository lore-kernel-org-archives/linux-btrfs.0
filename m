Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:43654 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762Ab3DWReW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Apr 2013 13:34:22 -0400
Message-ID: <5176C5EC.5020209@jan-o-sch.net>
Date: Tue, 23 Apr 2013 19:33:32 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org, dsterba@suse.cz,
        Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Subject: Re: [PATCH v3 2/3] Btrfs: rescan for qgroups
References: <1366716411-9750-1-git-send-email-list.btrfs@jan-o-sch.net> <1366716411-9750-3-git-send-email-list.btrfs@jan-o-sch.net> <28CF59DE-A74D-4CC4-BBA1-FCD0503EE7BD@gmail.com>
In-Reply-To: <28CF59DE-A74D-4CC4-BBA1-FCD0503EE7BD@gmail.com>
Content-Type: text/plain; charset=GB2312
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, April 23, 2013 at 16:54 (+0200), Wang Shilong wrote:
> 
> Hello Jan,
> 
>>  
>> +static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
>> +{
>> +	struct qgroup_rescan *qscan = container_of(work, struct qgroup_rescan,
>> +						   work);
>> +	struct btrfs_path *path;
>> +	struct btrfs_trans_handle *trans = NULL;
>> +	struct btrfs_fs_info *fs_info = qscan->fs_info;
>> +	struct ulist *tmp = NULL;
>> +	struct extent_buffer *scratch_leaf = NULL;
>> +	int err = -ENOMEM;
>> +
>> +	path = btrfs_alloc_path();
>> +	if (!path)
>> +		goto out;
>> +	tmp = ulist_alloc(GFP_NOFS);
>> +	if (!tmp)
>> +		goto out;
>> +	scratch_leaf = kmalloc(sizeof(*scratch_leaf), GFP_NOFS);
>> +	if (!scratch_leaf)
>> +		goto out;
>> +
>> +	err = 0;
>> +	while (!err) {
>> +		trans = btrfs_start_transaction(fs_info->fs_root, 0);
>> +		if (IS_ERR(trans)) {
>> +			err = PTR_ERR(trans);
>> +			break;
>> +		}
>> +		if (!fs_info->quota_enabled) {
>> +			err = EINTR;'
> 				Why not -EINTR?

Makes sense, will change that.

>> +		} else {
>> +			err = qgroup_rescan_leaf(qscan, path, trans,
>> +						 tmp, scratch_leaf);
>> +		}
>> +		if (err > 0)
>> +			btrfs_commit_transaction(trans, fs_info->fs_root);
>> +		else
>> +			btrfs_end_transaction(trans, fs_info->fs_root);
>> +	}
>> +
>> +out:
>> +	kfree(scratch_leaf);
>> +	ulist_free(tmp);
>> +	btrfs_free_path(path);
>> +	kfree(qscan);
>> +
>> +	mutex_lock(&fs_info->qgroup_rescan_lock);
>> +	fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_RESCAN;
>> +
>> +	if (err == 2 &&
>> +	    fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT) {
>> +		fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
>> +	} else if (err < 0) {
> 
> It -EINTR happens, quota has been disabled, i don't think we should set INCONSISTENT flag¡­

Debatable. Quota information is in fact inconsistent on disk, and only because
we can conclude that also from the fact that it is currently disabled, it
doesn't hurt to set that flag. In fact, whenever quota is enabled, we're setting
the flag, too:

 802 int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 803                        struct btrfs_fs_info *fs_info)
...
 852         fs_info->qgroup_flags = BTRFS_QGROUP_STATUS_FLAG_ON |
 853                                 BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;

So I don't think it's worth another comparison here.

Thanks,
-Jan

> Thanks,
> Wang
> 
>> +		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
>> +	}
>> +	mutex_unlock(&fs_info->qgroup_rescan_lock);
>> +
>> +	if (err >= 0) {
>> +		pr_info("btrfs: qgroup scan completed%s\n",
>> +			err == 2 ? " (inconsistency flag cleared)" : "");
>> +	} else {
>> +		pr_err("btrfs: qgroup scan failed with %d\n", err);
>> +	}
>> +}
>> +
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
