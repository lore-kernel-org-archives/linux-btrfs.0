From: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: silence warning in raid array setup
Date: Fri,  6 Jan 2012 16:18:53 +0100
Message-ID: <1325863133-31460-1-git-send-email-dsterba@suse.cz>
Cc: chris.mason@oracle.com, David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Raid array setup code creates an extent buffer in an usual way. When the
PAGE_CACHE_SIZE is > super block size, the extent pages are not marked
up-to-date, which triggers a WARN_ON in the following
write_extent_buffer call. Add an explicit SetPageUptodate call to
silence the warning.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/volumes.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f4b839f..732ccc6 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3699,6 +3699,20 @@ int btrfs_read_sys_array(struct btrfs_root *root)
 		return -ENOMEM;
 	btrfs_set_buffer_uptodate(sb);
 	btrfs_set_buffer_lockdep_class(root->root_key.objectid, sb, 0);
+	/*
+	 * The sb extent buffer is artifical and just used to read the system array.
+	 * btrfs_set_buffer_uptodate() call does not properly mark all it's
+	 * pages up-to-date when the page is larger: extent does not cover the
+	 * whole page and consequently check_page_uptodate does not find all
+	 * the page's extents up-to-date (the hole beyond sb),
+	 * write_extent_buffer then triggers a WARN_ON.
+	 *
+	 * Regular short extents go through mark_extent_buffer_dirty/writeback cycle,
+	 * but sb spans only this function. Add an explicit SetPageUptodate call
+	 * to silence the warning eg. on PowerPC 64.
+	 */
+	if (PAGE_CACHE_SIZE > BTRFS_SUPER_INFO_SIZE)
+		SetPageUptodate(extent_buffer_page(sb, 0));
 
 	write_extent_buffer(sb, super_copy, 0, BTRFS_SUPER_INFO_SIZE);
 	array_size = btrfs_super_sys_array_size(super_copy);
-- 
1.7.8

