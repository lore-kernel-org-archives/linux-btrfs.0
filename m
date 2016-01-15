Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36898 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbcAOK4c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jan 2016 05:56:32 -0500
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: fix typo in log message when starting a balance
Date: Fri, 15 Jan 2016 10:56:15 +0000
Message-Id: <1452855375-17633-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

The recent change titled "Btrfs: Check metadata redundancy on balance"
(already in linux-next) left a typo in a message for users:
metatdata -> metadata.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c32abbc..b59db3e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3751,7 +3751,7 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 	if (btrfs_get_num_tolerated_disk_barrier_failures(bctl->meta.target) <
 		btrfs_get_num_tolerated_disk_barrier_failures(bctl->data.target)) {
 		btrfs_warn(fs_info,
-	"metatdata profile 0x%llx has lower redundancy than data profile 0x%llx",
+	"metadata profile 0x%llx has lower redundancy than data profile 0x%llx",
 			bctl->meta.target, bctl->data.target);
 	}
 
-- 
2.7.0.rc3

