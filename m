From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] make tree_search_offset more flexible in its searching
Date: Thu, 9 Oct 2008 16:10:45 -0400
Message-ID: <20081009201044.GB19500@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Sometimes we end up freeing a reserved extent because we don't need it, however
this means that its possible for transaction->last_alloc to point to the middle
of a free area.  When we search for free space in find_free_space we do a
tree_search_offset with contains set to 0, because we want it to find the next
best free area if we do not have an offset starting on the given offset.
Unfortunately that currently means that if the offset we were given as a hint
points to the middle of a free area, we won't find anything.  This is especially
bad if we happened to last allocate from the big huge chunk of a newly formed
block group, since we won't find anything and have to go back and search the
long way around.  This fixes this problem by making it so that we return the
free space area regardless of the contains variable.  This made cache missing
happen _alot_ less, and speeds things up considerably.  Going ahead and sending
this out now since I'm tackling the alloc_mutex thing and that could take me a
while.  Thank you,

Signed-off-by: Josef Bacik <jbacik@redhat.com>


Index: root/btrfs-unstable/fs/btrfs/free-space-cache.c
===================================================================
--- root.orig/btrfs-unstable/fs/btrfs/free-space-cache.c
+++ root/btrfs-unstable/fs/btrfs/free-space-cache.c
@@ -90,8 +90,8 @@ static struct btrfs_free_space *tree_sea
 				ret = entry;
 			n = n->rb_left;
 		} else if (offset > entry->offset) {
-			if (contains &&
-			    (entry->offset + entry->bytes - 1) >= offset) {
+			if ((entry->offset + entry->bytes - 1) >= offset &&
+			    bytes <= entry->bytes) {
 				ret = entry;
 				break;
 			}
