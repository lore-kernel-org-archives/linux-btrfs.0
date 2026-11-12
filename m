Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=51.250.60.163
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794491239;
	b=MxfktvmeR66rBf3mBLyJZ0J5J7JmrYvM6vcDXiu/iYxAOaW9hqX9fjVyZaqw0up68MBF
	 q0X+Lpsmi0k3hP+MMgTROTYVwzCwh/xHGNW1TiM3/XLIMZgi+2LfLuF2LiacEdvpa9ZAG
	 QiH7PUHQJNWQWQTuMcyZxZkUBUvsODVTkl9tUyMzBF2iDtp+CP7u59vCktobvCyije5ZV
	 s65wCxa/WOwoo5r4m1qpqo6qTXADerCj0oAnka81us46OPBOXDX/JKWs2IDC+chhpWvah
	 y4dn8P9tla734ucNgi9fGxUbTYodltrpLSQL4PuRxI55jo5g1QdOVkHEcoYMhhlwDgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794491239;
	h=DMARC-Filter:Received:Received:X-Yandex-Fwd:DKIM-Signature:From:To:
	 Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Reply-To:Content-Transfer-Encoding;
	bh=H9g4MoxmMur+vDwi1FVWqL/MeI+9gklnr+KDxAhGsTs=;
	b=DEZJeQGZhtSH8VWzyEZ42b4JLiOFmrly3IkMsw9zuAjpUBdEOQOpdWhaJR70Dc5pjz95
	 NaVobQAotBEKHlutU4CiSlVZlxqQsJQMDFdlm72/Ww+k6Ze4yxpvb7LRUsgM4xE4W/Kb7
	 Nr4JMxaipnAPqd5H+TM7H3w1DtNVuuQe6lWSRu66C+2okJGjR/8pmqddwnVW7LtOJkdcB
	 p9BGdVQLGFoVIWUqA691yw/Tb8YCu05niMejgqNaHen6aPVcQnUcHpqr3ihbXMypmKoXt
	 SYuQyNSFu4jUX+m3Vl2l0syV8MedXxy8YANZ6blw4pkYQnFbfESgRgst28pbo4Wf84Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=yandex.ru;
	spf=pass smtp.mailfrom=yandex.ru;
	dkim=pass header.d=yandex.ru header.i=@yandex.ru header.a=rsa-sha256 header.s=mail header.b=NGKnzL7D;
	arc=none smtp.remote-ip=51.250.60.163
Received: from forward103d.mail.yandex.net (forward103d.mail.yandex.net [51.250.60.163])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D300E606A327;
	Thu, 12 Nov 2026 13:47:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D300E606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.a=rsa-sha256 header.s=mail header.b=NGKnzL7D
Received: from mail-nwsmtp-smtp-production-canary-28 (mail-nwsmtp-smtp-production-canary-28.yp-c.yandex.net)
	by forward103d.mail.yandex.net (postfix) with ESMTPS id 8CF1BC0084;
	Thu, 12 Nov 2026 16:47:07 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-canary-28 with ESMTPSA id 3lUfioFgImI0-bVci9K4P;
	Thu, 12 Nov 2026 16:47:07 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1794491227; bh=H9g4MoxmMur+vDwi1FVWqL/MeI+9gklnr+KDxAhGsTs=;
	h=Reply-To:Cc:Message-ID:References:Date:In-Reply-To:Subject:To:
	 From;
	b=NGKnzL7DN89dmaT8jIVjLrhy1LZEDYIoACgYc9GVgU9Aau99O9PTiCKjA2I3LNOF7
	 vNnmlGaoCdK1mTfBb2gH9UKuEedjbcwhaEHWGvegggPZgFIqakziED0GQ55r3G1dVa
	 pEq45IUAHxhAnN1+HlivzoJAe7kUACjWyncjyYII=
Authentication-Results: mail-nwsmtp-smtp-production-canary-28; dkim=pass header.i=@yandex.ru
From: Alexey Kuznetsov <nondet@yandex.ru>
To: linux-btrfs@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Alexey Kuznetsov <axet@me.com>
Subject: [RFC PATCH 1/1] btrfs: track physical bad extents, fast-fail, persist, and relocate
Date: Thu, 12 Nov 2026 08:47:03 -0500
Message-ID: <20261112134703.38510-2-nondet@yandex.ru>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261112134703.38510-1-nondet@yandex.ru>
References: <20261112134703.38510-1-nondet@yandex.ru>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Reply-To: Alexey Kuznetsov <axet@me.com>
Content-Transfer-Encoding: 8bit

From: Alexey Kuznetsov <axet@me.com>

From: Alexey Kuznetsov <axet@me.com>

RFC prototype of hybrid physical bad-block handling for btrfs.

