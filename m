Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:48056 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbaGDUEa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Jul 2014 16:04:30 -0400
Received: by mail-ie0-f179.google.com with SMTP id lx4so844800iec.24
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Jul 2014 13:04:29 -0700 (PDT)
Received: from [192.168.1.2] ([216.26.106.6])
        by mx.google.com with ESMTPSA id y8sm64999641igg.5.2014.07.04.13.04.28
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Fri, 04 Jul 2014 13:04:29 -0700 (PDT)
Message-ID: <53B708CC.5020306@gmail.com>
Date: Fri, 04 Jul 2014 15:04:28 -0500
From: Kevin Brandstatter <icarusthecow@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs_qgroup_create unused parameter
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

|The code is pasted below for convenience of reference, but in the function to 
create a qgruop, it taks a 4th parameter (char * name). I assume this is the name
of the path to limit, however, i don't see where its used anywhere in the function.

-Kevin Brandstatter

int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
			struct btrfs_fs_info *fs_info, u64 qgroupid, *char** *****name**)*
{
	struct btrfs_root *quota_root;
	struct btrfs_qgroup *qgroup;
	int ret = 0;

	mutex_lock(&fs_info->qgroup_ioctl_lock);
	quota_root = fs_info->quota_root;
	if (!quota_root) {
		ret = -EINVAL;
		goto out;
	}
	qgroup = find_qgroup_rb(fs_info, qgroupid);
	if (qgroup) {
		ret = -EEXIST;
		goto out;
	}

	ret = add_qgroup_item(trans, quota_root, qgroupid);
	if (ret)
		goto out;

	spin_lock(&fs_info->qgroup_lock);
	qgroup = add_qgroup_rb(fs_info, qgroupid);
	spin_unlock(&fs_info->qgroup_lock);

	if (IS_ERR(qgroup))
		ret = PTR_ERR(qgroup);
out:
	mutex_unlock(&fs_info->qgroup_ioctl_lock);
	return ret;
}|

