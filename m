Return-Path: <SRS0=M3o5=XA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F03F7C3A5A5
	for <linux-btrfs@archiver.kernel.org>; Thu,  5 Sep 2019 07:58:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C733F2173B
	for <linux-btrfs@archiver.kernel.org>; Thu,  5 Sep 2019 07:58:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731886AbfIEH6S (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 03:58:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:48042 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731732AbfIEH6R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Sep 2019 03:58:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D5208AD07
        for <linux-btrfs@vger.kernel.org>; Thu,  5 Sep 2019 07:58:16 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 4/6] btrfs-progs: check/lowmem: Repair bad imode early
Date:   Thu,  5 Sep 2019 15:57:58 +0800
Message-Id: <20190905075800.1633-5-wqu@suse.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190905075800.1633-1-wqu@suse.com>
References: <20190905075800.1633-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

For lowmem mode, if we hit a bad inode mode, normally it is reported
when we checking the DIR_INDEX/DIR_ITEM of the parent inode.

If we didn't repair at that timing, the error will be recorded even we
fixed it later.

So this patch will check for INODE_ITEM_MISMATCH error type, and if it's
really caused by invalid imode, repair it and clear the error.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/mode-lowmem.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 5f7f101daab1..5d0c520217fa 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -1550,6 +1550,35 @@ static int lowmem_delete_corrupted_dir_item(struct btrfs_root *root,
 	return ret;
 }
 
+static int try_repair_imode(struct btrfs_root *root, u64 ino)
+{
+	struct btrfs_inode_item *iitem;
+	struct btrfs_path path;
+	struct btrfs_key key;
+	int ret;
+
+	key.objectid = ino;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = 0;
+	btrfs_init_path(&path);
+
+	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
+	if (ret > 0)
+		ret = -ENOENT;
+	if (ret < 0)
+		goto out;
+	iitem = btrfs_item_ptr(path.nodes[0], path.slots[0],
+			       struct btrfs_inode_item);
+	if (!is_valid_imode(btrfs_inode_mode(path.nodes[0], iitem))) {
+		ret = repair_imode_common(root, &path);
+	} else {
+		ret = -ENOTTY;
+	}
+out:
+	btrfs_release_path(&path);
+	return ret;
+}
+
 /*
  * Call repair_inode_item_missing and repair_ternary_lowmem to repair
  *
@@ -1574,6 +1603,16 @@ static int repair_dir_item(struct btrfs_root *root, struct btrfs_key *di_key,
 			err &= ~(INODE_ITEM_MISMATCH | INODE_ITEM_MISSING);
 	}
 
+	if (err & INODE_ITEM_MISMATCH) {
+		/*
+		 * INODE_ITEM mismatch can be caused by bad imode,
+		 * so check if it's a bad imode, then repair if possible.
+		 */
+		ret = try_repair_imode(root, ino);
+		if (!ret)
+			err &= ~INODE_ITEM_MISMATCH;
+	}
+
 	if (err & ~(INODE_ITEM_MISMATCH | INODE_ITEM_MISSING)) {
 		ret = repair_ternary_lowmem(root, dirid, ino, index, namebuf,
 					    name_len, filetype, err);
-- 
2.23.0

