Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60791 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964798AbcIWMBd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Sep 2016 08:01:33 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 93CF1AB9F
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Sep 2016 12:01:31 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: tests: uninline member definitions in free_space_extent
Date: Fri, 23 Sep 2016 13:59:28 +0200
Message-Id: <1474631968-31154-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The recommended way is to put all members on separate lines.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/tests/free-space-tree-tests.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tests/free-space-tree-tests.c b/fs/btrfs/tests/free-space-tree-tests.c
index 061b4d5315c4..6e144048a72e 100644
--- a/fs/btrfs/tests/free-space-tree-tests.c
+++ b/fs/btrfs/tests/free-space-tree-tests.c
@@ -24,7 +24,8 @@
 #include "../transaction.h"
 
 struct free_space_extent {
-	u64 start, length;
+	u64 start;
+	u64 length;
 };
 
 static int __check_free_space_extents(struct btrfs_trans_handle *trans,
-- 
2.7.1

