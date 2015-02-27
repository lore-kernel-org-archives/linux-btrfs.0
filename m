Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36159 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754974AbbB0I0p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Feb 2015 03:26:45 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1R8Pp0V019935
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2015 16:25:51 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 6/7] btrfs-progs: Print warning message if qgroup data is inconsistent.
Date: Fri, 27 Feb 2015 16:26:38 +0800
Message-ID: <1425025599-30048-7-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1425025599-30048-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1425025599-30048-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before this patch, qgroup show won't check btrfs qgroup status, so even
the INCONSISTENT flags is set, user is not aware of it.

This patch will include BTRFS_QGROUP_STATUS_ITEM in the search range and
check the flag, if there is any flag meaning the inconsistence of qgroup
data, info user.

NOTE: There is several kernel bugs from INCONSISTENT flags is always set
to RUNNING flags is not cleared until umount.
So this warning will always be here if using a newer kernel fixing these
bugs.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 qgroup.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/qgroup.c b/qgroup.c
index 7288365..4173846 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -1016,6 +1016,20 @@ static void __filter_and_sort_qgroups(struct qgroup_lookup *all_qgroups,
 		n = rb_prev(n);
 	}
 }
+
+static inline void print_status_flag_warning(u64 flags)
+{
+	if (!(flags & BTRFS_QGROUP_STATUS_FLAG_ON))
+		fprintf(stderr,
+		"WARNING: Quota disabled, qgroup data may be out of date\n");
+	else if (flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN)
+		fprintf(stderr,
+		"WARNING: Rescan is running, qgroup data may be incorrect\n");
+	else if (flags & BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT)
+		fprintf(stderr,
+		"WARNING: Qgroup data inconsistent, rescan recommended\n");
+}
+
 static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 {
 	int ret;
@@ -1039,7 +1053,7 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 
 	sk->tree_id = BTRFS_QUOTA_TREE_OBJECTID;
 	sk->max_type = BTRFS_QGROUP_RELATION_KEY;
-	sk->min_type = BTRFS_QGROUP_INFO_KEY;
+	sk->min_type = BTRFS_QGROUP_STATUS_KEY;
 	sk->max_objectid = (u64)-1;
 	sk->max_offset = (u64)-1;
 	sk->max_transid = (u64)-1;
@@ -1070,7 +1084,15 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 								  off);
 			off += sizeof(*sh);
 
-			if (sh->type == BTRFS_QGROUP_INFO_KEY) {
+			if (sh->type == BTRFS_QGROUP_STATUS_KEY) {
+				struct btrfs_qgroup_status_item *si;
+				u64 flags;
+
+				si = (struct btrfs_qgroup_status_item *)
+				     (args.buf + off);
+				flags = btrfs_stack_qgroup_status_flags(si);
+				print_status_flag_warning(flags);
+			} else if (sh->type == BTRFS_QGROUP_INFO_KEY) {
 				info = (struct btrfs_qgroup_info_item *)
 				       (args.buf + off);
 				a1 = btrfs_stack_qgroup_info_generation(info);
-- 
2.3.0

