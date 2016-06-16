Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:11603 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933269AbcFPBQA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jun 2016 21:16:00 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: qgroup: Fix a bug that fails to skip rescan running case
Date: Thu, 16 Jun 2016 09:15:51 +0800
Message-Id: <20160616011551.4356-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 6bdf962fe35a8648d(btrfs-progs: Read qgroup status for qgroup
verify) will read qgroup status, and then use it to skip qgroup
reporting.

However since the rescan_running/inconsistent flags are only 1 bit long,
while qgroup flags & BTRFS_QGROUP_FLAGS returns value longer than 1bit,
it doesn't work.

Fix it by doing double negation on (flags & BTRFS_QGROUP_FLAGS) to
convert it to either 1 or 0.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 qgroup-verify.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/qgroup-verify.c b/qgroup-verify.c
index 1a0d38c..86dcd6d 100644
--- a/qgroup-verify.c
+++ b/qgroup-verify.c
@@ -711,8 +711,13 @@ static void read_qgroup_status(struct btrfs_path *path,
 	status_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
 				     struct btrfs_qgroup_status_item);
 	flags = btrfs_qgroup_status_flags(path->nodes[0], status_item);
-	counts->qgroup_inconsist = flags & BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
-	counts->rescan_running = flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN;
+	/*
+	 * Since qgroup_inconsist/rescan_running is just one bit,
+	 * assign value directly won't work.
+	 */
+	counts->qgroup_inconsist = !!(flags &
+			BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT);
+	counts->rescan_running = !!(flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN);
 }
 
 static int load_quota_info(struct btrfs_fs_info *info)
-- 
2.8.3



