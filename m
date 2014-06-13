Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:41242 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaFMVeq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Jun 2014 17:34:46 -0400
Received: by mail-pd0-f181.google.com with SMTP id v10so1602782pde.26
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Jun 2014 14:34:46 -0700 (PDT)
From: Adam Buchbinder <abuchbinder@google.com>
To: linux-btrfs@vger.kernel.org
Cc: dave@jikos.cz, Adam Buchbinder <abuchbinder@google.com>
Subject: [PATCH 2/2] Remove a leading '+'.
Date: Fri, 13 Jun 2014 14:34:36 -0700
Message-Id: <1402695276-28104-2-git-send-email-abuchbinder@google.com>
In-Reply-To: <1402695276-28104-1-git-send-email-abuchbinder@google.com>
References: <1402695276-28104-1-git-send-email-abuchbinder@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It was added in commit aab7f3ae3eb02fb7e8a6a31d7e2ada704a3dcd5e,
most likely as a copy-pasteo.

Signed-off-by: Adam Buchbinder <abuchbinder@google.com>
---
 btrfs-show-super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/btrfs-show-super.c b/btrfs-show-super.c
index f42cd15..ed0311f 100644
--- a/btrfs-show-super.c
+++ b/btrfs-show-super.c
@@ -50,7 +50,7 @@ static void print_usage(void)
 	fprintf(stderr, "\t-f : print full superblock information\n");
 	fprintf(stderr, "\t-a : print information of all superblocks\n");
 	fprintf(stderr, "\t-i <super_mirror> : specify which mirror to print out\n");
-+	fprintf(stderr, "\t-F : attempt to dump superblocks with bad magic\n");
+	fprintf(stderr, "\t-F : attempt to dump superblocks with bad magic\n");
 	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
 }
 
-- 
2.0.0.526.g5318336

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
