Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41429 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751821AbdLAJTw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Dec 2017 04:19:52 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 76657AD48
        for <linux-btrfs@vger.kernel.org>; Fri,  1 Dec 2017 09:19:51 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/5] btrfs: Remove dead code
Date: Fri,  1 Dec 2017 11:19:41 +0200
Message-Id: <1512119984-12708-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1512119984-12708-1-git-send-email-nborisov@suse.com>
References: <1512119984-12708-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

'clear' is always set to 0 (BTRFS_FEATURE_COMPAT_SAFE_CLEAR,
BTRFS_FEATURE_COMPAT_RO_SAFE_CLEAR and BTRFS_FEATURE_INCOMPAT_SAFE_CLEAR are
all defined to 0). So remove the code that logically can never execute.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/sysfs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index a8bafed931f4..37dbf2fccedc 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -84,8 +84,6 @@ static int can_modify_feature(struct btrfs_feature_attr *fa)
 
 	if (set & fa->feature_bit)
 		val |= 1;
-	if (clear & fa->feature_bit)
-		val |= 2;
 
 	return val;
 }
-- 
2.7.4

