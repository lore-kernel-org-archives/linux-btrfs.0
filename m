Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45672 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389634AbeIUSPS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Sep 2018 14:15:18 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 43788ACB4
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Sep 2018 12:26:38 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: use common helper instead of open coding a bit test
Date: Fri, 21 Sep 2018 14:26:34 +0200
Message-Id: <20180921122634.12138-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The helper does the same math and we take care about the special case
when flags is 0 too.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 909c578506ee..26eb388db343 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3691,7 +3691,7 @@ static int alloc_profile_is_valid(u64 flags, int extended)
 		return !extended; /* "0" is valid for usual profiles */
 
 	/* true if exactly one bit set */
-	return (flags & (flags - 1)) == 0;
+	return is_power_of_2(flags);
 }
 
 static inline int balance_need_close(struct btrfs_fs_info *fs_info)
-- 
2.18.0
