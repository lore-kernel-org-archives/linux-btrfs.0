From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: [PATCH] btrfs/ctree.c: remove the unnecessary 'return -1;' at the
 end of bin_search
Date: Fri, 30 Mar 2012 15:14:27 +0800
Message-ID: <4F755D53.1070102@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The code path should not reach there. Remove it.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/ctree.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 0639a55..c1be2da 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -829,20 +829,18 @@ static noinline int generic_bin_search(struct extent_buffer *eb,
 static int bin_search(struct extent_buffer *eb, struct btrfs_key *key,
 		      int level, int *slot)
 {
-	if (level == 0) {
+	if (level == 0)
 		return generic_bin_search(eb,
 					  offsetof(struct btrfs_leaf, items),
 					  sizeof(struct btrfs_item),
 					  key, btrfs_header_nritems(eb),
 					  slot);
-	} else {
+	else
 		return generic_bin_search(eb,
 					  offsetof(struct btrfs_node, ptrs),
 					  sizeof(struct btrfs_key_ptr),
 					  key, btrfs_header_nritems(eb),
 					  slot);
-	}
-	return -1;
 }
 
 int btrfs_bin_search(struct extent_buffer *eb, struct btrfs_key *key,
-- 
1.7.1



