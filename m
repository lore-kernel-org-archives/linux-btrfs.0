Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:58236 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752382AbeB0JNO (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 27 Feb 2018 04:13:14 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 2/4] btrfs-progs: check: Fix data csum check return value
Date: Tue, 27 Feb 2018 17:12:57 +0800
Message-Id: <20180227091259.10877-3-wqu@suse.com>
In-Reply-To: <20180227091259.10877-1-wqu@suse.com>
References: <20180227091259.10877-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When --check-data-csum option found csum mismatch, btrfs check still
return 0.

Fix it so log-replay could automatically pause when found csum error.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/check/main.c b/check/main.c
index f25fdc765d63..15b3c402c9f5 100644
--- a/check/main.c
+++ b/check/main.c
@@ -5356,6 +5356,13 @@ static int check_space_cache(struct btrfs_root *root)
 	return error ? -EINVAL : 0;
 }
 
+/*
+ * Check data checksum for [@bytenr, @bytenr + @num_bytes).
+ *
+ * Return <0 for fatal error (fails to read checksum/data or allocate memory).
+ * Return >0 for csum mismatch for *ANY* copy.
+ * Return 0 if everything is OK.
+ */
 static int check_extent_csums(struct btrfs_root *root, u64 bytenr,
 			u64 num_bytes, unsigned long leaf_offset,
 			struct extent_buffer *eb)
@@ -5373,6 +5380,7 @@ static int check_extent_csums(struct btrfs_root *root, u64 bytenr,
 	int ret = 0;
 	int mirror;
 	int num_copies;
+	bool csum_mismatch = false;
 
 	if (num_bytes % fs_info->sectorsize)
 		return -EINVAL;
@@ -5405,11 +5413,13 @@ static int check_extent_csums(struct btrfs_root *root, u64 bytenr,
 					 tmp / fs_info->sectorsize * csum_size;
 				read_extent_buffer(eb, (char *)&csum_expected,
 						   csum_offset, csum_size);
-				if (csum != csum_expected)
+				if (csum != csum_expected) {
+					csum_mismatch = true;
 					fprintf(stderr,
 			"mirror %d bytenr %llu csum %u expected csum %u\n",
 						mirror, bytenr + tmp,
 						csum, csum_expected);
+				}
 				data_checked += fs_info->sectorsize;
 			}
 		}
@@ -5417,6 +5427,8 @@ static int check_extent_csums(struct btrfs_root *root, u64 bytenr,
 	}
 out:
 	free(data);
+	if (!ret && csum_mismatch)
+		ret = 1;
 	return ret;
 }
 
@@ -5625,6 +5637,8 @@ static int check_csums(struct btrfs_root *root)
 		 */
 		if (ret < 0)
 			break;
+		if (ret > 0)
+			errors++;
 skip_csum_check:
 		if (!num_bytes) {
 			offset = key.offset;
-- 
2.16.2

