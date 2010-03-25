From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 02/18] btrfs: Calculate member variant's address directly
 for btrfs_##name
Date: Thu, 25 Mar 2010 20:28:18 +0800
Message-ID: <4BAB56E2.6050809@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

It can decrease a additional address calculation and increase little speed.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/struct-funcs.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/struct-funcs.c b/fs/btrfs/struct-funcs.c
index c0f7eca..b0f80c0 100644
--- a/fs/btrfs/struct-funcs.c
+++ b/fs/btrfs/struct-funcs.c
@@ -49,13 +49,13 @@ u##bits btrfs_##name(struct extent_buffer *eb,				\
 {									\
 	unsigned long part_offset = (unsigned long)s;			\
 	unsigned long offset = part_offset + offsetof(type, member);	\
-	type *p;							\
+	u##bits *p;							\
 	/* ugly, but we want the fast path here */			\
 	if (eb->map_token && offset >= eb->map_start &&			\
 	    offset + sizeof(((type *)0)->member) <= eb->map_start +	\
 	    eb->map_len) {						\
-		p = (type *)(eb->kaddr + part_offset - eb->map_start);	\
-		return le##bits##_to_cpu(p->member);			\
+		p = (u##bits *)(eb->kaddr + offset - eb->map_start);	\
+		return le##bits##_to_cpu(*p);				\
 	}								\
 	{								\
 		int err;						\
@@ -74,8 +74,8 @@ u##bits btrfs_##name(struct extent_buffer *eb,				\
 			read_eb_member(eb, s, type, member, &leres);	\
 			return le##bits##_to_cpu(leres);		\
 		}							\
-		p = (type *)(kaddr + part_offset - map_start);		\
-		res = le##bits##_to_cpu(p->member);			\
+		p = (u##bits *)(kaddr + offset - map_start);		\
+		res = le##bits##_to_cpu(*p);				\
 		if (unmap_on_exit)					\
 			unmap_extent_buffer(eb, map_token, KM_USER1);	\
 		return res;						\
-- 
1.6.5.2


