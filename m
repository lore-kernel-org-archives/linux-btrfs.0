Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.141]:16282 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755466Ab3ICNZ3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Sep 2013 09:25:29 -0400
Received: from pizpot.store ([192.168.43.236])
 by jored.store (RZmta 31.47 OK) with ESMTP id p04509p8370gWR
 for <linux-btrfs@vger.kernel.org>;
 Tue, 3 Sep 2013 15:25:27 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: show compiled-in config features at module load time
Date: Tue,  3 Sep 2013 15:25:27 +0200
Message-Id: <32516c087c164d4c319ac774758c70112e560a21.1378214658.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We want to know if there are debugging features compiled in, this may
affect performance. The message is printed before the sanity checks.

(This commit message is a copy of David Sterba's commit message when
he introduced btrfs_print_info()).

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 3aab10c..58cb83f 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1762,6 +1762,9 @@ static void btrfs_print_info(void)
 #ifdef CONFIG_BTRFS_DEBUG
 			", debug=on"
 #endif
+#ifdef CONFIG_BTRFS_ASSERT
+			", assert=on"
+#endif
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 			", integrity-checker=on"
 #endif
-- 
1.8.4

