Return-Path: <SRS0=YGKe=NF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BED7ECDE47
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Oct 2018 07:45:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D6E22054F
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Oct 2018 07:45:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D6E22054F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbeJYQQd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Oct 2018 12:16:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:58224 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726465AbeJYQQd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Oct 2018 12:16:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5ED86AE02
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2018 07:44:59 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 3/4] btrfs-progs: original check: Add ability to repair dir item with invalid hash
Date:   Thu, 25 Oct 2018 15:44:48 +0800
Message-Id: <20181025074449.32469-4-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181025074449.32469-1-wqu@suse.com>
References: <20181025074449.32469-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The repair function is reusing delete_corrupted_dir_item().

Since the error can happen for root dir inode, also call
try_repair_inode() on root dir inode.

This is especially important for old btrfs, since later kernel
introduces restrict tree-checker, which could detect such hash mismatch
and refuse to read the corrupted leaf.

With this repair ability, user could repair with btrfs check --repair.

Link: https://bugzilla.opensuse.org/show_bug.cgi?id=1111991
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c | 45 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/check/main.c b/check/main.c
index 4a4f2a7c9cdb..1abf6c994710 100644
--- a/check/main.c
+++ b/check/main.c
@@ -2658,6 +2658,41 @@ out:
 	return ret;
 }
 
+static int repair_mismatch_dir_hash(struct btrfs_trans_handle *trans,
+				    struct btrfs_root *root,
+				    struct inode_record *rec)
+{
+	struct mismatch_dir_hash_record *hash;
+	int ret;
+
+	printf(
+	"Deleting bad dir items with invalid hash for root %llu ino %llu\n",
+		root->root_key.objectid, rec->ino);
+	while (!list_empty(&rec->mismatch_dir_hash)) {
+		char *namebuf;
+
+		hash = list_entry(rec->mismatch_dir_hash.next,
+				struct mismatch_dir_hash_record, list);
+		namebuf = (char *)(hash + 1);
+
+		ret = delete_corrupted_dir_item(trans, root, &hash->key,
+						namebuf, hash->namelen);
+		if (ret < 0)
+			break;
+
+		/* Also reduce dir isize */
+		rec->found_size -= hash->namelen;
+		list_del(&hash->list);
+		free(hash);
+	}
+	if (!ret) {
+		rec->errors &= ~I_ERR_MISMATCH_DIR_HASH;
+		/* We rely on later dir isize repair to reset dir isize */
+		rec->errors |= I_ERR_DIR_ISIZE_WRONG;
+	}
+	return ret;
+}
+
 static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
 {
 	struct btrfs_trans_handle *trans;
@@ -2671,7 +2706,8 @@ static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
 			     I_ERR_FILE_EXTENT_ORPHAN |
 			     I_ERR_FILE_EXTENT_DISCOUNT |
 			     I_ERR_FILE_NBYTES_WRONG |
-			     I_ERR_INLINE_RAM_BYTES_WRONG)))
+			     I_ERR_INLINE_RAM_BYTES_WRONG |
+			     I_ERR_MISMATCH_DIR_HASH)))
 		return rec->errors;
 
 	/*
@@ -2686,6 +2722,8 @@ static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
 		return PTR_ERR(trans);
 
 	btrfs_init_path(&path);
+	if (!ret && rec->errors & I_ERR_MISMATCH_DIR_HASH)
+		ret = repair_mismatch_dir_hash(trans, root, rec);
 	if (rec->errors & I_ERR_NO_INODE_ITEM)
 		ret = repair_inode_no_item(trans, root, &path, rec);
 	if (!ret && rec->errors & I_ERR_FILE_EXTENT_ORPHAN)
@@ -2780,6 +2818,11 @@ static int check_inode_recs(struct btrfs_root *root,
 	rec = get_inode_rec(inode_cache, root_dirid, 0);
 	BUG_ON(IS_ERR(rec));
 	if (rec) {
+		if (repair) {
+			ret = try_repair_inode(root, rec);
+			if (ret < 0)
+				error++;
+		}
 		ret = check_root_dir(rec);
 		if (ret) {
 			fprintf(stderr, "root %llu root dir %llu error\n",
-- 
2.19.1

