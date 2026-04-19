Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A243081BE
	for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2026 14:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776608797; cv=none; b=D8LIc9+PUmXOQqj0Li/cnBHLl2565t3utCvzFaLXqc+7SYYFsvQECsrJiQh2BPTCHxGw3nLXmGlCNzxInvATECkyY8bEjkO511zvc7Q5xUU04km8RbGDg8SKAdyuxzmg5UkCcBs+zwpNbaL2B4oBqWLp2TDVPi/cpY07vJ6vJ2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776608797; c=relaxed/simple;
	bh=zazQj1ToSNlzKmM5xjzQqqU6nSdT1rr10+kRFoNVRwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AT+JE3ot1qD0iJgA8TfTpQVE42J381QrHY2H8OS7fBalhVUivTspx/ffOIC5Ag4WXiewGYtHYfhxLkbT98aujRci/QeQC+VQ1as9DhDgzSG1HWvnlwL7mmMrTzZQOqYhb80pFddJurYBb6SXZ46JI7qJaAREYiUPplh5nQnvJpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GsEmEuE8; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GsEmEuE8"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b93698bb57aso411012166b.0
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2026 07:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776608795; x=1777213595; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4+yqN5cF9YATbBaKpJLZIzMolqoyLxiIOOo+fVmzeoU=;
        b=GsEmEuE858Ph6+fXt+Ho3oVZjA53sJKjvy781ot5CMmC/s4keSzGbf9ReXZGYN1gAu
         hCwjZ/dPQTr0Tzo6EZFujUs1S0kI9/vRonfMqFNARWnW9ljD3ihhxuXlz4ZUhaeB4qb9
         nuXRA3DrVlhFd99NVdmpZm0YcItb6NKG/hSTHND7uyxNY8HBFYVv3BE4lyh7BwlPj90g
         NtDRFkbVsrzTPa/xfCyDiNWAHxvR1KjbSfoH8uCWcC6zAfN10SeR1alaNpcSSZ1bYY/N
         qlGh+egdytUHk62MHW4O4j65CxZ1P8H4OoA1wI2aZaFxthaENHDYXvoSwQLX7HfAZs9A
         2H3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776608795; x=1777213595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4+yqN5cF9YATbBaKpJLZIzMolqoyLxiIOOo+fVmzeoU=;
        b=VBIusfcfIExYQ6HOtEd2HNlAIJOuL8LglyKiBHFuByj8qNujMpZ+XXhqsuLvrdayOw
         7QU4jLEJRUGRfte6LiywaxyC2Kfu2yGbvKEblyLhC1x6NvVL6q/aSkPaqpitIHykTm9b
         vptxpmY8JXti1K+1PwHlKG/FIB9FUbDcw0bkndAgVNjvktqRElEzo6hTUP9DtXNla7JQ
         uv7uFCg3YlNxvd8h5r/ftmtZUJSpBvy9kLgy8rCh8gIgCLQMwaBeP038bn0ZLNmhkhXa
         AuCwWU68+fAKwiZXDVnE5zEK27tctmWYyXlr2EByc5p1gquoP10lLXJk8wc+O57vDSye
         eg5A==
X-Gm-Message-State: AOJu0YxTeCMsTKP4f7/R1HLFJ2tz8xyjRdtnsx2DKalQMmtn+eARoXos
	nulYy/bT8GwNH/QdJYnUq72BB4bK+5BJc6RY/rrj3EyFg5vrz4X0RtTEl4pSEA==
