Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60551 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752101AbdATTEE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jan 2017 14:04:04 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B75D2AB5D
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Jan 2017 19:04:01 +0000 (UTC)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH] btrfs-progs: sanitize - Use correct source for memcpy
Date: Fri, 20 Jan 2017 13:03:33 -0600
Message-Id: <20170120190333.17737-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

While performing a memcpy, we are copying from uninitialized dst
as opposed to src->data. Though using eb->len is correct, I used
src->len to make it more readable.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 image/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/image/main.c b/image/main.c
index 58dcecb..0158844 100644
--- a/image/main.c
+++ b/image/main.c
@@ -550,7 +550,7 @@ static void sanitize_name(struct metadump_struct *md, u8 *dst,
 		return;
 	}
 
-	memcpy(eb->data, dst, eb->len);
+	memcpy(eb->data, src->data, src->len);
 
 	switch (key->type) {
 	case BTRFS_DIR_ITEM_KEY:
-- 
2.10.2

