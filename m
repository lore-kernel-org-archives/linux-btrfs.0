Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:47184 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933324AbaLJVFo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 16:05:44 -0500
Received: from mail-in-10-z2.arcor-online.net (mail-in-10-z2.arcor-online.net [151.189.8.27])
	by mx.arcor.de (Postfix) with ESMTP id DE4C75A121
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 22:05:42 +0100 (CET)
From: mwilck@arcor.de
To: linux-btrfs@vger.kernel.org
Cc: mwilck@arcor.de
Subject: [PATCH 14/18] btrfs restore: report mismatch in file size
Date: Wed, 10 Dec 2014 21:51:44 +0100
Message-Id: <1418244708-7087-15-git-send-email-mwilck@arcor.de>
In-Reply-To: <1418244708-7087-1-git-send-email-mwilck@arcor.de>
References: <1418244708-7087-1-git-send-email-mwilck@arcor.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Martin Wilck <mwilck@arcor.de>

A mismatch between the file size stored in the inode and the
number of bytes restored may indicate a problem.
restore reads data in 4k chunks, so it's normal that files are
truncated. Only emit the warning in unusual cases.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 cmds-restore.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index 8ae3337..3c4dc7a 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -799,6 +799,12 @@ set_size:
 				file);
 	}
 
+	if (st.st_size != _INVALID_SIZE && (st.st_size > next_pos || 
+					    (st.st_size < next_pos &&
+					     (st.st_size >> 12) !=
+					     (next_pos >> 12) - 1)))
+		fprintf(stderr, "size mismatch: extpected %llu, got %llu (written %llu)\n",
+			st.st_size, next_pos, total_written);	
 	set_fd_attrs(fd, &st, file);
 	return ret;
 }
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
