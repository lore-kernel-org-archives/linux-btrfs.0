Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.68.134.40.188.clients.your-server.de ([188.40.134.68]:33643
	"EHLO mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834AbbK0QcG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Nov 2015 11:32:06 -0500
Received: from tux.wizards.de (p4FF582A1.dip0.t-ipconnect.de [79.245.130.161])
	by mail02.iobjects.de (Postfix) with ESMTPSA id 1696A4160151
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2015 17:32:05 +0100 (CET)
Received: from [192.168.100.223] (ragnarok [192.168.100.223])
	by tux.wizards.de (Postfix) with ESMTP id A78A411C01DE
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2015 17:32:04 +0100 (CET)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: [PATCH] btrfs: fix misleading warning when space cache failed to load
Message-ID: <56588584.3030705@googlemail.com>
Date: Fri, 27 Nov 2015 17:32:04 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When an inconsistent space cache is detected during loading we log a
warning that users frequently mistake as instruction to invalidate the
cache manually, even though this is not required. Fix the message to
indicate that the cache will be rebuilt automatically.

Signed-off-by: Holger Hoffstätte <holger.hoffstaette@googlemail.com>
---
 fs/btrfs/free-space-cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 0948d34..7a91770 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -891,7 +891,7 @@ out:
 		spin_unlock(&block_group->lock);
 		ret = 0;
 
-		btrfs_warn(fs_info, "failed to load free space cache for block group %llu, rebuild it now",
+		btrfs_warn(fs_info, "failed to load free space cache for block group %llu, rebuilding it now",
 			block_group->key.objectid);
 	}
 
-- 
2.6.3
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
