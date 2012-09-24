Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54813 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab2IXArh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Sep 2012 20:47:37 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so591587pad.19
        for <linux-btrfs@vger.kernel.org>; Sun, 23 Sep 2012 17:47:37 -0700 (PDT)
Message-ID: <505FADA5.3070500@gmail.com>
Date: Mon, 24 Sep 2012 08:47:33 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org, trivial@kernel.org
Subject: [PATCH 4/4] Btrfs: tivial cleanup: add space between = and the rest
 code
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

trivial code cleanup.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/transaction.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 675d813..3279df2 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1619,7 +1619,7 @@ int btrfs_clean_old_snapshots(struct btrfs_root *root)
 		    BTRFS_MIXED_BACKREF_REV)
 			ret = btrfs_drop_snapshot(root, NULL, 0, 0);
 		else
-			ret =btrfs_drop_snapshot(root, NULL, 1, 0);
+			ret = btrfs_drop_snapshot(root, NULL, 1, 0);
 		BUG_ON(ret < 0);
 	}
 	return 0;
-- 
1.7.1

