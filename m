From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 7/7] btrfs: fix a wrong error check in add_ra_bio_pages()
Date: Thu, 29 Jul 2010 16:32:21 +0800
Message-ID: <4C513C95.3080403@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	Yan Zheng <zheng.yan@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Liu Bo <liubo2009@cn.fujitsu.com>

Only when a page is not found by page_index, we'll go to the error check.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/compression.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index cb3877c..8458840 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -467,7 +467,7 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 		rcu_read_lock();
 		page = radix_tree_lookup(&mapping->page_tree, page_index);
 		rcu_read_unlock();
-		if (page) {
+		if (!page) {
 check_misses:
 			misses++;
 			if (misses > 4)
-- 
1.7.0.1
