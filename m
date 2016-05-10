Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:57194 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbcEJM4h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2016 08:56:37 -0400
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@intel.com>
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@intel.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH] Btrfs: fix fspath error deallocation
Date: Tue, 10 May 2016 14:56:20 +0200
Message-Id: <1462884980-10052-1-git-send-email-vincent.stehle@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Make sure to deallocate fspath with vfree() in case of error in
init_ipath().

fspath is allocated with vmalloc() in init_data_container() since
commit 425d17a290c0 ("Btrfs: use larger limit for translation of logical to
inode").

Signed-off-by: Vincent Stehlé <vincent.stehle@intel.com>
Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: David Sterba <dsterba@suse.com>
---
 fs/btrfs/backref.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 80e8472..d309018 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1991,7 +1991,7 @@ struct inode_fs_paths *init_ipath(s32 total_bytes, struct btrfs_root *fs_root,
 
 	ifp = kmalloc(sizeof(*ifp), GFP_NOFS);
 	if (!ifp) {
-		kfree(fspath);
+		vfree(fspath);
 		return ERR_PTR(-ENOMEM);
 	}
 
-- 
2.8.0.rc3

