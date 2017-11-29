Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:60435 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753403AbdK2JQS (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 29 Nov 2017 04:16:18 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 1/9] btrfs-progs: mkfs: Cleanup temporary chunks before filling rootdir
Date: Wed, 29 Nov 2017 17:15:56 +0800
Message-Id: <20171129091604.2194-2-wqu@suse.com>
In-Reply-To: <20171129091604.2194-1-wqu@suse.com>
References: <20171129091604.2194-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Cleanup those temporary chunks should be as soon as possible, and it
should be especially before doing large tree operations, like filling
rootdir.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 mkfs/main.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/mkfs/main.c b/mkfs/main.c
index 2da38cb9490e..a81718d1517d 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1248,6 +1248,13 @@ raid_groups:
 		goto out;
 	}
 
+	ret = cleanup_temp_chunks(fs_info, &allocation, data_profile,
+				  metadata_profile, metadata_profile);
+	if (ret < 0) {
+		error("failed to cleanup temporary chunks: %d", ret);
+		goto out;
+	}
+
 	if (source_dir_set) {
 		trans = btrfs_start_transaction(root, 1);
 		BUG_ON(IS_ERR(trans));
@@ -1311,12 +1318,6 @@ raid_groups:
 			}
 		}
 	}
-	ret = cleanup_temp_chunks(fs_info, &allocation, data_profile,
-				  metadata_profile, metadata_profile);
-	if (ret < 0) {
-		error("failed to cleanup temporary chunks: %d", ret);
-		goto out;
-	}
 
 	if (verbose) {
 		char features_buf[64];
-- 
2.15.0

