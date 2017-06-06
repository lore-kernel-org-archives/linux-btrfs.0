Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:35893 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750766AbdFFXpn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Jun 2017 19:45:43 -0400
Received: by mail-pg0-f54.google.com with SMTP id a70so32458029pge.3
        for <linux-btrfs@vger.kernel.org>; Tue, 06 Jun 2017 16:45:43 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>, Liu Bo <bo.li.liu@oracle.com>,
        kernel-team@fb.com
Subject: [PATCH 2/7] Btrfs: make BUG_ON() in add_pinned_bytes() an ASSERT()
Date: Tue,  6 Jun 2017 16:45:27 -0700
Message-Id: <5e543709c942292f3e97cbd22fd3137dd521bb16.1496792333.git.osandov@fb.com>
In-Reply-To: <cover.1496792333.git.osandov@fb.com>
References: <cover.1496792333.git.osandov@fb.com>
In-Reply-To: <cover.1496792333.git.osandov@fb.com>
References: <cover.1496792333.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/extent-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7c01b4e9e3b6..6032e9a635f2 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -782,7 +782,7 @@ static void add_pinned_bytes(struct btrfs_fs_info *fs_info, s64 num_bytes,
 	}
 
 	space_info = __find_space_info(fs_info, flags);
-	BUG_ON(!space_info); /* Logic bug */
+	ASSERT(space_info);
 	percpu_counter_add(&space_info->total_bytes_pinned, num_bytes);
 }
 
-- 
2.13.0

