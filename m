From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH] Btrfs: fix uninit warning in backref.c
Date: Thu, 19 Jan 2012 11:24:35 +0100
Message-ID: <1326968675-12294-1-git-send-email-list.btrfs@jan-o-sch.net>
References: <20120119100935.82c5ec6db156f3799835163f@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	sensille@gmx.net, torvalds@linux-foundation.org
To: sfr@canb.auug.org.au, chris.mason@oracle.com,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120119100935.82c5ec6db156f3799835163f@canb.auug.org.au>
List-ID: <linux-btrfs.vger.kernel.org>

Added initialization with the declaration of ret. It isn't set later on the
switch-default branch (which should never be taken).

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/backref.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index b9a8432..633c701 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -297,7 +297,7 @@ static int __add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
 	struct btrfs_delayed_extent_op *extent_op = head->extent_op;
 	struct rb_node *n = &head->node.rb_node;
 	int sgn;
-	int ret;
+	int ret = 0;
 
 	if (extent_op && extent_op->update_key)
 		btrfs_disk_key_to_cpu(info_key, &extent_op->key);
@@ -392,7 +392,7 @@ static int __add_inline_refs(struct btrfs_fs_info *fs_info,
 			     struct btrfs_key *info_key, int *info_level,
 			     struct list_head *prefs)
 {
-	int ret;
+	int ret = 0;
 	int slot;
 	struct extent_buffer *leaf;
 	struct btrfs_key key;
-- 
1.7.3.4

