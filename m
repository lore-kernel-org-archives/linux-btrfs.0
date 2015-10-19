Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:34579 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbbJSLkP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Oct 2015 07:40:15 -0400
Received: by padhk11 with SMTP id hk11so28103911pad.1
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2015 04:40:15 -0700 (PDT)
From: Eryu Guan <guaneryu@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH 02/10] btrfs-progs: save and return error number correctly in check_chunks_and_extents
Date: Mon, 19 Oct 2015 19:37:51 +0800
Message-Id: <1445254680-11102-2-git-send-email-guaneryu@gmail.com>
In-Reply-To: <1445254680-11102-1-git-send-email-guaneryu@gmail.com>
References: <1445254680-11102-1-git-send-email-guaneryu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"err" is assigned to "ret" then "ret" gets overwritten by
check_extent_refs() before "ret" can be used.

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

