Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43987 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753610AbbAVFtq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Jan 2015 00:49:46 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0M5msAE009227
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Jan 2015 13:48:54 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 1/3] btrfs: qgroup: return EINVAL if level of parent is not higher than child's.
Date: Thu, 22 Jan 2015 13:46:20 +0800
Message-ID: <1421905582-4539-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we create a qgroup inheriting a qgroup, we need to check the level
of them. Otherwise, there is a chance where a qgroup can inherit another qgroup
at the same level.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 6 ++++++
 fs/btrfs/qgroup.h | 9 +++++++++
 2 files changed, 15 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 953befd..c2983a4 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2221,6 +2221,12 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 				ret = -EINVAL;
 				goto out;
 			}
+
+			if ((srcgroup->qgroupid >> BTRFS_QGROUP_LEVEL_SHIFT) <=
+			    (objectid >> BTRFS_QGROUP_LEVEL_SHIFT)) {
+				ret = -EINVAL;
+				goto out;
+			}
 			++i_qgroups;
 		}
 	}
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 18cc68c..67291ff 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -20,6 +20,15 @@
 #define __BTRFS_QGROUP__
 
 /*
+ * The ID of a qgroup consists of a level and a id, looks like: 1/3.
+ * The 1 is the level means this qgroup is in the level 1 and the 3
+ * is the id of this qgroup in level 1. We use a u64 number store a
+ * qgroup ID, the first 16bits stands for the level and the last 48bits
+ * stands for the id.
+ */
+#define BTRFS_QGROUP_LEVEL_SHIFT	48
+
+/*
  * A description of the operations, all of these operations only happen when we
  * are adding the 1st reference for that subvolume in the case of adding space
  * or on the last reference delete in the case of subtraction.  The only
-- 
1.8.4.2

