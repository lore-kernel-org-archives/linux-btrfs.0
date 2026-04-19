Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DA737C0F1
	for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2026 14:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776608801; cv=none; b=szNzakNPxV1cbfvM9TO3fNb7hCJOXQJuEBVNQv2Dd2iSEoH/0BpUNywifrnKHE3Z6jzoXWdE3tOZL8Tz6YfvrIHt+LqtpcBiQKrQjqxiVTAMIbWmABmNE9UiuU3PLSMq0cPIxGBZgpJrRngRpWK1O3+wjIil27C4vZalQagtszg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776608801; c=relaxed/simple;
	bh=N7TvWnqpunr3awAHty8h2+mHpdERnYbhessezm881PI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3a5qwO8LMe6OsA6c1aUe1suSrzSJxI+kiMpkH0mPbpAOycPHS4TUSGmzH6UcP8LePPsSTye+77t2ekgFcDPwB1rtykLcvq8tcP4ip6LOq18OxmjVJT6brNqyi3wxZkh/ch6CU0XdvW7qkcPVZ5UR2GxL0gMXO8q+Otckc9LIZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KxgXoPeO; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KxgXoPeO"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b9c3a9fe80fso279103966b.3
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2026 07:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776608797; x=1777213597; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZwiMuu+930sGI0DeJFUgTszXhgEKT1/fklC6orMe7vk=;
        b=KxgXoPeOBeAFqBVb0NncwA/Y3c74Bkt8X9n/S5ejj8sCej2M7U51xWbHD+Bmj3yHdN
         eLUw2PDZyZQUtZI+guCc06IUJHrtL+wPTcZm1iTLN8AB9EBozS67ijqI4lEB8tWHYBB2
         RUVJupzLZGdYYDWDY1zETNZ4YRRQBmgBA+nGm4U38jhzgj64MHN39BFB+8sHqGEq6LW8
         KxcSdmX7RiS3obFt5ZlwhX8EvUA+/tUmzezP23id267ypUJBXxeF2dBRwd3GJhX3KigI
         YpKrB6tl1wJGxPk60Php6nOhXTUVVYbxrxQsSbWeDsmwM4EvjOJedgP7fNhOSLNFsvv7
         91Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776608797; x=1777213597;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZwiMuu+930sGI0DeJFUgTszXhgEKT1/fklC6orMe7vk=;
        b=A7dd/qzpAPHuWu0mTKTSaNfvLfpkz9iV5ugHOjM621xRL9vNt5V8egeDQhmVPXAKtt
         srHtj/O55d8+J8R9YWYlK/+kseht5Y/AgEC3ozh3pJLO/rIXGLXCgUT84S8MHzcJ0Koy
         VmI2z1ightqiTeJ15OVkBhZ1uipVbNe8I5BSMGMUmTL7y1HcMNyBsbs0gUgyU/Humjtf
         hkXDcxGclZkHe166665EZVjpN7rLqIdeRUKyaFO6IOQmS/B/1smzi5ewzxAlyj1IDwrP
         hpwWLIHnEhl5iYjiliw2cWos/jvbMkjutDLrgT6G3711TGPph3e18dTpDLwYwAl79B64
         vJFA==
X-Gm-Message-State: AOJu0YwpMCAqMNO3VW+KGh6jVfahZTWzS0QpQLAtcrGtL73Br9GTgxby
	ifIF/NOFgqECk9F6Ci+Gm/TXJVC5/HWipPMdvF4YriXiLFg4Hy1/5r+PM6Z4+w==
X-Gm-Gg: AeBDietpZ+uv2MgOBuSrDvE+dOjRx+JtdHwQ40LvdtqkM8+EBuAy1lTzEs+bSws8QEz
	tfAK3sNpQq2S47kiCGnQc5vqJKXYjtB2sB0KZsCxJ4ZO63vU/9NxQwf8zg80FhqCQT0nb7efyeo
	twNie4nx56mNM3lqLfm9SOJ9RtPQqPpgGeCNRxsGbFD4ziOFLniTIq3lWDkp+a/Q+7tpwmGUpSh
	6yD8MLKQojkWu1Jh1ZLguHzvpod7nnH+c5rd1rBzTTTGKcrOMfwlVk6HGUMYdhGNilsgMtepDoo
	5/lptzpJIw+l+WGUq8ik8EYns+TXmusyG+sO5wZVuvofbC5Leug6GMQYRfkBS91HZe97UrOe8r1
	tN9ZD7ThO3vluZZH2UhXYGFVilnzM7pL8hEkDdwuC7kJBOfL8v/y2OMHtM3jQJKhZuv2ijvtgLT
	XAP1NlrYX4IuSFhpJXng9e4EPjuHUqhP3+bppWdFmuTnOL8Mftv24=
X-Received: by 2002:a17:907:934c:b0:b9c:1089:47b8 with SMTP id a640c23a62f3a-ba41b3e12e6mr436855566b.47.1776608797329;
        Sun, 19 Apr 2026 07:26:37 -0700 (PDT)
Received: from TE-laptop.internal ([2a01:799:3a1:9700:10f5:c193:4430:919e])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-ba455046223sm258232666b.49.2026.04.19.07.26.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Apr 2026 07:26:36 -0700 (PDT)
From: Torstein Eide <torsteine@gmail.com>
X-Google-Original-From: Torstein Eide <torsteine+linux@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Torstein Eide <torsteine@gmail.com>
Subject: [PATCH 5/5] btrfs: expose scrub lifetime and session counters via sysfs
Date: Sun, 19 Apr 2026 16:26:17 +0200
Message-ID: <20260419142618.3147763-6-torsteine+linux@gmail.com>
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

