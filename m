Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C17EC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D14920700
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730335AbfCYSpf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:45:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:39020 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730294AbfCYSpe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 14:45:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AD386AF94
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 18:45:32 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 23212DA98F; Mon, 25 Mar 2019 19:46:46 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 14/30] btrfs: tree-checker: get fs_info from eb in file_extent_err
Date:   Mon, 25 Mar 2019 19:46:46 +0100
Message-Id: <2af5a82ab180d16a2e4034d7685b5dda9a699d21.1553539114.git.dsterba@suse.com>
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
 fs/btrfs/tree-checker.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index dc157925a602..c2a08491d0d1 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -66,12 +66,12 @@ static void generic_err(const struct extent_buffer *eb, int slot,
  * Customized reporter for extent data item, since its key objectid and
  * offset has its own meaning.
  */
-__printf(4, 5)
+__printf(3, 4)
 __cold
-static void file_extent_err(const struct btrfs_fs_info *fs_info,
-			    const struct extent_buffer *eb, int slot,
+static void file_extent_err(const struct extent_buffer *eb, int slot,
 			    const char *fmt, ...)
 {
+	const struct btrfs_fs_info *fs_info = eb->fs_info;
 	struct btrfs_key key;
 	struct va_format vaf;
 	va_list args;
@@ -97,7 +97,7 @@ static void file_extent_err(const struct btrfs_fs_info *fs_info,
 #define CHECK_FE_ALIGNED(fs_info, leaf, slot, fi, name, alignment)	      \
 ({									      \
 	if (!IS_ALIGNED(btrfs_file_extent_##name((leaf), (fi)), (alignment))) \
-		file_extent_err((fs_info), (leaf), (slot),		      \
+		file_extent_err((leaf), (slot),				      \
 	"invalid %s for file extent, have %llu, should be aligned to %u",     \
 			(#name), btrfs_file_extent_##name((leaf), (fi)),      \
 			(alignment));					      \
@@ -113,7 +113,7 @@ static int check_extent_data_item(struct btrfs_fs_info *fs_info,
 	u32 item_size = btrfs_item_size_nr(leaf, slot);
 
 	if (!IS_ALIGNED(key->offset, sectorsize)) {
-		file_extent_err(fs_info, leaf, slot,
+		file_extent_err(leaf, slot,
 "unaligned file_offset for file extent, have %llu should be aligned to %u",
 			key->offset, sectorsize);
 		return -EUCLEAN;
@@ -122,7 +122,7 @@ static int check_extent_data_item(struct btrfs_fs_info *fs_info,
 	fi = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
 
 	if (btrfs_file_extent_type(leaf, fi) > BTRFS_FILE_EXTENT_TYPES) {
-		file_extent_err(fs_info, leaf, slot,
+		file_extent_err(leaf, slot,
 		"invalid type for file extent, have %u expect range [0, %u]",
 			btrfs_file_extent_type(leaf, fi),
 			BTRFS_FILE_EXTENT_TYPES);
@@ -134,14 +134,14 @@ static int check_extent_data_item(struct btrfs_fs_info *fs_info,
 	 * and must be caught in open_ctree().
 	 */
 	if (btrfs_file_extent_compression(leaf, fi) > BTRFS_COMPRESS_TYPES) {
-		file_extent_err(fs_info, leaf, slot,
+		file_extent_err(leaf, slot,
 	"invalid compression for file extent, have %u expect range [0, %u]",
 			btrfs_file_extent_compression(leaf, fi),
 			BTRFS_COMPRESS_TYPES);
 		return -EUCLEAN;
 	}
 	if (btrfs_file_extent_encryption(leaf, fi)) {
-		file_extent_err(fs_info, leaf, slot,
+		file_extent_err(leaf, slot,
 			"invalid encryption for file extent, have %u expect 0",
 			btrfs_file_extent_encryption(leaf, fi));
 		return -EUCLEAN;
@@ -149,7 +149,7 @@ static int check_extent_data_item(struct btrfs_fs_info *fs_info,
 	if (btrfs_file_extent_type(leaf, fi) == BTRFS_FILE_EXTENT_INLINE) {
 		/* Inline extent must have 0 as key offset */
 		if (key->offset) {
-			file_extent_err(fs_info, leaf, slot,
+			file_extent_err(leaf, slot,
 		"invalid file_offset for inline file extent, have %llu expect 0",
 				key->offset);
 			return -EUCLEAN;
@@ -163,7 +163,7 @@ static int check_extent_data_item(struct btrfs_fs_info *fs_info,
 		/* Uncompressed inline extent size must match item size */
 		if (item_size != BTRFS_FILE_EXTENT_INLINE_DATA_START +
 		    btrfs_file_extent_ram_bytes(leaf, fi)) {
-			file_extent_err(fs_info, leaf, slot,
+			file_extent_err(leaf, slot,
 	"invalid ram_bytes for uncompressed inline extent, have %u expect %llu",
 				item_size, BTRFS_FILE_EXTENT_INLINE_DATA_START +
 				btrfs_file_extent_ram_bytes(leaf, fi));
@@ -174,7 +174,7 @@ static int check_extent_data_item(struct btrfs_fs_info *fs_info,
 
 	/* Regular or preallocated extent has fixed item size */
 	if (item_size != sizeof(*fi)) {
-		file_extent_err(fs_info, leaf, slot,
+		file_extent_err(leaf, slot,
 	"invalid item size for reg/prealloc file extent, have %u expect %zu",
 			item_size, sizeof(*fi));
 		return -EUCLEAN;
-- 
2.21.0

