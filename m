Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www17.your-server.de ([213.133.104.17]:47764 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932411Ab2HFSb5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Aug 2012 14:31:57 -0400
Subject: [PATCH] Btrfs: Use PTR_RET rather than if(IS_ERR(.. [1]
From: Thomas Meyer <thomas@m3y3r.de>
To: "[chris.mason@fusionio.com, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org]"@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Mon, 06 Aug 2012 19:51:17 +0200
Message-ID: <1344275477.14513.117.camel@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The semantic patch that makes this change is available
in scripts/coccinelle/api/ptr_ret.cocci.

More information about semantic patching is available at
http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2886,10 +2886,7 @@ int btrfs_resume_balance_async(struct bt
 	}
 
 	tsk = kthread_run(balance_kthread, fs_info, "btrfs-balance");
-	if (IS_ERR(tsk))
-		return PTR_ERR(tsk);
-
-	return 0;
+	return PTR_RET(tsk);
 }
 
 int btrfs_recover_balance(struct btrfs_fs_info *fs_info)
