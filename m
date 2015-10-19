Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35786 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbbJSLsC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Oct 2015 07:48:02 -0400
Received: by pasz6 with SMTP id z6so28755819pas.2
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2015 04:48:01 -0700 (PDT)
From: Eryu Guan <guaneryu@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH 08/10] btrfs-progs: remove identical branch in record_extent()
Date: Mon, 19 Oct 2015 19:37:58 +0800
Message-Id: <1445254680-11102-9-git-send-email-guaneryu@gmail.com>
In-Reply-To: <1445254680-11102-1-git-send-email-guaneryu@gmail.com>
References: <1445254680-11102-1-git-send-email-guaneryu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The same code is executed when the condition "ret" is true or false,
because the code in the if-then branch and after the if statement is
identical.

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 cmds-check.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 118a274..a459893 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6310,8 +6310,6 @@ static int record_extent(struct btrfs_trans_handle *trans,
 			"start %llu len %llu parent %llu root %llu\n",
 			rec->start, rec->max_size, parent, tback->root);
 	}
-	if (ret)
-		goto fail;
 fail:
 	btrfs_release_path(path);
 	return ret;
-- 
2.4.3

