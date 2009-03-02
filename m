From: Chris Ball <cjb@laptop.org>
Subject: Re: [review] Btrfs: Allow shrinking close to used space
Date: Sun, 01 Mar 2009 21:29:37 -0500
Message-ID: <m31vtgk67i.fsf@pullcord.laptop.org>
References: <m34oyixrcp.fsf@pullcord.laptop.org>
	<20090225200229.GB10849@unused.rdu.redhat.com>
	<3d0408630902251831x4fad55d3t2375135067bdd3ce@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Yan Zheng <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408630902251831x4fad55d3t2375135067bdd3ce@mail.gmail.com>
	(Yan Zheng's message of "Thu, 26 Feb 2009 10:31:09 +0800")
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Here's a new patch that incorporates these comments.  We now update
device->fs_devices->total_rw_bytes before the shrink, as Josef suggests,
and create a new field in btrfs_device to store an on-disk size that is
only updated on a successful shrink operation, as requested by Yan.

(Thanks, Yan and Josef, for the patient explanations.)

==
From: Chris Ball <cjb@laptop.org>

Btrfs: When shrinking, only update disk size on success

Previously, we updated a device's size prior to attempting a shrink
operation.  This patch moves the device resizing logic to only happen if
the shrink completes successfully.  In the process, it introduces a new
field to btrfs_device -- disk_total_bytes -- to track the on-disk size.

Signed-off-by: Chris Ball <cjb@laptop.org>
---
 fs/btrfs/volumes.c |   35 ++++++++++++++++++++++++-----------
 fs/btrfs/volumes.h |    3 +++
 2 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1316139..303b7d6 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1433,7 +1433,7 @@ static noinline int btrfs_update_device(struct btrfs_trans_handle *trans,
 	btrfs_set_device_io_align(leaf, dev_item, device->io_align);
 	btrfs_set_device_io_width(leaf, dev_item, device->io_width);
 	btrfs_set_device_sector_size(leaf, dev_item, device->sector_size);
-	btrfs_set_device_total_bytes(leaf, dev_item, device->total_bytes);
+	btrfs_set_device_total_bytes(leaf, dev_item, device->disk_total_bytes);
 	btrfs_set_device_bytes_used(leaf, dev_item, device->bytes_used);
 	btrfs_mark_buffer_dirty(leaf);
 
@@ -1828,14 +1828,6 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 	device->total_bytes = new_size;
 	if (device->writeable)
 		device->fs_devices->total_rw_bytes -= diff;
-	ret = btrfs_update_device(trans, device);
-	if (ret) {
-		unlock_chunks(root);
-		btrfs_end_transaction(trans, root);
-		goto done;
-	}
-	WARN_ON(diff > old_total);
-	btrfs_set_super_total_bytes(super_copy, old_total - diff);
 	unlock_chunks(root);
 	btrfs_end_transaction(trans, root);
 
@@ -1867,7 +1859,7 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 		length = btrfs_dev_extent_length(l, dev_extent);
 
 		if (key.offset + length <= new_size)
-			goto done;
+			break;
 
 		chunk_tree = btrfs_dev_extent_chunk_tree(l, dev_extent);
 		chunk_objectid = btrfs_dev_extent_chunk_objectid(l, dev_extent);
@@ -1880,6 +1872,26 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 			goto done;
 	}
 
+	/* Shrinking succeeded, else we would be at "done". */
+	trans = btrfs_start_transaction(root, 1);
+	if (!trans) {
+		ret = -ENOMEM;
+		goto done;
+	}
+	lock_chunks(root);
+
+	device->disk_total_bytes = new_size;
+	/* Now btrfs_update_device() will change the on-disk size. */
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
 done:
 	btrfs_free_path(path);
 	return ret;
@@ -2959,7 +2971,8 @@ static int fill_device_from_item(struct extent_buffer *leaf,
 	unsigned long ptr;
 
 	device->devid = btrfs_device_id(leaf, dev_item);
-	device->total_bytes = btrfs_device_total_bytes(leaf, dev_item);
+	device->disk_total_bytes = btrfs_device_total_bytes(leaf, dev_item);
+	device->total_bytes = device->disk_total_bytes;
 	device->bytes_used = btrfs_device_bytes_used(leaf, dev_item);
 	device->type = btrfs_device_type(leaf, dev_item);
 	device->io_align = btrfs_device_io_align(leaf, dev_item);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 86c44e9..bf1ba75 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -52,6 +52,9 @@ struct btrfs_device {
 	/* size of the device */
 	u64 total_bytes;
 
+	/* size of the disk */
+	u64 disk_total_bytes;
+
 	/* bytes used */
 	u64 bytes_used;
 
-- 
1.6.1.3


- Chris.
-- 
Chris Ball   <cjb@laptop.org>
