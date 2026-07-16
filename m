Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6AC41A55E
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Jul 2026 11:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784201331; cv=none; b=mW7R0Vqmn44Tlnoj+RKVRbbC94foDkD5F92Dxx2OQSGwBybWGyuAf4ORrfEwIOgRk6UZr4Ase4lyfTw2IXseNqXDyRITM4/t0JhiJgT3Y8ZGdO8iH62oKwCSfJRS3KDKKK5BZbcikzKkQdhEx/h7xSui3OPc7XqmJLtC3k6B6J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784201331; c=relaxed/simple;
	bh=lGVRG07Me+3mNF9gaYEHlOyBQ9PD9JvsHZuNm34RNto=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jMLTn0t2XYojGqw50V0nJLi8QQvx5KVstMNlxh8Gx91U/z9ydh3IlSD3psLlnaF90lg+xmtzk883M6KZoDoRo2dm/Rr1tzpZRh0IUje6/fYx6FFXdcVWmi9cXZpFojjtGtAFaXroAWSN46qb/w8S4vJjnI9jd0wlhuJesCZz/J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=SCC0horX; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="SCC0horX"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784201330; x=1815737330;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=lGVRG07Me+3mNF9gaYEHlOyBQ9PD9JvsHZuNm34RNto=;
  b=SCC0horXxAjCB8rl+MRXNsOjicv+NDPrprkukl9zXF/gWHUnCxfeduiw
   I6ElqHbnM/Q4/FFexwffIgzD3bNfrTyjTmLVPZIktftOAYGsnnlN+kBfq
   n5OCuw4H5MeBU8Z3WdWmaxGXJ5zjfduyhPu8TV3xcpAMZ/nebAt0oI+zm
   M9E8S531P4xnfaTFY8TCVfATvH+Nzdgzm6/xZxyi+PB4xjAz9vpjfIoTt
   2nWAO+Y+XUwJREgFjhWu8PnD93sC7ajxpKo0KBpT1sPqJBNKPQk0LcNqG
   NrzVcR+jLOARvvY7w0u2wdoj7Wa3tXcV2d0RQCmlRp2BG4ZRm8I4Oozxh
   g==;
X-CSE-ConnectionGUID: hPmVG/SPQfqNw9X9k5W2Bw==
X-CSE-MsgGUID: 1YDYhd/GQrWBxfl8DpPMvA==
X-IronPort-AV: E=Sophos;i="6.25,167,1779120000"; 
   d="scan'208";a="152058033"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 16 Jul 2026 19:28:49 +0800
X-CSE-ConnectionGUID: CXtyJRSPQZeqUXkK7bko0A==
X-CSE-MsgGUID: xOIUlXQyRy6mnz7vZZgLpw==
IronPort-SDR: 6a58c057_BwlXc19xjOZlXzc6O9UvNlImnYj48Fyg2aYQLTTSnrjXu+p
 oHPzOWaop1m8rOK6HOgioEJ373Bk01aXaFoJaag==
Received: from uls-op-esai2-o.wdc.com ([10.248.3.38])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Jul 2026 04:28:23 -0700
X-CSE-ConnectionGUID: Ow2oFZaPRYC7r9r/tpsXbA==
X-CSE-MsgGUID: XiGfmBEyRuaI721JCRo+Nw==
WDCIronportException: Internal
Received: from wdap-fln31fg1cp.ad.shared (HELO neo.wdc.com) ([10.224.28.153])
  by uls-op-esai2-o.wdc.com with ESMTP; 16 Jul 2026 04:28:22 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <wqu@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2] btrfs-progs: zoned: open host-managed devices with O_DIRECT for read-only
Date: Thu, 16 Jul 2026 13:28:19 +0200
Message-ID: <20260716112819.1315467-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On host-managed zoned block devices the page cache cannot be used for
writing to the device because it does not guarantee ordering, therefore
direct I/O is used to write any on-disk data structures.

But reading in btrfs-progs is still performed using buffered I/O. This
mix of direct and buffered I/O can lead to stale page cache entries
being handed off to btrfs-progs and tools like "btrfs check" can report
spurious errors like:

	checksum verify failed on <bytenr> wanted 0x00000000 found 0xb6bde3e4

even though both copies are intact on disk.

Drop the O_RDWR condition so host-managed zoned devices always use
O_DIRECT, matching btrfstune.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
Changes to v1:
- reworded commit message

 kernel-shared/disk-io.c | 2 +-
 kernel-shared/volumes.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel-shared/disk-io.c b/kernel-shared/disk-io.c
index 7f87e567f0b1..8b9c6dcac967 100644
--- a/kernel-shared/disk-io.c
+++ b/kernel-shared/disk-io.c
@@ -1722,7 +1722,7 @@ struct btrfs_fs_info *open_ctree_fs_info(struct open_ctree_args *oca)
 	if (!(oca->flags & OPEN_CTREE_WRITES))
 		oflags = O_RDONLY;

-	if ((oflags & O_RDWR) && zoned_model(oca->filename) == ZONED_HOST_MANAGED)
+	if (zoned_model(oca->filename) == ZONED_HOST_MANAGED)
 		oflags |= O_DIRECT;

 	fp = open(oca->filename, oflags);
diff --git a/kernel-shared/volumes.c b/kernel-shared/volumes.c
index f35b59bcc20e..e2b6708ad872 100644
--- a/kernel-shared/volumes.c
+++ b/kernel-shared/volumes.c
@@ -697,7 +697,7 @@ int btrfs_open_devices(struct btrfs_fs_info *fs_info,
 			continue;
 		}

-		if ((flags & O_RDWR) && zoned_model(device->name) == ZONED_HOST_MANAGED)
+		if (zoned_model(device->name) == ZONED_HOST_MANAGED)
 			flags |= O_DIRECT;

 		fd = open(device->name, flags);
--
2.54.0

