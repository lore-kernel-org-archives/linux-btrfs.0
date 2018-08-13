Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59382 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726345AbeHMInh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Aug 2018 04:43:37 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2C57CAE4F
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Aug 2018 06:02:54 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/2] btrfs-progs: completion: Let dump-tree/dump-super/inode-resolve to accept any file
Date: Mon, 13 Aug 2018 14:02:44 +0800
Message-Id: <20180813060244.8795-3-wqu@suse.com>
In-Reply-To: <20180813060244.8795-1-wqu@suse.com>
References: <20180813060244.8795-1-wqu@suse.com>
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
index b7628e6984c5..6ae57d1b752b 100644
--- a/btrfs-completion
+++ b/btrfs-completion
@@ -128,7 +128,7 @@ _btrfs()
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
