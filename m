Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D609B3CF692
	for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2026 07:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779175023; cv=none; b=EtAcEvwq9MavFX3n2sOeAHiMIH5fTVqUw1w9HEvRYXEiOJhA6RrPcE7XtISWWhyOON4ODKu/b6mnTYdHn5chYYSyKOxaEZp5hkx7/NaFWkw+ipdcbKO/QMeSnIrQ1YPjzxrbtmWrVKCZn4JQ+dZnOflX8b+KEAlAE15vFm0SAKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779175023; c=relaxed/simple;
	bh=hZj5F0yT63BEz2Lb8w/t0ek96egX2pE5VIMvWo7cnR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gh6izm+bqh326FKypd+WAuy6FZwgdr/zAa1idtsWyffP0a7rWHb80mtVfBFxjvwkbvHiIIMFbQUs72eqhe4v5k0kF2YwDm31nHCmM2v7IIlsQBKF64TX/NG7gb7box2Ke6qSQC2wz4DUa762rN3crvYXQf9EtDiqoVNUkiNBkes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=nab/MGs4; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="nab/MGs4"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1779175021; x=1810711021;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hZj5F0yT63BEz2Lb8w/t0ek96egX2pE5VIMvWo7cnR4=;
  b=nab/MGs4eDBR66VLddDUS2wcA97nGwSP5Wh1O5g/k4Df0UOAKIZiQ8A5
   7pyisUM1zReE41Qg4fZKaP6eS+Qretzo0+T8Kj583ZtR5z/a0qMdHPQC0
   gTgf+fK1zz9tAITmQ/Vbv8Wi0wJxBCwOQXpKgeOd2kxnqwGegCYmKztjb
   sQ8GsrlE1VbjKEEN4e8Iuz3jdOTyK8layQoRFZhYrAdWybdtExxUzDzB6
   Vi7hI175K/uDJ4Bj/ySPsvETI/sLqescm2CUqskivkNEuGFhKC/+G2u8G
   5P8OkU7wVx/XMt7GJFswYck71m81B5L5jkzNgdHKzIqw6zuGbDx9VtUIP
   g==;
X-CSE-ConnectionGUID: f5oAxPptRsiPyLNuZwLsKg==
X-CSE-MsgGUID: guOA3mOOQcKVgbX4zZm2Rw==
X-IronPort-AV: E=Sophos;i="6.23,243,1770566400"; 
   d="scan'208";a="147243129"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 May 2026 15:16:51 +0800
X-CSE-ConnectionGUID: OKEHTzFZTt25cvPZv7fpEQ==
X-CSE-MsgGUID: NVoG5pOcTYuIN6Tp2jlalg==
IronPort-SDR: 6a0c0e4e_hh1kugFMULJRRRo2vdXQobImO8sS7ToChfQuPikFdZiE+ad
 wlnuNHtyc9+TFEkBuT1gHLc3XJILQ6qmaKVCCmQ==
Received: from uls-op-esai2-o.wdc.com ([10.248.3.38])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 May 2026 00:16:30 -0700
X-CSE-ConnectionGUID: LkPIac1ZSWi1TdBUjh+O2A==
X-CSE-MsgGUID: kYJ1lqxgQmuZgO7OCQ780A==
WDCIronportException: Internal
Received: from wdap-io7kepqecw.ad.shared (HELO neo.fritz.box) ([10.224.19.18])
  by uls-op-esai2-o.wdc.com with ESMTP; 19 May 2026 00:16:28 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 1/2] btrfs: zoned: always set max_active_zones for zoned devices
Date: Tue, 19 May 2026 09:16:20 +0200
Message-ID: <20260519071621.56490-2-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260519071621.56490-1-johannes.thumshirn@wdc.com>
References: <20260519071621.56490-1-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a block device does not report a maximum number of open or active
zones, btrfs currently assigns BTRFS_DEFAULT_MAX_ACTIVE_ZONES (128) to the
internal limit, if the device has more than BTRFS_DEFAULT_MAX_ACTIVE_ZONES
zones.

But if the device has less than BTRFS_DEFAULT_MAX_ACTIVE_ZONES the
internal max_active_zones limit will stay at 0, even if the device has
zone resource limits. Furthermore, if the device has a total number of
zones that is less than BTRFS_DEFAULT_MAX_ACTIVE_ZONE, max_active_zones
should be set to at most the the number of zones.

