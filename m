From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 09/18] btrfs: Fix return value of read_extent_buffer_pages()
 when lock page failed
Date: Thu, 25 Mar 2010 20:33:27 +0800
Message-ID: <4BAB5817.8020803@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

read_extent_buffer_pages() should return error value instead of 0 when
lock page failed, we fix this problem.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index bdfbfa6..3194c79 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3419,8 +3419,10 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 	for (i = start_i; i < num_pages; i++) {
 		page = extent_buffer_page(eb, i);
 		if (!wait) {
-			if (!trylock_page(page))
+			if (!trylock_page(page)) {
+				ret = -EIO;
 				goto unlock_exit;
+			}
 		} else {
 			lock_page(page);
 		}
-- 
1.6.5.2


