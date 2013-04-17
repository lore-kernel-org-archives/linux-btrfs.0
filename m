Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:41464 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965067Ab3DQUpg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Apr 2013 16:45:36 -0400
Received: from romuald.bergerie (unknown [88.178.86.202])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 34EFC940184
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Apr 2013 22:45:27 +0200 (CEST)
From: "Vincent" <vincent.stehle@laposte.net>
To: David Sterba <dsterba@suse.cz>
Cc: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix reada debug code compilation
Date: Wed, 17 Apr 2013 22:45:18 +0200
Message-Id: <1366231518-15243-1-git-send-email-vincent.stehle@laposte.net>
In-Reply-To: <20130416132834.GM18193@twin.jikos.cz>
References: <20130416132834.GM18193@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This fixes the following errors:

  fs/btrfs/reada.c: In function ‘btrfs_reada_wait’:
  fs/btrfs/reada.c:958:42: error: invalid operands to binary < (have ‘atomic_t’ and ‘int’)
  fs/btrfs/reada.c:961:41: error: invalid operands to binary < (have ‘atomic_t’ and ‘int’)

Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Reviewed-by: David Sterba <dsterba@suse.cz>
Cc: Chris Mason <chris.mason@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
---


Hi David,

Thanks for your review; here is a resend with your 'Reviewed-by'.

Best regards,

V.


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

