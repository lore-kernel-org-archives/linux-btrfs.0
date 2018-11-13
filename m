Return-Path: <SRS0=2H/g=NY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77D7EC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 06:47:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41FE2223D0
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 06:47:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 41FE2223D0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730813AbeKMQnz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Nov 2018 11:43:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:53148 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730674AbeKMQnz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Nov 2018 11:43:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 75356ACC2
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Nov 2018 06:47:12 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: qgroup-verify: Check if qgroup limit is exceeded
Date:   Tue, 13 Nov 2018 14:47:07 +0800
Message-Id: <20181113064707.30516-1-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

For case where we exceed qgroup limits, we should also report it as an
error.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 qgroup-verify.c | 82 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/qgroup-verify.c b/qgroup-verify.c
index f5885589f02c..ab9b5f284d66 100644
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
+	if (flags & (__BTRFS_QGROUP_LIMIT_RSV_RFER |
+		     __BTRFS_QGROUP_LIMIT_RSV_EXCL |
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
2.19.1

