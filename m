Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:35112 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbbJSLlW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Oct 2015 07:41:22 -0400
Received: by pasz6 with SMTP id z6so28617829pas.2
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2015 04:41:22 -0700 (PDT)
From: Eryu Guan <guaneryu@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH 02/10] btrfs-progs: save error number correctly in check_chunks_and_extents
Date: Mon, 19 Oct 2015 19:37:52 +0800
Message-Id: <1445254680-11102-3-git-send-email-guaneryu@gmail.com>
In-Reply-To: <1445254680-11102-1-git-send-email-guaneryu@gmail.com>
References: <1445254680-11102-1-git-send-email-guaneryu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Coverity reports assigning value from "err" to "ret", but that stored
value is overwritten by check_extent_refs() before it can be used.

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 cmds-check.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 4225b21..80a7c29 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -8066,13 +8066,12 @@ again:
 		goto out;
 	}
 
-	err = check_chunks(&chunk_cache, &block_group_cache,
+	ret = check_chunks(&chunk_cache, &block_group_cache,
 			   &dev_extent_cache, NULL, NULL, NULL, 0);
-	if (err) {
-		if (err == -EAGAIN)
+	if (ret) {
+		if (ret == -EAGAIN)
 			goto loop;
-		if (!ret)
-			ret = err;
+		err = ret;
 	}
 
 	ret = check_extent_refs(root, &extent_cache);
@@ -8082,8 +8081,8 @@ again:
 		goto out;
 	}
 
-	err = check_devices(&dev_cache, &dev_extent_cache);
-	if (err && !ret)
+	ret = check_devices(&dev_cache, &dev_extent_cache);
+	if (ret && err)
 		ret = err;
 
 out:
-- 
2.4.3

