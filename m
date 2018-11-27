Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38563C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 02:33:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D018208E4
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 02:33:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0D018208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbeK0N3j (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 08:29:39 -0500
Received: from mx2.suse.de ([195.135.220.15]:58534 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728009AbeK0N3j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 08:29:39 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2A821AF57
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 02:33:21 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/5] btrfs-progs: image: Refactor fixup_devices() to fixup_chunks_and_devices()
Date:   Tue, 27 Nov 2018 10:33:11 +0800
Message-Id: <20181127023315.28176-2-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181127023315.28176-1-wqu@suse.com>
References: <20181127023315.28176-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Current fixup_devices() will only remove DEV_ITEMs and reset DEV_ITEM
size.
Later we need to do more fixup works, so change the name to
fixup_chunks_and_devices() and refactor the original device size fixup
to fixup_device_size().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 image/main.c | 52 ++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 36 insertions(+), 16 deletions(-)

diff --git a/image/main.c b/image/main.c
index c680ab19de6c..36b5c95ea146 100644
--- a/image/main.c
+++ b/image/main.c
@@ -2084,28 +2084,19 @@ static void remap_overlapping_chunks(struct mdrestore_struct *mdres)
 	}
 }
 
-static int fixup_devices(struct btrfs_fs_info *fs_info,
-			 struct mdrestore_struct *mdres, off_t dev_size)
+static int fixup_device_size(struct btrfs_trans_handle *trans,
+			     struct btrfs_fs_info *fs_info,
+			     struct mdrestore_struct *mdres,
+			     off_t dev_size)
 {
-	struct btrfs_trans_handle *trans;
 	struct btrfs_dev_item *dev_item;
 	struct btrfs_path path;
-	struct extent_buffer *leaf;
 	struct btrfs_root *root = fs_info->chunk_root;
 	struct btrfs_key key;
+	struct extent_buffer *leaf;
 	u64 devid, cur_devid;
 	int ret;
 
-	if (btrfs_super_log_root(fs_info->super_copy)) {
-		warning(
-		"log tree detected, its generation will not match superblock");
-	}
-	trans = btrfs_start_transaction(fs_info->tree_root, 1);
-	if (IS_ERR(trans)) {
-		error("cannot starting transaction %ld", PTR_ERR(trans));
-		return PTR_ERR(trans);
-	}
-
 	dev_item = &fs_info->super_copy->dev_item;
 
 	devid = btrfs_stack_device_id(dev_item);
@@ -2123,7 +2114,7 @@ again:
 	ret = btrfs_search_slot(trans, root, &key, &path, -1, 1);
 	if (ret < 0) {
 		error("search failed: %d", ret);
-		exit(1);
+		return ret;
 	}
 
 	while (1) {
@@ -2170,12 +2161,41 @@ again:
 	}
 
 	btrfs_release_path(&path);
+	return 0;
+}
+
+static int fixup_chunks_and_devices(struct btrfs_fs_info *fs_info,
+			 struct mdrestore_struct *mdres, off_t dev_size)
+{
+	struct btrfs_trans_handle *trans;
+	int ret;
+
+	if (btrfs_super_log_root(fs_info->super_copy)) {
+		warning(
+		"log tree detected, its generation will not match superblock");
+	}
+	trans = btrfs_start_transaction(fs_info->tree_root, 1);
+	if (IS_ERR(trans)) {
+		error("cannot starting transaction %ld", PTR_ERR(trans));
+		return PTR_ERR(trans);
+	}
+
+	ret = fixup_device_size(trans, fs_info, mdres, dev_size);
+	if (ret < 0)
+		goto error;
+
 	ret = btrfs_commit_transaction(trans, fs_info->tree_root);
 	if (ret) {
 		error("unable to commit transaction: %d", ret);
 		return ret;
 	}
 	return 0;
+error:
+	error(
+"failed to fix chunks and devices mapping, the fs may not be mountable: %s",
+		strerror(-ret));
+	btrfs_abort_transaction(trans, ret);
+	return ret;
 }
 
 static int restore_metadump(const char *input, FILE *out, int old_restore,
@@ -2282,7 +2302,7 @@ static int restore_metadump(const char *input, FILE *out, int old_restore,
 			return 1;
 		}
 
-		ret = fixup_devices(info, &mdrestore, st.st_size);
+		ret = fixup_chunks_and_devices(info, &mdrestore, st.st_size);
 		close_ctree(info->chunk_root);
 		if (ret)
 			goto out;
-- 
2.19.2

