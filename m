Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:54912 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbaGECJ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Jul 2014 22:09:59 -0400
Received: by mail-pa0-f44.google.com with SMTP id rd3so2612347pab.17
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Jul 2014 19:09:58 -0700 (PDT)
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: btrfs_qgroup_create unused parameter
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <53B708CC.5020306@gmail.com>
Date: Sat, 5 Jul 2014 10:09:48 +0800
Cc: linux-btrfs@vger.kernel.org
Message-Id: <474060AA-5D86-40F9-BD9C-27A68F732D63@gmail.com>
References: <53B708CC.5020306@gmail.com>
To: Kevin Brandstatter <icarusthecow@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi 

I think you are right,  @name here is unneeded..
You can give a patch for that.^_^

Wang
> |The code is pasted below for convenience of reference, but in the function to 
> create a qgruop, it taks a 4th parameter (char * name). I assume this is the name
> of the path to limit, however, i don't see where its used anywhere in the function.
> 
> -Kevin Brandstatter
> 
> int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
> 			struct btrfs_fs_info *fs_info, u64 qgroupid, *char** *****name**)*
> {
> 	struct btrfs_root *quota_root;
> 	struct btrfs_qgroup *qgroup;
> 	int ret = 0;
> 
> 	mutex_lock(&fs_info->qgroup_ioctl_lock);
> 	quota_root = fs_info->quota_root;
> 	if (!quota_root) {
> 		ret = -EINVAL;
> 		goto out;
> 	}
> 	qgroup = find_qgroup_rb(fs_info, qgroupid);
> 	if (qgroup) {
> 		ret = -EEXIST;
> 		goto out;
> 	}
> 
> 	ret = add_qgroup_item(trans, quota_root, qgroupid);
> 	if (ret)
> 		goto out;
> 
> 	spin_lock(&fs_info->qgroup_lock);
> 	qgroup = add_qgroup_rb(fs_info, qgroupid);
> 	spin_unlock(&fs_info->qgroup_lock);
> 
> 	if (IS_ERR(qgroup))
> 		ret = PTR_ERR(qgroup);
> out:
> 	mutex_unlock(&fs_info->qgroup_ioctl_lock);
> 	return ret;
> }|
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

