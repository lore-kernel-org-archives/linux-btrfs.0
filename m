Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45008 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727481AbeGQGqe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 02:46:34 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CE4D1ADAB
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jul 2018 06:15:37 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs-progs: completion: Let dump-tree/dump-super/inode-resolve to accept any file
Date: Tue, 17 Jul 2018 14:15:32 +0800
Message-Id: <20180717061532.11857-3-wqu@suse.com>
In-Reply-To: <20180717061532.11857-1-wqu@suse.com>
References: <20180717061532.11857-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For dump-tree/dump-super the completion uses default filedir -d, which
is far from convenient.
Use filedir for dump-tree/dump-super/inode-resolve just like rootid.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 btrfs-completion | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/btrfs-completion b/btrfs-completion
index 33830e827977..b22a951b3a65 100644
--- a/btrfs-completion
+++ b/btrfs-completion
@@ -133,7 +133,7 @@ _btrfs()
 						_btrfs_mnts
 						return 0
 						;;
-					rootid)
+					dump-tree|dump-super|rootid|inode-resolve)
 						_filedir
 						return 0
 						;;
-- 
2.18.0

