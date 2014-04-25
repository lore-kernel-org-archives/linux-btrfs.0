Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.zhinst.com ([212.126.164.98]:44030 "EHLO mail.zhinst.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966AbaDYNDQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Apr 2014 09:03:16 -0400
From: Tobias Klauser <tklauser@distanz.ch>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: Remove unnecessary check for NULL
Date: Fri, 25 Apr 2014 14:58:05 +0200
Message-Id: <1398430685-15395-1-git-send-email-tklauser@distanz.ch>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

iput() already checks for the inode being NULL, thus it's unnecessary to
check before calling.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 fs/btrfs/scrub.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 0be7799..bd850b5 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -717,8 +717,8 @@ static int scrub_fixup_readpage(u64 inum, u64 offset, u64 root, void *fixup_ctx)
 out:
 	if (page)
 		put_page(page);
-	if (inode)
-		iput(inode);
+
+	iput(inode);
 
 	if (ret < 0)
 		return ret;
-- 
1.7.9.5


