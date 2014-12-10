Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:43951 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933315AbaLJVFm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 16:05:42 -0500
Received: from mail-in-01-z2.arcor-online.net (mail-in-01-z2.arcor-online.net [151.189.8.13])
	by mx.arcor.de (Postfix) with ESMTP id 007E8107E48
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 22:05:41 +0100 (CET)
From: mwilck@arcor.de
To: linux-btrfs@vger.kernel.org
Cc: mwilck@arcor.de
Subject: [PATCH 07/18] btrfs restore: better output readability
Date: Wed, 10 Dec 2014 21:51:37 +0100
Message-Id: <1418244708-7087-8-git-send-email-mwilck@arcor.de>
In-Reply-To: <1418244708-7087-1-git-send-email-mwilck@arcor.de>
References: <1418244708-7087-1-git-send-email-mwilck@arcor.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Martin Wilck <mwilck@arcor.de>

Don't print whole path for files, which will mangle output
for long path names. Rather distinguish between directories
and files.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 cmds-restore.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index 5aa2167..f9dab7e 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -908,7 +908,7 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 				ret = 0;
 			}
 			if (verbose)
-				printf("Restoring %s\n", path_name);
+				printf("Restoring %s\n", filename);
 			if (dry_run)
 				goto next;
 			fd = open(path_name, O_CREAT|O_WRONLY, 0644);
@@ -982,7 +982,7 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 			}
 
 			if (verbose)
-				printf("Restoring %s\n", path_name);
+				printf("Searching directory %s\n", path_name);
 
 			errno = 0;
 			if (dry_run)
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