Create two sysfs sub-hierarchies under each filesystem UUID and under
each devinfo/<devid>/ entry:

  /sys/fs/btrfs/<UUID>/scrub/
    reset                   (write "1" to zero all devices' lifetime
                             counters and mark them dirty)
    lifetime/               filesystem-wide sums of per-device lifetime
      data_extents_scrubbed   counters (one file per stat index)
      tree_extents_scrubbed
      ... (14 counters total)
    session/                filesystem-wide view of the most recent run
      data_extents_scrubbed   (summed across devices for counters,
      ...                      earliest t_start / latest t_end for time)
      status                  idle | running | finished | canceled
      t_start / t_end         Unix timestamps (seconds)
      duration_seconds        computed on read; live while running

  /sys/fs/btrfs/<UUID>/devinfo/<devid>/scrub/
    reset                   (per-device reset)
    lifetime/               per-device lifetime counters
    session/                per-device session counters + metadata
      last_physical           byte offset where the last run stopped

The attribute arrays are declared as 'const struct attribute *[]' so
they are compatible with sysfs_create_files() / sysfs_remove_files().
Forward declarations are placed before btrfs_sysfs_remove_mounted() and
btrfs_sysfs_remove_device() which reference them before their
definitions.

Signed-off-by: Torstein Eide <torsteine@gmail.com>
Assisted-by: Claude:claude-sonnet-4-6
---
 fs/btrfs/sysfs.c | 586 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/sysfs.h |   3 +
 2 files changed, 589 insertions(+)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 0d14570c8bc29..d5f12a40b31fc 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -11,6 +11,7 @@
 #include <linux/bug.h>
 #include <linux/list.h>
 #include <linux/string_choices.h>
+#include <linux/timekeeping.h>
 #include "messages.h"
 #include "ctree.h"
 #include "discard.h"
@@ -1707,6 +1708,14 @@ static void btrfs_sysfs_remove_fs_devices(struct btrfs_fs_devices *fs_devices)
 	}
 }
 
+/* Forward declarations for scrub sysfs attribute arrays defined later. */
+static const struct attribute *scrub_attrs[];
+static const struct attribute *scrub_lifetime_attrs[];
+static const struct attribute *scrub_session_attrs[];
+static const struct attribute *devid_scrub_attrs[];
+static const struct attribute *devid_scrub_lifetime_attrs[];
+static const struct attribute *devid_scrub_session_attrs[];
+
 void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info)
 {
 	struct kobject *fsid_kobj = &fs_info->fs_devices->fsid_kobj;
@@ -1723,6 +1732,21 @@ void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info)
 		kobject_del(fs_info->discard_kobj);
 		kobject_put(fs_info->discard_kobj);
 	}
