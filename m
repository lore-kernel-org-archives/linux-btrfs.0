From: liu weni <qingshenlwy@gmail.com>
Subject: [PATCH]btrfs: Remove a extra condition
Date: Wed, 6 Jan 2010 22:11:54 +0800
Message-ID: <b3657a101001060611k57407d6aj94f5931a2f0a5f33@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	zheng.yan@oracle.com, chris.mason@oracle.com,
	Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
	strongzgy <stro
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch remove a extra condition.
In this place, the outer is if (!cur || !uptodate)
and then, there are 2 ways: !cur or ! uptodate.
The "else if (!uptodate)" is not necessary.
I think "else" is better.

---
Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>

---
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index c4bc570..654f702 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -679,7 +679,7 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 			if (!cur) {
 				cur = read_tree_block(root, blocknr,
 							 blocksize, gen);
-			} else if (!uptodate) {
+			} else {
 				btrfs_read_buffer(cur, gen);
 			}
 		}
---

Best Regards,
Liuwenyi
20100107
