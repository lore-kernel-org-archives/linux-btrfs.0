Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.30.189.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794869019;
	b=xTlOT0ijQt7x8+pqK0RA4dFX10TBVIf7jdhdyUsf9df4gZlgRMhfHlwDDgV3VhOwmzY3
	 rbDqV9goCF/v/WTB1WAxCF0fn9KZoavEHMprCQf2dysFdFwwaHxC4+ZM6bqCxZ0pOByBu
	 E8C0hygfcuS5GymDNvrufFlKVSV3wgfkP73qeXyTDY9qkeq78g0G5J4mxyntaaKzobDJC
	 +bg98Jx2hTwD//lZsFZExl6xDGoxlmT9Bn3VXn8mc4DF/y1mMM9BDYl0Lj+IBw4z8ocrg
	 9SJkhLLw4PcMw/fj2kPD880mifbaymdjYmAoF7eDiX4I2yH0/kdRSArRXFep1qqFnuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794869019;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=pqwA8iQjzePxl3QkxEtkx6yqosawnh4Wi/9hmVz9Gxs=;
	b=yX11m75bRMc0sW/sXCzDA1shImRh/H4STSLUttD6WCRMsS5yd8O0jhIySalhiWZ/MaW0
	 i9vZtwv/j6OsoTPPZ62Qjl4Z998Y8KmxA5KPPiDo+EKVYabVCdpVwR0MyRcrK/A0Qaheq
	 MU1wCgN1d4aarUKiDHdwThegYm9v4z9zRa2LQR/adaYZkKNeNfBlROssWTvqAoYj1S5RM
	 Xn9KvZRjZVcTRG8f74LU919y4qxk1FtbTpNAL5z9dHzeGPsWyw9IPc6pjbVqKgsdAhnX+
	 5z3Fwvvua1edILdIFVZ4cRM27TUMy93yk9hntva5ygocm49KorJ948GPB4EmCVU0djw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=iodev.co.uk;
	spf=pass smtp.mailfrom=iodev.co.uk;
	arc=none smtp.remote-ip=46.30.189.100
Received: from iodev.co.uk (iodev.co.uk [46.30.189.100])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38BC2606A33A;
	Mon, 16 Nov 2026 22:43:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38BC2606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iodev.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iodev.co.uk
Received: from localhost (unknown [79.116.217.174])
	by iodev.co.uk (Postfix) with ESMTPSA id 6240F5E22DA;
	Mon, 16 Nov 2026 23:43:38 +0100 (CET)
From: Ismael Luceno <ismael@iodev.co.uk>
To: linux-kernel@vger.kernel.org
Cc: Ismael Luceno <ismael@iodev.co.uk>,
	Ismael Luceno <iluceno@suse.de>,
	David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	linux-btrfs@vger.kernel.org (open list:BTRFS FILE SYSTEM)
Subject: [PATCH 5/8] btrfs: wait for the root filesystem to have all its devices
Date: Mon, 16 Nov 2026 23:43:21 +0100
Message-ID: <20261116224316.11237-15-ismael@iodev.co.uk>
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

A multi-device btrfs filesystem is normally assembled by the device
scanner in userspace, which the initrd runs before mounting the root
filesystem.  Without an initrd nothing runs that scanner, so the root
mount names a single device and the rest of the array is left out, and
the mount then fails on a missing device.

Find the rest of the devices in the kernel instead.  How many devices a
filesystem needs is only knowable from its superblock, so the search
cannot be done by init/ and has to live here, where the scan and the
device bookkeeping already are.

Do this only for the root mount, and only when the user asked for it
with rootwait.  Any other mount of a multi-device filesystem has been
given the devices it needs, or is being asked to mount degraded, and
delaying those would change behaviour for reasons that have nothing to
do with boot.

A mount that is not the root one is not delayed, and a root one that
did not ask to be waited for is not either.  rootwait= with no value
waits indefinitely, which a root mount is entitled to.

The loop re-scans the block devices every 100ms until the number of
registered devices reaches the number the superblock says there should
be, or until the wait runs out.  It holds uuid_mutex across each scan
but releases it before sleeping, so a scan of a slow device does not
block other btrfs work, and the sleeping task holds up nothing but its
own mount.

A degraded mount skips the wait; without that, mounting a filesystem that
is missing a device on purpose would stall before doing what it was asked
to do.  On timeout the mount proceeds with whatever was found, which for
a redundant profile usually means it fails, but that is the behaviour
the caller had before.  A warning is printed first so the failure is
attributable.

