Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.30.189.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794869017;
	b=R8xb+tzOG8/WUQcPSUuFwbzwA5o5e3h9JkT/2jTEuLrdmUmodrRt4bdjrf3Ej14BPAmx
	 uDz7GS2sV3Ap8hBsX/XRY/jONwpnvEgT8UaY8WDWBxElGRhs0z1LeFUC4xcI0B0gV8HqG
	 +axS9YjJ9zMtWwc/KI+l4fNTo30Zj6XjrgkdQ9GV+LA8kiYQnUZH/h0GIF8dVD+pB7wAp
	 EHFnr0hUz64JlZxroNcstk/+PN1cbU+SimWgzx2uq5He2hd7a70LJTFN+RvMhviqNgoqC
	 wu3C0PlNFl1F/dKAmZdMkVXmDqJ1Y9lI6YDx9FPAoKSEm9SjikHuPKJy6znwVSRrmvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794869017;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=sdaEbcD2XZaPl22pAeGSKqV9WoFv2cLFB38xaXyA0vI=;
	b=Ho9D6nMvB3EhdzU9zJ5ex/dM/DYtY1f/diWS3ReuljR38V7AotW4r6dqDr1uv+JVIIBD
	 VEazf+APCANNjQ3SzsF+IGZ+G2hgUdcivQRixtgRChmLM4TFiLy2j+0sqWjqltZnjGSBW
	 KzahbUqvzbOGcK7GPWSOO4veWDXT/d7mTMY6Ug6avp/7J9JfZn0waZUKlN6g3Q3iCFwE6
	 Vy4rp8u8b3m4imkZ+3TZ17I0qwNAiQqft1Rh/DLItVE6I3vtH5NvR61xyfiY2jmQ/HpS9
	 yw4x0E3H3euJFlTPn2IBLEX6fnhMXZtqfvZLGVz4n46/O3pTGzxI4uKjzDJpo9KsqVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=iodev.co.uk;
	spf=pass smtp.mailfrom=iodev.co.uk;
	arc=none smtp.remote-ip=46.30.189.100
Received: from iodev.co.uk (iodev.co.uk [46.30.189.100])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0055606A334;
	Mon, 16 Nov 2026 22:43:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F0055606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iodev.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iodev.co.uk
Received: from localhost (unknown [79.116.217.174])
	by iodev.co.uk (Postfix) with ESMTPSA id 39ECE5E22D8;
	Mon, 16 Nov 2026 23:43:36 +0100 (CET)
From: Ismael Luceno <ismael@iodev.co.uk>
To: linux-kernel@vger.kernel.org
Cc: Ismael Luceno <ismael@iodev.co.uk>,
	Ismael Luceno <iluceno@suse.de>,
	David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	linux-btrfs@vger.kernel.org (open list:BTRFS FILE SYSTEM)
Subject: [PATCH 4/8] btrfs: add a helper to scan all block devices
Date: Mon, 16 Nov 2026 23:43:20 +0100
Message-ID: <20261116224316.11237-14-ismael@iodev.co.uk>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261116224316.11237-10-ismael@iodev.co.uk>
References: <20261116224316.11237-10-ismael@iodev.co.uk>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btrfs learns about the devices of a filesystem from the mount source,
from the device= mount options, or from userspace running the device
scanner through the BTRFS_IOC_SCAN_DEV ioctl.  When btrfs is the root
filesystem and there is no initrd, none of those is there: the root
mount names one device and the rest of the array is left out.

Add btrfs_scan_all_devices(), which walks the block class and hands
every candidate to btrfs_scan_one_device(), the same path the ioctl
takes.  It is the kernel side of the scanner userspace would normally
run, so that the devices can be found without userspace.

A whole disk carrying a partition table is skipped.  btrfs reads its
superblock from a fixed offset near the start of the device, which on
a partitioned disk can fall inside the first partition, and picking the
disk up as a btrfs device when the partition is the real one would be
wrong.  Partitions themselves, and disks with no partition table, are
scanned as before.

The device is opened by its /dev name, which is what the rest of btrfs
records in device->name.

This adds no behaviour on its own; a caller is added separately.

