Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B665535AC33
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Jul 2026 07:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783062844; cv=none; b=VVwJ69FBOAwImfEJ+GKWEYXRUuSTJ9ddYkKrkww2T5ne4Fo8zTKWsMXD5x5LPUrZO5C92mpLGiOq+nIr9xFTf1cZf6xipxDDPNDKUuW7189MQqmRSnd+StOH0qLF0MGiwVEQZdlQs4PyzXnWo08OylLO0QYOjQ6xu6i/95QKBeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783062844; c=relaxed/simple;
	bh=T1Hi7WLPJIBMEj/KQnAat36kCmgIjKnSrfaHhxa9tpE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tpjgYBFBZzhRe5f2S5Mpeeuv6pDYzs/O6UPCxQKOQBkMUHr/MkUodG8I697kwCUTx68KizPIP5tw5Msn3oVtWpRTTb6qhL5NbASGt3FXe+4uYEHvijAcvs9nUY1ulB0uuNcnKVobb4K75yoMmuYwVJLbDVzNea7fLtNMktyR2w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=e5KpYeEE; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="e5KpYeEE"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783062842; x=1814598842;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=T1Hi7WLPJIBMEj/KQnAat36kCmgIjKnSrfaHhxa9tpE=;
  b=e5KpYeEEKPHOmM1h5yvFoBQw5kjWOayevRoxZrEm6rlMvVMVKn7kKVz+
   iW1HR5ca8hlboVmBMJRwpoS7KZL8HOxg/PQ/nWT76ZZ4eg/vnWZUhHvrI
   LEk9jPwXHoZI5UcVFI1QQkSAhZSMHmrx7c+PLwdKbALF5dxA0OzP0/wO3
   SpmitPN8czQ3oEqbEtmovdCQEF+DuueXdr1LRp6IWaf3zcE0JBaT6eJ54
   L5QPDr/CoGqe/SiaPqUhUAaVJmmVRl+9Ho4scEeExlVnfcugsKozly+O+
   3khlUCN6baj8+qh8qo7KhIV8JDBr4PQ5vpOAAmq7sE9FbzHoFC4GZmrSV
   Q==;
X-CSE-ConnectionGUID: g19kDiiFQdSZZ0S71YaM/A==
X-CSE-MsgGUID: N4uo9eaRTzG96G0u3v2cUA==
X-IronPort-AV: E=Sophos;i="6.25,145,1779120000"; 
   d="scan'208";a="151208858"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jul 2026 15:14:02 +0800
X-CSE-ConnectionGUID: RW+Q4aW9TFuTiZPCcwuGYA==
X-CSE-MsgGUID: BXgG8cyhSxKDojyyZuivhQ==
IronPort-SDR: 6a476123_lkeHR3Ga49x8pbJZKrSMyWIDdPJ+bRqqkczV4jr/ZUhb87e
 PF3k7EJL3fsUXTAjTj0Fd86Wjrq0ftazb+MJkrw==
Received: from uls-op-esai2-o.wdc.com ([10.248.3.38])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Jul 2026 00:13:38 -0700
X-CSE-ConnectionGUID: wH3YjiLlQr2+IbMwRjdQ4w==
X-CSE-MsgGUID: Sbi7uUEAR0qvGuV9OKHQuw==
WDCIronportException: Internal
Received: from cnd1221spb.ad.shared (HELO neo.wdc.com) ([10.224.28.133])
  by uls-op-esai2-o.wdc.com with ESMTP; 03 Jul 2026 00:13:38 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH] btrfs-progs: zoned: open host-managed devices with O_DIRECT for read-only
Date: Fri,  3 Jul 2026 09:13:35 +0200
Message-ID: <20260703071335.124167-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On host-managed zoned devices the page cache is not coherent with the
on-disk contents, so all IO must use O_DIRECT. Both device-open paths only
added O_DIRECT for O_RDWR opens, so read-only tools like "btrfs check" used
buffered IO and could read stale zero pages for one mirror of duplicated
metadata, reporting a spurious

	checksum verify failed on <bytenr> wanted 0x00000000 found 0xb6bde3e4

even though both copies are intact on disk.

Drop the O_RDWR condition so host-managed zoned devices always use
O_DIRECT, matching btrfstune.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 kernel-shared/disk-io.c | 2 +-
 kernel-shared/volumes.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel-shared/disk-io.c b/kernel-shared/disk-io.c
index 7f87e567..8b9c6dca 100644
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
index a54ea4dd..24971c09 100644
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

