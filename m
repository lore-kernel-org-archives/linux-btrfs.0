Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54378 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbbKPPxL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Nov 2015 10:53:11 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 79D87AABB
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 15:52:47 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: fix clashing number of the enhanced balance usage filter
Date: Mon, 16 Nov 2015 16:50:13 +0100
Message-Id: <1447689013-26385-1-git-send-email-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've accidentally picked an already used number for the enhanced usage
filter represented by BTRFS_BALANCE_ARGS_USAGE_RANGE, clashing with
BTRFS_BALANCE_ARGS_CONVERT. Introduced during the development phase,
no backward compatibility issues.

Reported-by: Holger Hoffstätte <holger.hoffstaette@googlemail.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: bc3094673f22 ("btrfs: extend balance filter usage to take minimum and maximum")
Signed-off-by: David Sterba <dsterba@suse.com>
---

For 4.4-rc

 fs/btrfs/volumes.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index ec5712372732..d5c84f6b1353 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -382,7 +382,7 @@ struct map_lookup {
 #define BTRFS_BALANCE_ARGS_LIMIT	(1ULL << 5)
 #define BTRFS_BALANCE_ARGS_LIMIT_RANGE	(1ULL << 6)
 #define BTRFS_BALANCE_ARGS_STRIPES_RANGE (1ULL << 7)
-#define BTRFS_BALANCE_ARGS_USAGE_RANGE	(1ULL << 8)
+#define BTRFS_BALANCE_ARGS_USAGE_RANGE	(1ULL << 10)
 
 #define BTRFS_BALANCE_ARGS_MASK			\
 	(BTRFS_BALANCE_ARGS_PROFILES |		\
-- 
2.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
