Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59318 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbcC3Uxv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Mar 2016 16:53:51 -0400
From: Luis de Bethencourt <luisbg@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: [PATCH 2/2] btrfs: avoid overflowing f_bfree
Date: Wed, 30 Mar 2016 21:53:39 +0100
Message-Id: <1459371219-1815-2-git-send-email-luisbg@osg.samsung.com>
In-Reply-To: <1459371219-1815-1-git-send-email-luisbg@osg.samsung.com>
References: <1459371219-1815-1-git-send-email-luisbg@osg.samsung.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since mixed block groups accounting isn't byte-accurate and f_bree is an
unsigned integer, it could overflow. Avoid this.

Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
Suggested-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/super.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index bdca79c..93376d0 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2101,6 +2101,11 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	/* Account global block reserve as used, it's in logical size already */
 	spin_lock(&block_rsv->lock);
 	buf->f_bfree -= block_rsv->size >> bits;
+	/* Mixed block groups accounting is not byte-accurate, avoid overflow */
+	if (buf->f_bfree >= block_rsv->size >> bits)
+		buf->f_bfree -= block_rsv->size >> bits;
+	else
+		buf->f_bfree = 0;
 	spin_unlock(&block_rsv->lock);
 
 	buf->f_bavail = div_u64(total_free_data, factor);
-- 
2.5.3

