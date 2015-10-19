Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:32879 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbbJSLpt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Oct 2015 07:45:49 -0400
Received: by pabrc13 with SMTP id rc13so189450031pab.0
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2015 04:45:48 -0700 (PDT)
From: Eryu Guan <guaneryu@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH 06/10] btrfs-progs: vailidate pointer before dereferencing it in btrfs_cow_block()
Date: Mon, 19 Oct 2015 19:37:56 +0800
Message-Id: <1445254680-11102-7-git-send-email-guaneryu@gmail.com>
In-Reply-To: <1445254680-11102-1-git-send-email-guaneryu@gmail.com>
References: <1445254680-11102-1-git-send-email-guaneryu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Check trans before dereferencing it.

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 ctree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ctree.c b/ctree.c
index 1434007..f9d972a 100644
--- a/ctree.c
+++ b/ctree.c
@@ -356,7 +356,7 @@ int btrfs_cow_block(struct btrfs_trans_handle *trans,
 		WARN_ON(1);
 	}
 	*/
-	if (trans->transid != root->fs_info->generation) {
+	if (trans && trans->transid != root->fs_info->generation) {
 		printk(KERN_CRIT "trans %llu running %llu\n",
 			(unsigned long long)trans->transid,
 			(unsigned long long)root->fs_info->generation);
-- 
2.4.3

