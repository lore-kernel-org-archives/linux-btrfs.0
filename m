From: Greg KH <gregkh@suse.de>
Subject: [063/111] Btrfs, fix memory leaks in error paths
Date: Wed, 11 Aug 2010 16:54:44 -0700
Message-ID: <20100811235501.341781170@clark.site>
References: <20100811235623.GA24440@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
	Jiri Slaby <jslaby@suse.cz>, linux-btrfs@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>,
	Jeff Mahoney <jeffm@suse.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100811235623.GA24440@kroah.com>
List-ID: <linux-btrfs.vger.kernel.org>

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit 2423fdfb96e3f9ff3baeb6c4c78d74145547891d upstream.

Stanse found 2 memory leaks in relocate_block_group and
__btrfs_map_block. cluster and multi are not freed/assigned on all
paths. Fix that.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: linux-btrfs@vger.kernel.org
Signed-off-by: Chris Mason <chris.mason@oracle.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 fs/btrfs/relocation.c |    4 +++-
 fs/btrfs/volumes.c    |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3281,8 +3281,10 @@ static noinline_for_stack int relocate_b
 		return -ENOMEM;
 
 	path = btrfs_alloc_path();
-	if (!path)
+	if (!path) {
+		kfree(cluster);
 		return -ENOMEM;
+	}
 
 	rc->extents_found = 0;
 	rc->extents_skipped = 0;
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2649,8 +2649,10 @@ again:
 	em = lookup_extent_mapping(em_tree, logical, *length);
 	read_unlock(&em_tree->lock);
 
-	if (!em && unplug_page)
+	if (!em && unplug_page) {
+		kfree(multi);
 		return 0;
+	}
 
 	if (!em) {
 		printk(KERN_CRIT "unable to find logical %llu len %llu\n",


