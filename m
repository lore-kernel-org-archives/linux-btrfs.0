Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:48406 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753969AbeASFiB (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 19 Jan 2018 00:38:01 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 11/16] btrfs-progs: check: Move check_dev_size_alignment to check/common.c
Date: Fri, 19 Jan 2018 13:37:26 +0800
Message-Id: <20180119053731.10795-12-wqu@suse.com>
In-Reply-To: <20180119053731.10795-1-wqu@suse.com>
References: <20180119053731.10795-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/common.c | 15 +++++++++++++++
 check/common.h |  1 +
 check/main.c   | 16 ----------------
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/check/common.c b/check/common.c
index 9051936a61cb..7392ed6b472f 100644
--- a/check/common.c
+++ b/check/common.c
@@ -237,3 +237,18 @@ out:
 	return ret;
 }
 
+/*
+ * Extra (optional) check for dev_item size to report possbile problem on a new
+ * kernel.
+ */
+void check_dev_size_alignment(u64 devid, u64 total_bytes, u32 sectorsize)
+{
+	if (!IS_ALIGNED(total_bytes, sectorsize)) {
+		warning(
+"unaligned total_bytes detected for devid %llu, have %llu should be aligned to %u",
+			devid, total_bytes, sectorsize);
+		warning(
+"this is OK for older kernel, but may cause kernel warning for newer kernels");
+		warning("this can be fixed by 'btrfs rescue fix-device-size'");
+	}
+}
diff --git a/check/common.h b/check/common.h
index 9a3488ae365a..72146b444a79 100644
--- a/check/common.h
+++ b/check/common.h
@@ -90,5 +90,6 @@ int link_inode_to_lostfound(struct btrfs_trans_handle *trans,
 			    struct btrfs_path *path,
 			    u64 ino, char *namebuf, u32 name_len,
 			    u8 filetype, u64 *ref_count);
+void check_dev_size_alignment(u64 devid, u64 total_bytes, u32 sectorsize);
 
 #endif
diff --git a/check/main.c b/check/main.c
index 0da25c460336..a8155630df18 100644
--- a/check/main.c
+++ b/check/main.c
@@ -10708,22 +10708,6 @@ static int check_device_used(struct device_record *dev_rec,
 	}
 }
 
-/*
- * Extra (optional) check for dev_item size to report possbile problem on a new
- * kernel.
- */
-static void check_dev_size_alignment(u64 devid, u64 total_bytes, u32 sectorsize)
-{
-	if (!IS_ALIGNED(total_bytes, sectorsize)) {
-		warning(
-"unaligned total_bytes detected for devid %llu, have %llu should be aligned to %u",
-			devid, total_bytes, sectorsize);
-		warning(
-"this is OK for older kernel, but may cause kernel warning for newer kernels");
-		warning("this can be fixed by 'btrfs rescue fix-device-size'");
-	}
-}
-
 /*
  * Unlike device size alignment check above, some super total_bytes check
  * failure can lead to mount failure for newer kernel.
-- 
2.15.1

