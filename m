Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224Ab3HFCxH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Aug 2013 22:53:07 -0400
Message-ID: <52006509.1060207@redhat.com>
Date: Mon, 05 Aug 2013 21:52:57 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: don't overrun "answer" array in cmds-chunk.c
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If an array is 5 chars in size:

       char answer[5];

and we write the 6th char (counting from 0)...

       answer[5] = '\0';

we get problems:

cmds-chunk.c: In function 'ask_user.clone.0':
cmds-chunk.c:1343: warning: array subscript is above array bounds

Fix it...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---


diff --git a/cmds-chunk.c b/cmds-chunk.c
index 03314de..7c3257c 100644
--- a/cmds-chunk.c
+++ b/cmds-chunk.c
@@ -1340,7 +1340,7 @@ again:
 		}
 		i++;
 	}
-	answer[5] = '\0';
+	answer[4] = '\0';
 	__fpurge(stdin);
 
 	if (strlen(answer) == 0) {

