Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:36578 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390Ab3DPIPn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 04:15:43 -0400
Received: from romuald.bergerie (unknown [88.178.86.202])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 11ACF940137
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 10:15:35 +0200 (CEST)
From: "Vincent" <vincent.stehle@laposte.net>
To: Chris Mason <chris.mason@fusionio.com>
Cc: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix reada debug code compilation
Date: Tue, 16 Apr 2013 10:15:25 +0200
Message-Id: <1366100125-13043-1-git-send-email-vincent.stehle@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This fixes the following errors:

  fs/btrfs/reada.c: In function ‘btrfs_reada_wait’:
  fs/btrfs/reada.c:958:42: error: invalid operands to binary < (have ‘atomic_t’ and ‘int’)
  fs/btrfs/reada.c:961:41: error: invalid operands to binary < (have ‘atomic_t’ and ‘int’)

Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Cc: Chris Mason <chris.mason@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
---
 fs/btrfs/reada.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 692185e..d1690c3 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -955,10 +955,11 @@ int btrfs_reada_wait(void *handle)
 	while (atomic_read(&rc->elems)) {
 		wait_event_timeout(rc->wait, atomic_read(&rc->elems) == 0,
 				   5 * HZ);
-		dump_devs(rc->root->fs_info, rc->elems < 10 ? 1 : 0);
+		dump_devs(rc->root->fs_info,
+			  atomic_read(&rc->elems) < 10 ? 1 : 0);
 	}
 
-	dump_devs(rc->root->fs_info, rc->elems < 10 ? 1 : 0);
+	dump_devs(rc->root->fs_info, atomic_read(&rc->elems) < 10 ? 1 : 0);
 
 	kref_put(&rc->refcnt, reada_control_release);
 
-- 
1.7.10.4

