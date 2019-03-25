Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97D2AC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 08:23:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6883D20879
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 08:23:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730006AbfCYIXK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 04:23:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:36574 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729943AbfCYIXJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 04:23:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B95E2AE7F
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 08:23:08 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 4/7] btrfs-progs: check/original: Repair invalid inode mode in root tree
Date:   Mon, 25 Mar 2019 16:22:50 +0800
Message-Id: <20190325082253.19583-5-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190325082253.19583-1-wqu@suse.com>
References: <20190325082253.19583-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patch will reuse the mode independent repair_imode() function, to
repair invalid inode mode.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/check/main.c b/check/main.c
index 553c93caa2c9..5db0716d23a1 100644
--- a/check/main.c
+++ b/check/main.c
@@ -2698,6 +2698,24 @@ static int repair_mismatch_dir_hash(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+static int repair_imode_original(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *root,
+				 struct btrfs_path *path,
+				 struct inode_record *rec)
+{
+	int ret;
+
+	if (root->root_key.objectid != BTRFS_ROOT_TREE_OBJECTID)
+		return 0;
+	if (rec->ino != BTRFS_ROOT_TREE_DIR_OBJECTID || !is_fstree(rec->ino))
+		return 0;
+	ret = repair_imode(trans, root, path, rec->ino);
+	if (ret < 0)
+		return ret;
+	rec->errors &= ~I_ERR_INVALID_IMODE;
+	return ret;
+}
+
 static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
 {
 	struct btrfs_trans_handle *trans;
@@ -2745,6 +2763,8 @@ static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
 		ret = repair_inode_nbytes(trans, root, &path, rec);
 	if (!ret && rec->errors & I_ERR_INLINE_RAM_BYTES_WRONG)
 		ret = repair_inline_ram_bytes(trans, root, &path, rec);
+	if (!ret && rec->errors & I_ERR_INVALID_IMODE)
+		ret = repair_imode_original(trans, root, &path, rec);
 	btrfs_commit_transaction(trans, root);
 	btrfs_release_path(&path);
 	return ret;
-- 
2.21.0

