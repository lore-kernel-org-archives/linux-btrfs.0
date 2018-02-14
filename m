Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:43159 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754578AbeBNIKE (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 14 Feb 2018 03:10:04 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH] btrfs-progs: convert/ext2: Fix memory leak caused by handled ext2_filsys
Date: Wed, 14 Feb 2018 16:09:56 +0800
Message-Id: <20180214080956.9953-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Exposed convert-test with D=asan.

Unlike btrfs, ext2fs_close() still leaves its ext2_filsys parameter
filled with allocated pointers.

It needs ext2fs_free() to free those pointers.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 convert/source-ext2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/convert/source-ext2.c b/convert/source-ext2.c
index e9277213b77a..67e97cf87185 100644
--- a/convert/source-ext2.c
+++ b/convert/source-ext2.c
@@ -95,6 +95,7 @@ static int ext2_open_fs(struct btrfs_convert_context *cctx, const char *name)
 	return 0;
 fail:
 	ext2fs_close(ext2_fs);
+	ext2fs_free(ext2_fs);
 	return -1;
 }
 
@@ -179,6 +180,7 @@ static void ext2_close_fs(struct btrfs_convert_context *cctx)
 		cctx->volume_name = NULL;
 	}
 	ext2fs_close(cctx->fs_data);
+	ext2fs_free(cctx->fs_data);
 }
 
 static u8 ext2_filetype_conversion_table[EXT2_FT_MAX] = {
-- 
2.16.1

