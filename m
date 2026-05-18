Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A0E3CF02C
	for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2026 09:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779098151; cv=none; b=EL2wrzGxO3mCxAoOQKq6pbYshRv7ayi4z7HnQrzwOdwZcFkLHzzrApOAtnmukQwHrz9gC99IrxrYUw4CdOtr9C6Lz8PEaxzZM5LKk0+ei3qCgY2MPaJX7D1WfWpX+fJjEbpD2ocwZ3xuCg/iVGQp5ihgoF3P4FoQmZDHy8Ifz2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779098151; c=relaxed/simple;
	bh=tDhYJvVCiAcrel6N+eV5UZ6wX8nvn75y8OCY18dfylQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dXzjZhDR6qggZcKEcfmo3KN/vOmUndiFOddKOQmfUsSlS750m0d37Blp5GVrfWWxXjzPLRavdpq7kUF2cTZLQC58Y3KcnWK6hjHNHGX29o+xRi2FwopSYKRoAWlcqvRh4fBHyKNiGlZEIe660JGJ2ARdAQ6cFZNVoxL3jvKgQMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=FXxan2Gd; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="FXxan2Gd"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1779098148; x=1810634148;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tDhYJvVCiAcrel6N+eV5UZ6wX8nvn75y8OCY18dfylQ=;
  b=FXxan2GdS6WX/5LcXh/+8Ks3ZOnYLjLVbuhUm8xGxJlOS13DuhV5GnL3
   8CO5J52BDMQAJmSBCTmeC8GIcG0ATgGvPGoA5jqAcT/k2juWoVUKTYC8H
   t8hA/hW+s8UnjJqDnuKHYEd31bi8R3tyhha5WDBOUTAP/KAaLLkdtbR4S
   DdecSUKk4sRnhIxgUzbVZ1jCzyaT/w0Lwx+oYfdMI2p9lTC3XrkrafAoy
   TZZPkYsCGjmRw06Ud1GIhgYF/m1HgV1fLSxc9MCHOQDCchNSgpC+tTjYt
   PES/kYHyZeoqSoNvttqvmpcDDaD371MLGYBj91t2IZ+4jXNGWKDRteaUh
   Q==;
X-CSE-ConnectionGUID: +ARCCbiaTiiiBCxfeIqCig==
X-CSE-MsgGUID: sDb5ZYQhTiOg1mYvEn4wRQ==
X-IronPort-AV: E=Sophos;i="6.23,241,1770566400"; 
   d="scan'208";a="146794127"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 May 2026 17:55:41 +0800
X-CSE-ConnectionGUID: OLI3qxMWQU6viSyQKMVzBA==
X-CSE-MsgGUID: 3c468EyoTJmBypoqISNCfQ==
IronPort-SDR: 6a0ae1ff_9Hh6qUiaViv5TkgBBQ+3qzfftCJvVfSbEX+EaNmoA88LtTd
 /+g+50cbZ/coalDIqgD8F56vq8BcSHAX9NNGluw==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 May 2026 02:55:10 -0700
X-CSE-ConnectionGUID: LBIl/mtPRs2+igun68ZSxA==
X-CSE-MsgGUID: u8ttG8nIRaKsSFe6+DpwLQ==
WDCIronportException: Internal
Received: from wdap-qxk27l9gfp.ad.shared (HELO neo.guest.cpihotels.com) ([10.224.28.58])
  by uls-op-esai1-o.wdc.com with ESMTP; 18 May 2026 02:55:09 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH] btrfs: zoned: always set max_active_zones for zoned devices
Date: Mon, 18 May 2026 11:55:03 +0200
Message-ID: <20260518095503.132430-1-johannes.thumshirn@wdc.com>
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
internal max_active_zones limit will stay at 0.

If a device doesn't report a number of max open or active zones and it has
less than BTRFS_DEFAULT_MAX_ACTIVE_ZONES, set the internal limit to the
number of zones on the device divided by 4.

Fixes: 04147d8394e8 ("btrfs: zoned: limit active zones to max_open_zones")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 0b80b498fb85..bdd6fac93c93 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -426,8 +426,10 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 
 	max_active_zones = min_not_zero(bdev_max_active_zones(bdev),
 					bdev_max_open_zones(bdev));
-	if (!max_active_zones && zone_info->nr_zones > BTRFS_DEFAULT_MAX_ACTIVE_ZONES)
-		max_active_zones = BTRFS_DEFAULT_MAX_ACTIVE_ZONES;
+	if (!max_active_zones)
+		max_active_zones = min(zone_info->nr_zones / 4,
+				       BTRFS_DEFAULT_MAX_ACTIVE_ZONES);
+
 	if (max_active_zones && max_active_zones < BTRFS_MIN_ACTIVE_ZONES) {
 		btrfs_err(fs_info,
 "zoned: %s: max active zones %u is too small, need at least %u active zones",
-- 
2.54.0

