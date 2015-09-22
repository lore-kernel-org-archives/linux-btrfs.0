Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38657 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933181AbbIVQ3d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 12:29:33 -0400
From: Luis de Bethencourt <luisbg@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: [PATCH 2/2] btrfs: reada: Fix returned errno code
Date: Tue, 22 Sep 2015 17:29:39 +0100
Message-Id: <c4a7a8023880c4a11326a6f7d9cc07ae37c12b0d.1442939007.git.luis@debethencourt.com>
In-Reply-To: <cover.1442939007.git.luis@debethencourt.com>
References: <cover.1442939007.git.luis@debethencourt.com>
In-Reply-To: <cover.1442939007.git.luis@debethencourt.com>
References: <cover.1442939007.git.luis@debethencourt.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

reada is using -1 instead of the -ENOMEM defined macro to specify that
a buffer allocation failed. Since the error number is propagated, the
caller will get a -EPERM which is the wrong error condition.

Smatch tool warning:
reada_add_block() warn: returning -1 instead of -ENOMEM is sloppy

Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
---
 fs/btrfs/reada.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 4645cd1..5bfd3cd 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -569,7 +569,7 @@ static int reada_add_block(struct reada_control *rc, u64 logical,
 	rec = kzalloc(sizeof(*rec), GFP_NOFS);
 	if (!rec) {
 		reada_extent_put(root->fs_info, re);
-		return -1;
+		return -ENOMEM;
 	}
 
 	rec->rc = rc;
-- 
2.5.3