X-Gm-Gg: AeBDievDGmu0X5gQ4RcDio3pLf1z1b9scUc0KWu4/S0YsHsgrVSSqCXDxcBtWEnPavG
	GuQLgOOAYEQgmysnEz/NKD3mqtVaCgIYOHJ20dGSAhTl7wRJBgimHWuWjVZ4ViGf+TxwSmjYsjk
	ayQLBNHsiNvqHZn7CKS5GV8WzDjyEZrBYHc4zrp6T8CavMBBkhTDurF1tMeHLD61oqnFbbdmJsR
	x+BsxsmwJ8/WI/CcNRYUakJhWTGqcDJMMyGyqbmPMB+R6KaLnHjD08NX/m7eayrX6nDkrFkh328
	5nAt0eUD8miLIWbuiM7f8/ddK+dW4oVGYvLSxIzltm8rcTATlgFORSCk9+pkQaQbbM6vEn2g2EN
	Lw0OGrJ+7u1SZkV6r/mD8akHSZ4X0RfaLOnndFOwcvCSjFt1xDeKaSQ8uurfxSJXkg3kaxjYkxo
	NIO5IHCq6q3Pa94eurxAeiQlmxOh3f+z/vvM9/7jUSLdtk/GgTXlvnzdhrB7ZJCQ==
X-Received: by 2002:a17:907:2d0f:b0:ba6:79c0:c743 with SMTP id a640c23a62f3a-ba679c0cceamr112492366b.11.1776608794421;
        Sun, 19 Apr 2026 07:26:34 -0700 (PDT)
Received: from TE-laptop.internal ([2a01:799:3a1:9700:10f5:c193:4430:919e])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-ba455046223sm258232666b.49.2026.04.19.07.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Apr 2026 07:26:34 -0700 (PDT)
From: Torstein Eide <torsteine@gmail.com>
X-Google-Original-From: Torstein Eide <torsteine+linux@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Torstein Eide <torsteine@gmail.com>
Subject: [PATCH 2/5] btrfs: add in-memory scrub lifetime and session fields
Date: Sun, 19 Apr 2026 16:26:14 +0200
Message-ID: <20260419142618.3147763-3-torsteine+linux@gmail.com>
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

Extend struct btrfs_device with two counter arrays and session metadata:

  scrub_stat_values[]    - lifetime totals, persisted across mounts via
                           the new BTRFS_SCRUB_STATS_OBJECTID tree item.
                           Protected by an atomic dirty counter
                           (scrub_stats_ccnt) and flushed at transaction
                           commit by btrfs_run_scrub_stats().

  scrub_session_values[] - per-run counters reset when a new scrub
                           starts; never written to disk.

  scrub_session_{t_start,t_end,last_physical,status} - timing and
                           progress metadata for the current or most
                           recent scrub session on this device.

Add matching kobject pointers (scrub_kobj, scrub_lifetime_kobj,
scrub_session_kobj) to both struct btrfs_device and struct btrfs_fs_info
for the sysfs hierarchy added in a later patch.

Add BTRFS_SCRUB_STATUS_* constants and the inline read/write helpers
btrfs_scrub_stat_{read,add,set}() and btrfs_scrub_session_read().
The add/set helpers include an smp_mb__before_atomic() to order stat
updates before the dirty-counter increment, pairing with the smp_rmb()
in btrfs_run_scrub_stats().

Signed-off-by: Torstein Eide <torsteine@gmail.com>
Assisted-by: Claude:claude-sonnet-4-6
---
 fs/btrfs/fs.h      |  5 +++
 fs/btrfs/volumes.h | 79 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+)

diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index a4758d94b32e9..c333e30c93e40 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -714,6 +714,11 @@ struct btrfs_fs_info {
 	struct kobject *qgroups_kobj;
 	struct kobject *discard_kobj;
 
+	/* For /sys/fs/btrfs/<UUID>/scrub/{lifetime,session}/ */
+	struct kobject *scrub_kobj;
+	struct kobject *scrub_lifetime_kobj;
+	struct kobject *scrub_session_kobj;
+
 	/* Track the number of blocks (sectors) read by the filesystem. */
 	struct percpu_counter stats_read_blocks;
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 0082c166af91f..e77f726928abd 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -200,6 +200,29 @@ struct btrfs_device {
 	atomic_t dev_stats_ccnt;
 	atomic_t dev_stat_values[BTRFS_DEV_STAT_VALUES_MAX];
 
+	/*
+	 * Scrub lifetime counters. Persisted via BTRFS_SCRUB_STATS_OBJECTID
+	 * tree items in the device tree; loaded at mount by
+	 * btrfs_init_scrub_stats(), flushed at commit by btrfs_run_scrub_stats().
+	 * Index values defined by BTRFS_SCRUB_STAT_* in btrfs_tree.h.
+	 */
+	int scrub_stats_valid;
+	atomic_t scrub_stats_ccnt;
+	atomic64_t scrub_stat_values[BTRFS_SCRUB_STAT_VALUES_MAX];
+
+	/*
+	 * Per-session scrub counters. Reset to zero when a new scrub starts on
+	 * this device. Never persisted to disk.
+	 */
+	atomic64_t scrub_session_values[BTRFS_SCRUB_STAT_VALUES_MAX];
+	/* Resume offset at end of session */
+	u64 scrub_session_last_physical;
+	/* Unix time (seconds) when the session started / ended (0 if idle) */
+	u64 scrub_session_t_start;
+	u64 scrub_session_t_end;
+	/* BTRFS_SCRUB_STATUS_* */
+	atomic_t scrub_session_status;
+
 	/*
 	 * Device's major-minor number. Must be set even if the device is not
 	 * opened (bdev == NULL), unless the device is missing.
@@ -211,6 +234,10 @@ struct btrfs_device {
 	struct completion kobj_unregister;
 	/* For sysfs/FSID/devinfo/devid/ */
 	struct kobject devid_kobj;
+	/* For sysfs/FSID/devinfo/devid/scrub/ hierarchy */
+	struct kobject *scrub_kobj;
+	struct kobject *scrub_lifetime_kobj;
+	struct kobject *scrub_session_kobj;
 
 	/* Bandwidth limit for scrub, in bytes */
 	u64 scrub_speed_max;
@@ -864,6 +891,58 @@ static inline void btrfs_dev_stat_set(struct btrfs_device *dev,
 	atomic_inc(&dev->dev_stats_ccnt);
 }
 
+/*
+ * Scrub session status values stored in device->scrub_session_status.
+ */
+#define BTRFS_SCRUB_STATUS_IDLE		0
+#define BTRFS_SCRUB_STATUS_RUNNING	1
+#define BTRFS_SCRUB_STATUS_FINISHED	2
+#define BTRFS_SCRUB_STATUS_CANCELED	3
+
+static inline u64 btrfs_scrub_stat_read(const struct btrfs_device *dev,
+					int index)
+{
+	return (u64)atomic64_read(&dev->scrub_stat_values[index]);
+}
+
+static inline void btrfs_scrub_stat_add(struct btrfs_device *dev,
+					int index, u64 val)
+{
+	atomic64_add((long long)val, &dev->scrub_stat_values[index]);
+	/*
+	 * Order the stat update before the dirty-counter increment so that
+	 * btrfs_run_scrub_stats() observes a consistent snapshot.  Pairs with
+	 * smp_rmb() in btrfs_run_scrub_stats().
+	 */
+	smp_mb__before_atomic();
+	atomic_inc(&dev->scrub_stats_ccnt);
+}
+
+static inline void btrfs_scrub_stat_set(struct btrfs_device *dev,
+					int index, u64 val)
+{
+	atomic64_set(&dev->scrub_stat_values[index], (long long)val);
+	/*
+	 * Order the stat update before the dirty-counter increment so that
+	 * btrfs_run_scrub_stats() observes a consistent snapshot.  Pairs with
+	 * smp_rmb() in btrfs_run_scrub_stats().
+	 */
+	smp_mb__before_atomic();
+	atomic_inc(&dev->scrub_stats_ccnt);
+}
+
+static inline u64 btrfs_scrub_session_read(const struct btrfs_device *dev,
+					   int index)
+{
+	return (u64)atomic64_read(&dev->scrub_session_values[index]);
+}
+
+int btrfs_init_scrub_stats(struct btrfs_fs_info *fs_info);
+int btrfs_run_scrub_stats(struct btrfs_trans_handle *trans);
+void btrfs_update_scrub_stats(struct btrfs_device *dev,
+			      const struct btrfs_scrub_progress *progress,
+			      int scrub_ret);
+
 static inline const char *btrfs_dev_name(const struct btrfs_device *device)
 {
 	if (!device || test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state))
-- 
2.48.1

