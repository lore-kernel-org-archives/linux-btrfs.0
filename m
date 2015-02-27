Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:35835 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755197AbbB0IYd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Feb 2015 03:24:33 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1R8NcIX019762
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2015 16:23:38 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/7] btrfs: Check qgroup level in kernel qgroup assign.
Date: Fri, 27 Feb 2015 16:24:22 +0800
Message-ID: <1425025468-29749-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1425025468-29749-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1425025468-29749-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although we have qgroup level check in btrfs-progs, it's not enough
since other programe may still call ioctl directly not using
btrfs-progs. For example, systemd.

But it's btrfs-progs to be blame since we don't provide a
full-function(like subvolume create things) btrfs library with enough
check, and only rely on kernel ioctl.

So Add level checks in kernel too.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/ctree.h  | 6 ++++++
 fs/btrfs/qgroup.c | 4 ++++
 2 files changed, 10 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0b18070..cbaf1a4 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1056,6 +1056,12 @@ struct btrfs_block_group_item {
 	__le64 flags;
 } __attribute__ ((__packed__));
 
+#define BTRFS_QGROUP_LEVEL_SHIFT		48
+static inline u64 btrfs_qgroup_level(u64 qgroupid)
+{
+	return qgroupid >> BTRFS_QGROUP_LEVEL_SHIFT;
+}
+
 /*
  * is subvolume quota turned on?
  */
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 48b60db..523e5b2 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1010,6 +1010,10 @@ int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans,
 	struct btrfs_qgroup_list *list;
 	int ret = 0;
 
+	/* Check the level of src and dst first */
+	if (btrfs_qgroup_level(src) >= btrfs_qgroup_level(dst))
+		return -EINVAL;
+
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
 	quota_root = fs_info->quota_root;
 	if (!quota_root) {
-- 
2.3.0