The existing bad-block interfaces are either below the filesystem
(remappers, md, dm-linear) or logical (ext4's bad-block inode).  Neither
knows which physical copy of a mirrored logical extent failed, so a
filesystem cannot use redundancy to salvage a bad sector, cannot relocate
only the affected data, and cannot avoid reusing the bad physical range.

This series teaches btrfs about per-device physical bad extents:

  - scrub records the physical range of every initially failed sector;
    an I/O error is confirmed, a checksum/header/generation mismatch is
    suspect;
  - reads that overlap a confirmed range fail before device I/O and go
    through the normal completion path, so another mirror is retried and
    a fully degraded extent returns -EIO instead of stale data;
  - repair writes into a confirmed range are dropped;
  - confirmed ranges are trimmed out of find_free_dev_extent(), so new
    chunks never land in known-bad media; suspect ranges remain
    allocatable for verification;
  - ranges persist in the device tree under a new incompat feature and
    are loaded at mount;
  - writes on RAID1/RAID1C3/RAID1C4/DUP/RAID10 alias a confirmed-bad
    stripe to a healthy mirror instead of writing the bad sector; RST
    records the alias when that feature is enabled;
  - userspace can drive targeted relocation through the existing balance
    ioctl with a devid and physical-range filter.

A userspace side (dmq) scans, persists a sector map, feeds dm-linear or
dm-quarantine, and provides the relocation command.  The kernel patch is
self-contained and does not depend on it.

This is an RFC, not a submission candidate.  The on-disk format and the
ioctl ABI are placeholders.  btrfs-progs 6.14 does not know the incompat
bit (btrfs check reports unsupported features 0x8000) or expose
raid-stripe-tree, so RST persistence could not be tested on loop
devices.  Zoned devices are intentionally left alone.  Fast-fail is
whole-bio/chunk granular.  Relocation is manual.  Persisted items for a
removed device are not cleaned up.

Feedback wanted on: on-disk representation (device-tree items vs a
dedicated tree vs extending RST), per-sector vs per-bio failure, whether
the I/O path should record errors or only scrub/userspace, how to
coordinate with device replace and balance, and whether an incompat bit
is the right compatibility mechanism for a feature that changes read
semantics.

Signed-off-by: Alexey Kuznetsov <axet@me.com>
---
 fs/btrfs/Makefile               |   2 +-
 fs/btrfs/accessors.h            |  12 +
 fs/btrfs/bad-extents.c          | 825 ++++++++++++++++++++++++++++++++
 fs/btrfs/bad-extents.h          |  46 ++
 fs/btrfs/bio.c                  |  38 +-
 fs/btrfs/disk-io.c              |   8 +
 fs/btrfs/fs.h                   |   4 +
 fs/btrfs/ioctl.c                |  96 ++++
 fs/btrfs/scrub.c                |  32 ++
 fs/btrfs/sysfs.c                |   2 +
 fs/btrfs/volumes.c              |  29 ++
 fs/btrfs/volumes.h              |   5 +
 include/uapi/linux/btrfs.h      |  40 ++
 include/uapi/linux/btrfs_tree.h |  22 +
 14 files changed, 1159 insertions(+), 2 deletions(-)
 create mode 100644 fs/btrfs/bad-extents.c
 create mode 100644 fs/btrfs/bad-extents.h

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index 87617f2..a736b82 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -33,7 +33,7 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   uuid-tree.o props.o free-space-tree.o tree-checker.o space-info.o \
 	   block-rsv.o delalloc-space.o block-group.o discard.o reflink.o \
 	   subpage.o tree-mod-log.o extent-io-tree.o fs.o messages.o bio.o \
-	   lru_cache.o raid-stripe-tree.o fiemap.o direct-io.o
+	   lru_cache.o raid-stripe-tree.o fiemap.o direct-io.o bad-extents.o
 
 btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
 btrfs-$(CONFIG_BTRFS_FS_REF_VERIFY) += ref-verify.o
diff --git a/fs/btrfs/accessors.h b/fs/btrfs/accessors.h
index 15ea634..2a18508 100644
--- a/fs/btrfs/accessors.h
+++ b/fs/btrfs/accessors.h
@@ -321,6 +321,18 @@ BTRFS_SETGET_FUNCS(raid_stride_physical, struct btrfs_raid_stride, physical, 64)
 BTRFS_SETGET_STACK_FUNCS(stack_raid_stride_devid, struct btrfs_raid_stride, devid, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_raid_stride_physical, struct btrfs_raid_stride, physical, 64);
 
+/* struct btrfs_dev_bad_extent_item */
+BTRFS_SETGET_FUNCS(dev_bad_extent_length, struct btrfs_dev_bad_extent_item,
+		   length, 64);
+BTRFS_SETGET_FUNCS(dev_bad_extent_logical, struct btrfs_dev_bad_extent_item,
+		   logical, 64);
+BTRFS_SETGET_FUNCS(dev_bad_extent_generation, struct btrfs_dev_bad_extent_item,
+		   generation, 64);
+BTRFS_SETGET_FUNCS(dev_bad_extent_state, struct btrfs_dev_bad_extent_item,
+		   state, 32);
+BTRFS_SETGET_FUNCS(dev_bad_extent_errors, struct btrfs_dev_bad_extent_item,
+		   errors, 32);
+
 /* struct btrfs_dev_extent */
 BTRFS_SETGET_FUNCS(dev_extent_chunk_tree, struct btrfs_dev_extent, chunk_tree, 64);
 BTRFS_SETGET_FUNCS(dev_extent_chunk_objectid, struct btrfs_dev_extent,
diff --git a/fs/btrfs/bad-extents.c b/fs/btrfs/bad-extents.c
new file mode 100644
index 0000000..b86f074
--- /dev/null
+++ b/fs/btrfs/bad-extents.c
@@ -0,0 +1,825 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Per-device physical bad extent tracking (prototype).
+ *
+ * This is the btrfs side of the hybrid bad-block design: btrfs detects bad
+ * physical ranges (scrub already knows the logical -> physical mapping and
+ * which mirror failed) and reports them.  Userspace can then hand the ranges
+ * to a block-layer remapper.
+ *
+ * The ranges are persisted in the device tree, keyed by devid and physical
+ * start offset, under a dedicated incompat feature.  The in-memory list is
+ * authoritative while mounted; userspace mutations are written back by
+ * btrfs_bad_extents_persist() and loaded again by btrfs_bad_extents_load().
+ */
+
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/overflow.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
+#include <linux/btrfs.h>
+
+#include "ctree.h"
+#include "fs.h"
+#include "accessors.h"
+#include "messages.h"
+#include "transaction.h"
+#include "volumes.h"
+#include "bad-extents.h"
+
+struct btrfs_bad_extent {
+	struct list_head list;
+	u64 start;	/* physical byte offset on the device */
+	u64 length;	/* bytes */
+	u64 logical;	/* last logical byte offset, 0 if unknown */
+	u32 state;	/* BTRFS_BAD_EXTENT_STATE_* */
+	u32 errors;	/* number of observations */
+};
+
+static u32 bad_extent_sector_size(const struct btrfs_device *dev)
+{
+	return dev->sector_size ? dev->sector_size : SZ_4K;
+}
+
+void btrfs_bad_extents_init(struct btrfs_device *dev)
+{
+	INIT_LIST_HEAD(&dev->bad_extents);
+	mutex_init(&dev->bad_extents_lock);
+	atomic_set(&dev->bad_extents_count, 0);
+}
+
+void btrfs_bad_extents_free(struct btrfs_device *dev)
+{
+	struct btrfs_bad_extent *extent, *tmp;
+
+	mutex_lock(&dev->bad_extents_lock);
+	list_for_each_entry_safe(extent, tmp, &dev->bad_extents, list) {
+		list_del(&extent->list);
+		kfree(extent);
+	}
+	atomic_set(&dev->bad_extents_count, 0);
+	mutex_unlock(&dev->bad_extents_lock);
+}
+
+/*
+ * Record a physical range.  Adjacent/overlapping ranges are coalesced, the
+ * state only ever moves forward (suspect -> confirmed), and the error counter
+ * accumulates observations.
+ */
+int btrfs_bad_extents_record(struct btrfs_device *dev, u64 physical,
+			     u64 length, u64 logical, u32 state)
+{
+	struct btrfs_bad_extent *extent, *tmp, *new;
+	u64 start, end, new_end;
+	u32 sector_size;
+	int removed = 0;
+
+	if (!dev || !length)
+		return -EINVAL;
+	if (physical >= dev->total_bytes)
+		return -ERANGE;
+
+	sector_size = bad_extent_sector_size(dev);
+	length = min(length, dev->total_bytes - physical);
+	start = round_down(physical, sector_size);
+	end = min(round_up(physical + length, sector_size), dev->total_bytes);
+	if (end <= start)
+		return -ERANGE;
+
+	if (state != BTRFS_BAD_EXTENT_STATE_CONFIRMED)
+		state = BTRFS_BAD_EXTENT_STATE_SUSPECT;
+
+	new = kzalloc(sizeof(*new), GFP_NOFS);
+	if (!new)
+		return -ENOMEM;
+
+	new->start = start;
+	new->length = end - start;
+	new->logical = logical;
+	new->state = state;
+	new->errors = 1;
+	new_end = end;
+
+	mutex_lock(&dev->bad_extents_lock);
+	list_for_each_entry_safe(extent, tmp, &dev->bad_extents, list) {
+		u64 extent_end = extent->start + extent->length;
+
+		/* Merge touching and overlapping ranges as well. */
+		if (extent_end < new->start || extent->start > new_end)
+			continue;
+
+		new->start = min(new->start, extent->start);
+		new_end = max(new_end, extent_end);
+		new->state = max(new->state, extent->state);
+		if (U32_MAX - new->errors < extent->errors)
+			new->errors = U32_MAX;
+		else
+			new->errors += extent->errors;
+		if (!new->logical)
+			new->logical = extent->logical;
+		list_del(&extent->list);
+		kfree(extent);
+		removed++;
+	}
+	new->length = new_end - new->start;
+	atomic_inc(&dev->bad_extents_count);
+	if (removed)
+		atomic_sub(removed, &dev->bad_extents_count);
+
+	list_for_each_entry(extent, &dev->bad_extents, list) {
+		if (new->start < extent->start) {
+			list_add_tail(&new->list, &extent->list);
+			goto out;
+		}
+	}
+	list_add_tail(&new->list, &dev->bad_extents);
+out:
+	mutex_unlock(&dev->bad_extents_lock);
+	return 0;
+}
+
+/*
+ * Explicit import uses the same path as scrub, but a manual range defaults to
+ * confirmed rather than suspect.
+ */
+int btrfs_bad_extents_add(struct btrfs_device *dev, u64 start, u64 length,
+			  u64 logical, u32 state)
+{
+	if (!state)
+		state = BTRFS_BAD_EXTENT_STATE_CONFIRMED;
+	return btrfs_bad_extents_record(dev, start, length, logical, state);
+}
+
+int btrfs_bad_extents_remove(struct btrfs_device *dev, u64 start, u64 length)
+{
+	struct btrfs_bad_extent *extent, *tmp, *right;
+	u64 end;
+	int removed = 0;
+	bool added = false;
+
+	if (!dev || !length)
+		return -EINVAL;
+	if (check_add_overflow(start, length, &end) || end <= start)
+		return -EINVAL;
+
+	/* A single removal can split at most one range. */
+	right = kzalloc(sizeof(*right), GFP_NOFS);
+	if (!right)
+		return -ENOMEM;
+
+	mutex_lock(&dev->bad_extents_lock);
+	list_for_each_entry_safe(extent, tmp, &dev->bad_extents, list) {
+		u64 extent_end = extent->start + extent->length;
+
+		if (end <= extent->start || start >= extent_end)
+			continue;
+
+		if (start <= extent->start && end >= extent_end) {
+			list_del(&extent->list);
+			kfree(extent);
+			removed++;
+			continue;
+		}
+
+		if (start <= extent->start) {
+			u64 delta = end - extent->start;
+
+			extent->start = end;
+			extent->length = extent_end - end;
+			if (extent->logical)
+				extent->logical += delta;
+			continue;
+		}
+
+		if (end >= extent_end) {
+			extent->length = start - extent->start;
+			continue;
+		}
+
+		/* The removed range is strictly inside this extent. */
+		*right = *extent;
+		INIT_LIST_HEAD(&right->list);
+		right->start = end;
+		right->length = extent_end - end;
+		if (right->logical)
+			right->logical += end - extent->start;
+		right->errors = 1;
+		extent->length = start - extent->start;
+		list_add(&right->list, &extent->list);
+		right = NULL;
+		added = true;
+		break;
+	}
+	if (removed)
+		atomic_sub(removed, &dev->bad_extents_count);
+	if (added)
+		atomic_inc(&dev->bad_extents_count);
+	mutex_unlock(&dev->bad_extents_lock);
+
+	kfree(right);
+	return 0;
+}
+
+void btrfs_bad_extents_clear(struct btrfs_device *dev)
+{
+	struct btrfs_bad_extent *extent, *tmp;
+
+	mutex_lock(&dev->bad_extents_lock);
+	list_for_each_entry_safe(extent, tmp, &dev->bad_extents, list) {
+		list_del(&extent->list);
+		kfree(extent);
+	}
+	atomic_set(&dev->bad_extents_count, 0);
+	mutex_unlock(&dev->bad_extents_lock);
+}
+
+/*
+ * True if [physical, physical + length) overlaps a confirmed bad extent.
+ *
+ * This is called from the read submission path, so the common case (no bad
+ * extents at all) is a single atomic read and no locking.
+ */
+bool btrfs_bad_extents_confirmed_overlap(struct btrfs_device *dev, u64 physical,
+					 u64 length)
+{
+	struct btrfs_bad_extent *extent;
+	u64 end;
+	bool found = false;
+
+	if (!dev || !length || check_add_overflow(physical, length, &end))
+		return false;
+	if (atomic_read(&dev->bad_extents_count) == 0)
+		return false;
+
+	mutex_lock(&dev->bad_extents_lock);
+	list_for_each_entry(extent, &dev->bad_extents, list) {
+		if (extent->state != BTRFS_BAD_EXTENT_STATE_CONFIRMED)
+			continue;
+		if (physical < extent->start + extent->length &&
+		    extent->start < end) {
+			found = true;
+			break;
+		}
+	}
+	mutex_unlock(&dev->bad_extents_lock);
+	return found;
+}
+
+/*
+ * Trim a candidate device-extent allocation hole so it never covers a
+ * confirmed bad physical range.
+ *
+ * On input [*start, *start + *size) is a free hole.  On return the same
+ * fields describe the best sub-hole that does not overlap a confirmed
+ * extent.  Returns true when that sub-hole is at least @num_bytes, which is
+ * the only case the caller may allocate.  Suspect ranges are ignored: they
+ * are still candidates for verification and repair.
+ *
+ * Zoned devices are left untouched; zone-aware exclusion would also have to
+ * respect zone alignment and is outside this prototype.
+ */
+bool btrfs_bad_extents_trim_alloc_hole(struct btrfs_device *dev, u64 *start,
+				       u64 *size, u64 num_bytes)
+{
+	struct btrfs_bad_extent *extent;
+	u64 hole_end, pos, best_start, best_size = 0;
+	bool fits = false;
+
+	if (!dev || !size || !*size || dev->zone_info)
+		return *size >= num_bytes;
+	if (atomic_read(&dev->bad_extents_count) == 0)
+		return *size >= num_bytes;
+
+	hole_end = *start + *size;
+	pos = *start;
+	best_start = pos;
+
+	mutex_lock(&dev->bad_extents_lock);
+	while (pos < hole_end) {
+		struct btrfs_bad_extent *bad = NULL;
+		u64 good_size;
+
+		list_for_each_entry(extent, &dev->bad_extents, list) {
+			if (extent->state != BTRFS_BAD_EXTENT_STATE_CONFIRMED)
+				continue;
+			if (extent->start + extent->length <= pos)
+				continue;
+			bad = extent;
+			break;
+		}
+
+		if (!bad || bad->start >= hole_end) {
+			good_size = hole_end - pos;
+			if (good_size > best_size) {
+				best_start = pos;
+				best_size = good_size;
+			}
+			if (good_size >= num_bytes)
+				fits = true;
+			break;
+		}
+
+		if (bad->start > pos) {
+			good_size = bad->start - pos;
+			if (good_size > best_size) {
+				best_start = pos;
+				best_size = good_size;
+			}
+			if (good_size >= num_bytes) {
+				fits = true;
+				break;
+			}
+		}
+		pos = bad->start + bad->length;
+	}
+	mutex_unlock(&dev->bad_extents_lock);
+
+	*start = best_start;
+	*size = best_size;
+	return fits;
+}
+
+/*
+ * Redirect writes that would touch a confirmed bad physical range to another
+ * mirror of the same logical range.  This is the write-side counterpart of
+ * read fast-fail: a RAID1/DUP/RAID10 write can survive one dead copy by
+ * updating a live copy instead.
+ *
+ * The caller must only invoke this for mirror profiles, where @stripes holds
+ * all copies of the same logical range.  When the raid-stripe-tree feature is
+ * enabled, btrfs_insert_raid_extent() later records the aliased stripe, so
+ * reads use the live mapping as well.
+ *
+ * Returns -EIO when every copy of the range is confirmed bad; the write must
+ * not touch a known-bad sector.
+ */
+int btrfs_bad_extents_redirect_write(struct btrfs_io_stripe *stripes,
+				     int num_stripes, u64 length)
+{
+	int i;
+
+	if (num_stripes < 2 || length == 0)
+		return 0;
+
+	for (i = 0; i < num_stripes; i++) {
+		struct btrfs_io_stripe *bad = &stripes[i];
+		struct btrfs_io_stripe *good = NULL;
+		int j;
+
+		if (!bad->dev)
+			continue;
+		if (!btrfs_bad_extents_confirmed_overlap(bad->dev, bad->physical,
+							 length))
+			continue;
+
+		for (j = 0; j < num_stripes; j++) {
+			if (j == i || !stripes[j].dev)
+				continue;
+			if (!btrfs_bad_extents_confirmed_overlap(stripes[j].dev,
+								 stripes[j].physical,
+								 length)) {
+				good = &stripes[j];
+				break;
+			}
+		}
+		if (!good)
+			return -EIO;
+
+		btrfs_warn_rl(bad->dev->fs_info,
+			"redirecting write from bad physical %llu on devid %llu to devid %llu physical %llu",
+			bad->physical, bad->dev->devid, good->dev->devid,
+			good->physical);
+		bad->dev = good->dev;
+		bad->physical = good->physical;
+	}
+	return 0;
+}
+
+int btrfs_bad_extents_list(struct btrfs_device *dev,
+			   struct btrfs_ioctl_bad_extent *buf,
+			   u64 capacity, u64 *total)
+{
+	struct btrfs_bad_extent *extent;
+	u64 nr = 0;
+
+	mutex_lock(&dev->bad_extents_lock);
+	list_for_each_entry(extent, &dev->bad_extents, list) {
+		if (buf && nr < capacity) {
+			buf[nr].start = extent->start;
+			buf[nr].length = extent->length;
+			buf[nr].logical = extent->logical;
+			buf[nr].devid = dev->devid;
+			buf[nr].state = extent->state;
+			buf[nr].errors = extent->errors;
+			buf[nr].reserved = 0;
+		}
+		nr++;
+	}
+	mutex_unlock(&dev->bad_extents_lock);
+
+	*total = nr;
+	return 0;
+}
+
+/*
+ * On-disk persistence.
+ *
+ * Bad extents live in the device tree as
+ *   (devid, BTRFS_DEV_BAD_EXTENT_KEY, physical_start)
+ * items.  A sync is a delete-all/insert-all of the extents for one devid.
+ */
+
+struct btrfs_bad_extent_snap {
+	u64 start;
+	u64 length;
+	u64 logical;
+	u32 state;
+	u32 errors;
+};
+
+/*
+ * Copy the in-memory list for a device into a plain array.  The device list
+ * mutex is held only while looking up the device and taking the snapshot; the
+ * transaction commit below must not run under it because
+ * btrfs_run_dev_stats() takes the same mutex during commit.
+ */
+static int bad_extents_snapshot(struct btrfs_fs_info *fs_info, u64 devid,
+				struct btrfs_bad_extent_snap **snap_ret,
+				u64 *nr_ret)
+{
+	BTRFS_DEV_LOOKUP_ARGS(lookup);
+	struct btrfs_bad_extent_snap *snap = NULL;
+	struct btrfs_bad_extent *extent;
+	struct btrfs_device *dev;
+	u64 nr = 0;
+	u64 i = 0;
+	int ret = 0;
+
+	*snap_ret = NULL;
+	*nr_ret = 0;
+
+	lookup.devid = devid;
+	mutex_lock(&fs_info->fs_devices->device_list_mutex);
+	dev = btrfs_find_device(fs_info->fs_devices, &lookup);
+	if (!dev) {
+		ret = -ENODEV;
+		goto out_device;
+	}
+
+	mutex_lock(&dev->bad_extents_lock);
+	list_for_each_entry(extent, &dev->bad_extents, list)
+		nr++;
+
+	if (nr) {
+		snap = kcalloc(nr, sizeof(*snap), GFP_NOFS);
+		if (!snap) {
+			ret = -ENOMEM;
+			goto out_unlock;
+		}
+		list_for_each_entry(extent, &dev->bad_extents, list) {
+			snap[i].start = extent->start;
+			snap[i].length = extent->length;
+			snap[i].logical = extent->logical;
+			snap[i].state = extent->state;
+			snap[i].errors = extent->errors;
+			i++;
+		}
+	}
+	ASSERT(i == nr);
+
+out_unlock:
+	mutex_unlock(&dev->bad_extents_lock);
+out_device:
+	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+
+	if (ret)
+		kfree(snap);
+	else {
+		*snap_ret = snap;
+		*nr_ret = nr;
+	}
+	return ret;
+}
+
+static int bad_extents_count_persisted(struct btrfs_fs_info *fs_info,
+				       u64 devid, u64 *nr)
+{
+	struct btrfs_key key;
+	struct btrfs_key found;
+	struct btrfs_path *path;
+	int ret;
+
+	*nr = 0;
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key.objectid = devid;
+	key.type = BTRFS_DEV_BAD_EXTENT_KEY;
+	key.offset = 0;
+	ret = btrfs_search_slot(NULL, fs_info->dev_root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+
+	while (true) {
+		if (path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
+			ret = btrfs_next_leaf(fs_info->dev_root, path);
+			if (ret > 0) {
+				ret = 0;
+				break;
+			}
+			if (ret < 0)
+				goto out;
+		}
+		btrfs_item_key_to_cpu(path->nodes[0], &found, path->slots[0]);
+		if (found.objectid != devid ||
+		    found.type != BTRFS_DEV_BAD_EXTENT_KEY)
+			break;
+		(*nr)++;
+		path->slots[0]++;
+	}
+	ret = 0;
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+static int bad_extents_delete_all(struct btrfs_trans_handle *trans,
+				  struct btrfs_fs_info *fs_info, u64 devid)
+{
+	struct btrfs_key key;
+	struct btrfs_key found;
+	struct btrfs_path *path;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key.objectid = devid;
+	key.type = BTRFS_DEV_BAD_EXTENT_KEY;
+	key.offset = 0;
+	while (true) {
+		ret = btrfs_search_slot(trans, fs_info->dev_root, &key, path,
+					-1, 1);
+		if (ret < 0)
+			break;
+
+		if (path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
+			ret = btrfs_next_leaf(fs_info->dev_root, path);
+			if (ret > 0) {
+				ret = 0;
+				break;
+			}
+			if (ret < 0)
+				break;
+		}
+
+		btrfs_item_key_to_cpu(path->nodes[0], &found, path->slots[0]);
+		if (found.objectid != devid ||
+		    found.type != BTRFS_DEV_BAD_EXTENT_KEY) {
+			ret = 0;
+			break;
+		}
+
+		ret = btrfs_del_item(trans, fs_info->dev_root, path);
+		if (ret)
+			break;
+		btrfs_release_path(path);
+	}
+	btrfs_free_path(path);
+	return ret;
+}
+
+static int bad_extents_insert(struct btrfs_trans_handle *trans,
+			      struct btrfs_fs_info *fs_info, u64 devid,
+			      const struct btrfs_bad_extent_snap *snap)
+{
+	struct btrfs_dev_bad_extent_item *item;
+	struct extent_buffer *leaf;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key.objectid = devid;
+	key.type = BTRFS_DEV_BAD_EXTENT_KEY;
+	key.offset = snap->start;
+	ret = btrfs_insert_empty_item(trans, fs_info->dev_root, path, &key,
+				      sizeof(*item));
+	if (ret) {
+		btrfs_free_path(path);
+		return ret;
+	}
+
+	leaf = path->nodes[0];
+	item = btrfs_item_ptr(leaf, path->slots[0],
+			      struct btrfs_dev_bad_extent_item);
+	btrfs_set_dev_bad_extent_length(leaf, item, snap->length);
+	btrfs_set_dev_bad_extent_logical(leaf, item, snap->logical);
+	btrfs_set_dev_bad_extent_generation(leaf, item, trans->transid);
+	btrfs_set_dev_bad_extent_state(leaf, item, snap->state);
+	btrfs_set_dev_bad_extent_errors(leaf, item, snap->errors);
+
+	btrfs_free_path(path);
+	return 0;
+}
+
+static int bad_extents_sync(struct btrfs_fs_info *fs_info, u64 devid,
+			    const struct btrfs_bad_extent_snap *snap, u64 nr)
+{
+	struct btrfs_trans_handle *trans;
+	u64 old_nr;
+	u64 reserve;
+	u64 i;
+	int ret;
+
+	ret = bad_extents_count_persisted(fs_info, devid, &old_nr);
+	if (ret)
+		return ret;
+
+	/* Nothing to do: keep the incompat flag (if any) untouched. */
+	if (!nr && !old_nr)
+		return 0;
+
+	reserve = 2 + 2 * max(old_nr, nr);
+	if (reserve > 64)
+		reserve = 64;
+
+	trans = btrfs_start_transaction(fs_info->dev_root, reserve);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
+	ret = bad_extents_delete_all(trans, fs_info, devid);
+	if (ret)
+		goto abort;
+
+	for (i = 0; i < nr; i++) {
+		ret = bad_extents_insert(trans, fs_info, devid, &snap[i]);
+		if (ret)
+			goto abort;
+	}
+
+	/*
+	 * Set/clear the feature before committing.  Once the last item is gone
+	 * the feature has no remaining semantics, so it is safe to clear it and
+	 * let older kernels mount the filesystem again.
+	 */
+	if (nr)
+		btrfs_set_fs_incompat(fs_info, BAD_EXTENTS);
+	else
+		btrfs_clear_fs_incompat(fs_info, BAD_EXTENTS);
+
+	return btrfs_commit_transaction(trans);
+
+abort:
+	btrfs_abort_transaction(trans, ret);
+	return ret;
+}
+
+/*
+ * Persist the current in-memory list of one device.  Must be called without
+ * device_list_mutex held.
+ */
+int btrfs_bad_extents_persist(struct btrfs_fs_info *fs_info, u64 devid)
+{
+	struct btrfs_bad_extent_snap *snap = NULL;
+	u64 nr = 0;
+	int ret;
+
+	if (sb_rdonly(fs_info->sb))
+		return -EROFS;
+
+	ret = bad_extents_snapshot(fs_info, devid, &snap, &nr);
+	if (ret)
+		return ret;
+
+	ret = bad_extents_sync(fs_info, devid, snap, nr);
+	kfree(snap);
+	return ret;
+}
+
+static int bad_extents_load_device(struct btrfs_device *dev)
+{
+	struct btrfs_fs_info *fs_info = dev->fs_info;
+	struct btrfs_dev_bad_extent_item *item;
+	struct btrfs_bad_extent *extent;
+	struct extent_buffer *leaf;
+	struct btrfs_key key;
+	struct btrfs_key found;
+	struct btrfs_path *path;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key.objectid = dev->devid;
+	key.type = BTRFS_DEV_BAD_EXTENT_KEY;
+	key.offset = 0;
+	ret = btrfs_search_slot(NULL, fs_info->dev_root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+
+	while (true) {
+		u64 start, length, logical;
+		u32 state, errors;
+
+		if (path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
+			ret = btrfs_next_leaf(fs_info->dev_root, path);
+			if (ret > 0) {
+				ret = 0;
+				break;
+			}
+			if (ret < 0)
+				goto out;
+		}
+
+		leaf = path->nodes[0];
+		btrfs_item_key_to_cpu(leaf, &found, path->slots[0]);
+		if (found.objectid != dev->devid ||
+		    found.type != BTRFS_DEV_BAD_EXTENT_KEY)
+			break;
+
+		if (btrfs_item_size(leaf, path->slots[0]) != sizeof(*item)) {
+			btrfs_warn(fs_info,
+				   "invalid bad extent item size for devid %llu",
+				   dev->devid);
+			path->slots[0]++;
+			continue;
+		}
+
+		item = btrfs_item_ptr(leaf, path->slots[0],
+				      struct btrfs_dev_bad_extent_item);
+		start = found.offset;
+		length = btrfs_dev_bad_extent_length(leaf, item);
+		logical = btrfs_dev_bad_extent_logical(leaf, item);
+		state = btrfs_dev_bad_extent_state(leaf, item);
+		errors = btrfs_dev_bad_extent_errors(leaf, item);
+
+		if (!length || start >= dev->total_bytes ||
+		    length > dev->total_bytes - start) {
+			btrfs_warn(fs_info,
+				   "ignoring invalid bad extent on devid %llu start %llu length %llu",
+				   dev->devid, start, length);
+			path->slots[0]++;
+			continue;
+		}
+		if (state != BTRFS_BAD_EXTENT_STATE_CONFIRMED)
+			state = BTRFS_BAD_EXTENT_STATE_SUSPECT;
+
+		extent = kzalloc(sizeof(*extent), GFP_NOFS);
+		if (!extent) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		extent->start = start;
+		extent->length = length;
+		extent->logical = logical;
+		extent->state = state;
+		extent->errors = errors ? errors : 1;
+
+		mutex_lock(&dev->bad_extents_lock);
+		list_add_tail(&extent->list, &dev->bad_extents);
+		atomic_inc(&dev->bad_extents_count);
+		mutex_unlock(&dev->bad_extents_lock);
+
+		path->slots[0]++;
+	}
+	ret = 0;
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+/*
+ * Load persisted bad extents at mount time.  Only runs when the incompat
+ * feature is set, so filesystems without the feature pay nothing.
+ */
+int btrfs_bad_extents_load(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_device *dev;
+	int ret = 0;
+
+	if (!btrfs_fs_incompat(fs_info, BAD_EXTENTS))
+		return 0;
+	if (!fs_info->dev_root)
+		return 0;
+
+	mutex_lock(&fs_info->fs_devices->device_list_mutex);
+	list_for_each_entry(dev, &fs_info->fs_devices->devices, dev_list) {
+		ret = bad_extents_load_device(dev);
+		if (ret)
+			break;
+	}
+	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+
+	if (ret)
+		btrfs_err(fs_info, "failed to load bad extents: %d", ret);
+	return ret;
+}
diff --git a/fs/btrfs/bad-extents.h b/fs/btrfs/bad-extents.h
new file mode 100644
index 0000000..8ee847c
--- /dev/null
+++ b/fs/btrfs/bad-extents.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Per-device physical bad extent tracking (prototype).
+ *
+ * The list is populated by scrub and by an ioctl.  A list is meant to be
+ * consumed by userspace so it can feed the ranges to a block-layer remapper
+ * such as dm-quarantine, and it is persisted in the device tree so the
+ * information survives unmount/remount.
+ */
+
+#ifndef BTRFS_BAD_EXTENTS_H
+#define BTRFS_BAD_EXTENTS_H
+
+#include <linux/types.h>
+
+struct btrfs_device;
+struct btrfs_fs_info;
+struct btrfs_io_stripe;
+struct btrfs_ioctl_bad_extent;
+
+void btrfs_bad_extents_init(struct btrfs_device *dev);
+void btrfs_bad_extents_free(struct btrfs_device *dev);
+
+int btrfs_bad_extents_record(struct btrfs_device *dev, u64 physical,
+			     u64 length, u64 logical, u32 state);
+int btrfs_bad_extents_add(struct btrfs_device *dev, u64 start, u64 length,
+			  u64 logical, u32 state);
+int btrfs_bad_extents_remove(struct btrfs_device *dev, u64 start, u64 length);
+void btrfs_bad_extents_clear(struct btrfs_device *dev);
+int btrfs_bad_extents_list(struct btrfs_device *dev,
+			   struct btrfs_ioctl_bad_extent *buf,
+			   u64 capacity, u64 *total);
+
+bool btrfs_bad_extents_confirmed_overlap(struct btrfs_device *dev,
+					 u64 physical, u64 length);
+
+bool btrfs_bad_extents_trim_alloc_hole(struct btrfs_device *dev, u64 *start,
+				       u64 *size, u64 num_bytes);
+
+int btrfs_bad_extents_redirect_write(struct btrfs_io_stripe *stripes,
+				     int num_stripes, u64 length);
+
+int btrfs_bad_extents_persist(struct btrfs_fs_info *fs_info, u64 devid);
+int btrfs_bad_extents_load(struct btrfs_fs_info *fs_info);
+
+#endif /* BTRFS_BAD_EXTENTS_H */
diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 6225f9d..f1f6cc2 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -8,6 +8,7 @@
 #include "bio.h"
 #include "ctree.h"
 #include "volumes.h"
+#include "bad-extents.h"
 #include "raid56.h"
 #include "async-thread.h"
 #include "dev-replace.h"
@@ -676,8 +677,10 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
 	struct btrfs_io_stripe smap;
 	blk_status_t ret;
 	int error;
+	bool reloc;
 
-	if (!bbio->inode || btrfs_is_data_reloc_root(inode->root))
+	reloc = inode && btrfs_is_data_reloc_root(inode->root);
+	if (!bbio->inode || reloc)
 		smap.rst_search_commit_root = true;
 	else
 		smap.rst_search_commit_root = false;
@@ -760,6 +763,24 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
 		}
 	}
 
+	/*
+	 * Do not touch a physical range that scrub confirmed bad.  Route the
+	 * failure through the normal read completion so btrfs can try another
+	 * mirror; if there is no other copy the caller gets -EIO.  Data
+	 * relocation is the exception: it has to read the old copy to move
+	 * the data away.
+	 */
+	if (bio_op(bio) == REQ_OP_READ && !bioc && !reloc &&
+	    btrfs_bad_extents_confirmed_overlap(smap.dev, smap.physical,
+						map_length)) {
+		bbio->mirror_num = mirror_num;
+		bio->bi_private = smap.dev;
+		bio->bi_status = BLK_STS_IOERR;
+		bio->bi_end_io = btrfs_simple_end_io;
+		btrfs_simple_end_io(bio);
+		return true;
+	}
+
 	btrfs_submit_bio(bio, bioc, &smap, mirror_num);
 done:
 	return map_length == length;
@@ -834,6 +855,15 @@ int btrfs_repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 start,
 	if (ret < 0)
 		goto out_counter_dec;
 
+	/* Never write repaired data back into a confirmed bad physical range. */
+	if (btrfs_bad_extents_confirmed_overlap(smap.dev, smap.physical, length)) {
+		btrfs_debug(fs_info,
+			    "skip repair write into confirmed bad range on dev %s",
+			    btrfs_dev_name(smap.dev));
+		ret = 0;
+		goto out_counter_dec;
+	}
+
 	if (!smap.dev->bdev ||
 	    !test_bit(BTRFS_DEV_STATE_WRITEABLE, &smap.dev->dev_state)) {
 		ret = -EIO;
@@ -891,6 +921,12 @@ void btrfs_submit_repair_write(struct btrfs_bio *bbio, int mirror_num, bool dev_
 		ASSERT(smap.dev == fs_info->dev_replace.srcdev);
 		smap.dev = fs_info->dev_replace.tgtdev;
 	}
+	/* Do not write into a confirmed bad range (unless replacing to a new dev). */
+	if (btrfs_bad_extents_confirmed_overlap(smap.dev, smap.physical, length)) {
+		btrfs_bio_counter_dec(fs_info);
+		btrfs_bio_end_io(bbio, BLK_STS_OK);
+		return;
+	}
 	btrfs_submit_bio(&bbio->bio, NULL, &smap, mirror_num);
 	return;
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index d1f245e..96d54ae 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -49,6 +49,7 @@
 #include "uuid-tree.h"
 #include "relocation.h"
 #include "scrub.h"
+#include "bad-extents.h"
 #include "super.h"
 
 #define BTRFS_SUPER_FLAG_SUPP	(BTRFS_HEADER_FLAG_WRITTEN |\
@@ -2767,6 +2768,7 @@ void btrfs_init_fs_info(struct btrfs_fs_info *fs_info)
 	mutex_init(&fs_info->transaction_kthread_mutex);
 	mutex_init(&fs_info->cleaner_mutex);
 	mutex_init(&fs_info->ro_block_group_mutex);
+	mutex_init(&fs_info->bad_extents_mutex);
 	init_rwsem(&fs_info->commit_root_sem);
 	init_rwsem(&fs_info->cleanup_work_sem);
 	init_rwsem(&fs_info->subvol_sem);
@@ -3430,6 +3432,12 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 		goto fail_block_groups;
 	}
 
+	ret = btrfs_bad_extents_load(fs_info);
+	if (ret) {
+		btrfs_err(fs_info, "failed to init bad extents: %d", ret);
+		goto fail_block_groups;
+	}
+
 	ret = btrfs_init_dev_replace(fs_info);
 	if (ret) {
 		btrfs_err(fs_info, "failed to init dev_replace: %d", ret);
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index de10a95..9092805 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -271,6 +271,7 @@ enum {
 	 BTRFS_FEATURE_INCOMPAT_METADATA_UUID	|	\
 	 BTRFS_FEATURE_INCOMPAT_RAID1C34	|	\
 	 BTRFS_FEATURE_INCOMPAT_ZONED		|	\
+	 BTRFS_FEATURE_INCOMPAT_BAD_EXTENTS	|	\
 	 BTRFS_FEATURE_INCOMPAT_SIMPLE_QUOTA)
 
 #ifdef CONFIG_BTRFS_DEBUG
@@ -713,6 +714,9 @@ struct btrfs_fs_info {
 	refcount_t scrub_workers_refcnt;
 	struct workqueue_struct *scrub_workers;
 
+	/* Serialize bad extent mutation with device-tree persistence. */
+	struct mutex bad_extents_mutex;
+
 	struct btrfs_discard_ctl discard_ctl;
 
 	/* Is qgroup tracking in a consistent state? */
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 3c3c767..4d329ee 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -35,6 +35,7 @@
 #include "transaction.h"
 #include "btrfs_inode.h"
 #include "volumes.h"
+#include "bad-extents.h"
 #include "locking.h"
 #include "backref.h"
 #include "send.h"
@@ -3330,6 +3331,99 @@ static long btrfs_ioctl_get_dev_stats(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
+static long btrfs_ioctl_dev_bad_extents(struct btrfs_fs_info *fs_info,
+					void __user *arg)
+{
+	struct btrfs_ioctl_dev_bad_extents_args args;
+	struct btrfs_ioctl_bad_extent *buf = NULL;
+	BTRFS_DEV_LOOKUP_ARGS(lookup);
+	struct btrfs_device *dev;
+	bool mutating;
+	u64 total = 0;
+	int ret = 0;
+
+	if (copy_from_user(&args, arg, sizeof(args)))
+		return -EFAULT;
+
+	mutating = args.op != BTRFS_BAD_EXTENT_OP_LIST;
+
+	if (args.op != BTRFS_BAD_EXTENT_OP_LIST && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	if (args.op != BTRFS_BAD_EXTENT_OP_LIST && sb_rdonly(fs_info->sb))
+		return -EROFS;
+
+	if (args.op == BTRFS_BAD_EXTENT_OP_LIST && args.nr_extents) {
+		if (args.nr_extents > (1U << 20))
+			return -E2BIG;
+		if (!args.extents)
+			return -EFAULT;
+		buf = kcalloc(args.nr_extents, sizeof(*buf), GFP_KERNEL);
+		if (!buf)
+			return -ENOMEM;
+	}
+
+	if (mutating)
+		mutex_lock(&fs_info->bad_extents_mutex);
+
+	lookup.devid = args.devid;
+	mutex_lock(&fs_info->fs_devices->device_list_mutex);
+	dev = btrfs_find_device(fs_info->fs_devices, &lookup);
+	if (!dev) {
+		ret = -ENODEV;
+		goto out_unlock;
+	}
+
+	switch (args.op) {
+	case BTRFS_BAD_EXTENT_OP_LIST:
+		ret = btrfs_bad_extents_list(dev, buf, args.nr_extents, &total);
+		break;
+	case BTRFS_BAD_EXTENT_OP_ADD:
+		ret = btrfs_bad_extents_add(dev, args.start, args.length,
+					    args.logical, args.state);
+		break;
+	case BTRFS_BAD_EXTENT_OP_REMOVE:
+		ret = btrfs_bad_extents_remove(dev, args.start, args.length);
+		break;
+	case BTRFS_BAD_EXTENT_OP_CLEAR:
+		btrfs_bad_extents_clear(dev);
+		break;
+	case BTRFS_BAD_EXTENT_OP_SYNC:
+		/* Nothing to mutate; persistence happens below. */
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+out_unlock:
+	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+
+	/*
+	 * Persist outside device_list_mutex: committing the transaction can run
+	 * btrfs_run_dev_stats(), which takes the same mutex.
+	 */
+	if (!ret && mutating)
+		ret = btrfs_bad_extents_persist(fs_info, args.devid);
+	if (mutating)
+		mutex_unlock(&fs_info->bad_extents_mutex);
+
+	if (!ret && args.op == BTRFS_BAD_EXTENT_OP_LIST) {
+		u64 copied = min(total, args.nr_extents);
+
+		args.nr_extents = total;
+		if (copied &&
+		    copy_to_user((void __user *)(unsigned long)args.extents,
+				 buf, copied * sizeof(*buf)))
+			ret = -EFAULT;
+	}
+	kfree(buf);
+	if (ret)
+		return ret;
+	if (copy_to_user(arg, &args, sizeof(args)))
+		return -EFAULT;
+	return 0;
+}
+
 static long btrfs_ioctl_dev_replace(struct btrfs_fs_info *fs_info,
 				    void __user *arg)
 {
@@ -4855,6 +4949,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 #endif
 	case BTRFS_IOC_GET_DEV_STATS:
 		return btrfs_ioctl_get_dev_stats(fs_info, argp);
+	case BTRFS_IOC_DEV_BAD_EXTENTS:
+		return btrfs_ioctl_dev_bad_extents(fs_info, argp);
 	case BTRFS_IOC_QUOTA_CTL:
 		return btrfs_ioctl_quota_ctl(file, argp);
 	case BTRFS_IOC_QGROUP_ASSIGN:
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 9afe363..012727b 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -10,6 +10,7 @@
 #include "ctree.h"
 #include "discard.h"
 #include "volumes.h"
+#include "bad-extents.h"
 #include "disk-io.h"
 #include "ordered-data.h"
 #include "transaction.h"
@@ -1026,6 +1027,36 @@ static void scrub_write_sectors(struct scrub_ctx *sctx, struct scrub_stripe *str
  * Writeback for dev-replace does not happen here, it needs extra
  * synchronization for zoned devices.
  */
+
+/*
+ * Report the initially failed sectors of this stripe to the per-device bad
+ * extent list.  This must run before repair reads rewrite the error bitmaps:
+ * at this point io_error_bitmap/csum_error_bitmap describe the first read.
+ */
+static void scrub_record_bad_extents(struct scrub_stripe *stripe)
+{
+	struct btrfs_fs_info *fs_info = stripe->bg->fs_info;
+	int sector_nr;
+
+	if (test_bit(SCRUB_STRIPE_FLAG_NO_REPORT, &stripe->state))
+		return;
+	if (!stripe->dev)
+		return;
+
+	for_each_set_bit(sector_nr, &stripe->init_error_bitmap,
+			 stripe->nr_sectors) {
+		u64 offset = (u64)sector_nr << fs_info->sectorsize_bits;
+		u32 state = test_bit(sector_nr, &stripe->io_error_bitmap) ?
+			BTRFS_BAD_EXTENT_STATE_CONFIRMED :
+			BTRFS_BAD_EXTENT_STATE_SUSPECT;
+
+		btrfs_bad_extents_record(stripe->dev,
+					 stripe->physical + offset,
+					 fs_info->sectorsize,
+					 stripe->logical + offset, state);
+	}
+}
+
 static void scrub_stripe_read_repair_worker(struct work_struct *work)
 {
 	struct scrub_stripe *stripe = container_of(work, struct scrub_stripe, work);
@@ -1051,6 +1082,7 @@ static void scrub_stripe_read_repair_worker(struct work_struct *work)
 						    stripe->nr_sectors);
 	stripe->init_nr_meta_gen_errors = bitmap_weight(&stripe->meta_gen_error_bitmap,
 							stripe->nr_sectors);
+	scrub_record_bad_extents(stripe);
 
 	if (bitmap_empty(&stripe->init_error_bitmap, stripe->nr_sectors))
 		goto out;
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 8f195e7..0298515 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -291,6 +291,7 @@ BTRFS_FEAT_ATTR_INCOMPAT(metadata_uuid, METADATA_UUID);
 BTRFS_FEAT_ATTR_COMPAT_RO(free_space_tree, FREE_SPACE_TREE);
 BTRFS_FEAT_ATTR_COMPAT_RO(block_group_tree, BLOCK_GROUP_TREE);
 BTRFS_FEAT_ATTR_INCOMPAT(raid1c34, RAID1C34);
+BTRFS_FEAT_ATTR_INCOMPAT(bad_extents, BAD_EXTENTS);
 BTRFS_FEAT_ATTR_INCOMPAT(simple_quota, SIMPLE_QUOTA);
 #ifdef CONFIG_BLK_DEV_ZONED
 BTRFS_FEAT_ATTR_INCOMPAT(zoned, ZONED);
@@ -325,6 +326,7 @@ static struct attribute *btrfs_supported_feature_attrs[] = {
 	BTRFS_FEAT_ATTR_PTR(free_space_tree),
 	BTRFS_FEAT_ATTR_PTR(raid1c34),
 	BTRFS_FEAT_ATTR_PTR(block_group_tree),
+	BTRFS_FEAT_ATTR_PTR(bad_extents),
 	BTRFS_FEAT_ATTR_PTR(simple_quota),
 #ifdef CONFIG_BLK_DEV_ZONED
 	BTRFS_FEAT_ATTR_PTR(zoned),
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 6d9df90..007407f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -17,6 +17,7 @@
 #include "disk-io.h"
 #include "transaction.h"
 #include "volumes.h"
+#include "bad-extents.h"
 #include "raid56.h"
 #include "rcu-string.h"
 #include "dev-replace.h"
@@ -402,6 +403,7 @@ static struct btrfs_fs_devices *alloc_fs_devices(const u8 *fsid)
 static void btrfs_free_device(struct btrfs_device *device)
 {
 	WARN_ON(!list_empty(&device->post_commit_list));
+	btrfs_bad_extents_free(device);
 	rcu_string_free(device->name);
 	extent_io_tree_release(&device->alloc_state);
 	btrfs_destroy_dev_zone_info(device);
@@ -1854,6 +1856,9 @@ static int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
 			hole_size = key.offset - search_start;
 			dev_extent_hole_check(device, &search_start, &hole_size,
 					      num_bytes);
+			btrfs_bad_extents_trim_alloc_hole(device, &search_start,
+							  &hole_size,
+							  num_bytes);
 
 			if (hole_size > max_hole_size) {
 				max_hole_start = search_start;
@@ -1893,6 +1898,8 @@ next:
 	if (search_end > search_start) {
 		hole_size = search_end - search_start;
 		dev_extent_hole_check(device, &search_start, &hole_size, num_bytes);
+		btrfs_bad_extents_trim_alloc_hole(device, &search_start,
+						  &hole_size, num_bytes);
 
 		if (hole_size > max_hole_size) {
 			max_hole_start = search_start;
@@ -6797,6 +6804,27 @@ int btrfs_map_block(struct btrfs_fs_info *fs_info, enum btrfs_map_op op,
 		goto out;
 	}
 
+	/*
+	 * A write must not touch a physical range that scrub confirmed bad.
+	 * For mirror profiles we can still complete it by updating a healthy
+	 * copy instead; with the raid-stripe-tree feature enabled the aliased
+	 * stripe is recorded at ordered extent completion, so reads use it too.
+	 * Device replace has its own stripe duplication and is left alone.
+	 */
+	if (op == BTRFS_MAP_WRITE && !dev_replace_is_ongoing &&
+	    (map->type & (BTRFS_BLOCK_GROUP_RAID1_MASK |
+			  BTRFS_BLOCK_GROUP_DUP |
+			  BTRFS_BLOCK_GROUP_RAID10))) {
+		ret = btrfs_bad_extents_redirect_write(bioc->stripes,
+						       io_geom.num_stripes,
+						       *length);
+		if (ret) {
+			*bioc_ret = NULL;
+			btrfs_put_bioc(bioc);
+			goto out;
+		}
+	}
+
 	if (op != BTRFS_MAP_READ)
 		io_geom.max_errors = btrfs_chunk_max_errors(map);
 
@@ -6940,6 +6968,7 @@ struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
 	INIT_LIST_HEAD(&dev->dev_list);
 	INIT_LIST_HEAD(&dev->dev_alloc_list);
 	INIT_LIST_HEAD(&dev->post_commit_list);
+	btrfs_bad_extents_init(dev);
 
 	atomic_set(&dev->dev_stats_ccnt, 0);
 	btrfs_device_data_ordered_init(dev);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index a2863d2..d79904a 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -201,6 +201,11 @@ struct btrfs_device {
 
 	/* Bandwidth limit for scrub, in bytes */
 	u64 scrub_speed_max;
+
+	/* Physical bad extents reported by scrub (in-memory prototype). */
+	struct list_head bad_extents;
+	struct mutex bad_extents_lock;
+	atomic_t bad_extents_count;
 };
 
 /*
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 8c5490c..aa75ca5 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -335,6 +335,7 @@ struct btrfs_ioctl_fs_info_args {
 #define BTRFS_FEATURE_INCOMPAT_ZONED		(1ULL << 12)
 #define BTRFS_FEATURE_INCOMPAT_EXTENT_TREE_V2	(1ULL << 13)
 #define BTRFS_FEATURE_INCOMPAT_RAID_STRIPE_TREE	(1ULL << 14)
+#define BTRFS_FEATURE_INCOMPAT_BAD_EXTENTS	(1ULL << 15)
 #define BTRFS_FEATURE_INCOMPAT_SIMPLE_QUOTA	(1ULL << 16)
 
 struct btrfs_ioctl_feature_flags {
@@ -756,6 +757,43 @@ struct btrfs_ioctl_get_dev_stats {
 	__u64 unused[128 - 2 - BTRFS_DEV_STAT_VALUES_MAX];
 };
 
+/*
+ * Per-device physical bad extents (prototype).
+ *
+ * Ranges are populated by scrub and by explicit import, and are persisted in
+ * the device tree under BTRFS_FEATURE_INCOMPAT_BAD_EXTENTS.  Offsets are
+ * physical byte offsets on the device.
+ */
+#define BTRFS_BAD_EXTENT_STATE_SUSPECT		1
+#define BTRFS_BAD_EXTENT_STATE_CONFIRMED	2
+
+#define BTRFS_BAD_EXTENT_OP_LIST	0
+#define BTRFS_BAD_EXTENT_OP_ADD		1
+#define BTRFS_BAD_EXTENT_OP_REMOVE	2
+#define BTRFS_BAD_EXTENT_OP_CLEAR	3
+#define BTRFS_BAD_EXTENT_OP_SYNC	4	/* persist the current list */
+
+struct btrfs_ioctl_bad_extent {
+	__u64 start;		/* physical byte offset on the device */
+	__u64 length;		/* bytes */
+	__u64 logical;		/* last logical byte offset, 0 if unknown */
+	__u64 devid;
+	__u32 state;		/* BTRFS_BAD_EXTENT_STATE_* */
+	__u32 errors;		/* number of observations */
+	__u64 reserved;
+};
+
+struct btrfs_ioctl_dev_bad_extents_args {
+	__u64 devid;		/* in: device to operate on */
+	__u64 start;		/* in: physical byte offset (ADD/REMOVE) */
+	__u64 length;		/* in: bytes (ADD/REMOVE) */
+	__u64 logical;		/* in: logical byte offset (ADD) */
+	__u64 nr_extents;	/* in/out: array capacity; out: total extents */
+	__u64 extents;		/* in: user pointer to btrfs_ioctl_bad_extent[] */
+	__u32 op;		/* BTRFS_BAD_EXTENT_OP_* */
+	__u32 state;		/* in: state for ADD */
+};
+
 #define BTRFS_QUOTA_CTL_ENABLE	1
 #define BTRFS_QUOTA_CTL_DISABLE	2
 #define BTRFS_QUOTA_CTL_RESCAN__NOTUSED	3
@@ -1181,6 +1219,8 @@ enum btrfs_err_code {
 				    struct btrfs_ioctl_encoded_io_args)
 #define BTRFS_IOC_ENCODED_WRITE _IOW(BTRFS_IOCTL_MAGIC, 64, \
 				     struct btrfs_ioctl_encoded_io_args)
+#define BTRFS_IOC_DEV_BAD_EXTENTS _IOWR(BTRFS_IOCTL_MAGIC, 65, \
+				struct btrfs_ioctl_dev_bad_extents_args)
 
 #ifdef __cplusplus
 }
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index fc29d27..0730c63 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -350,6 +350,14 @@
  */
 #define BTRFS_DEV_REPLACE_KEY	250
 
+/*
+ * Persistently stores per-device physical bad extents in the device tree.
+ * One item exists per range and the key is built like this:
+ *   (devid, BTRFS_DEV_BAD_EXTENT_KEY, physical_start)
+ * The range starts at physical_start and its length is stored in the item.
+ */
+#define BTRFS_DEV_BAD_EXTENT_KEY	254
+
 /*
  * Stores items that allow to quickly map UUIDs to something else.
  * These items are part of the filesystem UUID tree.
@@ -1129,6 +1137,20 @@ struct btrfs_dev_stats_item {
 	__le64 values[BTRFS_DEV_STAT_VALUES_MAX];
 } __attribute__ ((__packed__));
 
+/*
+ * Describes one physical bad extent of a device.  The range starts at the
+ * key offset and covers length bytes.  logical is the logical address the
+ * range was last seen at, or 0 if unknown.  generation records the
+ * transaction that last wrote the item.
+ */
+struct btrfs_dev_bad_extent_item {
+	__le64 length;
+	__le64 logical;
+	__le64 generation;
+	__le32 state;
+	__le32 errors;
+} __attribute__ ((__packed__));
+
 #define BTRFS_DEV_REPLACE_ITEM_CONT_READING_FROM_SRCDEV_MODE_ALWAYS	0
 #define BTRFS_DEV_REPLACE_ITEM_CONT_READING_FROM_SRCDEV_MODE_AVOID	1
 
-- 
2.47.3

