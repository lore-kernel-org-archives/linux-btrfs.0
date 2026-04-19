Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FC737C0F1
	for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2026 14:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776608797; cv=none; b=sWDFgzt+X1+wzCtYTYnhgoHKjOBXgq0UqYIh1gDlXdp2qtKQ74ycZBR55izbeOfHKRC6Y/1oM9MvcVeQ8i6rdRYv0urmdI8sKFM56mA6Z0DKq39fdekSwYYoiaIK9kYWD8NxkqWeUd2W3e4Gdwq6q7NKZlz/1gFG62mss0wjqfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776608797; c=relaxed/simple;
	bh=FzaBNssAatdDoVK47gn9sO7SQfXNjfSOzING7huuodM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KbFD+QcX/Purn765qZssITq+iVish4TIyIDVVKEgKIJLcOoPY+W/y4mrPMBWj4NlWbTrlUXYmKzuTX5kRnE3TR6jjiXXmSWa8GO/HQK92MKNGGvPxDbRk2LFZlla3TVgS5v3ooJqdCbojlnfVre767KIHdvIxn0E4b1rkt5FBTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eVJSxKvK; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eVJSxKvK"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ba3b9601b97so332110166b.2
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2026 07:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776608794; x=1777213594; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s3UePxNCI5hUAslEeh02mUbfz4qnsxejHziKeuRjT4Y=;
        b=eVJSxKvKCLsnXr3ZauBFDHJOZimT+Pi4nENszOKFl9GOvx6Xv07Y9gIxu/sDx8sfxJ
         UAI/MeIGpkHqMFpEb6yS44XFqjssbxPSQiLdUGAJSkuIJq+ijey/7JNrVlOrixg03X+m
         8TH54csqxyE6TWTLteCMnP3PDIjMQJ70fD3lfpG3sfayTChYOv7iHaUVAK10Ad+eXfB0
         rH6biMfIoerE/XUthhr7qbYedz3XFM/KYGMk7O6THSBhQ+LO/5P4Dvi5Be/xjVNzQBWA
         qmG4aHJtFQEYRkJRg+Ke+KTCvhzrRkn4KXBiPyB+VFM3i2fme9bQzpX47IAo9tckvfH8
         ijdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776608794; x=1777213594;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s3UePxNCI5hUAslEeh02mUbfz4qnsxejHziKeuRjT4Y=;
        b=F6L3F+XPiKCE4piOc6UM5Wo92YLDez9dnNsPxJlLwS27vg/wNQB/Ol+QczgS9IBsh9
         uT9yTU8B/paEHL8MtqLjlc+xkVWCZbib0fv2tiz0Y0DIvhBwVserz9X2BowTKx+hldS0
         ydpUK12iH2JwcNbczjDnZrhhr7zd4Kw87aP6kbrOfhEpgUVlJiOkSopfJoF1L+WeO8el
         Xolg70eYG/+fzcRZNR32UdqnaeThJ+HXhhMn74qpl21/F5A0lhxyGTlNSihms/JIVc15
         AHED74Epq59KHBKQ4lXIyGV8Sj3wDkZp/mveJX2rhyyJrnHq/YRjpVCq7ZMDApTewdeo
         pQEw==
X-Gm-Message-State: AOJu0YwPiLCz1BMsWYYWPrIb0rsyfdKHb1PJWyfeL3sktjS76mOFGHqT
	vCk2D3qIxh2vibPQF+pMzkU3YVNFmi07ye3R/M7bnoq0dg6w2D42uRYLZZNatg==
X-Gm-Gg: AeBDies6qYhLU7M0rC+5JIzh/7g+dJXNjg2IZbvoZwZ7GGBbegwF1cZBVYVDyOEg1tB
	4uDvSyFnKVRD9djF/QQUQZOk8iz+tYAh088lLViCwc3B/CAM3jdc27/UR63ek84qa6HoQP/Kb0w
	xIZM7MDjsnY93m01Ns5otatQ/C4N8VpDaLU6CkQJ4lCHoUSdwN75y9qnOSF2Fhu1bWCKiKU9H+H
	XW+uzuMABX2vYhmX0QqXNsL0NTb45TdOO4AF4VUGnaauaslm3LKooZp4u1HDmZ3ycVu9LjTQUFb
	wKq6oMw+QmsrxMciZAJVak9BchCppjHUNBBD6fRyOM4DqSuuRvBs8m+/stjBlTbXV79pXINM2t9
	TWlYsuYnXiyi8DAGt2PJy9s7vZP5LE0g76X4dSKzPKe9mH47AxOiFBxRu9JKCv3wDguOKo+BHs2
	UISdcLeN/KA4WpDU1ykCbWEV3/dHdn9GpyjNyb8jetaaUoEK8/7ZwaFi5g+Qj6Kg==
