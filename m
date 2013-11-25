Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:59249 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab3KYDWO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Nov 2013 22:22:14 -0500
Received: by mail-wg0-f43.google.com with SMTP id k14so717426wgh.10
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Nov 2013 19:22:14 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: fix extent boundary check in bio_readpage_error
Date: Mon, 25 Nov 2013 03:22:07 +0000
Message-Id: <1385349727-982-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/extent_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index dfb528d..cb9ce69 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2166,7 +2166,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 			return -EIO;
 		}
 
-		if (em->start > start || em->start + em->len < start) {
+		if (em->start > start || em->start + em->len <= start) {
 			free_extent_map(em);
 			em = NULL;
 		}
-- 
1.7.9.5

