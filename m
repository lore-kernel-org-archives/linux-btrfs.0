Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.30.189.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794869024;
	b=vxMH/tkCy3B7XI+k+5CWtu0sXCDo1CrU8gWZid6Zz2gtM0zMsaXTpJb/YV2aQUQP2y4x
	 ga+E4C2OCVrKhgJmSfnrWUSBRvawib3KugBBdkRJtOWrMvr1h5MotGSzfB2AYsYlAyiWO
	 5iVs9utjnCJ2CN5uUYFajm8mw06QRYsZdPMlkQjDg8gw1SnCOJ5fAPCp7MnFL3/edjm/g
	 9RUVPo9X5aXLI/yppfIVdlsNhJIDmha2vO5CHA9F7ZjOGiHR/ynBqkudJNPdR3IXVyJDa
	 1/DAfYy+v3RrI4y2Bf4rorI1UX3NpX0VaJu2CvMV1hWW9sydhQFKn15BRqD6EW0JUhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794869024;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=qNq0idV0dNzzRJQOmqJRbNk/KK/u8smoSzf2hOz+AHA=;
	b=EEDcYkmPa+WjKgp7jiii/hOksZRqQ5Yi7YJxSPdvAW5dQu8s6VljzOF5wUJ4En7M5+Zy
	 nEa6YwaGy3TcqmiNbDjuZraz2OoC9x7FIu5vbZ7p5bLu0epnWP87unTbzywsagqxOgUT5
	 Bj8jj46f1uP4tEdQzb8ZTs5o/hUFdbdNPOuPyGem2e7YBjbG7jLkV6XAU+esmHWPwuHZj
	 TlXToQsM2Oze7CugnDznc+FUdnqfiulKwnEYkJXECPmKVwD+eh9EEo6MJItpYKE4pHaqv
	 5HuBp7D9RLF2biyd5SjNh68M5d6f6aSKXWKF7vD7wPSKFj2gGPGZkNer0VhEpEX3ylQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=iodev.co.uk;
	spf=pass smtp.mailfrom=iodev.co.uk;
	arc=none smtp.remote-ip=46.30.189.100
Received: from iodev.co.uk (iodev.co.uk [46.30.189.100])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D84C606A8A3;
	Mon, 16 Nov 2026 22:43:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4D84C606A8A3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iodev.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iodev.co.uk
Received: from localhost (unknown [79.116.217.174])
	by iodev.co.uk (Postfix) with ESMTPSA id 917B95E22E3;
	Mon, 16 Nov 2026 23:43:43 +0100 (CET)
From: Ismael Luceno <ismael@iodev.co.uk>
To: linux-kernel@vger.kernel.org
Cc: Ismael Luceno <ismael@iodev.co.uk>,
	Ismael Luceno <iluceno@suse.de>,
	David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	linux-btrfs@vger.kernel.org (open list:BTRFS FILE SYSTEM)
Subject: [PATCH 8/8] btrfs: resolve root=UUID= and root=LABEL=
Date: Mon, 16 Nov 2026 23:43:24 +0100
Message-ID: <20261116224316.11237-18-ismael@iodev.co.uk>
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

A btrfs filesystem UUID and label are in its superblock, so the block
layer cannot resolve them the way it resolves PARTUUID= and PARTLABEL=:
root=UUID=... reaches parse_root_device() as something that is not a
device name, and the mount fails with a message that gives no hint that
a filesystem UUID was what was being asked for.

Walk the block devices the way the device scan does and offer each one
its filesystem UUID or label.  Whole disks without partitions and the
partitions themselves are both candidates, since a btrfs filesystem is
usually on a partition and the disks are then passed over.

btrfs_can_scan_disk() is built regardless of CONFIG_BTRFS_ROOT_SCAN,
since this lookup needs it too.  The lookup does not depend on devtmpfs, so
it is not gated by that option.

Signed-off-by: Ismael Luceno <ismael@iodev.co.uk>
Signed-off-by: Ismael Luceno <iluceno@suse.de>
---
 fs/btrfs/super.c   |  1 +
 fs/btrfs/volumes.c | 92 +++++++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/volumes.h |  1 +
 3 files changed, 88 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index fb407361bbaf..a9f07e06f6ae 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2379,6 +2379,7 @@ #define btrfs_info_if_unset(fs_info, old_ctx, opt, fmt, args...)	\
 	.owner			= THIS_MODULE,
 	.name			= "btrfs",
 	.init_fs_context	= btrfs_init_fs_context,
+	.find_by_spec		= btrfs_find_dev_by_spec,
 	.parameters		= btrfs_fs_parameters,
 	.kill_sb		= btrfs_kill_super,
 	.fs_flags		= FS_REQUIRES_DEV | FS_BINARY_MOUNTDATA |
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9eedf6ef1383..12d9dd6d0737 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1531,7 +1531,6 @@ btrfs_get_bdev_and_sb(const char *device_path, blk_mode_t flags, void *holder,
 	return device;
 }
 
