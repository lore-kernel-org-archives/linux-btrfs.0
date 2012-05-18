Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965579Ab2ERR0w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 May 2012 13:26:52 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q4IHQqFJ027577
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 18 May 2012 13:26:52 -0400
Received: from localhost.localdomain.com (vpn-10-171.rdu.redhat.com [10.11.10.171])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q4IHQpJx001990
	for <linux-btrfs@vger.kernel.org>; Fri, 18 May 2012 13:26:52 -0400
From: Josef Bacik <josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: merge contigous regions when loading free space cache
Date: Fri, 18 May 2012 13:26:50 -0400
Message-Id: <1337362010-9281-1-git-send-email-josef@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we write out the free space cache we will write out everything that is
in our in memory tree, and then we will just walk the pinned extents tree
and write anything we see there.  The problem with this is that during
normal operations the pinned extents will be merged back into the free space
tree normally, and then we can allocate space from the merged areas and
commit them to the tree log.  If we crash and replay the tree log we will
crash again because the tree log will try to free up space from what looks
like 2 seperate but contiguous entries, since one entry is from the original
free space cache and the other was a pinned extent that was merged back.  To
fix this we just need to walk the free space tree after we load it and merge
contiguous entries back together.  This will keep the tree log stuff from
breaking and it will make the allocator behave more nicely.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/free-space-cache.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index cecf8df..19a0d85 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -33,6 +33,8 @@
 
 static int link_free_space(struct btrfs_free_space_ctl *ctl,
 			   struct btrfs_free_space *info);
+static void unlink_free_space(struct btrfs_free_space_ctl *ctl,
+			      struct btrfs_free_space *info);
 
 static struct inode *__lookup_free_space_inode(struct btrfs_root *root,
 					       struct btrfs_path *path,
@@ -584,6 +586,44 @@ static int io_ctl_read_bitmap(struct io_ctl *io_ctl,
 	return 0;
 }
 
+/*
+ * Since we attach pinned extents after the fact we can have contiguous sections
+ * of free space that are split up in entries.  This poses a problem with the
+ * tree logging stuff since it could have allocated across what appears to be 2
+ * entries since we would have merged the entries when adding the pinned extents
+ * back to the free space cache.  So run through the space cache that we just
+ * loaded and merge contiguous entries.  This will make the log replay stuff not
+ * blow up and it will make for nicer allocator behavior.
+ */
+static void merge_space_tree(struct btrfs_free_space_ctl *ctl)
+{
+	struct btrfs_free_space *e, *prev = NULL;
+	struct rb_node *n;
+
+again:
+	spin_lock(&ctl->tree_lock);
+	for (n = rb_first(&ctl->free_space_offset); n; n = rb_next(n)) {
+		e = rb_entry(n, struct btrfs_free_space, offset_index);
+		if (!prev)
+			goto next;
+		if (e->bitmap || prev->bitmap)
+			goto next;
+		if (prev->offset + prev->bytes == e->offset) {
+			unlink_free_space(ctl, prev);
+			unlink_free_space(ctl, e);
+			prev->bytes += e->bytes;
+			kmem_cache_free(btrfs_free_space_cachep, e);
+			link_free_space(ctl, prev);
+			prev = NULL;
+			spin_unlock(&ctl->tree_lock);
+			goto again;
+		}
+next:
+		prev = e;
+	}
+	spin_unlock(&ctl->tree_lock);
+}
+
 int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 			    struct btrfs_free_space_ctl *ctl,
 			    struct btrfs_path *path, u64 offset)
@@ -726,6 +766,7 @@ int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 	}
 
 	io_ctl_drop_pages(&io_ctl);
+	merge_space_tree(ctl);
 	ret = 1;
 out:
 	io_ctl_free(&io_ctl);
-- 
1.7.7.6

