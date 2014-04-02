Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46879 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932263AbaDBRNB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Apr 2014 13:13:01 -0400
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>,
        Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] btrfs: fix reversed warning condition in btrfs_delayed_inode_reserve_metadata
Date: Wed,  2 Apr 2014 19:13:00 +0200
Message-Id: <1396458780-10923-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit fae7f21cece9a4c181 ("btrfs: Use WARN_ON()'s return value in place of
WARN_ON(1)") cleaned up WARN_ON usage and in one place reversed the condition
that led to loads of warnings that were not supposed to occur.

WARN_ON will trigger because it sees 'ret' though in the previous code
did not reach the WARN_ON below. The correct pattern is

-       if (condition)
+       if (WARN_ON(condition))

CC: Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>
CC: <stable@vger.kernel.org> # 3.13
Reported-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/delayed-inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 451b00c86f6c..098af20abd88 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -649,7 +649,7 @@ static int btrfs_delayed_inode_reserve_metadata(
 			goto out;
 
 		ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes);
-		if (!WARN_ON(ret))
+		if (WARN_ON(!ret))
 			goto out;
 
 		/*
-- 
1.9.0

