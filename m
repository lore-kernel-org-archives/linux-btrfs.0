Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B09F220698
	for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2026 13:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779112740; cv=none; b=qF3bWUxw+T4WDWkmnhIs4UJE6CzOapTcZNmJInzpvggIQeLNC82KH5V/jEqW5NmDpfvgspcVx25pEHXuIBZsqWqjcK0uqdDRt6C7gnlQJqAMOoNCMmVtgdTOxYWPHIPm7Nh/Vobr2FPQk5vINav+XDCHPAfKSyRy6qXFTDNSILQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779112740; c=relaxed/simple;
	bh=SqFeztrGFwa08sKDajYqDO+xMkeFeUkZxBPPvaBvHZM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gSax91vYPnT+XXX1JOGJTAT3Ckl7ZkE+c+jAg3MaNeJsfwzszHXsFBa6sOuktfBPVpxElKUoRmb37INIGPdcjD9gjOdG+dP7jkrjYLl9WtSlG1avf9/fzeLAhvg1nGGdtpdMlwoBo8nD0/UhRdfJmtCDN8sFJaNlLUIBWaGC3Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=WaNhO68+; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="WaNhO68+"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1779112739; x=1810648739;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=SqFeztrGFwa08sKDajYqDO+xMkeFeUkZxBPPvaBvHZM=;
  b=WaNhO68+zeOEJLXYB3GPt5ujKTOqYo2UUGgsBBbyeYJ/rJSGiurcUEmI
   nV9WGmCvsyh8dS/8vYFx0N9WhXYHkztRCZtZtwJTXgw6qU7+J0KuyAHNJ
   00IBnEWdm+Tdz/XjhuhPnKP1nTzCC27JypdJba3yBqb5OLaA6l+UJW/7L
   rD0f9/UydNuwAsuvKaRBqBJhEo7OISOZQnAk0ubz3fwwfOq80THFIjOii
   hSDJ+4zfw8t9pXQ8T8xcffl8YC72V0OoqOh1r5HVHBKG5LLRH6znryP/0
   X1M+awNzgi7az397tEPtdkAeuC4EdjGKZue13O+xIZLEURKYL0PfC2H7g
   A==;
X-CSE-ConnectionGUID: I0ZVm05xTOm6SdCKEuCFiw==
X-CSE-MsgGUID: 0saG2MqORpiP7GJeI7ntyg==
X-IronPort-AV: E=Sophos;i="6.23,242,1770566400"; 
   d="scan'208";a="145678160"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 May 2026 21:58:58 +0800
X-CSE-ConnectionGUID: 9YDQ2SPYRDiLxdid3f/Ugg==
X-CSE-MsgGUID: UY1gbE1DRPqMLxZgRh2Lvg==
IronPort-SDR: 6a0b1b04_Deuh+N/piFnVz/U+jwY2QipSlI1vxI0AIMxPJy9VEd9aMC4
 DAFfA/l57/5bWhshnnh3RZzUWROumm3yM7VByPg==
Received: from uls-op-esai2-o.wdc.com ([10.248.3.38])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 May 2026 06:58:27 -0700
X-CSE-ConnectionGUID: IfOy84V6TDCWx/OZcpcXpw==
X-CSE-MsgGUID: PuV5bw+oToW2IJ4Uu7oUAg==
WDCIronportException: Internal
Received: from wdap-9p2qshykbp.ad.shared (HELO neo.guest.cpihotels.com) ([10.224.28.59])
  by uls-op-esai2-o.wdc.com with ESMTP; 18 May 2026 06:58:28 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2] btrfs: zoned: always set max_active_zones for zoned devices
Date: Mon, 18 May 2026 15:58:24 +0200
Message-ID: <20260518135824.202728-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
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
Changes to v1:
- Check if the device has enough zones to run BTRFS
- Move all the setting to a seperate function
- Never run with less than BTRFS_MIN_ACTIVE_ZONES
---
 fs/btrfs/zoned.c | 45 +++++++++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 0b80b498fb85..dcdd022f7009 100644
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
@@ -517,22 +527,21 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 		goto out;
 	}
 
-	if (max_active_zones) {
-		if (unlikely(nactive > max_active_zones)) {
+	if (zone_info->max_active_zones) {
+		if (unlikely(nactive > zone_info->max_active_zones)) {
 			if (bdev_max_active_zones(bdev) == 0) {
-				max_active_zones = 0;
 				zone_info->max_active_zones = 0;
 				goto validate;
 			}
 			btrfs_err(device->fs_info,
 			"zoned: %u active zones on %s exceeds max_active_zones %u",
 					 nactive, rcu_dereference(device->name),
-					 max_active_zones);
+					 zone_info->max_active_zones);
 			ret = -EIO;
 			goto out;
 		}
 		atomic_set(&zone_info->active_zones_left,
-			   max_active_zones - nactive);
+			   zone_info->max_active_zones - nactive);
 		set_bit(BTRFS_FS_ACTIVE_ZONE_TRACKING, &fs_info->flags);
 	}
 
-- 
2.54.0

