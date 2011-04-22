From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH V6 1/3] btrfs: fix wrong allocating flag when reading page
Date: Fri, 22 Apr 2011 18:12:19 +0800
Message-ID: <4DB15483.6050907@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>

the space cache use extent_readpages() to read free space information,
so we can not use GFP_KERNEL flag to allocate memory, or it may lead
to deadlock.

Signed-off-by: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 5ae0bff..0d1196d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2681,7 +2681,7 @@ int extent_readpages(struct extent_io_tree *tree,
 		prefetchw(&page->flags);
 		list_del(&page->lru);
 		if (!add_to_page_cache_lru(page, mapping,
-					page->index, GFP_KERNEL)) {
+					page->index, GFP_NOFS)) {
 			__extent_read_full_page(tree, page, get_extent,
 						&bio, 0, &bio_flags);
 		}
-- 
1.7.4
