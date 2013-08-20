Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:43587 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab3HTLUa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Aug 2013 07:20:30 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chris Mason <chris.mason@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 02/12] Btrfs: Make BTRFS_DEV_REPLACE_DEVID an unsigned long long constant
Date: Tue, 20 Aug 2013 13:20:08 +0200
Message-Id: <1376997618-13573-3-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1376997618-13573-1-git-send-email-geert@linux-m68k.org>
References: <1376997618-13573-1-git-send-email-geert@linux-m68k.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The internal btrfs device id is a u64, hence make the constant
BTRFS_DEV_REPLACE_DEVID "unsigned long long" as well, so we no longer need
a cast to print it.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 fs/btrfs/ctree.h       |    2 +-
 fs/btrfs/dev-replace.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e795bf1..2ab606c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -142,7 +142,7 @@ struct btrfs_ordered_sum;
 
 #define BTRFS_EMPTY_SUBVOL_DIR_OBJECTID 2
 
-#define BTRFS_DEV_REPLACE_DEVID 0
+#define BTRFS_DEV_REPLACE_DEVID 0ULL
 
 /*
  * the max metadata block size.  This limit is somewhat artificial,
diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index e34e72f..af800ef 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -154,7 +154,7 @@ no_valid_dev_replace_entry_found:
 		    !btrfs_test_opt(dev_root, DEGRADED)) {
 			ret = -EIO;
 			pr_warn("btrfs: cannot mount because device replace operation is ongoing and\n" "tgtdev (devid %llu) is missing, need to run btrfs dev scan?\n",
-				(unsigned long long)BTRFS_DEV_REPLACE_DEVID);
+				BTRFS_DEV_REPLACE_DEVID);
 		}
 		if (dev_replace->tgtdev) {
 			if (dev_replace->srcdev) {
-- 
1.7.9.5

