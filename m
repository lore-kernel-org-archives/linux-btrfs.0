Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:36588 "EHLO
	mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbcEDTnj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 May 2016 15:43:39 -0400
Received: by mail-qk0-f170.google.com with SMTP id x7so31811441qkd.3
        for <linux-btrfs@vger.kernel.org>; Wed, 04 May 2016 12:43:38 -0700 (PDT)
From: Noah Massey <noah.massey@gmail.com>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: Noah Massey <noah.massey@gmail.com>
Subject: [PATCH] btrfs-progs: Adjust timing of safety delay countdown
Date: Wed,  4 May 2016 15:43:26 -0400
Message-Id: <1462391006-4057-1-git-send-email-noah.massey@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When printing the countdown in the safety delay, the number should
correspond to the number of seconds remaining to wait at the time the
delay is printed.

In other words, there should be a one second sleep after printing '1'.

Signed-off-by: Noah Massey <noah.massey@gmail.com>
---
 cmds-balance.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-balance.c b/cmds-balance.c
index 5f05f60..8f3bf5b 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -445,9 +445,9 @@ static int do_balance(const char *path, struct btrfs_ioctl_balance_args *args,
 		printf("\twarning. The operation will start in %d seconds.\n", delay);
 		printf("\tUse Ctrl-C to stop it.\n");
 		while (delay) {
-			sleep(1);
 			printf("%2d", delay--);
 			fflush(stdout);
+			sleep(1);
 		}
 		printf("\nStarting balance without any filters.\n");
 	}
-- 
2.8.1

