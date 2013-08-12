Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:34714 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357Ab3HLO70 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Aug 2013 10:59:26 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id A5EAF9A04E0
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Aug 2013 08:59:25 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx1.fusionio.com with ESMTP id kIFmELp0RpMjhdOD (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 12 Aug 2013 08:59:25 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: skip subvol entries when checking if we've created a dir already
Date: Mon, 12 Aug 2013 10:59:22 -0400
Message-ID: <1376319562-5230-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have logic to see if we've already created a parent directory by check to see
if an inode inside of that directory has a lower inode number than the one we
are currently processing.  The logic is that if there is a lower inode number
then we would have had to made sure the directory was created at that previous
point.  The problem is if we have subvols in that directory these will always be
lower since they are set to the first free objectid.  To fix this we just skip
entries with that inode number.  Thanks,

Reported-by: Emil Karlson <jekarlson@gmail.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/send.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 0efc2e2..5c09059 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -2538,7 +2538,8 @@ static int did_create_dir(struct send_ctx *sctx, u64 dir)
 		di = btrfs_item_ptr(eb, slot, struct btrfs_dir_item);
 		btrfs_dir_item_key_to_cpu(eb, di, &di_key);
 
-		if (di_key.objectid < sctx->send_progress) {
+		if (di_key.objectid != BTRFS_FIRST_FREE_OBJECTID &&
+		    di_key.objectid < sctx->send_progress) {
 			ret = 1;
 			goto out;
 		}
-- 
1.7.7.6

