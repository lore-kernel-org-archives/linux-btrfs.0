Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34FDE37D126
	for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2026 14:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776608798; cv=none; b=QTpj3floCPC62VRfKL6VOz3l1Er8mzA7djYbakkZ7PFOeYII6+46w+JwoBHc8ot1a8h0ThcFeZBKsaG4r2HS00TO8Dm5+Wy7OY64aiVV6mg87+PEQYmiey5QZSpq3KOyfi33nzPyviJdv57mMx3dHQXsdkq4JbxvunErZ5kA8P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776608798; c=relaxed/simple;
	bh=ymOIa1eJiY45ReD2MFi8FtOmSP2ueVcWswL4vpCBN7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nx2tYuUxPUlmok9VgkIYQkdXsoyKL8LTL9xwD6BDJThipO7LxrHmDeDiARIjVJpina/R367mrrHPNBHP8GxflEneKP8dXKl6cD89CaOg0YTJw0QsK+b2DYl0xUqXQlUUckiYt/z41LlqMwXrkq3RBFwxoAQ3bQ5azprFCKkGqcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P0v+dbMV; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P0v+dbMV"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ba67b332bbaso81053066b.0
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2026 07:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776608796; x=1777213596; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Obk1PVYAmoOKh+2s67XywyvL/KoIvyyG3GLyIu1YJ3w=;
        b=P0v+dbMV22bsxjZ7qyB/BCG1dVcyvCMCQwPOfDBu2ovJQPga0JhCD7EYFPIDnV8WYF
         vt6Psl1q6oW2z1tbchHu2n/xMnMH4e/bpX0b4+OlDHfJNyp2etWRDZLHOinzOuKnJqb4
         qMofWojYt12imMABLpZpskbqO9i5My9BljjRDpxZY75vlUatnfEsYBBG3P5IOnNt0u+A
         m6ruK/8VZxZVUhwfLSpKfFNVOuSPJfJqo79g8WyJvJhdWkn0KLHp4mZu7ZnK4sTPFM+K
         a1IONI9XmmTntc1CxhIkakqB9gvPjn/WcrNTZOiscLEXMMUhJZOG5lcwYP5Qn1jwRv6O
         UzFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776608796; x=1777213596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Obk1PVYAmoOKh+2s67XywyvL/KoIvyyG3GLyIu1YJ3w=;
        b=FxRyOmb27FWcENxSCbKNsrx6qGbWdbOBNahmCVZgHxo+8kVtp+Lla5+yd9yQZ+lYTm
         C6NIBvtMmrH2rL8pYbQ94sYZgSvF4ZAivbeH36+Q8+rPteCuY7+SCa2Pt7IooRSIWS9A
         RiSIdbujBQvcghinN4pjKMPiCjr/eH2BXsP1FxqnJib/4Nqw54KqUaib+CYgY8aU53j/
         XgSrmihYKmpyVXABSH/Lrxv0Z2lkNeqESre+aMIk9bc9daJ05KaxDlG41GKbb9OJXdAz
         MC8N5Gh+Qlk6PBq59wb3N8i9iAVEAI+V1dWjes6xxKWhkDmsFvidOkDO5gaLO2XIhRor
         nj1w==
X-Gm-Message-State: AOJu0YyaRFYyUB/0iYvXLZvHP8qNdvvM6X7vLTYJvkQ58stHu90553nL
	MfLUXHPqaT2qKIO/UeMq7tTUdXgI5E1aDQvFpHDFTo5CihQQkRrnDzjvFdxCFQ==
X-Gm-Gg: AeBDiesJY+wYsjxTjkHcDrmY5UU49UEAgfknVYuHHO/A8p30YatngbJOqDBBRdPVELH
	4wX6bhGMYhRkqz8plke3zrJsGrBxkuPFGuGX7UqYoa1gIysRsxfUR/J3UUjDyqmsbtryaNL8Hm9
	WKYU80iKhR4eIxm/PFfraoW7H/AjYEAxAl+wki8ICUHFDqtkvvi14xl3BrsY/fPEmWtRfLpPuQc
	L+vsfukS7ESnsokfz9F/FsgrRzbFuZfWX+58AN0a3cbhUETotFtv3B8joW+CcD8kai3qxNIhsEi
	rtA66o9TjTQNwt0EvQmRNsjzsSe3qcsX79rOw4ibZ3fvvY8yUfDYb8xWgrF6m/9b63z3YheotJj
	nwjH+/3pSBEB9OXA3D2JkPO2448z11bk6EsZnwgK1AOQfVF6p0S4BXDlEaFPzvVa8bZ3GacKmUh
	fjlaUlYwf+cJZexzSbDvrGM00MFdMNuiyruttorH8W961elHcfMs9YaqnUNoxy4w==
