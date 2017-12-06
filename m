Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:46426 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752857AbdLFGyR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Dec 2017 01:54:17 -0500
Received: by mail-pl0-f67.google.com with SMTP id i6so420109plt.13
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Dec 2017 22:54:17 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH] Btrfs: disable FUA if mounted with nobarrier
Date: Tue,  5 Dec 2017 22:54:02 -0800
Message-Id: <bf59f09eff9232dcb5872aab4c975a776232b6ac.1512543205.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

I was seeing disk flushes still happening when I mounted a Btrfs
filesystem with nobarrier for testing. This is because we use FUA to
write out the first super block, and on devices without FUA support, the
block layer translates FUA to a flush. Even on devices supporting true
FUA, using FUA when we asked for no barriers is surprising.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/disk-io.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 10a2a579cc7f..a8ecccfc36de 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3231,6 +3231,7 @@ static int write_dev_supers(struct btrfs_device *device,
 	int errors = 0;
 	u32 crc;
 	u64 bytenr;
+	int op_flags;
 
 	if (max_mirrors == 0)
 		max_mirrors = BTRFS_SUPER_MIRROR_MAX;
@@ -3273,13 +3274,10 @@ static int write_dev_supers(struct btrfs_device *device,
 		 * we fua the first super.  The others we allow
 		 * to go down lazy.
 		 */
-		if (i == 0) {
-			ret = btrfsic_submit_bh(REQ_OP_WRITE,
-				REQ_SYNC | REQ_FUA | REQ_META | REQ_PRIO, bh);
-		} else {
-			ret = btrfsic_submit_bh(REQ_OP_WRITE,
-				REQ_SYNC | REQ_META | REQ_PRIO, bh);
-		}
+		op_flags = REQ_SYNC | REQ_META | REQ_PRIO;
+		if (i == 0 && !btrfs_test_opt(device->fs_info, NOBARRIER))
+			op_flags |= REQ_FUA;
+		ret = btrfsic_submit_bh(REQ_OP_WRITE, op_flags, bh);
 		if (ret)
 			errors++;
 	}
-- 
2.15.1

