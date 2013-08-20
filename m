Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:32816 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab3HTLU3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Aug 2013 07:20:29 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chris Mason <chris.mason@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 04/12] Btrfs: Format mirror_num as int
Date: Tue, 20 Aug 2013 13:20:10 +0200
Message-Id: <1376997618-13573-5-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1376997618-13573-1-git-send-email-geert@linux-m68k.org>
References: <1376997618-13573-1-git-send-email-geert@linux-m68k.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

mirror_num is always "int", hence don't cast it to "unsigned long long" and
format it as a 64-bit number.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 fs/btrfs/scrub.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index f2bc6df..838c8a0 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3170,9 +3170,9 @@ static void copy_nocow_pages_worker(struct btrfs_work *work)
 					  copy_nocow_pages_for_inode,
 					  nocow_ctx);
 	if (ret != 0 && ret != -ENOENT) {
-		pr_warn("iterate_inodes_from_logical() failed: log %llu, phys %llu, len %llu, mir %llu, ret %d\n",
-			logical, physical_for_dev_replace, len,
-			(unsigned long long)mirror_num, ret);
+		pr_warn("iterate_inodes_from_logical() failed: log %llu, phys %llu, len %llu, mir %u, ret %d\n",
+			logical, physical_for_dev_replace, len, mirror_num,
+			ret);
 		not_written = 1;
 		goto out;
 	}
-- 
1.7.9.5