The wait is only built with CONFIG_BTRFS_ROOT_SCAN, and the call to it is
only made when that is set.

Signed-off-by: Ismael Luceno <ismael@iodev.co.uk>
Signed-off-by: Ismael Luceno <iluceno@suse.de>
---
 fs/btrfs/super.c   | 164 +++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.c |  55 ++++++++++++---
 fs/btrfs/volumes.h |  23 ++++++-
 3 files changed, 232 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b424cc836bd4..fb407361bbaf 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -9,6 +9,8 @@
 #include <linux/pagemap.h>
 #include <linux/highmem.h>
 #include <linux/time.h>
+#include <linux/delay.h>
+#include <linux/jiffies.h>
 #include <linux/init.h>
 #include <linux/seq_file.h>
 #include <linux/string.h>
@@ -19,6 +21,7 @@
 #include <linux/compat.h>
 #include <linux/parser.h>
 #include <linux/ctype.h>
+#include <linux/root_dev.h>
 #include <linux/namei.h>
 #include <linux/miscdevice.h>
 #include <linux/magic.h>
@@ -65,6 +68,7 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/btrfs.h>
 
+
 static const struct super_operations btrfs_super_ops;
 static struct file_system_type btrfs_fs_type;
 
@@ -1849,6 +1853,133 @@ #define btrfs_info_if_unset(fs_info, old_ctx, opt, fmt, args...)	\
 	return fs_info->fs_devices == p->fs_devices;
 }
 