Partitions are registered with part_type and disks with disk_type, so
iterating with a type filter for either skips the other.  Iterate
everything and let btrfs_can_scan_disk() decide, so a partition is
scanned and a disk that only holds partitions is not.

Signed-off-by: Ismael Luceno <ismael@iodev.co.uk>
Signed-off-by: Ismael Luceno <iluceno@suse.de>
---
 fs/btrfs/volumes.c | 79 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h |  3 ++
 2 files changed, 82 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f1305f68b1f8..55f11c9fe24c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1531,6 +1531,85 @@ btrfs_get_bdev_and_sb(const char *device_path, blk_mode_t flags, void *holder,
 	return device;
 }
 
+#ifdef CONFIG_BTRFS_ROOT_SCAN
+/*
+ * Return true if @disk is worth handing to btrfs_scan_one_device().
+ *
+ * A partition always is.  A whole disk only is when it carries no partition
+ * table: if it does, the first partition may well have a signature in the
+ * area btrfs reads from, and picking the disk up as a btrfs device would be
+ * wrong.
+ */
+static bool btrfs_can_scan_disk(struct gendisk *disk, struct block_device *bdev)
+{
+	struct block_device *part;
+	unsigned long idx;
+
+	if (!get_capacity(disk) || (disk->flags & GENHD_FL_HIDDEN))
+		return false;
+	if (bdev_is_partition(bdev))
+		return true;
+
+	rcu_read_lock();
+	xa_for_each_start(&disk->part_tbl, idx, part, 1) {
+		if (bdev_nr_sectors(part)) {
+			rcu_read_unlock();
+			return false;
+		}
+	}
+	rcu_read_unlock();
+
+	return true;
+}
+
+/*
+ * Register every block device that holds a btrfs superblock.
+ *
+ * This is the kernel side of the device scanner userspace normally drives with
+ * the BTRFS_IOC_SCAN_DEV ioctl.  It exists for the case where there is no
+ * userspace around to do it, e.g. a multi-device root filesystem mounted
+ * without an initrd.
+ *
+ * Devices are opened by their /dev name, which is what the rest of btrfs
+ * records in device->name.
+ */
+void btrfs_scan_all_devices(void)
+{
+	struct class_dev_iter iter;
+	struct device *dev;
+
+	lockdep_assert_held(&uuid_mutex);
+
+	/*
+	 * Every block device, not just whole disks: partitions are registered
+	 * with part_type rather than disk_type, and a btrfs filesystem usually
+	 * lives on one, so a type filter here would skip exactly the devices
+	 * we are looking for.  A disk that has partitions is filtered out by
+	 * btrfs_can_scan_disk() below, which can say why.
+	 */
+	class_dev_iter_init(&iter, &block_class, NULL, NULL);
+	while ((dev = class_dev_iter_next(&iter))) {
+		struct gendisk *disk = dev_to_disk(dev);
+		struct block_device *bdev = dev_to_bdev(dev);
+
+		if (btrfs_can_scan_disk(disk, bdev)) {
+			/* Longest is "/dev/" plus a BDEVNAME_SIZE name. */
+			char path[sizeof("/dev/") + BDEVNAME_SIZE];
+			struct btrfs_device *device;
+
+			snprintf(path, sizeof(path), "/dev/%s", dev_name(dev));
+
+			device = btrfs_scan_one_device(path, false);
+			if (IS_ERR(device))
+				btrfs_debug(NULL, "skipping %s: %ld\n", path,
+					    PTR_ERR(device));
+		}
+	}
+	class_dev_iter_exit(&iter);
+}
+
+#endif /* CONFIG_BTRFS_ROOT_SCAN */
+
 /*
  * Find the first pending extent intersecting a range.
  *
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 1c4cfb21ad12..814d801db2e8 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -744,6 +744,9 @@ #define BTRFS_DEV_LOOKUP_ARGS(name) \
 int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		       blk_mode_t flags, void *holder);
 struct btrfs_device *btrfs_scan_one_device(const char *path, bool mount_arg_dev);
+#ifdef CONFIG_BTRFS_ROOT_SCAN
+void btrfs_scan_all_devices(void);
+#endif
 int btrfs_forget_devices(dev_t devt);
 void btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
 void btrfs_release_device_allow_freeze(struct file *bdev_file);