Also move the max_active_zone calculation and setting into a dedicated
helper, to shrink btrfs_get_dev_zone_info().

Fixes: 04147d8394e8 ("btrfs: zoned: limit active zones to max_open_zones")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 65 +++++++++++++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 0b80b498fb85..b1d0e2414178 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -354,12 +354,32 @@ int btrfs_get_dev_zone_info_all_devices(struct btrfs_fs_info *fs_info)
 	return ret;
 }
 
+static int btrfs_get_max_active_zones(struct btrfs_device *device,
+				       struct btrfs_zoned_device_info *zone_info)
+{
+	struct block_device *bdev = device->bdev;
+	int max_active_zones;
+
+	if (zone_info->nr_zones < BTRFS_MIN_ACTIVE_ZONES) {
+		btrfs_err(device->fs_info, "Not enough zones to mount filesystem.");
+		return -EINVAL;
+	}
+
+	max_active_zones = min_not_zero(bdev_max_active_zones(bdev),
+					bdev_max_open_zones(bdev));
+	if (!max_active_zones)
+		max_active_zones = min(zone_info->nr_zones / 4,
+				       BTRFS_DEFAULT_MAX_ACTIVE_ZONES);
+
+	zone_info->max_active_zones = max(max_active_zones, BTRFS_MIN_ACTIVE_ZONES);
+	return 0;
+}
+
 int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 {
 	struct btrfs_fs_info *fs_info = device->fs_info;
 	struct btrfs_zoned_device_info *zone_info = NULL;
 	struct block_device *bdev = device->bdev;
-	unsigned int max_active_zones;
 	unsigned int nactive;
 	sector_t nr_sectors;
 	sector_t sector = 0;
@@ -424,19 +444,9 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 	if (!IS_ALIGNED(nr_sectors, zone_sectors))
 		zone_info->nr_zones++;
 
-	max_active_zones = min_not_zero(bdev_max_active_zones(bdev),
-					bdev_max_open_zones(bdev));
-	if (!max_active_zones && zone_info->nr_zones > BTRFS_DEFAULT_MAX_ACTIVE_ZONES)
-		max_active_zones = BTRFS_DEFAULT_MAX_ACTIVE_ZONES;
-	if (max_active_zones && max_active_zones < BTRFS_MIN_ACTIVE_ZONES) {
-		btrfs_err(fs_info,
-"zoned: %s: max active zones %u is too small, need at least %u active zones",
-				 rcu_dereference(device->name), max_active_zones,
-				 BTRFS_MIN_ACTIVE_ZONES);
-		ret = -EINVAL;
+	ret = btrfs_get_max_active_zones(device, zone_info);
+	if (ret)
 		goto out;
-	}
-	zone_info->max_active_zones = max_active_zones;
 
 	zone_info->seq_zones = bitmap_zalloc(zone_info->nr_zones, GFP_KERNEL);
 	if (!zone_info->seq_zones) {
@@ -517,24 +527,21 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 		goto out;
 	}
 
-	if (max_active_zones) {
-		if (unlikely(nactive > max_active_zones)) {
-			if (bdev_max_active_zones(bdev) == 0) {
-				max_active_zones = 0;
-				zone_info->max_active_zones = 0;
-				goto validate;
-			}
-			btrfs_err(device->fs_info,
-			"zoned: %u active zones on %s exceeds max_active_zones %u",
-					 nactive, rcu_dereference(device->name),
-					 max_active_zones);
-			ret = -EIO;
-			goto out;
+	if (unlikely(nactive > zone_info->max_active_zones)) {
+		if (bdev_max_active_zones(bdev) == 0) {
+			zone_info->max_active_zones = 0;
+			goto validate;
 		}
-		atomic_set(&zone_info->active_zones_left,
-			   max_active_zones - nactive);
-		set_bit(BTRFS_FS_ACTIVE_ZONE_TRACKING, &fs_info->flags);
+		btrfs_err(device->fs_info,
+				"zoned: %u active zones on %s exceeds max_active_zones %u",
+				nactive, rcu_dereference(device->name),
+				zone_info->max_active_zones);
+		ret = -EIO;
+		goto out;
 	}
+	atomic_set(&zone_info->active_zones_left,
+			zone_info->max_active_zones - nactive);
+	set_bit(BTRFS_FS_ACTIVE_ZONE_TRACKING, &fs_info->flags);
 
 validate:
 	/* Validate superblock log */
-- 
2.54.0