X-Received: by 2002:a17:907:5ce:b0:b9d:6109:f1fb with SMTP id a640c23a62f3a-ba419558722mr448423366b.11.1776608795341;
        Sun, 19 Apr 2026 07:26:35 -0700 (PDT)
Received: from TE-laptop.internal ([2a01:799:3a1:9700:10f5:c193:4430:919e])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-ba455046223sm258232666b.49.2026.04.19.07.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Apr 2026 07:26:34 -0700 (PDT)
From: Torstein Eide <torsteine@gmail.com>
X-Google-Original-From: Torstein Eide <torsteine+linux@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Torstein Eide <torsteine@gmail.com>
Subject: [PATCH 3/5] btrfs: persist scrub lifetime stats to the device tree
Date: Sun, 19 Apr 2026 16:26:15 +0200
Message-ID: <20260419142618.3147763-4-torsteine+linux@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260419142618.3147763-1-torsteine+linux@gmail.com>
References: <20260419142618.3147763-1-torsteine+linux@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Torstein Eide <torsteine@gmail.com>

Load and save per-device scrub lifetime counters using the on-disk item
introduced in the previous patch.

btrfs_init_scrub_stats() - called from open_ctree() after device stats
  are initialised.  Reads each device's BTRFS_SCRUB_STATS_OBJECTID item
  into the in-memory atomic arrays.  Devices with no item yet start with
  all counters at zero.  Items shorter than the current struct (from an
  older kernel) are handled by zero-filling the missing tail entries.

update_scrub_stat_item() / btrfs_run_scrub_stats() - mirrors the
  existing btrfs_run_dev_stats() pattern.  Called from
  commit_cowonly_roots() after btrfs_run_dev_stats().  Iterates over all
  devices; for each device whose scrub_stats_ccnt dirty counter is
  non-zero it writes the current atomic values back to the tree item,
  creating or replacing the item as needed.

btrfs_update_scrub_stats() - called from btrfs_scrub_dev() on
  completion (or cancellation).  Copies the final btrfs_scrub_progress
  counters into both the session arrays and the lifetime totals, records
  t_end and last_physical, and sets the session status.

Signed-off-by: Torstein Eide <torsteine@gmail.com>
Assisted-by: Claude:claude-sonnet-4-6
---
 fs/btrfs/disk-io.c     |   6 ++
 fs/btrfs/transaction.c |   3 +
 fs/btrfs/volumes.c     | 239 ++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 246 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8a11be02eeb9b..fab08780e403e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3545,6 +3545,12 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 		goto fail_block_groups;
 	}
 
+	ret = btrfs_init_scrub_stats(fs_info);
+	if (ret) {
+		btrfs_err(fs_info, "failed to init scrub_stats: %d", ret);
+		goto fail_block_groups;
+	}
+
 	ret = btrfs_init_dev_replace(fs_info);
 	if (ret) {
 		btrfs_err(fs_info, "failed to init dev_replace: %d", ret);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 248adb785051b..65689a3abbdbc 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1375,6 +1375,9 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans)
 		return ret;
 
 	ret = btrfs_run_dev_stats(trans);
+	if (ret)
+		return ret;
+	ret = btrfs_run_scrub_stats(trans);
 	if (ret)
 		return ret;
 	ret = btrfs_run_dev_replace(trans);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a88e68f905646..7de9396a52757 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -9,6 +9,7 @@
 #include <linux/ratelimit.h>
 #include <linux/kthread.h>
 #include <linux/semaphore.h>
+#include <linux/timekeeping.h>
 #include <linux/uuid.h>
 #include <linux/list_sort.h>
 #include <linux/namei.h>
