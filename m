Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739F33CF032
	for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2026 07:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779175025; cv=none; b=JgOeZUyYCWjqq6wOF5DcNHiqW2ywTmSqWZ5kCW7mv4Iz9lgR05VnXXzDu67nUKSf/55PTwWHImkNll7TUoOPfXXdQbAaaiTWka6tRW6YhGjrfxZlrDzRrzMZOyhuYQHbIMYE3l7qtFTinhtBgDpRRmSbCQxzwM2va6y9isRQkH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779175025; c=relaxed/simple;
	bh=IDOWPMx9poZUU5ejhELrp/9OFob5hzfK4NbW0Ujqt1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPpieRvpgdeMR9YdSjbZ3gKdgF0tcqpiqIT5/L9txac+gO6npWHlWDCYOhvdGLCxKCt3pJaG99ESJloa5r3tW5g4XN3LTCjom9gN8/jhyJaO2YESZzwD6ML7BdIPjrb0ls0aNVK/Co0ZpS/6qun21NuPuKL7BebtjSFRvzG89Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=NAc53O5a; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="NAc53O5a"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1779175021; x=1810711021;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IDOWPMx9poZUU5ejhELrp/9OFob5hzfK4NbW0Ujqt1g=;
  b=NAc53O5a6rq19LKgPn+VPWQfREyiCjMyybVfBy6T3NUlBQtvW8KHWWM/
   xjWfCzkLQccOUG5WI5LNY7cccE/nj0VVRYcmKYLLaY5VhVV+udCwCOg7q
   dPOoTKCg2KP55piLL7F2+fvxuaiPVBmgM8jizdoBsNn9Vazu88Oese3Qr
   qqcyvRi3Fu3E8Yr1Ld0b8Cm6Hhq+Fzv+9wuI/aIT/HQoPgi5nxyyI9iHr
   PxDXflGsjBlD1yns/zoa0MlPDQydk7SCESPeuYIvAO+yWkAIGaA/gx2cm
   8YYaJgoZL6VqiiD75tWMarpibn5gBKkZX1B/bLKa231GP0NCczXPFy7uM
   g==;
X-CSE-ConnectionGUID: 5c4VoEy+SJGQPs2T3Yp1AQ==
X-CSE-MsgGUID: /4K2yXi6QwiVHazfTB3fTA==
X-IronPort-AV: E=Sophos;i="6.23,243,1770566400"; 
   d="scan'208";a="147243130"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 May 2026 15:16:51 +0800
X-CSE-ConnectionGUID: n4FnmtajQO6aoSveWb84YA==
X-CSE-MsgGUID: HQVAaH76Q5W4Hu/B+ugEdA==
IronPort-SDR: 6a0c0e50_BpjmLwIzUEOGEJm+5qT/71gMu3HkVszIUvUl31HgZZBunhz
 9+eECchiXmd7sXNCNInVwOqGLt8yWxOvUx9ba9w==
Received: from uls-op-esai2-o.wdc.com ([10.248.3.38])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 May 2026 00:16:32 -0700
X-CSE-ConnectionGUID: cAyWXDOLR2yw71qaXsZCgA==
X-CSE-MsgGUID: jjLoCRyGTZOeY1rd9srquA==
WDCIronportException: Internal
Received: from wdap-io7kepqecw.ad.shared (HELO neo.fritz.box) ([10.224.19.18])
  by uls-op-esai2-o.wdc.com with ESMTP; 19 May 2026 00:16:30 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 2/2] btrfs: zoned: reflow max_active vs active checking
Date: Tue, 19 May 2026 09:16:21 +0200
Message-ID: <20260519071621.56490-3-johannes.thumshirn@wdc.com>
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

Reflow the checking of max_active_zones vs number of active zones, this
simplifies the code and gets rid of a goto.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index b1d0e2414178..9653681a6954 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -528,22 +528,28 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 	}
 
 	if (unlikely(nactive > zone_info->max_active_zones)) {
-		if (bdev_max_active_zones(bdev) == 0) {
-			zone_info->max_active_zones = 0;
-			goto validate;
+		if (bdev_max_active_zones(bdev) > 0) {
+			btrfs_err(device->fs_info,
+					"zoned: %u active zones on %s exceeds max_active_zones %u",
+					nactive, rcu_dereference(device->name),
+					zone_info->max_active_zones);
+			ret = -EIO;
+			goto out;
 		}
-		btrfs_err(device->fs_info,
-				"zoned: %u active zones on %s exceeds max_active_zones %u",
-				nactive, rcu_dereference(device->name),
-				zone_info->max_active_zones);
-		ret = -EIO;
-		goto out;
+
+		/*
+		 * This is for backwards compatibility with old filesystems that
+		 * have a lot of active zones because the device doesn't report
+		 * a maximum number of zones and we previously didn't care for
+		 * the limit,
+		 */
+		zone_info->max_active_zones = 0;
+	} else {
+		atomic_set(&zone_info->active_zones_left,
+				zone_info->max_active_zones - nactive);
+		set_bit(BTRFS_FS_ACTIVE_ZONE_TRACKING, &fs_info->flags);
 	}
-	atomic_set(&zone_info->active_zones_left,
-			zone_info->max_active_zones - nactive);
-	set_bit(BTRFS_FS_ACTIVE_ZONE_TRACKING, &fs_info->flags);
 
-validate:
 	/* Validate superblock log */
 	nr_zones = BTRFS_NR_SB_LOG_ZONES;
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
-- 
2.54.0