+	if (fs_info->scrub_session_kobj) {
+		sysfs_remove_files(fs_info->scrub_session_kobj, scrub_session_attrs);
+		kobject_del(fs_info->scrub_session_kobj);
+		kobject_put(fs_info->scrub_session_kobj);
+	}
+	if (fs_info->scrub_lifetime_kobj) {
+		sysfs_remove_files(fs_info->scrub_lifetime_kobj, scrub_lifetime_attrs);
+		kobject_del(fs_info->scrub_lifetime_kobj);
+		kobject_put(fs_info->scrub_lifetime_kobj);
+	}
+	if (fs_info->scrub_kobj) {
+		sysfs_remove_files(fs_info->scrub_kobj, scrub_attrs);
+		kobject_del(fs_info->scrub_kobj);
+		kobject_put(fs_info->scrub_kobj);
+	}
 #ifdef CONFIG_BTRFS_DEBUG
 	if (fs_info->debug_kobj) {
 		sysfs_remove_files(fs_info->debug_kobj, btrfs_debug_mount_attrs);
@@ -1970,6 +1994,28 @@ void btrfs_sysfs_remove_device(struct btrfs_device *device)
 	if (device->bdev)
 		sysfs_remove_link(devices_kobj, bdev_kobj(device->bdev)->name);
 
+	/* Tear down devinfo/<devid>/scrub/ hierarchy (children before parent) */
+	if (device->scrub_session_kobj) {
+		sysfs_remove_files(device->scrub_session_kobj,
+				   devid_scrub_session_attrs);
+		kobject_del(device->scrub_session_kobj);
+		kobject_put(device->scrub_session_kobj);
+		device->scrub_session_kobj = NULL;
+	}
+	if (device->scrub_lifetime_kobj) {
+		sysfs_remove_files(device->scrub_lifetime_kobj,
+				   devid_scrub_lifetime_attrs);
+		kobject_del(device->scrub_lifetime_kobj);
+		kobject_put(device->scrub_lifetime_kobj);
+		device->scrub_lifetime_kobj = NULL;
+	}
+	if (device->scrub_kobj) {
+		sysfs_remove_files(device->scrub_kobj, devid_scrub_attrs);
+		kobject_del(device->scrub_kobj);
+		kobject_put(device->scrub_kobj);
+		device->scrub_kobj = NULL;
+	}
+
 	if (device->devid_kobj.state_initialized) {
 		kobject_del(&device->devid_kobj);
 		kobject_put(&device->devid_kobj);
@@ -2099,6 +2145,482 @@ static ssize_t btrfs_devinfo_error_stats_show(struct kobject *kobj,
 }
 BTRFS_ATTR(devid, error_stats, btrfs_devinfo_error_stats_show);
 
+/* ---------- scrub/lifetime/ and scrub/session/ sysfs attributes ---------- */
+
+/*
+ * Return the btrfs_device owning a kobject that lives two levels below
+ * devid_kobj, i.e. kobj->parent is scrub_kobj, kobj->parent->parent is
+ * devid_kobj.
+ */
+static struct btrfs_device *kobj_to_scrub_device(struct kobject *kobj)
+{
+	return container_of(kobj->parent->parent, struct btrfs_device, devid_kobj);
+}
+
+/*
+ * Return the btrfs_fs_info owning a kobject that lives two levels below
+ * fsid_kobj, i.e. kobj->parent is fs_info->scrub_kobj,
+ * kobj->parent->parent is &fs_devs->fsid_kobj.
+ */
+static struct btrfs_fs_info *kobj_to_scrub_fs_info(struct kobject *kobj)
+{
+	struct btrfs_fs_devices *fs_devs =
+		container_of(kobj->parent->parent, struct btrfs_fs_devices, fsid_kobj);
+	return fs_devs->fs_info;
+}
+
+/*
+ * Per-device scrub/lifetime/ attributes.
+ * Each show function reads an atomic64 from btrfs_device::scrub_stat_values[].
+ */
+#define DEV_SCRUB_LIFETIME_ATTR(_name, _idx)					\
+static ssize_t btrfs_devid_scrub_lifetime_##_name##_show(			\
+		struct kobject *kobj, struct kobj_attribute *a, char *buf)	\
+{										\
+	struct btrfs_device *dev = kobj_to_scrub_device(kobj);			\
+	return sysfs_emit(buf, "%llu\n", btrfs_scrub_stat_read(dev, _idx));	\
+}										\
+BTRFS_ATTR(devid_scrub_lifetime, _name,					\
+	   btrfs_devid_scrub_lifetime_##_name##_show)
+
+DEV_SCRUB_LIFETIME_ATTR(data_extents_scrubbed, BTRFS_SCRUB_STAT_DATA_EXTENTS_SCRUBBED);
+DEV_SCRUB_LIFETIME_ATTR(tree_extents_scrubbed, BTRFS_SCRUB_STAT_TREE_EXTENTS_SCRUBBED);
+DEV_SCRUB_LIFETIME_ATTR(data_bytes_scrubbed,   BTRFS_SCRUB_STAT_DATA_BYTES_SCRUBBED);
+DEV_SCRUB_LIFETIME_ATTR(tree_bytes_scrubbed,   BTRFS_SCRUB_STAT_TREE_BYTES_SCRUBBED);
+DEV_SCRUB_LIFETIME_ATTR(read_errors,           BTRFS_SCRUB_STAT_READ_ERRORS);
+DEV_SCRUB_LIFETIME_ATTR(csum_errors,           BTRFS_SCRUB_STAT_CSUM_ERRORS);
+DEV_SCRUB_LIFETIME_ATTR(verify_errors,         BTRFS_SCRUB_STAT_VERIFY_ERRORS);
+DEV_SCRUB_LIFETIME_ATTR(no_csum,               BTRFS_SCRUB_STAT_NO_CSUM);
+DEV_SCRUB_LIFETIME_ATTR(csum_discards,         BTRFS_SCRUB_STAT_CSUM_DISCARDS);
+DEV_SCRUB_LIFETIME_ATTR(super_errors,          BTRFS_SCRUB_STAT_SUPER_ERRORS);
+DEV_SCRUB_LIFETIME_ATTR(malloc_errors,         BTRFS_SCRUB_STAT_MALLOC_ERRORS);
+DEV_SCRUB_LIFETIME_ATTR(uncorrectable_errors,  BTRFS_SCRUB_STAT_UNCORRECTABLE_ERRORS);
+DEV_SCRUB_LIFETIME_ATTR(corrected_errors,      BTRFS_SCRUB_STAT_CORRECTED_ERRORS);
+DEV_SCRUB_LIFETIME_ATTR(unverified_errors,     BTRFS_SCRUB_STAT_UNVERIFIED_ERRORS);
+
+static const struct attribute *devid_scrub_lifetime_attrs[] = {
+	BTRFS_ATTR_PTR(devid_scrub_lifetime, data_extents_scrubbed),
+	BTRFS_ATTR_PTR(devid_scrub_lifetime, tree_extents_scrubbed),
+	BTRFS_ATTR_PTR(devid_scrub_lifetime, data_bytes_scrubbed),
+	BTRFS_ATTR_PTR(devid_scrub_lifetime, tree_bytes_scrubbed),
+	BTRFS_ATTR_PTR(devid_scrub_lifetime, read_errors),
+	BTRFS_ATTR_PTR(devid_scrub_lifetime, csum_errors),
+	BTRFS_ATTR_PTR(devid_scrub_lifetime, verify_errors),
+	BTRFS_ATTR_PTR(devid_scrub_lifetime, no_csum),
+	BTRFS_ATTR_PTR(devid_scrub_lifetime, csum_discards),
+	BTRFS_ATTR_PTR(devid_scrub_lifetime, super_errors),
+	BTRFS_ATTR_PTR(devid_scrub_lifetime, malloc_errors),
+	BTRFS_ATTR_PTR(devid_scrub_lifetime, uncorrectable_errors),
+	BTRFS_ATTR_PTR(devid_scrub_lifetime, corrected_errors),
+	BTRFS_ATTR_PTR(devid_scrub_lifetime, unverified_errors),
+	NULL
+};
+
+/*
+ * Per-device scrub/session/ attributes.
+ */
+#define DEV_SCRUB_SESSION_ATTR(_name, _idx)					\
+static ssize_t btrfs_devid_scrub_session_##_name##_show(			\
+		struct kobject *kobj, struct kobj_attribute *a, char *buf)	\
+{										\
+	struct btrfs_device *dev = kobj_to_scrub_device(kobj);			\
+	return sysfs_emit(buf, "%llu\n", btrfs_scrub_session_read(dev, _idx));	\
+}										\
+BTRFS_ATTR(devid_scrub_session, _name,					\
+	   btrfs_devid_scrub_session_##_name##_show)
+
+DEV_SCRUB_SESSION_ATTR(data_extents_scrubbed, BTRFS_SCRUB_STAT_DATA_EXTENTS_SCRUBBED);
+DEV_SCRUB_SESSION_ATTR(tree_extents_scrubbed, BTRFS_SCRUB_STAT_TREE_EXTENTS_SCRUBBED);
+DEV_SCRUB_SESSION_ATTR(data_bytes_scrubbed,   BTRFS_SCRUB_STAT_DATA_BYTES_SCRUBBED);
+DEV_SCRUB_SESSION_ATTR(tree_bytes_scrubbed,   BTRFS_SCRUB_STAT_TREE_BYTES_SCRUBBED);
+DEV_SCRUB_SESSION_ATTR(read_errors,           BTRFS_SCRUB_STAT_READ_ERRORS);
+DEV_SCRUB_SESSION_ATTR(csum_errors,           BTRFS_SCRUB_STAT_CSUM_ERRORS);
+DEV_SCRUB_SESSION_ATTR(verify_errors,         BTRFS_SCRUB_STAT_VERIFY_ERRORS);
+DEV_SCRUB_SESSION_ATTR(no_csum,               BTRFS_SCRUB_STAT_NO_CSUM);
+DEV_SCRUB_SESSION_ATTR(csum_discards,         BTRFS_SCRUB_STAT_CSUM_DISCARDS);
+DEV_SCRUB_SESSION_ATTR(super_errors,          BTRFS_SCRUB_STAT_SUPER_ERRORS);
+DEV_SCRUB_SESSION_ATTR(malloc_errors,         BTRFS_SCRUB_STAT_MALLOC_ERRORS);
+DEV_SCRUB_SESSION_ATTR(uncorrectable_errors,  BTRFS_SCRUB_STAT_UNCORRECTABLE_ERRORS);
+DEV_SCRUB_SESSION_ATTR(corrected_errors,      BTRFS_SCRUB_STAT_CORRECTED_ERRORS);
+DEV_SCRUB_SESSION_ATTR(unverified_errors,     BTRFS_SCRUB_STAT_UNVERIFIED_ERRORS);
+
+static ssize_t btrfs_devid_scrub_session_last_physical_show(
+		struct kobject *kobj, struct kobj_attribute *a, char *buf)
+{
+	struct btrfs_device *dev = kobj_to_scrub_device(kobj);
+
+	return sysfs_emit(buf, "%llu\n", READ_ONCE(dev->scrub_session_last_physical));
+}
+BTRFS_ATTR(devid_scrub_session, last_physical,
+	   btrfs_devid_scrub_session_last_physical_show);
+
+static ssize_t btrfs_devid_scrub_session_t_start_show(
+		struct kobject *kobj, struct kobj_attribute *a, char *buf)
+{
+	struct btrfs_device *dev = kobj_to_scrub_device(kobj);
+
+	return sysfs_emit(buf, "%llu\n", READ_ONCE(dev->scrub_session_t_start));
+}
+BTRFS_ATTR(devid_scrub_session, t_start, btrfs_devid_scrub_session_t_start_show);
+
+static ssize_t btrfs_devid_scrub_session_t_end_show(
+		struct kobject *kobj, struct kobj_attribute *a, char *buf)
+{
+	struct btrfs_device *dev = kobj_to_scrub_device(kobj);
+
+	return sysfs_emit(buf, "%llu\n", READ_ONCE(dev->scrub_session_t_end));
+}
+BTRFS_ATTR(devid_scrub_session, t_end, btrfs_devid_scrub_session_t_end_show);
+
+static ssize_t btrfs_devid_scrub_session_duration_seconds_show(
+		struct kobject *kobj, struct kobj_attribute *a, char *buf)
+{
+	struct btrfs_device *dev = kobj_to_scrub_device(kobj);
+	u64 t_start = READ_ONCE(dev->scrub_session_t_start);
+	u64 t_end   = READ_ONCE(dev->scrub_session_t_end);
+	u64 dur;
+
+	if (t_start == 0)
+		dur = 0;
+	else if (t_end != 0)
+		dur = t_end - t_start;
+	else
+		dur = (u64)ktime_get_real_seconds() - t_start;
+	return sysfs_emit(buf, "%llu\n", dur);
+}
+BTRFS_ATTR(devid_scrub_session, duration_seconds,
+	   btrfs_devid_scrub_session_duration_seconds_show);
+
+static const char * const btrfs_scrub_status_strings[] = {
+	[BTRFS_SCRUB_STATUS_IDLE]     = "idle",
+	[BTRFS_SCRUB_STATUS_RUNNING]  = "running",
+	[BTRFS_SCRUB_STATUS_FINISHED] = "finished",
+	[BTRFS_SCRUB_STATUS_CANCELED] = "canceled",
+};
+
+static ssize_t btrfs_devid_scrub_session_status_show(
+		struct kobject *kobj, struct kobj_attribute *a, char *buf)
+{
+	struct btrfs_device *dev = kobj_to_scrub_device(kobj);
+	int status = atomic_read(&dev->scrub_session_status);
+
+	if (status < 0 || status >= ARRAY_SIZE(btrfs_scrub_status_strings))
+		return sysfs_emit(buf, "unknown\n");
+	return sysfs_emit(buf, "%s\n", btrfs_scrub_status_strings[status]);
+}
+BTRFS_ATTR(devid_scrub_session, status, btrfs_devid_scrub_session_status_show);
+
+static const struct attribute *devid_scrub_session_attrs[] = {
+	BTRFS_ATTR_PTR(devid_scrub_session, data_extents_scrubbed),
+	BTRFS_ATTR_PTR(devid_scrub_session, tree_extents_scrubbed),
+	BTRFS_ATTR_PTR(devid_scrub_session, data_bytes_scrubbed),
+	BTRFS_ATTR_PTR(devid_scrub_session, tree_bytes_scrubbed),
+	BTRFS_ATTR_PTR(devid_scrub_session, read_errors),
+	BTRFS_ATTR_PTR(devid_scrub_session, csum_errors),
+	BTRFS_ATTR_PTR(devid_scrub_session, verify_errors),
+	BTRFS_ATTR_PTR(devid_scrub_session, no_csum),
+	BTRFS_ATTR_PTR(devid_scrub_session, csum_discards),
+	BTRFS_ATTR_PTR(devid_scrub_session, super_errors),
+	BTRFS_ATTR_PTR(devid_scrub_session, malloc_errors),
+	BTRFS_ATTR_PTR(devid_scrub_session, uncorrectable_errors),
+	BTRFS_ATTR_PTR(devid_scrub_session, corrected_errors),
+	BTRFS_ATTR_PTR(devid_scrub_session, unverified_errors),
+	BTRFS_ATTR_PTR(devid_scrub_session, last_physical),
+	BTRFS_ATTR_PTR(devid_scrub_session, t_start),
+	BTRFS_ATTR_PTR(devid_scrub_session, t_end),
+	BTRFS_ATTR_PTR(devid_scrub_session, duration_seconds),
+	BTRFS_ATTR_PTR(devid_scrub_session, status),
+	NULL
+};
+
+/*
+ * Per-device scrub/reset (write-only): "echo 1 > reset" zeroes lifetime
+ * counters and marks them dirty for the next transaction commit.
+ */
+static ssize_t btrfs_devid_scrub_reset_store(struct kobject *kobj,
+		struct kobj_attribute *a, const char *buf, size_t len)
+{
+	struct btrfs_device *dev;
+	unsigned long val;
+	int i;
+
+	if (kstrtoul(buf, 10, &val) || val != 1)
+		return -EINVAL;
+
+	/* kobj here is the scrub_kobj, one level below devid_kobj */
+	dev = container_of(kobj->parent, struct btrfs_device, devid_kobj);
+
+	for (i = 0; i < BTRFS_SCRUB_STAT_VALUES_MAX; i++)
+		btrfs_scrub_stat_set(dev, i, 0);
+
+	btrfs_info(dev->fs_info,
+		   "scrub: lifetime stats reset for devid %llu by %s (%d)",
+		   dev->devid, current->comm, task_pid_nr(current));
+	return len;
+}
+BTRFS_ATTR_W(devid_scrub, reset, btrfs_devid_scrub_reset_store);
+
+static const struct attribute *devid_scrub_attrs[] = {
+	BTRFS_ATTR_PTR(devid_scrub, reset),
+	NULL
+};
+
+/* ---------- fs-level scrub/lifetime/ and scrub/session/ attributes ---------- */
+
+/*
+ * Filesystem-level lifetime counters: sum of all device lifetime counters.
+ */
+#define FS_SCRUB_LIFETIME_ATTR(_name, _idx)					\
+static ssize_t btrfs_scrub_lifetime_##_name##_show(				\
+		struct kobject *kobj, struct kobj_attribute *a, char *buf)	\
+{										\
+	struct btrfs_fs_info *fs_info = kobj_to_scrub_fs_info(kobj);		\
+	struct btrfs_fs_devices *fs_devs = fs_info->fs_devices;			\
+	struct btrfs_device *dev;						\
+	u64 total = 0;								\
+										\
+	mutex_lock(&fs_devs->device_list_mutex);				\
+	list_for_each_entry(dev, &fs_devs->devices, dev_list)			\
+		total += btrfs_scrub_stat_read(dev, _idx);			\
+	mutex_unlock(&fs_devs->device_list_mutex);				\
+	return sysfs_emit(buf, "%llu\n", total);				\
+}										\
+BTRFS_ATTR(scrub_lifetime, _name, btrfs_scrub_lifetime_##_name##_show)
+
+FS_SCRUB_LIFETIME_ATTR(data_extents_scrubbed, BTRFS_SCRUB_STAT_DATA_EXTENTS_SCRUBBED);
+FS_SCRUB_LIFETIME_ATTR(tree_extents_scrubbed, BTRFS_SCRUB_STAT_TREE_EXTENTS_SCRUBBED);
+FS_SCRUB_LIFETIME_ATTR(data_bytes_scrubbed,   BTRFS_SCRUB_STAT_DATA_BYTES_SCRUBBED);
+FS_SCRUB_LIFETIME_ATTR(tree_bytes_scrubbed,   BTRFS_SCRUB_STAT_TREE_BYTES_SCRUBBED);
+FS_SCRUB_LIFETIME_ATTR(read_errors,           BTRFS_SCRUB_STAT_READ_ERRORS);
+FS_SCRUB_LIFETIME_ATTR(csum_errors,           BTRFS_SCRUB_STAT_CSUM_ERRORS);
+FS_SCRUB_LIFETIME_ATTR(verify_errors,         BTRFS_SCRUB_STAT_VERIFY_ERRORS);
+FS_SCRUB_LIFETIME_ATTR(no_csum,               BTRFS_SCRUB_STAT_NO_CSUM);
+FS_SCRUB_LIFETIME_ATTR(csum_discards,         BTRFS_SCRUB_STAT_CSUM_DISCARDS);
+FS_SCRUB_LIFETIME_ATTR(super_errors,          BTRFS_SCRUB_STAT_SUPER_ERRORS);
+FS_SCRUB_LIFETIME_ATTR(malloc_errors,         BTRFS_SCRUB_STAT_MALLOC_ERRORS);
+FS_SCRUB_LIFETIME_ATTR(uncorrectable_errors,  BTRFS_SCRUB_STAT_UNCORRECTABLE_ERRORS);
+FS_SCRUB_LIFETIME_ATTR(corrected_errors,      BTRFS_SCRUB_STAT_CORRECTED_ERRORS);
+FS_SCRUB_LIFETIME_ATTR(unverified_errors,     BTRFS_SCRUB_STAT_UNVERIFIED_ERRORS);
+
+static const struct attribute *scrub_lifetime_attrs[] = {
+	BTRFS_ATTR_PTR(scrub_lifetime, data_extents_scrubbed),
+	BTRFS_ATTR_PTR(scrub_lifetime, tree_extents_scrubbed),
+	BTRFS_ATTR_PTR(scrub_lifetime, data_bytes_scrubbed),
+	BTRFS_ATTR_PTR(scrub_lifetime, tree_bytes_scrubbed),
+	BTRFS_ATTR_PTR(scrub_lifetime, read_errors),
+	BTRFS_ATTR_PTR(scrub_lifetime, csum_errors),
+	BTRFS_ATTR_PTR(scrub_lifetime, verify_errors),
+	BTRFS_ATTR_PTR(scrub_lifetime, no_csum),
+	BTRFS_ATTR_PTR(scrub_lifetime, csum_discards),
+	BTRFS_ATTR_PTR(scrub_lifetime, super_errors),
+	BTRFS_ATTR_PTR(scrub_lifetime, malloc_errors),
+	BTRFS_ATTR_PTR(scrub_lifetime, uncorrectable_errors),
+	BTRFS_ATTR_PTR(scrub_lifetime, corrected_errors),
+	BTRFS_ATTR_PTR(scrub_lifetime, unverified_errors),
+	NULL
+};
+
+/*
+ * Filesystem-level session counters: sum of per-device session values.
+ * Timing/status derive from per-device values.
+ */
+#define FS_SCRUB_SESSION_ATTR(_name, _idx)					\
+static ssize_t btrfs_scrub_session_##_name##_show(				\
+		struct kobject *kobj, struct kobj_attribute *a, char *buf)	\
+{										\
+	struct btrfs_fs_info *fs_info = kobj_to_scrub_fs_info(kobj);		\
+	struct btrfs_fs_devices *fs_devs = fs_info->fs_devices;			\
+	struct btrfs_device *dev;						\
+	u64 total = 0;								\
+										\
+	mutex_lock(&fs_devs->device_list_mutex);				\
+	list_for_each_entry(dev, &fs_devs->devices, dev_list)			\
+		total += btrfs_scrub_session_read(dev, _idx);			\
+	mutex_unlock(&fs_devs->device_list_mutex);				\
+	return sysfs_emit(buf, "%llu\n", total);				\
+}										\
+BTRFS_ATTR(scrub_session, _name, btrfs_scrub_session_##_name##_show)
+
+FS_SCRUB_SESSION_ATTR(data_extents_scrubbed, BTRFS_SCRUB_STAT_DATA_EXTENTS_SCRUBBED);
+FS_SCRUB_SESSION_ATTR(tree_extents_scrubbed, BTRFS_SCRUB_STAT_TREE_EXTENTS_SCRUBBED);
+FS_SCRUB_SESSION_ATTR(data_bytes_scrubbed,   BTRFS_SCRUB_STAT_DATA_BYTES_SCRUBBED);
+FS_SCRUB_SESSION_ATTR(tree_bytes_scrubbed,   BTRFS_SCRUB_STAT_TREE_BYTES_SCRUBBED);
+FS_SCRUB_SESSION_ATTR(read_errors,           BTRFS_SCRUB_STAT_READ_ERRORS);
+FS_SCRUB_SESSION_ATTR(csum_errors,           BTRFS_SCRUB_STAT_CSUM_ERRORS);
+FS_SCRUB_SESSION_ATTR(verify_errors,         BTRFS_SCRUB_STAT_VERIFY_ERRORS);
+FS_SCRUB_SESSION_ATTR(no_csum,               BTRFS_SCRUB_STAT_NO_CSUM);
+FS_SCRUB_SESSION_ATTR(csum_discards,         BTRFS_SCRUB_STAT_CSUM_DISCARDS);
+FS_SCRUB_SESSION_ATTR(super_errors,          BTRFS_SCRUB_STAT_SUPER_ERRORS);
+FS_SCRUB_SESSION_ATTR(malloc_errors,         BTRFS_SCRUB_STAT_MALLOC_ERRORS);
+FS_SCRUB_SESSION_ATTR(uncorrectable_errors,  BTRFS_SCRUB_STAT_UNCORRECTABLE_ERRORS);
+FS_SCRUB_SESSION_ATTR(corrected_errors,      BTRFS_SCRUB_STAT_CORRECTED_ERRORS);
+FS_SCRUB_SESSION_ATTR(unverified_errors,     BTRFS_SCRUB_STAT_UNVERIFIED_ERRORS);
+
+static ssize_t btrfs_scrub_session_status_show(
+		struct kobject *kobj, struct kobj_attribute *a, char *buf)
+{
+	struct btrfs_fs_info *fs_info = kobj_to_scrub_fs_info(kobj);
+
+	if (atomic_read(&fs_info->scrubs_running) > 0)
+		return sysfs_emit(buf, "running\n");
+
+	/*
+	 * Not running: check if any device's last session finished or was
+	 * canceled.
+	 */
+	{
+		struct btrfs_fs_devices *fs_devs = fs_info->fs_devices;
+		struct btrfs_device *dev;
+		int seen_finished = 0, seen_canceled = 0;
+
+		mutex_lock(&fs_devs->device_list_mutex);
+		list_for_each_entry(dev, &fs_devs->devices, dev_list) {
+			int st = atomic_read(&dev->scrub_session_status);
+
+			if (st == BTRFS_SCRUB_STATUS_FINISHED)
+				seen_finished = 1;
+			else if (st == BTRFS_SCRUB_STATUS_CANCELED)
+				seen_canceled = 1;
+		}
+		mutex_unlock(&fs_devs->device_list_mutex);
+
+		if (seen_canceled)
+			return sysfs_emit(buf, "canceled\n");
+		if (seen_finished)
+			return sysfs_emit(buf, "finished\n");
+	}
+	return sysfs_emit(buf, "idle\n");
+}
+BTRFS_ATTR(scrub_session, status, btrfs_scrub_session_status_show);
+
+static ssize_t btrfs_scrub_session_t_start_show(
+		struct kobject *kobj, struct kobj_attribute *a, char *buf)
+{
+	struct btrfs_fs_info *fs_info = kobj_to_scrub_fs_info(kobj);
+	struct btrfs_fs_devices *fs_devs = fs_info->fs_devices;
+	struct btrfs_device *dev;
+	u64 t_min = 0;
+
+	mutex_lock(&fs_devs->device_list_mutex);
+	list_for_each_entry(dev, &fs_devs->devices, dev_list) {
+		u64 t = READ_ONCE(dev->scrub_session_t_start);
+
+		if (t && (!t_min || t < t_min))
+			t_min = t;
+	}
+	mutex_unlock(&fs_devs->device_list_mutex);
+	return sysfs_emit(buf, "%llu\n", t_min);
+}
+BTRFS_ATTR(scrub_session, t_start, btrfs_scrub_session_t_start_show);
+
+static ssize_t btrfs_scrub_session_t_end_show(
+		struct kobject *kobj, struct kobj_attribute *a, char *buf)
+{
+	struct btrfs_fs_info *fs_info = kobj_to_scrub_fs_info(kobj);
+	struct btrfs_fs_devices *fs_devs = fs_info->fs_devices;
+	struct btrfs_device *dev;
+	u64 t_max = 0;
+
+	mutex_lock(&fs_devs->device_list_mutex);
+	list_for_each_entry(dev, &fs_devs->devices, dev_list) {
+		u64 t = READ_ONCE(dev->scrub_session_t_end);
+
+		if (t > t_max)
+			t_max = t;
+	}
+	mutex_unlock(&fs_devs->device_list_mutex);
+	return sysfs_emit(buf, "%llu\n", t_max);
+}
+BTRFS_ATTR(scrub_session, t_end, btrfs_scrub_session_t_end_show);
+
+static ssize_t btrfs_scrub_session_duration_seconds_show(
+		struct kobject *kobj, struct kobj_attribute *a, char *buf)
+{
+	struct btrfs_fs_info *fs_info = kobj_to_scrub_fs_info(kobj);
+	struct btrfs_fs_devices *fs_devs = fs_info->fs_devices;
+	struct btrfs_device *dev;
+	u64 t_start = 0, t_end = 0, dur;
+
+	mutex_lock(&fs_devs->device_list_mutex);
+	list_for_each_entry(dev, &fs_devs->devices, dev_list) {
+		u64 ts = READ_ONCE(dev->scrub_session_t_start);
+		u64 te = READ_ONCE(dev->scrub_session_t_end);
+
+		if (ts && (!t_start || ts < t_start))
+			t_start = ts;
+		if (te > t_end)
+			t_end = te;
+	}
+	mutex_unlock(&fs_devs->device_list_mutex);
+
+	if (!t_start)
+		dur = 0;
+	else if (t_end)
+		dur = t_end - t_start;
+	else
+		dur = (u64)ktime_get_real_seconds() - t_start;
+	return sysfs_emit(buf, "%llu\n", dur);
+}
+BTRFS_ATTR(scrub_session, duration_seconds,
+	   btrfs_scrub_session_duration_seconds_show);
+
+static const struct attribute *scrub_session_attrs[] = {
+	BTRFS_ATTR_PTR(scrub_session, data_extents_scrubbed),
+	BTRFS_ATTR_PTR(scrub_session, tree_extents_scrubbed),
+	BTRFS_ATTR_PTR(scrub_session, data_bytes_scrubbed),
+	BTRFS_ATTR_PTR(scrub_session, tree_bytes_scrubbed),
+	BTRFS_ATTR_PTR(scrub_session, read_errors),
+	BTRFS_ATTR_PTR(scrub_session, csum_errors),
+	BTRFS_ATTR_PTR(scrub_session, verify_errors),
+	BTRFS_ATTR_PTR(scrub_session, no_csum),
+	BTRFS_ATTR_PTR(scrub_session, csum_discards),
+	BTRFS_ATTR_PTR(scrub_session, super_errors),
+	BTRFS_ATTR_PTR(scrub_session, malloc_errors),
+	BTRFS_ATTR_PTR(scrub_session, uncorrectable_errors),
+	BTRFS_ATTR_PTR(scrub_session, corrected_errors),
+	BTRFS_ATTR_PTR(scrub_session, unverified_errors),
+	BTRFS_ATTR_PTR(scrub_session, status),
+	BTRFS_ATTR_PTR(scrub_session, t_start),
+	BTRFS_ATTR_PTR(scrub_session, t_end),
+	BTRFS_ATTR_PTR(scrub_session, duration_seconds),
+	NULL
+};
+
+/*
+ * Filesystem-level scrub/reset (write-only): zeros all devices' lifetime
+ * counters and marks them dirty.
+ */
+static ssize_t btrfs_scrub_reset_store(struct kobject *kobj,
+		struct kobj_attribute *a, const char *buf, size_t len)
+{
+	/* kobj is fs_info->scrub_kobj, parent is fsid_kobj */
+	struct btrfs_fs_devices *fs_devs =
+		container_of(kobj->parent, struct btrfs_fs_devices, fsid_kobj);
+	struct btrfs_fs_info *fs_info = fs_devs->fs_info;
+	struct btrfs_device *dev;
+	unsigned long val;
+	int i;
+
+	if (kstrtoul(buf, 10, &val) || val != 1)
+		return -EINVAL;
+
+	mutex_lock(&fs_devs->device_list_mutex);
+	list_for_each_entry(dev, &fs_devs->devices, dev_list)
+		for (i = 0; i < BTRFS_SCRUB_STAT_VALUES_MAX; i++)
+			btrfs_scrub_stat_set(dev, i, 0);
+	mutex_unlock(&fs_devs->device_list_mutex);
+
+	btrfs_info(fs_info, "scrub: all lifetime stats reset by %s (%d)",
+		   current->comm, task_pid_nr(current));
+	return len;
+}
+BTRFS_ATTR_W(scrub, reset, btrfs_scrub_reset_store);
+
+static const struct attribute *scrub_attrs[] = {
+	BTRFS_ATTR_PTR(scrub, reset),
+	NULL
+};
+
 /*
  * Information about one device.
  *
@@ -2169,7 +2691,41 @@ int btrfs_sysfs_add_device(struct btrfs_device *device)
 		btrfs_warn(device->fs_info,
 			   "devinfo init for devid %llu failed: %d",
 			   device->devid, ret);
+		goto out;
+	}
+
+	/* Create devinfo/<devid>/scrub/ hierarchy */
+	device->scrub_kobj = kobject_create_and_add("scrub", &device->devid_kobj);
+	if (!device->scrub_kobj) {
+		ret = -ENOMEM;
+		btrfs_warn(device->fs_info,
+			   "scrub kobj init for devid %llu failed",
+			   device->devid);
+		goto out;
+	}
+	ret = sysfs_create_files(device->scrub_kobj, devid_scrub_attrs);
+	if (ret)
+		goto out;
+
+	device->scrub_lifetime_kobj = kobject_create_and_add("lifetime",
+							      device->scrub_kobj);
+	if (!device->scrub_lifetime_kobj) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	ret = sysfs_create_files(device->scrub_lifetime_kobj,
+				 devid_scrub_lifetime_attrs);
+	if (ret)
+		goto out;
+
+	device->scrub_session_kobj = kobject_create_and_add("session",
+							     device->scrub_kobj);
+	if (!device->scrub_session_kobj) {
+		ret = -ENOMEM;
+		goto out;
 	}
+	ret = sysfs_create_files(device->scrub_session_kobj,
+				 devid_scrub_session_attrs);
 
 out:
 	memalloc_nofs_restore(nofs_flag);
@@ -2346,6 +2902,36 @@ int btrfs_sysfs_add_mounted(struct btrfs_fs_info *fs_info)
 	if (ret)
 		goto failure;
 
+	/* Create /sys/fs/btrfs/<UUID>/scrub/{lifetime,session}/ hierarchy */
+	fs_info->scrub_kobj = kobject_create_and_add("scrub", fsid_kobj);
+	if (!fs_info->scrub_kobj) {
+		ret = -ENOMEM;
+		goto failure;
+	}
+	ret = sysfs_create_files(fs_info->scrub_kobj, scrub_attrs);
+	if (ret)
+		goto failure;
+
+	fs_info->scrub_lifetime_kobj = kobject_create_and_add("lifetime",
+							       fs_info->scrub_kobj);
+	if (!fs_info->scrub_lifetime_kobj) {
+		ret = -ENOMEM;
+		goto failure;
+	}
+	ret = sysfs_create_files(fs_info->scrub_lifetime_kobj, scrub_lifetime_attrs);
+	if (ret)
+		goto failure;
+
+	fs_info->scrub_session_kobj = kobject_create_and_add("session",
+							      fs_info->scrub_kobj);
+	if (!fs_info->scrub_session_kobj) {
+		ret = -ENOMEM;
+		goto failure;
+	}
+	ret = sysfs_create_files(fs_info->scrub_session_kobj, scrub_session_attrs);
+	if (ret)
+		goto failure;
+
 	return 0;
 failure:
 	btrfs_sysfs_remove_mounted(fs_info);
diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index 05498e5346c39..93da8ea06659e 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -41,6 +41,9 @@ int btrfs_sysfs_add_space_info_type(struct btrfs_space_info *space_info);
 void btrfs_sysfs_remove_space_info(struct btrfs_space_info *space_info);
 void btrfs_sysfs_update_devid(struct btrfs_device *device);
 
+int btrfs_sysfs_add_scrub_device(struct btrfs_device *device);
+void btrfs_sysfs_remove_scrub_device(struct btrfs_device *device);
+
 int btrfs_sysfs_add_one_qgroup(struct btrfs_fs_info *fs_info,
 				struct btrfs_qgroup *qgroup);
 void btrfs_sysfs_del_qgroups(struct btrfs_fs_info *fs_info);
-- 
2.48.1

