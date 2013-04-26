Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37326 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986Ab3DZVGP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Apr 2013 17:06:15 -0400
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 8/9] Btrfs-progs: remove the unnecessary 'return -1;' at the end of bin_search
Date: Fri, 26 Apr 2013 16:06:09 -0500
Message-Id: <1367010370-21571-9-git-send-email-sandeen@redhat.com>
In-Reply-To: <1367010370-21571-1-git-send-email-sandeen@redhat.com>
References: <1367010370-21571-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The code path should not reach there. Remove it.

[Eric Sandeen: port kernel commit 3fed40c to userspace]

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 ctree.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/ctree.c b/ctree.c
index b7b12a3..7257e6f 100644
--- a/ctree.c
+++ b/ctree.c
@@ -579,20 +579,18 @@ static int generic_bin_search(struct extent_buffer *eb, unsigned long p,
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
 
 static noinline struct extent_buffer *read_node_slot(struct btrfs_root *root,
-- 
1.7.1