X-Received: by 2002:a17:906:7946:b0:ba2:7010:c535 with SMTP id a640c23a62f3a-ba41c0bb9c2mr441461266b.47.1776608793525;
        Sun, 19 Apr 2026 07:26:33 -0700 (PDT)
Received: from TE-laptop.internal ([2a01:799:3a1:9700:10f5:c193:4430:919e])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-ba455046223sm258232666b.49.2026.04.19.07.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Apr 2026 07:26:33 -0700 (PDT)
From: Torstein Eide <torsteine@gmail.com>
X-Google-Original-From: Torstein Eide <torsteine+linux@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Torstein Eide <torsteine@gmail.com>
Subject: [PATCH 1/5] btrfs: uapi: introduce on-disk scrub stats item
Date: Sun, 19 Apr 2026 16:26:13 +0200
Message-ID: <20260419142618.3147763-2-torsteine+linux@gmail.com>
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

Add a new persistent item type for per-device scrub lifetime counters:

  Key: (BTRFS_SCRUB_STATS_OBJECTID, BTRFS_PERSISTENT_ITEM_KEY, devid)

The item payload is struct btrfs_scrub_stats_item, an array of __le64
values indexed by BTRFS_SCRUB_STAT_* constants (data/tree extents and
bytes scrubbed, read/checksum/verify/malloc errors, etc.).

The array is designed to grow at the end; existing index values are
fixed and must not be renumbered.  New entries should be appended and
the item_size check in the reader handles shorter on-disk items from
older kernels gracefully.

Signed-off-by: Torstein Eide <torsteine@gmail.com>
Assisted-by: Claude:claude-sonnet-4-6
---
 include/uapi/linux/btrfs_tree.h | 34 +++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index cc3b9f7dccafa..7eb775b6b6253 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -82,6 +82,9 @@
 /* device stats in the device tree */
 #define BTRFS_DEV_STATS_OBJECTID 0ULL
 
+/* per-device scrub lifetime stats in the device tree */
+#define BTRFS_SCRUB_STATS_OBJECTID 1ULL
+
 /* for storing balance parameters in the root tree */
 #define BTRFS_BALANCE_OBJECTID -4ULL
 
@@ -1139,6 +1142,37 @@ struct btrfs_dev_stats_item {
 	__le64 values[BTRFS_DEV_STAT_VALUES_MAX];
 } __attribute__ ((__packed__));
 
+/*
+ * Scrub lifetime error counters, stored per device in the device tree.
+ * Key: (BTRFS_SCRUB_STATS_OBJECTID, BTRFS_PERSISTENT_ITEM_KEY, devid)
+ *
+ * Index values are defined by enum btrfs_scrub_stat_index in btrfs_tree.h
+ * (kernel-internal, not exposed via ioctl).
+ */
+#define BTRFS_SCRUB_STAT_DATA_EXTENTS_SCRUBBED		0
+#define BTRFS_SCRUB_STAT_TREE_EXTENTS_SCRUBBED		1
+#define BTRFS_SCRUB_STAT_DATA_BYTES_SCRUBBED		2
+#define BTRFS_SCRUB_STAT_TREE_BYTES_SCRUBBED		3
+#define BTRFS_SCRUB_STAT_READ_ERRORS			4
+#define BTRFS_SCRUB_STAT_CSUM_ERRORS			5
+#define BTRFS_SCRUB_STAT_VERIFY_ERRORS			6
+#define BTRFS_SCRUB_STAT_NO_CSUM			7
+#define BTRFS_SCRUB_STAT_CSUM_DISCARDS			8
+#define BTRFS_SCRUB_STAT_SUPER_ERRORS			9
+#define BTRFS_SCRUB_STAT_MALLOC_ERRORS			10
+#define BTRFS_SCRUB_STAT_UNCORRECTABLE_ERRORS		11
+#define BTRFS_SCRUB_STAT_CORRECTED_ERRORS		12
+#define BTRFS_SCRUB_STAT_UNVERIFIED_ERRORS		13
+#define BTRFS_SCRUB_STAT_VALUES_MAX			14
+
+struct btrfs_scrub_stats_item {
+	/*
+	 * Grow at the end for future enhancements; keep existing values
+	 * unchanged.  Index values defined by BTRFS_SCRUB_STAT_* above.
+	 */
+	__le64 values[BTRFS_SCRUB_STAT_VALUES_MAX];
+} __attribute__ ((__packed__));
+
 #define BTRFS_DEV_REPLACE_ITEM_CONT_READING_FROM_SRCDEV_MODE_ALWAYS	0
 #define BTRFS_DEV_REPLACE_ITEM_CONT_READING_FROM_SRCDEV_MODE_AVOID	1
 
-- 
2.48.1

