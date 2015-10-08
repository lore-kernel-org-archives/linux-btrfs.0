Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-by2on0133.outbound.protection.outlook.com ([207.46.100.133]:51254
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755356AbbJHJTh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Oct 2015 05:19:37 -0400
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@freescale.com>
To: <linux-btrfs@vger.kernel.org>
CC: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@freescale.com>
Subject: [PATCH] btrfs-progs: restore: fix off-by-one len check
Date: Thu, 8 Oct 2015 10:47:09 +0200
Message-ID: <1444294029-23310-1-git-send-email-vincent.stehle@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fix a check of len versus PATH_MAX in function copy_symlink(), to
account for the terminating null byte.

Resolves-Coverity-CID: 1296749
Signed-off-by: Vincent Stehlé <vincent.stehle@freescale.com>
---
 cmds-restore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index 8fc8b2a..a1445d4 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -863,7 +863,7 @@ static int copy_symlink(struct btrfs_root *root, struct btrfs_key *key,
 
 	len = btrfs_file_extent_inline_item_len(leaf,
 			btrfs_item_nr(path->slots[0]));
-	if (len > PATH_MAX) {
+	if (len >= PATH_MAX) {
 		fprintf(stderr, "Symlink '%s' target length %d is longer than PATH_MAX\n",
 				fs_name, len);
 		ret = -1;
-- 
2.5.3

