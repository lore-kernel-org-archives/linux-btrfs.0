Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:39199 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294Ab3BLRFL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 12:05:11 -0500
Received: by mail-ee0-f54.google.com with SMTP id c41so170289eek.41
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2013 09:05:10 -0800 (PST)
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: idryomov@gmail.com
Subject: [PATCH] Btrfs-progs: make 0 a valid usage filter argument
Date: Tue, 12 Feb 2013 19:05:03 +0200
Message-Id: <1360688703-23230-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a progs counterpart to a "Btrfs: allow for selecting only
completely empty chunks".  usage=0 now means "select only only
completely empty chunks and nothing else".

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 cmds-balance.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/cmds-balance.c b/cmds-balance.c
index 38a7426..1f888db 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -159,7 +159,7 @@ static int parse_filters(char *filters, struct btrfs_balance_args *args)
 				return 1;
 			}
 			if (parse_u64(value, &args->usage) ||
-			    args->usage < 1 || args->usage > 100) {
+			    args->usage > 100) {
 				fprintf(stderr, "Invalid usage argument: %s\n",
 				       value);
 				return 1;
-- 
1.7.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
