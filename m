From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 03/18] btrfs: Calculate member variant's address directly
 for btrfs_set_##name
Date: Thu, 25 Mar 2010 20:28:51 +0800
Message-ID: <4BAB5703.2080104@cn.fujitsu.com>
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
index b0f80c0..4ec8055 100644
--- a/fs/btrfs/struct-funcs.c
+++ b/fs/btrfs/struct-funcs.c
@@ -86,13 +86,13 @@ void btrfs_set_##name(struct extent_buffer *eb,				\
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
-		p->member = cpu_to_le##bits(val);			\
+		p = (u##bits *)(eb->kaddr + offset - eb->map_start);	\
+		*p = cpu_to_le##bits(val);				\
 		return;							\
 	}								\
 	{								\
@@ -112,8 +112,8 @@ void btrfs_set_##name(struct extent_buffer *eb,				\
 			write_eb_member(eb, s, type, member, &val2);	\
 			return;						\
 		}							\
-		p = (type *)(kaddr + part_offset - map_start);		\
-		p->member = cpu_to_le##bits(val);			\
+		p = (u##bits *)(kaddr + offset - map_start);		\
+		*p = cpu_to_le##bits(val);				\
 		if (unmap_on_exit)					\
 			unmap_extent_buffer(eb, map_token, KM_USER1);	\
 	}								\
-- 
1.6.5.2


