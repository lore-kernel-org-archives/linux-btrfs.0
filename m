Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCB43C5DBB
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 09:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779441761; cv=none; b=J37HLTGpTBtLWSJJN+kP/m15/21XJHYjV4pewJZrpOK3qHgbdnY6G1KTf9uewdVsgKvf/iMmwTRKUeISVjvny3Wou5E8Ck8Rty2m4uL9O1MNFl/K0fVSSH4ICCdoOt0FclCGEx1vAVbf0zFW5zNVG69u9phv5tHaGkSqadqrE1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779441761; c=relaxed/simple;
	bh=qiR3+/X8m4hThw7cEpsuD7qAartCaqzNczdQ5T9pLXk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U2l1Dni5IQyTDDVQP3UGR5BBfvobg/v2XfU/tyDIF8seyLpFJeQhGOxcXIq+VFKmnzpMHwWaFAxFybhO12ZZeCHM7Z4TLSVjlC6Lof4q4RkunXvdiVzswtm6HH4hU9xGuDn2DgXwCFGaUOkWSPcXWDaKgu07i9z3QRgZVfEHLY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=GLNMv32t; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="GLNMv32t"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1779441759; x=1810977759;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qiR3+/X8m4hThw7cEpsuD7qAartCaqzNczdQ5T9pLXk=;
  b=GLNMv32tPrxbUwp3sLDZv4OcmyyOROX2pMtK4pLYDLoTw7yMxUu8pU67
   6wWPSQaEjAupFEAoY02SlYiY0dLGewJ+5t6/AIm5Iq6LkGnLWkr834pE7
   Oj6Tm0PPWuh6wAkbu8GA5ZdeHaPIuNiRtT61+2UmOTMvctMkfTDko/tfH
   maQlYht8IwMM4gceOUtlebaQoRnuwWy2cveatJ6JK+fznmSZoNxtvc8Jf
   SHRG3FEbi3ZuUWYQg28Qrt0BRlNEl/ULK09RrWqyIEcwQPiBrKvKgoCHW
   xZRZeA39g11F1t0bxtCA1hXUcvsLSMe3Pf4x9HZJ8CmGLEmGsG9RLN0Im
   A==;
X-CSE-ConnectionGUID: FtrdQhTWRq+DubtnoNwz1A==
X-CSE-MsgGUID: 0LEyGDyXTI2kpf+aFNyJEQ==
X-IronPort-AV: E=Sophos;i="6.24,162,1774281600"; 
   d="scan'208";a="146528036"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 22 May 2026 17:22:33 +0800
X-CSE-ConnectionGUID: O9JbCIkqSrqVeYN7QIiPrw==
X-CSE-MsgGUID: i3aUQRBuTbWJ+dN8QdgfWg==
IronPort-SDR: 6a102049_02SIT/uIIXFkwg5fCOhSTXSZvfmrl6SqguhbkUJExoLafIv
 60qk2/WHe+Te5+EGsigAxAQXqSL7WDeTXE3uUjQ==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 May 2026 02:22:16 -0700
X-CSE-ConnectionGUID: Fr15mS1BQh2j0K+y823hdQ==
X-CSE-MsgGUID: tbY/TtfgRlOFlwWppi+bew==
WDCIronportException: Internal
Received: from wdap-b6euub3vgq.ad.shared (HELO neo.wdc.com) ([10.224.19.8])
  by uls-op-esai1-o.wdc.com with ESMTP; 22 May 2026 02:22:15 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH v4] btrfs: zoned: always set max_active_zones for zoned devices
Date: Fri, 22 May 2026 11:22:12 +0200
Message-ID: <20260522092212.31118-1-johannes.thumshirn@wdc.com>
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
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

---
Changes to v2:
- prefix error message with zoned, remove capitalisation and .

Changes to v2:
- Remove the now pointless 'if (max_active_zones)' before validating
  nr_active <= max_active_zones

Changes to v1:
- Check if the device has enough zones to run BTRFS
- Move all the setting to a seperate function
- Never run with less than BTRFS_MIN_ACTIVE_ZONES
---
 fs/btrfs/zoned.c | 63 +++++++++++++++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 0b80b498fb85..1a8c1078fa0a 100644
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
+		btrfs_err(device->fs_info, "zoned: not enough zones to mount filesystem");
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
@@ -517,26 +527,29 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 		goto out;
 	}
 
-	if (max_active_zones) {
-		if (unlikely(nactive > max_active_zones)) {
-			if (bdev_max_active_zones(bdev) == 0) {
-				max_active_zones = 0;
-				zone_info->max_active_zones = 0;
-				goto validate;
-			}
+	if (unlikely(nactive > zone_info->max_active_zones)) {
+		if (bdev_max_active_zones(bdev) > 0) {
 			btrfs_err(device->fs_info,
-			"zoned: %u active zones on %s exceeds max_active_zones %u",
-					 nactive, rcu_dereference(device->name),
-					 max_active_zones);
+					"zoned: %u active zones on %s exceeds max_active_zones %u",
+					nactive, rcu_dereference(device->name),
+					zone_info->max_active_zones);
 			ret = -EIO;
 			goto out;
 		}
+
+		/*
+		 * This is for backwards compatibility with old filesystems that
+		 * have a lot of active zones because the device doesn't report
+		 * a maximum number of zones and we previously didn't care for
+		 * the limit,
+		 */
+		zone_info->max_active_zones = 0;
+	} else {
 		atomic_set(&zone_info->active_zones_left,
-			   max_active_zones - nactive);
+				zone_info->max_active_zones - nactive);
 		set_bit(BTRFS_FS_ACTIVE_ZONE_TRACKING, &fs_info->flags);
 	}
 
-validate:
 	/* Validate superblock log */
 	nr_zones = BTRFS_NR_SB_LOG_ZONES;
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
-- 
2.54.0

