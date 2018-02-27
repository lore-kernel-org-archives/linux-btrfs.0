Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35010 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753225AbeB0OvN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Feb 2018 09:51:13 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4C5D5ACED
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Feb 2018 14:51:12 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/4] btrfs: drop extern from function declarations
Date: Tue, 27 Feb 2018 15:48:54 +0100
Message-Id: <10d174a9a051e01014c80728f8102bfa0289bd3c.1519742886.git.dsterba@suse.com>
In-Reply-To: <cover.1519742886.git.dsterba@suse.com>
References: <cover.1519742886.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Extern for functions does not make any difference, there are only a few
so let's remove them before it's too late.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.h | 4 ++--
 fs/btrfs/xattr.h     | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index a7a850abd600..226c4876ddf8 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -83,8 +83,8 @@ static inline int le_test_bit(int nr, const u8 *addr)
 	return 1U & (addr[BIT_BYTE(nr)] >> (nr & (BITS_PER_BYTE-1)));
 }
 
-extern void le_bitmap_set(u8 *map, unsigned int start, int len);
-extern void le_bitmap_clear(u8 *map, unsigned int start, int len);
+void le_bitmap_set(u8 *map, unsigned int start, int len);
+void le_bitmap_clear(u8 *map, unsigned int start, int len);
 
 struct extent_state;
 struct btrfs_root;
diff --git a/fs/btrfs/xattr.h b/fs/btrfs/xattr.h
index 3c227c549dfc..96e6f3a304d3 100644
--- a/fs/btrfs/xattr.h
+++ b/fs/btrfs/xattr.h
@@ -23,13 +23,13 @@
 
 extern const struct xattr_handler *btrfs_xattr_handlers[];
 
-extern ssize_t btrfs_getxattr(struct inode *inode, const char *name,
+ssize_t btrfs_getxattr(struct inode *inode, const char *name,
 		void *buffer, size_t size);
-extern int btrfs_setxattr(struct btrfs_trans_handle *trans,
+int btrfs_setxattr(struct btrfs_trans_handle *trans,
 			    struct inode *inode, const char *name,
 			    const void *value, size_t size, int flags);
 
-extern int btrfs_xattr_security_init(struct btrfs_trans_handle *trans,
+int btrfs_xattr_security_init(struct btrfs_trans_handle *trans,
 				     struct inode *inode, struct inode *dir,
 				     const struct qstr *qstr);
 
-- 
2.16.2

