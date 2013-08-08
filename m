Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.137]:14719 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965026Ab3HHKvl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Aug 2013 06:51:41 -0400
Received: from pizpot.store ([192.168.43.236])
 by joses.store (RZmta 31.37 OK) with ESMTP id 600811p789DFhe
 for <linux-btrfs@vger.kernel.org>;
 Thu, 8 Aug 2013 12:51:39 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: fix a regression in mkfs.btrfs
Date: Thu,  8 Aug 2013 12:51:39 +0200
Message-Id: <1375959099-30488-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 55061a98 adds a cut & paste error that makes mkfs.btrfs fail
if leafsize != sectorsize.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils.c b/utils.c
index 15b991f..691b075 100644
--- a/utils.c
+++ b/utils.c
@@ -430,7 +430,7 @@ int make_btrfs(int fd, const char *device, const char *label,
 	ret = pwrite(fd, buf->data, sectorsize, blocks[0]);
 	if (ret < 0)
 		return -errno;
-	else if (ret != leafsize)
+	else if (ret != sectorsize)
 		return -EIO;
 
 	free(buf);
-- 
1.8.3.4

