Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx.mylinuxtime.de ([148.251.109.235]:33789 "EHLO
	mx.mylinuxtime.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbaFCL3d (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jun 2014 07:29:33 -0400
From: Christian Hesse <mail@eworm.de>
To: linux-btrfs@vger.kernel.org
Cc: Christian Hesse <mail@eworm.de>
Subject: [PATCH 1/1] btrfs-progs: fix compiler warning
Date: Tue,  3 Jun 2014 13:29:19 +0200
Message-Id: <1401794959-25907-1-git-send-email-mail@eworm.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

gcc 4.9.0 gives a warning: array subscript is above array bounds

Checking for "greater or equal" instead of just "equal" fixes this.

Signed-off-by: Christian Hesse <mail@eworm.de>
---
 cmds-restore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index 96b97e1..534a49e 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -169,7 +169,7 @@ again:
 			break;
 	}
 
-	if (level == BTRFS_MAX_LEVEL)
+	if (level >= BTRFS_MAX_LEVEL)
 		return 1;
 
 	slot = path->slots[level] + 1;
-- 
2.0.0

