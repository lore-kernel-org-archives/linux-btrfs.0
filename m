Return-Path: <SRS0=wLRn=O3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57A73C43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Dec 2018 05:28:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AE89217D8
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Dec 2018 05:28:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbeLRF2g (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 18 Dec 2018 00:28:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:48818 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726322AbeLRF2g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Dec 2018 00:28:36 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 33350B042
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Dec 2018 05:28:34 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs-progs: qgroup-verify: Check if qgroup limit is exceeded
Date:   Tue, 18 Dec 2018 13:28:28 +0800
Message-Id: <20181218052828.19808-1-wqu@suse.com>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[ENHANCEMENT]
This patch will enhance qgroup verify code to report qgroup number
exceeding its limit as error.

For test case fstests/btrfs/139, it will fail if the system has less
than 2G ram, resulting qgroup numbers exceeding its limit, and the test
case itself will detect such exceeding.

However it would be time consuming to make every qgroup test detect limit
exceeding, so enhancing btrfs check to detect such problem is a pretty
natural move.

[IMPLEMENTATION]
- Read out the qgroup limit number at load_quota_info()
  Here we will ignore certain unsupported limit flags.

- Compare limit to the calculated number

- Report error if we exceed the limit

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
changelog:
v2:
  Update commit message to show more details of this modification.
---
 qgroup-verify.c | 82 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/qgroup-verify.c b/qgroup-verify.c
index 3f2ce14a51a9..d59b40e4d3e0 100644
--- a/qgroup-verify.c
+++ b/qgroup-verify.c
@@ -54,6 +54,11 @@ struct qgroup_info {
 	u64 exclusive_compressed;
 };
 
+struct qgroup_limit {
+	u64 max_rfer;
+	u64 max_excl;
+};
+
 struct qgroup_count {
 	u64 qgroupid;
 	int subvol_exists;
@@ -63,6 +68,8 @@ struct qgroup_count {
 
 	struct qgroup_info info;
 
+	struct qgroup_limit limit;
+
 	struct rb_node rb_node;
 
 	/* Parents when we are a child group */
@@ -926,6 +933,48 @@ static void read_qgroup_status(struct extent_buffer *eb, int slot,
 	counts->scan_progress = btrfs_qgroup_status_rescan(eb, status_item);
 }
 
+static void read_qgroup_limit(struct extent_buffer *leaf, int slot)
+{
+	struct btrfs_key key;
+	struct btrfs_qgroup_limit_item *qli;
+	struct qgroup_count *count;
+	u64 flags;
+
+	btrfs_item_key_to_cpu(leaf, &key, slot);
+	qli = btrfs_item_ptr(leaf, slot, struct btrfs_qgroup_limit_item);
+	flags = btrfs_qgroup_limit_flags(leaf, qli);
+
+	/*
+	 * Despite the deprecated LIMIT_RSV_* flags, for CMPR (compressed)
+	 * limit it doesn't really work either.
+	 * As qgroup works at extent level, all numbers are at compressed size
+	 * already.
+	 */
+	if (flags & (BTRFS_QGROUP_LIMIT_RSV_RFER |
+		     BTRFS_QGROUP_LIMIT_RSV_EXCL |
+		     BTRFS_QGROUP_LIMIT_RFER_CMPR |
+		     BTRFS_QGROUP_LIMIT_EXCL_CMPR)) {
+		warning("ignoring deprecated limit flags for qgroup %llu/%llu",
+			btrfs_qgroup_level(key.offset),
+			btrfs_qgroup_subvid(key.offset));
+	}
+	count = find_count(key.offset);
+	if (!count) {
+		warning(
+	"found orphan QGROUP_LIMIT item, qgroup %llu/%llu doesn't exist",
+			btrfs_qgroup_level(key.offset),
+			btrfs_qgroup_subvid(key.offset));
+		return;
+	}
+	memset(&count->limit, 0, sizeof(struct qgroup_limit));
+	if (flags & BTRFS_QGROUP_LIMIT_MAX_RFER)
+		count->limit.max_rfer =
+			btrfs_qgroup_limit_max_referenced(leaf, qli);
+	if (flags & BTRFS_QGROUP_LIMIT_MAX_EXCL)
+		count->limit.max_excl =
+			btrfs_qgroup_limit_max_exclusive(leaf, qli);
+}
+
 static int load_quota_info(struct btrfs_fs_info *info)
 {
 	int ret;
@@ -979,6 +1028,10 @@ loop:
 				continue;
 			}
 
+			if (key.type == BTRFS_QGROUP_LIMIT_KEY) {
+				read_qgroup_limit(leaf, i);
+				continue;
+			}
 			if (key.type == BTRFS_QGROUP_STATUS_KEY) {
 				read_qgroup_status(leaf, i, &counts);
 				continue;
@@ -1308,6 +1361,31 @@ static int report_qgroup_difference(struct qgroup_count *count, int verbose)
 	return is_different;
 }
 
+bool report_qgroup_limit_error(struct qgroup_count *count)
+{
+	struct qgroup_info *info = &count->info;
+	struct qgroup_limit *limit = &count->limit;
+	bool ret = false;
+
+	if (limit->max_excl && limit->max_excl < info->exclusive) {
+		printf("Exclusive limit for qgroup id: %llu/%llu is exceeded\n",
+			btrfs_qgroup_level(count->qgroupid),
+			btrfs_qgroup_subvid(count->qgroupid));
+		print_fields(limit->max_excl, info->exclusive, "limit",
+			     "exclusive");
+		ret = true;
+	}
+	if (limit->max_rfer && limit->max_rfer < info->referenced) {
+		printf("Referenced limit for qgroup id: %llu/%llu is exceeded\n",
+			btrfs_qgroup_level(count->qgroupid),
+			btrfs_qgroup_subvid(count->qgroupid));
+		print_fields(limit->max_rfer, info->referenced, "limit",
+			     "referenced");
+		ret = true;
+	}
+	return ret;
+}
+
 /*
  * Report qgroups errors
  * Return 0 if nothing wrong.
@@ -1352,6 +1430,10 @@ int report_qgroups(int all)
 			list_add_tail(&c->bad_list, &bad_qgroups);
 			found_err = true;
 		}
+		if (report_qgroup_limit_error(c)) {
+			list_add_tail(&c->bad_list, &bad_qgroups);
+			found_err = true;
+		}
 
 		node = rb_next(node);
 	}
-- 
2.20.0

