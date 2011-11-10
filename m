From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 6/6] Btrfs: fix orphan backref nodes
Date: Thu, 10 Nov 2011 14:31:27 +0800
Message-ID: <4EBB6FBF.8080400@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If the root node of a fs/file tree is in the block group that is
being relocated, but the others are not in the other block groups.
when we create a snapshot for this tree between the relocation tree
creation ends and ->create_reloc_tree is set to 0, Btrfs will create
some backref nodes that are the lowest nodes of the backrefs cache.
But we forget to add them into ->leaves list of the backref cache
and deal with them, and at last, they will triggered BUG_ON().

  kernel BUG at fs/btrfs/relocation.c:239!

This patch fixes it by adding them into ->leaves list of backref cache.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/relocation.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 162af18..1db3771 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1174,6 +1174,8 @@ static int clone_backref_node(struct btrfs_trans_handle *trans,
 			list_add_tail(&new_edge->list[UPPER],
 				      &new_node->lower);
 		}
+	} else {
+		list_add_tail(&new_node->lower, &cache->leaves);
 	}
 
 	rb_node = tree_insert(&cache->rb_root, new_node->bytenr,
-- 
1.7.6.4