-#ifdef CONFIG_BTRFS_ROOT_SCAN
 /*
  * Return true if @disk is worth handing to btrfs_scan_one_device().
  *
@@ -1562,6 +1561,7 @@ btrfs_get_bdev_and_sb(const char *device_path, blk_mode_t flags, void *holder,
 	return true;
 }
 
+#ifdef CONFIG_BTRFS_ROOT_SCAN
 /*
  * Register every block device that holds a btrfs superblock.
  *
@@ -1592,11 +1592,10 @@ btrfs_get_bdev_and_sb(const char *device_path, blk_mode_t flags, void *holder,
 	memset(res, 0, sizeof(*res));
 
 	/*
-	 * Every block device, not just whole disks: partitions are registered
-	 * with part_type rather than disk_type, and a btrfs filesystem usually
-	 * lives on one, so a type filter here would skip exactly the devices
-	 * we are looking for.  A disk that has partitions is filtered out by
-	 * btrfs_can_scan_disk() below, which can say why.
+	 * Iterate every block device, not just whole disks: partitions are
+	 * registered with part_type rather than disk_type, and a btrfs
+	 * filesystem usually lives on one, so filtering on disk_type here
+	 * would skip exactly the devices we are looking for.
 	 */
 	class_dev_iter_init(&iter, &block_class, NULL, NULL);
 	while ((dev = class_dev_iter_next(&iter))) {
@@ -1647,6 +1646,87 @@ btrfs_get_bdev_and_sb(const char *device_path, blk_mode_t flags, void *holder,
 
 #endif /* CONFIG_BTRFS_ROOT_SCAN */
 
+/*
+ * Format the filesystem UUID of a disk superblock, in the same textual form
+ * blkid and the rest of btrfs print it as.
+ */
+static const char *btrfs_sb_uuid_string(struct btrfs_super_block *disk_super)
+{
+	static char buf[UUID_STRING_LEN + 1];
+
+	/* The fsid is stored in the same layout a uuid_t is printed from. */
+	snprintf(buf, sizeof(buf), "%pU", (uuid_t *)disk_super->fsid);
+	return buf;
+}
+
+/*
+ * Read the primary superblock of @bdev and compare the field named by @key
+ * against @value.  @value is in the usual textual form: a UUID, or a label.
+ *
+ * Return 0 on a match, -ENOENT if the device is not btrfs or does not match,
+ * or an error.
+ */
+static int btrfs_dev_spec_matches(struct block_device *bdev, const char *key,
+				  const char *value)
+{
+	struct btrfs_super_block *disk_super;
+	bool matches;
+	int ret;
+
+	disk_super = btrfs_read_disk_super(bdev, 0, false);
+	if (IS_ERR(disk_super))
+		return PTR_ERR(disk_super);
+
+	if (!strcmp(key, "UUID"))
+		matches = !strcasecmp(value, btrfs_sb_uuid_string(disk_super));
+	else
+		matches = !strncmp(value, disk_super->label,
+				   BTRFS_LABEL_SIZE);
+
+	ret = matches ? 0 : -ENOENT;
+
+	btrfs_release_disk_super(disk_super);
+	return ret;
+}
+
+/*
+ * Find the block device holding the btrfs filesystem identified by @key and
+ * @value, for "root=UUID=" and "root=LABEL=".  Both are in the superblock
+ * rather than in the partition table, so unlike PARTUUID= and PARTLABEL= they
+ * can only be recognised by reading devices, and it has to be done by btrfs
+ * rather than by init/.
+ *
+ * Return 0 and the dev_t on a match, -ENODEV if no device matches.
+ */
+int btrfs_find_dev_by_spec(const char *key, const char *value, dev_t *devt)
+{
+	struct class_dev_iter iter;
+	struct device *dev;
+	int ret = -ENODEV;
+
+	if (!key || !value || !value[0])
+		return -EINVAL;
+
+	/* Every block device, disks and partitions alike: see the comment on
+	 * btrfs_scan_all_devices() for why the type filter cannot be used. */
+	class_dev_iter_init(&iter, &block_class, NULL, NULL);
+	while ((dev = class_dev_iter_next(&iter))) {
+		struct gendisk *disk = dev_to_disk(dev);
+		struct block_device *bdev = dev_to_bdev(dev);
+
+		if (!btrfs_can_scan_disk(disk, bdev))
+			continue;
+		if (btrfs_dev_spec_matches(bdev, key, value) == 0) {
+			*devt = bdev->bd_dev;
+			ret = 0;
+			break;
+		}
+	}
+	class_dev_iter_exit(&iter);
+
+	return ret;
+}
+
 /*
  * Find the first pending extent intersecting a range.
  *
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 6f2cf43d1038..8b550a5a2d6f 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -768,6 +768,7 @@ #define BTRFS_DEV_LOOKUP_ARGS(name) \
 #ifdef CONFIG_BTRFS_ROOT_SCAN
 unsigned int btrfs_scan_all_devices(struct btrfs_scan_result *res);
 #endif
+int btrfs_find_dev_by_spec(const char *key, const char *value, dev_t *devt);
 int btrfs_forget_devices(dev_t devt);
 void btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
 void btrfs_release_device_allow_freeze(struct file *bdev_file);
