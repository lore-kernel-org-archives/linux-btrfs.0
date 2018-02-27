Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:39912 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752238AbeB0JNO (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 27 Feb 2018 04:13:14 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 1/4] btrfs-progs: check: Check data csum for all copies
Date: Tue, 27 Feb 2018 17:12:56 +0800
Message-Id: <20180227091259.10877-2-wqu@suse.com>
In-Reply-To: <20180227091259.10877-1-wqu@suse.com>
References: <20180227091259.10877-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Original --check-data-csum option will skip the extra copy if the first
copy matches csum.

Since offline scrub (with recoverability report) is still out-of-tree, at
least enhance --check-data-csum option to handle multiple copies.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c | 65 ++++++++++++++++++++++++++++++------------------------------
 1 file changed, 32 insertions(+), 33 deletions(-)

diff --git a/check/main.c b/check/main.c
index 97baae583f04..f25fdc765d63 100644
--- a/check/main.c
+++ b/check/main.c
@@ -5381,42 +5381,37 @@ static int check_extent_csums(struct btrfs_root *root, u64 bytenr,
 	if (!data)
 		return -ENOMEM;
 
+	num_copies = btrfs_num_copies(root->fs_info, bytenr, num_bytes);
 	while (offset < num_bytes) {
-		mirror = 0;
-again:
-		read_len = num_bytes - offset;
-		/* read as much space once a time */
-		ret = read_extent_data(fs_info, data + offset,
-				bytenr + offset, &read_len, mirror);
-		if (ret)
-			goto out;
-		data_checked = 0;
-		/* verify every 4k data's checksum */
-		while (data_checked < read_len) {
-			csum = ~(u32)0;
-			tmp = offset + data_checked;
-
-			csum = btrfs_csum_data((char *)data + tmp,
-					       csum, fs_info->sectorsize);
-			btrfs_csum_final(csum, (u8 *)&csum);
-
-			csum_offset = leaf_offset +
-				 tmp / fs_info->sectorsize * csum_size;
-			read_extent_buffer(eb, (char *)&csum_expected,
-					   csum_offset, csum_size);
-			/* try another mirror */
-			if (csum != csum_expected) {
-				fprintf(stderr, "mirror %d bytenr %llu csum %u expected csum %u\n",
+		for (mirror = 1; mirror <= num_copies; mirror++) {
+			read_len = num_bytes - offset;
+			/* read as much space once a time */
+			ret = read_extent_data(fs_info, data + offset,
+					bytenr + offset, &read_len, mirror);
+			if (ret)
+				goto out;
+
+			data_checked = 0;
+			/* verify every 4k data's checksum */
+			while (data_checked < read_len) {
+				csum = ~(u32)0;
+				tmp = offset + data_checked;
+
+				csum = btrfs_csum_data((char *)data + tmp,
+						csum, fs_info->sectorsize);
+				btrfs_csum_final(csum, (u8 *)&csum);
+
+				csum_offset = leaf_offset +
+					 tmp / fs_info->sectorsize * csum_size;
+				read_extent_buffer(eb, (char *)&csum_expected,
+						   csum_offset, csum_size);
+				if (csum != csum_expected)
+					fprintf(stderr,
+			"mirror %d bytenr %llu csum %u expected csum %u\n",
 						mirror, bytenr + tmp,
 						csum, csum_expected);
-				num_copies = btrfs_num_copies(root->fs_info,
-						bytenr, num_bytes);
-				if (mirror < num_copies - 1) {
-					mirror += 1;
-					goto again;
-				}
+				data_checked += fs_info->sectorsize;
 			}
-			data_checked += fs_info->sectorsize;
 		}
 		offset += read_len;
 	}
@@ -5624,7 +5619,11 @@ static int check_csums(struct btrfs_root *root)
 		leaf_offset = btrfs_item_ptr_offset(leaf, path.slots[0]);
 		ret = check_extent_csums(root, key.offset, data_len,
 					 leaf_offset, leaf);
-		if (ret)
+		/*
+		 * Only break for fatal errors, if mismatch is found,
+		 * continue checking until all extents are checked.
+		 */
+		if (ret < 0)
 			break;
 skip_csum_check:
 		if (!num_bytes) {
-- 
2.16.2

