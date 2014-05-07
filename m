Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42239 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbaEGUH0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 May 2014 16:07:26 -0400
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>,
        Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 1/3] btrfs-progs: print qgroup excl as unsigned
Date: Wed,  7 May 2014 13:07:15 -0700
Message-Id: <1399493237-19740-2-git-send-email-mfasheh@suse.de>
In-Reply-To: <1399493237-19740-1-git-send-email-mfasheh@suse.de>
References: <1399493237-19740-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's unsigned in the structure definition.

Reviewed-by: Mark Fasheh <mfasheh@suse.de>
---
 print-tree.c | 12 ++++++------
 qgroup.c     |  4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index 7263b09..adef94a 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -884,18 +884,18 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 			qg_info = btrfs_item_ptr(l, i,
 						 struct btrfs_qgroup_info_item);
 			printf("\t\tgeneration %llu\n"
-			     "\t\treferenced %lld referenced compressed %lld\n"
-			     "\t\texclusive %lld exclusive compressed %lld\n",
+			     "\t\treferenced %llu referenced compressed %llu\n"
+			     "\t\texclusive %llu exclusive compressed %llu\n",
 			       (unsigned long long)
 			       btrfs_qgroup_info_generation(l, qg_info),
-			       (long long)
+			       (unsigned long long)
 			       btrfs_qgroup_info_referenced(l, qg_info),
-			       (long long)
+			       (unsigned long long)
 			       btrfs_qgroup_info_referenced_compressed(l,
 								       qg_info),
-			       (long long)
+			       (unsigned long long)
 			       btrfs_qgroup_info_exclusive(l, qg_info),
-			       (long long)
+			       (unsigned long long)
 			       btrfs_qgroup_info_exclusive_compressed(l,
 								      qg_info));
 			break;
diff --git a/qgroup.c b/qgroup.c
index 94d1feb..368b262 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -203,11 +203,11 @@ static void print_qgroup_column(struct btrfs_qgroup *qgroup,
 		print_qgroup_column_add_blank(BTRFS_QGROUP_QGROUPID, len);
 		break;
 	case BTRFS_QGROUP_RFER:
-		len = printf("%lld", qgroup->rfer);
+		len = printf("%llu", qgroup->rfer);
 		print_qgroup_column_add_blank(BTRFS_QGROUP_RFER, len);
 		break;
 	case BTRFS_QGROUP_EXCL:
-		len = printf("%lld", qgroup->excl);
+		len = printf("%llu", qgroup->excl);
 		print_qgroup_column_add_blank(BTRFS_QGROUP_EXCL, len);
 		break;
 	case BTRFS_QGROUP_PARENT:
-- 
1.8.4

