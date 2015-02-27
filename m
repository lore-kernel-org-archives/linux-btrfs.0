Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:35835 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755209AbbB0IYf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Feb 2015 03:24:35 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1R8NffY019782
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2015 16:23:42 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 5/7] btrfs: qgroup: clear STATUS_FLAG_ON in disabling quota.
Date: Fri, 27 Feb 2015 16:24:26 +0800
Message-ID: <1425025468-29749-6-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1425025468-29749-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1425025468-29749-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

we forgot to clear STATUS_FLAG_ON in quota_disable(), it
will cause a problem shown as below:

	# mount /dev/sdc /mnt
	# btrfs quota enable /mnt
	# btrfs quota disable /mnt
	# btrfs quota rescan /mnt
	quota rescan started <--- expecting it fail here.
	# echo $?
	0

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 20fe219..b48f2c8 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -967,6 +967,7 @@ int btrfs_quota_disable(struct btrfs_trans_handle *trans,
 	fs_info->pending_quota_state = 0;
 	quota_root = fs_info->quota_root;
 	fs_info->quota_root = NULL;
+	fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_ON;
 	spin_unlock(&fs_info->qgroup_lock);
 
 	btrfs_free_qgroup_config(fs_info);
-- 
2.3.0

