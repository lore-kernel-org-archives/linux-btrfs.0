Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:41340 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933318AbaLJVFn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 16:05:43 -0500
Received: from mail-in-11-z2.arcor-online.net (mail-in-11-z2.arcor-online.net [151.189.8.28])
	by mx.arcor.de (Postfix) with ESMTP id C782D302D6
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 22:05:41 +0100 (CET)
From: mwilck@arcor.de
To: linux-btrfs@vger.kernel.org
Cc: mwilck@arcor.de
Subject: [PATCH 10/18] btrfs restore: hide "offset is X" messages
Date: Wed, 10 Dec 2014 21:51:40 +0100
Message-Id: <1418244708-7087-11-git-send-email-mwilck@arcor.de>
In-Reply-To: <1418244708-7087-1-git-send-email-mwilck@arcor.de>
References: <1418244708-7087-1-git-send-email-mwilck@arcor.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Martin Wilck <mwilck@arcor.de>

Almost everyone who cares about her data will run btrfs restore
with -v. The "offset is" messages displayed will irritate users
because they reveal only btrfs internals. Users will think that
"offset" refers to a file offset and suspect severe corruption.

Limit these messages to verbose > 1.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 cmds-restore.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index 10bb8be..f1c63ed 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -315,7 +315,7 @@ static int copy_one_extent(struct btrfs_root *root, int fd,
 	if (compress == BTRFS_COMPRESS_NONE)
 		bytenr += offset;
 
-	if (verbose && offset)
+	if (verbose > 1 && offset)
 		printf("offset is %Lu\n", offset);
 	/* we found a hole */
 	if (disk_size == 0)
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
