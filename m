Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13C5CC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E76EB20700
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730361AbfCYSpj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:45:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:39044 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730294AbfCYSpj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 14:45:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 51DDEAF94
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 18:45:37 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B340BDA98F; Mon, 25 Mar 2019 19:46:50 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 16/30] btrfs: tree-checker: get fs_info from eb in dir_item_err
Date:   Mon, 25 Mar 2019 19:46:50 +0100
Message-Id: <84b70f00865d972ba1b443a87eb22050332d484e.1553539114.git.dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1553539114.git.dsterba@suse.com>
References: <cover.1553539114.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We can read fs_info from extent buffer and can drop it from the
parameters.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/tree-checker.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 8d6110fafcb4..3dc83e913d09 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -220,12 +220,12 @@ static int check_csum_item(struct extent_buffer *leaf, struct btrfs_key *key,
  * Customized reported for dir_item, only important new info is key->objectid,
  * which represents inode number
  */
-__printf(4, 5)
+__printf(3, 4)
 __cold
-static void dir_item_err(const struct btrfs_fs_info *fs_info,
-			 const struct extent_buffer *eb, int slot,
+static void dir_item_err(const struct extent_buffer *eb, int slot,
 			 const char *fmt, ...)
 {
+	const struct btrfs_fs_info *fs_info = eb->fs_info;
 	struct btrfs_key key;
 	struct va_format vaf;
 	va_list args;
@@ -263,7 +263,7 @@ static int check_dir_item(struct btrfs_fs_info *fs_info,
 
 		/* header itself should not cross item boundary */
 		if (cur + sizeof(*di) > item_size) {
-			dir_item_err(fs_info, leaf, slot,
+			dir_item_err(leaf, slot,
 		"dir item header crosses item boundary, have %zu boundary %u",
 				cur + sizeof(*di), item_size);
 			return -EUCLEAN;
@@ -272,7 +272,7 @@ static int check_dir_item(struct btrfs_fs_info *fs_info,
 		/* dir type check */
 		dir_type = btrfs_dir_type(leaf, di);
 		if (dir_type >= BTRFS_FT_MAX) {
-			dir_item_err(fs_info, leaf, slot,
+			dir_item_err(leaf, slot,
 			"invalid dir item type, have %u expect [0, %u)",
 				dir_type, BTRFS_FT_MAX);
 			return -EUCLEAN;
@@ -280,14 +280,14 @@ static int check_dir_item(struct btrfs_fs_info *fs_info,
 
 		if (key->type == BTRFS_XATTR_ITEM_KEY &&
 		    dir_type != BTRFS_FT_XATTR) {
-			dir_item_err(fs_info, leaf, slot,
+			dir_item_err(leaf, slot,
 		"invalid dir item type for XATTR key, have %u expect %u",
 				dir_type, BTRFS_FT_XATTR);
 			return -EUCLEAN;
 		}
 		if (dir_type == BTRFS_FT_XATTR &&
 		    key->type != BTRFS_XATTR_ITEM_KEY) {
-			dir_item_err(fs_info, leaf, slot,
+			dir_item_err(leaf, slot,
 			"xattr dir type found for non-XATTR key");
 			return -EUCLEAN;
 		}
@@ -300,13 +300,13 @@ static int check_dir_item(struct btrfs_fs_info *fs_info,
 		name_len = btrfs_dir_name_len(leaf, di);
 		data_len = btrfs_dir_data_len(leaf, di);
 		if (name_len > max_name_len) {
-			dir_item_err(fs_info, leaf, slot,
+			dir_item_err(leaf, slot,
 			"dir item name len too long, have %u max %u",
 				name_len, max_name_len);
 			return -EUCLEAN;
 		}
 		if (name_len + data_len > BTRFS_MAX_XATTR_SIZE(fs_info)) {
-			dir_item_err(fs_info, leaf, slot,
+			dir_item_err(leaf, slot,
 			"dir item name and data len too long, have %u max %u",
 				name_len + data_len,
 				BTRFS_MAX_XATTR_SIZE(fs_info));
@@ -314,7 +314,7 @@ static int check_dir_item(struct btrfs_fs_info *fs_info,
 		}
 
 		if (data_len && dir_type != BTRFS_FT_XATTR) {
-			dir_item_err(fs_info, leaf, slot,
+			dir_item_err(leaf, slot,
 			"dir item with invalid data len, have %u expect 0",
 				data_len);
 			return -EUCLEAN;
@@ -324,7 +324,7 @@ static int check_dir_item(struct btrfs_fs_info *fs_info,
 
 		/* header and name/data should not cross item boundary */
 		if (cur + total_size > item_size) {
-			dir_item_err(fs_info, leaf, slot,
+			dir_item_err(leaf, slot,
 		"dir item data crosses item boundary, have %u boundary %u",
 				cur + total_size, item_size);
 			return -EUCLEAN;
@@ -342,7 +342,7 @@ static int check_dir_item(struct btrfs_fs_info *fs_info,
 					(unsigned long)(di + 1), name_len);
 			name_hash = btrfs_name_hash(namebuf, name_len);
 			if (key->offset != name_hash) {
-				dir_item_err(fs_info, leaf, slot,
+				dir_item_err(leaf, slot,
 		"name hash mismatch with key, have 0x%016x expect 0x%016llx",
 					name_hash, key->offset);
 				return -EUCLEAN;
-- 
2.21.0