@@ -8386,6 +8388,242 @@ int btrfs_get_dev_stats(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+/* ---------- scrub lifetime stats: on-disk load/flush ---------- */
+
+static u64 btrfs_scrub_stats_value(const struct extent_buffer *eb,
+				   const struct btrfs_scrub_stats_item *ptr,
+				   int index)
+{
+	u64 val;
+
+	read_extent_buffer(eb, &val,
+			   offsetof(struct btrfs_scrub_stats_item, values) +
+			    ((unsigned long)ptr) + (index * sizeof(u64)),
+			   sizeof(val));
+	return le64_to_cpu(val);
+}
+
+static void btrfs_set_scrub_stats_value(struct extent_buffer *eb,
+					struct btrfs_scrub_stats_item *ptr,
+					int index, u64 val)
+{
+	__le64 leval = cpu_to_le64(val);
+
+	write_extent_buffer(eb, &leval,
+			    offsetof(struct btrfs_scrub_stats_item, values) +
+			     ((unsigned long)ptr) + (index * sizeof(u64)),
+			    sizeof(leval));
+}
+
+static int btrfs_device_init_scrub_stats(struct btrfs_device *device,
+					 struct btrfs_path *path)
+{
+	struct btrfs_scrub_stats_item *ptr;
+	struct extent_buffer *eb;
+	struct btrfs_key key;
+	int item_size;
+	int i, ret, slot;
+
+	key.objectid = BTRFS_SCRUB_STATS_OBJECTID;
+	key.type = BTRFS_PERSISTENT_ITEM_KEY;
+	key.offset = device->devid;
+
+	ret = btrfs_search_slot(NULL, device->fs_info->dev_root, &key, path, 0, 0);
+	if (ret) {
+		for (i = 0; i < BTRFS_SCRUB_STAT_VALUES_MAX; i++)
+			atomic64_set(&device->scrub_stat_values[i], 0);
+		device->scrub_stats_valid = 1;
+		btrfs_release_path(path);
+		return ret < 0 ? ret : 0;
+	}
+
+	slot = path->slots[0];
+	eb = path->nodes[0];
+	item_size = btrfs_item_size(eb, slot);
+	ptr = btrfs_item_ptr(eb, slot, struct btrfs_scrub_stats_item);
+
+	for (i = 0; i < BTRFS_SCRUB_STAT_VALUES_MAX; i++) {
+		u64 val = 0;
+
+		if (item_size >= (i + 1) * sizeof(__le64))
+			val = btrfs_scrub_stats_value(eb, ptr, i);
+		atomic64_set(&device->scrub_stat_values[i], (long long)val);
+	}
+
+	device->scrub_stats_valid = 1;
+	btrfs_release_path(path);
+	return 0;
+}
+
+int btrfs_init_scrub_stats(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
+	struct btrfs_device *device;
+	int ret = 0;
+
+	BTRFS_PATH_AUTO_FREE(path);
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	mutex_lock(&fs_devices->device_list_mutex);
+	list_for_each_entry(device, &fs_devices->devices, dev_list) {
+		ret = btrfs_device_init_scrub_stats(device, path);
+		if (ret)
+			goto out;
+	}
+out:
+	mutex_unlock(&fs_devices->device_list_mutex);
+	return ret;
+}
+
+static int update_scrub_stat_item(struct btrfs_trans_handle *trans,
+				  struct btrfs_device *device)
+{
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_root *dev_root = fs_info->dev_root;
+	struct btrfs_key key;
+	struct extent_buffer *eb;
+	struct btrfs_scrub_stats_item *ptr;
+	int ret;
+	int i;
+
+	BTRFS_PATH_AUTO_FREE(path);
+
+	key.objectid = BTRFS_SCRUB_STATS_OBJECTID;
+	key.type = BTRFS_PERSISTENT_ITEM_KEY;
+	key.offset = device->devid;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	ret = btrfs_search_slot(trans, dev_root, &key, path, -1, 1);
+	if (ret < 0) {
+		btrfs_warn(fs_info,
+			"error %d searching for scrub_stats item for device %s",
+			ret, btrfs_dev_name(device));
+		return ret;
+	}
+
+	if (ret == 0 &&
+	    btrfs_item_size(path->nodes[0], path->slots[0]) < sizeof(*ptr)) {
+		ret = btrfs_del_item(trans, dev_root, path);
+		if (ret) {
+			btrfs_warn(fs_info,
+				"delete undersized scrub_stats item for device %s failed %d",
+				btrfs_dev_name(device), ret);
+			return ret;
+		}
+		ret = 1;
+	}
+
+	if (ret == 1) {
+		btrfs_release_path(path);
+		ret = btrfs_insert_empty_item(trans, dev_root, path,
+					      &key, sizeof(*ptr));
+		if (ret < 0) {
+			btrfs_warn(fs_info,
+				"insert scrub_stats item for device %s failed %d",
+				btrfs_dev_name(device), ret);
+			return ret;
+		}
+	}
+
+	eb = path->nodes[0];
+	ptr = btrfs_item_ptr(eb, path->slots[0], struct btrfs_scrub_stats_item);
+	for (i = 0; i < BTRFS_SCRUB_STAT_VALUES_MAX; i++)
+		btrfs_set_scrub_stats_value(eb, ptr, i,
+					    btrfs_scrub_stat_read(device, i));
+	return 0;
+}
+
+/*
+ * Called from commit_transaction.  Flushes changed scrub lifetime stats to
+ * disk.  Mirrors btrfs_run_dev_stats().
+ */
+int btrfs_run_scrub_stats(struct btrfs_trans_handle *trans)
+{
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
+	struct btrfs_device *device;
+	int stats_cnt;
+	int ret = 0;
+
+	mutex_lock(&fs_devices->device_list_mutex);
+	list_for_each_entry(device, &fs_devices->devices, dev_list) {
+		stats_cnt = atomic_read(&device->scrub_stats_ccnt);
+		if (!device->scrub_stats_valid || stats_cnt == 0)
+			continue;
+
+		/*
+		 * LOAD-LOAD control dependency: reading scrub_stats_ccnt before
+		 * the counter values requires an explicit read barrier.  Pairs
+		 * with smp_mb__before_atomic() in btrfs_scrub_stat_add/set.
+		 */
+		smp_rmb();
+
+		ret = update_scrub_stat_item(trans, device);
+		if (ret)
+			break;
+		atomic_sub(stats_cnt, &device->scrub_stats_ccnt);
+	}
+	mutex_unlock(&fs_devices->device_list_mutex);
+
+	return ret;
+}
+
+/*
+ * Update per-device scrub stats after a scrub run completes (or is canceled).
+ * Accumulates session counters into the lifetime totals and records session
+ * metadata (timestamps, status, last_physical).
+ *
+ * @scrub_ret: return value from btrfs_scrub_dev(); 0=finished, -ECANCELED=
+ *             canceled, other nonzero = error/incomplete.
+ */
+void btrfs_update_scrub_stats(struct btrfs_device *dev,
+			      const struct btrfs_scrub_progress *progress,
+			      int scrub_ret)
+{
+	int i;
+	static const u64 offsets[BTRFS_SCRUB_STAT_VALUES_MAX] = {
+#define OFF(field) offsetof(struct btrfs_scrub_progress, field)
+		[BTRFS_SCRUB_STAT_DATA_EXTENTS_SCRUBBED]  = OFF(data_extents_scrubbed),
+		[BTRFS_SCRUB_STAT_TREE_EXTENTS_SCRUBBED]  = OFF(tree_extents_scrubbed),
+		[BTRFS_SCRUB_STAT_DATA_BYTES_SCRUBBED]    = OFF(data_bytes_scrubbed),
+		[BTRFS_SCRUB_STAT_TREE_BYTES_SCRUBBED]    = OFF(tree_bytes_scrubbed),
+		[BTRFS_SCRUB_STAT_READ_ERRORS]            = OFF(read_errors),
+		[BTRFS_SCRUB_STAT_CSUM_ERRORS]            = OFF(csum_errors),
+		[BTRFS_SCRUB_STAT_VERIFY_ERRORS]          = OFF(verify_errors),
+		[BTRFS_SCRUB_STAT_NO_CSUM]                = OFF(no_csum),
+		[BTRFS_SCRUB_STAT_CSUM_DISCARDS]          = OFF(csum_discards),
+		[BTRFS_SCRUB_STAT_SUPER_ERRORS]           = OFF(super_errors),
+		[BTRFS_SCRUB_STAT_MALLOC_ERRORS]          = OFF(malloc_errors),
+		[BTRFS_SCRUB_STAT_UNCORRECTABLE_ERRORS]   = OFF(uncorrectable_errors),
+		[BTRFS_SCRUB_STAT_CORRECTED_ERRORS]       = OFF(corrected_errors),
+		[BTRFS_SCRUB_STAT_UNVERIFIED_ERRORS]      = OFF(unverified_errors),
+#undef OFF
+	};
+
+	/* Update session counters from this run's progress struct */
+	for (i = 0; i < BTRFS_SCRUB_STAT_VALUES_MAX; i++) {
+		u64 val = *(const u64 *)((const u8 *)progress + offsets[i]);
+
+		atomic64_set(&dev->scrub_session_values[i], (long long)val);
+		/* Accumulate into lifetime totals */
+		btrfs_scrub_stat_add(dev, i, val);
+	}
+
+	dev->scrub_session_last_physical = progress->last_physical;
+	dev->scrub_session_t_end = ktime_get_real_seconds();
+
+	if (scrub_ret == -ECANCELED)
+		atomic_set(&dev->scrub_session_status, BTRFS_SCRUB_STATUS_CANCELED);
+	else
+		atomic_set(&dev->scrub_session_status, BTRFS_SCRUB_STATUS_FINISHED);
+}
+
 /*
  * Update the size and bytes used for each device where it changed.  This is
  * delayed since we would otherwise get errors while writing out the
@@ -8609,7 +8846,7 @@ int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info)
 
 		btrfs_item_key_to_cpu(leaf, &key, slot);
 		if (key.type != BTRFS_DEV_EXTENT_KEY)
-			break;
+			goto next;
 		devid = key.objectid;
 		physical_offset = key.offset;
 
@@ -8631,7 +8868,7 @@ int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info)
 			return ret;
 		prev_devid = devid;
 		prev_dev_ext_end = physical_offset + physical_len;
-
+next:
 		ret = btrfs_next_item(root, path);
 		if (ret < 0)
 			return ret;
-- 
2.48.1