+#ifdef CONFIG_BTRFS_ROOT_SCAN
+/*
+ * How many devices of the filesystem are not registered yet.
+ *
+ * Caller must hold uuid_mutex.
+ */
+static u64 btrfs_missing_devices(struct btrfs_fs_devices *fs_devices)
+{
+	if (fs_devices->num_devices >= fs_devices->total_devices)
+		return 0;
+
+	return fs_devices->total_devices - fs_devices->num_devices;
+}
+
+/*
+ * Scan the block devices until every device of the filesystem is registered,
+ * or until @timeout_ms has passed.
+ *
+ * btrfs only knows about the devices it was handed: the mount source, the
+ * device= mount options, or the device scanner running in userspace.  When
+ * btrfs is the root filesystem and no initrd is around to run that scanner,
+ * the remaining devices have to be discovered here, and they may not have
+ * shown up yet when we are first called.
+ *
+ * The filesystem is left in whatever state it is in when this returns, so the
+ * caller can still mount it in a degraded fashion.
+ */
+static void btrfs_wait_for_devices(struct btrfs_fs_devices *fs_devices,
+				   long timeout_ms)
+{
+	unsigned long end;
+	struct btrfs_scan_result res;
+	unsigned int last_opened = ~0U;
+	unsigned int last_candidates = ~0U;
+	u64 last_missing = ~0ULL;
+	bool explained = false;
+	u64 missing;
+
+	mutex_lock(&uuid_mutex);
+	missing = btrfs_missing_devices(fs_devices);
+	mutex_unlock(&uuid_mutex);
+
+	if (!missing)
+		return;
+
+	/*
+	 * A negative timeout is rootwait without a value, which means wait
+	 * indefinitely; the loop then has no end.
+	 */
+	end = timeout_ms < 0 ? jiffies + MAX_JIFFY_OFFSET :
+			      jiffies + msecs_to_jiffies(timeout_ms);
+
+	if (timeout_ms < 0)
+		btrfs_info(NULL, "fsid %pU is missing %llu device(s), waiting indefinitely",
+			   fs_devices->fsid, missing);
+	else
+		btrfs_info(NULL, "fsid %pU is missing %llu device(s), waiting up to %ld ms",
+			   fs_devices->fsid, missing, timeout_ms);
+
+	while (!time_after(jiffies, end)) {
+		mutex_lock(&uuid_mutex);
+		btrfs_scan_all_devices(&res);
+		missing = btrfs_missing_devices(fs_devices);
+		mutex_unlock(&uuid_mutex);
+
+		if (!missing)
+			break;
+
+		/*
+		 * One line, and only when it says something new.  A wait that
+		 * prints the same numbers every scan interval tells a reader nothing
+		 * that the first line did not, and the console is the scarce
+		 * resource here.  Devices arriving one at a time is the case
+		 * worth seeing, and that is exactly when the numbers move.
+		 */
+		if (res.opened != last_opened ||
+		    res.candidates != last_candidates ||
+		    missing != last_missing) {
+			btrfs_info(NULL,
+				   "fsid %pU: %u of %u device(s) scanned, %u btrfs, %llu missing (%u block devices, %u passed over)",
+				   fs_devices->fsid, res.opened,
+				   res.candidates, res.found, missing,
+				   res.seen, res.skipped);
+			last_opened = res.opened;
+			last_candidates = res.candidates;
+			last_missing = missing;
+		}
+
+		/*
+		 * Say why a scan came back with nothing, once.  The detail is
+		 * what a reader needs and cannot guess from the counts.
+		 */
+		if (!res.opened && !explained) {
+			explained = true;
+			btrfs_warn(NULL,
+				   "fsid %pU: no device could be opened; %u of %u have no node under /dev (e.g. %u:%u: %ld)",
+				   fs_devices->fsid, res.unreachable,
+				   res.candidates, MAJOR(res.first_unreachable),
+				   MINOR(res.first_unreachable), res.first_errno);
+			btrfs_warn(NULL,
+				   "fsid %pU: enable CONFIG_DEVTMPFS_MOUNT, or boot an initrd, to mount a multi-device root filesystem",
+				   fs_devices->fsid);
+			/*
+			 * The device this filesystem was mounted from is always
+			 * a candidate, so opening none of them is not a
+			 * filesystem that is merely incomplete: there is
+			 * nothing here to wait for, and under a bare rootwait
+			 * that would be forever.
+			 */
+			return;
+		}
+
+		msleep(CONFIG_BTRFS_ROOT_SCAN_INTERVAL_MS);
+
+	}
+
+	if (missing)
+		btrfs_warn(NULL,
+			   "fsid %pU: %u of %u device(s) scanned, %u btrfs, still missing %llu; mounting anyway (%u block devices, %u passed over)",
+			   fs_devices->fsid, res.opened, res.candidates, res.found,
+			   missing, res.seen, res.skipped);
+	else
+		btrfs_info(NULL, "all devices of fsid %pU found", fs_devices->fsid);
+}
+
+#endif /* CONFIG_BTRFS_ROOT_SCAN */
+
 static int btrfs_get_tree_super(struct fs_context *fc)
 {
 	struct btrfs_fs_info *fs_info = fc->s_fs_info;
@@ -1884,6 +2015,39 @@ #define btrfs_info_if_unset(fs_info, old_ctx, opt, fmt, args...)	\
 	fs_info->fs_devices = fs_devices;
 	mutex_unlock(&uuid_mutex);
 
+	/*
+	 * Only the root filesystem needs this, and only when the user asked
+	 * for a rootwait: any other mount of a multi-device filesystem has
+	 * either been given all its devices or is being asked to mount
+	 * degraded, and neither should be delayed.  A "degraded" mount is one
+	 * where the user knows a device is missing and wants the filesystem
+	 * anyway, so it skips the wait too.
+	 */
+#ifdef CONFIG_BTRFS_ROOT_SCAN
+	if (root_wait && is_root_dev(device->devt) &&
+	    !btrfs_raw_test_opt(ctx->mount_opt, DEGRADED)) {
+		btrfs_wait_for_devices(fs_devices, root_wait);
+	} else {
+		u64 missing;
+
+		mutex_lock(&uuid_mutex);
+		missing = btrfs_missing_devices(fs_devices);
+		mutex_unlock(&uuid_mutex);
+
+		/*
+		 * A filesystem that is missing devices but is not being
+		 * waited for is either going to mount degraded, which is
+		 * what was asked for, or is about to fail.  Say which, so a
+		 * wait that did not happen is not a mystery either.
+		 */
+		if (missing)
+			btrfs_info(NULL,
+				   "not waiting for %llu missing device(s): is_root_dev=%u root_wait=%d degraded=%u",
+				   missing, is_root_dev(device->devt), root_wait,
+				   !!btrfs_raw_test_opt(ctx->mount_opt, DEGRADED));
+	}
+#endif
+
 	fc->sb_flags |= SB_NOSEC;
 
 	sb = sget_fc(fc, btrfs_fc_test_super, set_anon_super_fc);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 55f11c9fe24c..9eedf6ef1383 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1571,15 +1571,26 @@ btrfs_get_bdev_and_sb(const char *device_path, blk_mode_t flags, void *holder,
  * without an initrd.
  *
  * Devices are opened by their /dev name, which is what the rest of btrfs
- * records in device->name.
+ * records in device->name, so the scan depends on the device nodes being
+ * there.  That is what res->opened is for: the caller needs to tell a
+ * filesystem that is merely not complete yet from one where the nodes are
+ * missing, and no amount of waiting will help the latter.
+ *
+ * Returns the number of devices that held a btrfs superblock, and fills in
+ * @res.
  */
-void btrfs_scan_all_devices(void)
+unsigned int btrfs_scan_all_devices(struct btrfs_scan_result *res)
 {
 	struct class_dev_iter iter;
 	struct device *dev;
+	unsigned int found = 0;
+	unsigned int opened = 0;
+	unsigned int candidates = 0;
 
 	lockdep_assert_held(&uuid_mutex);
 
+	memset(res, 0, sizeof(*res));
+
 	/*
 	 * Every block device, not just whole disks: partitions are registered
 	 * with part_type rather than disk_type, and a btrfs filesystem usually
@@ -1591,21 +1602,47 @@ btrfs_get_bdev_and_sb(const char *device_path, blk_mode_t flags, void *holder,
 	while ((dev = class_dev_iter_next(&iter))) {
 		struct gendisk *disk = dev_to_disk(dev);
 		struct block_device *bdev = dev_to_bdev(dev);
+		struct btrfs_device *device;
 
-		if (btrfs_can_scan_disk(disk, bdev)) {
-			/* Longest is "/dev/" plus a BDEVNAME_SIZE name. */
-			char path[sizeof("/dev/") + BDEVNAME_SIZE];
-			struct btrfs_device *device;
+		res->seen++;
+		if (!btrfs_can_scan_disk(disk, bdev)) {
+			res->skipped++;
+			continue;
+		}
 
-			snprintf(path, sizeof(path), "/dev/%s", dev_name(dev));
+		/* Longest is "/dev/" plus a BDEVNAME_SIZE name. */
+		char path[sizeof("/dev/") + BDEVNAME_SIZE];
 
-			device = btrfs_scan_one_device(path, false);
-			if (IS_ERR(device))
+		candidates++;
+		snprintf(path, sizeof(path), "/dev/%s", dev_name(dev));
+
+		device = btrfs_scan_one_device(path, false);
+		if (IS_ERR(device)) {
+			/*
+			 * ENOENT is the node not being there, as opposed to
+			 * the node being there and not holding a btrfs
+			 * filesystem.  Keep one of each to explain a scan
+			 * that reaches nothing, rather than one line each.
+			 */
+			if (!res->unreachable++) {
+				res->first_unreachable = dev_to_bdev(dev)->bd_dev;
+				res->first_errno = PTR_ERR(device);
+			}
+			if (PTR_ERR(device) != -ENOENT)
 				btrfs_debug(NULL, "skipping %s: %ld\n", path,
 					    PTR_ERR(device));
+		} else {
+			opened++;
+			found++;
 		}
 	}
 	class_dev_iter_exit(&iter);
+
+	res->candidates = candidates;
+	res->opened = opened;
+	res->found = found;
+
+	return found;
 }
 
 #endif /* CONFIG_BTRFS_ROOT_SCAN */
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 814d801db2e8..6f2cf43d1038 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -743,9 +743,30 @@ #define BTRFS_DEV_LOOKUP_ARGS(name) \
 void btrfs_mapping_tree_free(struct btrfs_fs_info *fs_info);
 int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		       blk_mode_t flags, void *holder);
+#ifdef CONFIG_BTRFS_ROOT_SCAN
+/*
+ * What a pass of btrfs_scan_all_devices() made of the block devices.
+ *
+ * A scan that finds nothing has to be explained, and the usual reason is
+ * either that the device nodes are not there or that the devices hold no
+ * btrfs filesystem.  Keeping one device and one errno of each is enough to
+ * say which, and costs two lines of output instead of one per device.
+ */
+struct btrfs_scan_result {
+	unsigned int seen;	/* devices the iterator returned at all */
+	unsigned int candidates;
+	unsigned int opened;
+	unsigned int found;
+	unsigned int unreachable;
+	dev_t first_unreachable;
+	long first_errno;
+	unsigned int skipped;
+};
+#endif
+
 struct btrfs_device *btrfs_scan_one_device(const char *path, bool mount_arg_dev);
 #ifdef CONFIG_BTRFS_ROOT_SCAN
-void btrfs_scan_all_devices(void);
+unsigned int btrfs_scan_all_devices(struct btrfs_scan_result *res);
 #endif
 int btrfs_forget_devices(dev_t devt);
 void btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
