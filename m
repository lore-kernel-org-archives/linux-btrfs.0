From: Chris Ball <cjb@laptop.org>
Subject: [review] Btrfs: Allow shrinking close to used space
Date: Wed, 25 Feb 2009 14:13:10 -0500
Message-ID: <m34oyixrcp.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

This patch (against experimental HEAD) attempts to make shrinking more
robust, by only updating device size if we've succeeded in creating
enough free space without any failures in btrfs_relocate_chunk().

Here's a log with my patch applied.  The two things to note are that a
near-limit shrink now works, and that a failed shrink (in this case,
trying to shrink to less than the used space) no longer updates the
device size erroneously:

  http://dev.laptop.org/~cjb/btrfs/shrink-log

Please review carefully -- I'm still new to btrfs.  The short version of
the patch is:

* create a success path, as a break out of the while(1) relocating
  (rather than going to the "done" label).
* move the device size updating code into that path
* leave "path->reada = 2;" behind in the entry path, since path is
  used by the searching operation rather than the later resize.

Thanks!

Signed-off-by: Chris Ball <cjb@laptop.org>

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1316139..e2fa072 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1815,30 +1815,8 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 	if (!path)
 		return -ENOMEM;
 
-	trans = btrfs_start_transaction(root, 1);
-	if (!trans) {
-		ret = -ENOMEM;
-		goto done;
-	}
-
 	path->reada = 2;
 
-	lock_chunks(root);
-
-	device->total_bytes = new_size;
-	if (device->writeable)
-		device->fs_devices->total_rw_bytes -= diff;
-	ret = btrfs_update_device(trans, device);
-	if (ret) {
-		unlock_chunks(root);
-		btrfs_end_transaction(trans, root);
-		goto done;
-	}
-	WARN_ON(diff > old_total);
-	btrfs_set_super_total_bytes(super_copy, old_total - diff);
-	unlock_chunks(root);
-	btrfs_end_transaction(trans, root);
-
 	key.objectid = device->devid;
 	key.offset = (u64)-1;
 	key.type = BTRFS_DEV_EXTENT_KEY;
@@ -1867,7 +1845,7 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 		length = btrfs_dev_extent_length(l, dev_extent);
 
 		if (key.offset + length <= new_size)
-			goto done;
+			break;
 
 		chunk_tree = btrfs_dev_extent_chunk_tree(l, dev_extent);
 		chunk_objectid = btrfs_dev_extent_chunk_objectid(l, dev_extent);
@@ -1880,6 +1858,31 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 			goto done;
 	}
 
+	/*
+	 * We've succeeded in freeing up enough space and can now update
+	 * the device's size.
+	 */
+	trans = btrfs_start_transaction(root, 1);
+	if (!trans) {
+		ret = -ENOMEM;
+		goto done;
+	}
+
+	lock_chunks(root);
+	device->total_bytes = new_size;
+	if (device->writeable)
+		device->fs_devices->total_rw_bytes -= diff;
+	ret = btrfs_update_device(trans, device);
+	if (ret) {
+		unlock_chunks(root);
+		btrfs_end_transaction(trans, root);
+		goto done;
+	}
+	WARN_ON(diff > old_total);
+	btrfs_set_super_total_bytes(super_copy, old_total - diff);
+	unlock_chunks(root);
+	btrfs_end_transaction(trans, root);
+
 done:
 	btrfs_free_path(path);
 	return ret;


-- 
Chris Ball   <cjb@laptop.org>
