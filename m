From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] Btrfs: use plain page_address() in header fields setget functions
Date: Wed, 03 Aug 2011 16:11:41 +0800
Message-ID: <4E3902BD.2090801@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We've stopped using highmem for extent buffers.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ctree.h |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 365c4e1..746e6b4 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1415,17 +1415,15 @@ void btrfs_set_##name(struct extent_buffer *eb, type *s, u##bits val);
 #define BTRFS_SETGET_HEADER_FUNCS(name, type, member, bits)		\
 static inline u##bits btrfs_##name(struct extent_buffer *eb)		\
 {									\
-	type *p = kmap_atomic(eb->first_page, KM_USER0);		\
+	type *p = page_address(eb->first_page);				\
 	u##bits res = le##bits##_to_cpu(p->member);			\
-	kunmap_atomic(p, KM_USER0);					\
 	return res;							\
 }									\
 static inline void btrfs_set_##name(struct extent_buffer *eb,		\
 				    u##bits val)			\
 {									\
-	type *p = kmap_atomic(eb->first_page, KM_USER0);		\
+	type *p = page_address(eb->first_page);				\
 	p->member = cpu_to_le##bits(val);				\
-	kunmap_atomic(p, KM_USER0);					\
 }
 
 #define BTRFS_SETGET_STACK_FUNCS(name, type, member, bits)		\
-- 
1.7.3.1
