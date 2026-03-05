Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E3D361DCE
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Mar 2026 10:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772705223; cv=none; b=C/7FQF7B0ymf1niWLb7gbdXZNdrM7IcoPqw3DZvYknlOJkZ1hU2SRcre+viqOoosaOTyw+yA74CchDfTrvhOyXR0bPuBsx1bs2jKfG+aexmJESvoFqoYvnw6yFW2Q9VsRjCcYN0jnG6mlSRjPBB8VaZLgWRgJnW6vlmE/EHTT+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772705223; c=relaxed/simple;
	bh=KzP+fj6x/qFTxkQu6hFsPzSJrh1cTbWcWuW9wzYQ5f8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRAIPnZcUm9NwREzal7QYjlchJMmE2m8YMIJ7v38I6yUbo6B10jA2/EyXdXSbGrZoF+ovuNv5WKyE09lEKzc4xtrg6p3i6eun4+EKWHL2VDhizz8x2S1NI6aAtlmN1tP8bRt2gvrH1xopAhxzaJpipSDg6JQEQJk2Wt/oVisVuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=YUltRIUI; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="YUltRIUI"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1772705220; x=1804241220;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KzP+fj6x/qFTxkQu6hFsPzSJrh1cTbWcWuW9wzYQ5f8=;
  b=YUltRIUIeT1vAYvYCNtfB+ilzaYxPWGrS5X4RuI3dm6a4xUY/+tTH/Su
   C34IBAG0r5+rAEM5gyNU+pFUokUGjtDVyIhFOyZRogaJ2hdo2xvezt4gl
   F+/vl3BG8nkhs8scrpAyILemGD+8lAlAGi0yMmCD4TEZaq+UPM00t0+fb
   HPLgxshHt2CBkM4AOf4MgDK28u90M+0o3VJbhtaS8/WRZ0lufgLZWQQmk
   /2P2mXQfCaWSlnMbFn57v525Z2K6wYynEJiHmp1ZUaFR1wKKfhrSmeI3u
   E6PCZreLlwE1gF9zFYyJWcQi1/wjxSDEuh8wrxwvsfHU47sFChL6zMajp
   w==;
X-CSE-ConnectionGUID: jHg8jb1ZQ4aJCsbvAwDf6A==
X-CSE-MsgGUID: ej0CZP2cSHS6xwaXkt4xyw==
X-IronPort-AV: E=Sophos;i="6.23,102,1770566400"; 
   d="scan'208";a="138339199"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 05 Mar 2026 18:06:54 +0800
IronPort-SDR: 69a955be_ha1zyPeqXvp+18w+3xgXZTKhqH/E1f7GN0dmMZrAE/esqYO
 aqRFt9Z7QiNHplmNfjsqvQGcu2xMB3+YzOPAkiA==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Mar 2026 02:06:55 -0800
WDCIronportException: Internal
Received: from wdap-bnfcsfsyyt.ad.shared (HELO neo.wdc.com) ([10.224.28.182])
  by uls-op-cesaip02.wdc.com with ESMTP; 05 Mar 2026 02:06:53 -0800
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Boris Burkov <boris@bur.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 2/3] btrfs: create btrfs_reclaim_block_groups()
Date: Thu,  5 Mar 2026 11:06:43 +0100
Message-ID: <20260305100644.356177-3-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260305100644.356177-1-johannes.thumshirn@wdc.com>
References: <20260305100644.356177-1-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Create a function btrfs_reclaim_block_groups() that gets called from the
block-group reclaim worker.

This allows creating synchronous block_group reclaim later on.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 4df076bd93f5..72fc9b3b6dc0 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2040,10 +2040,8 @@ static int btrfs_reclaim_block_group(struct btrfs_block_group *bg)
 	return ret;
 }
 
-void btrfs_reclaim_bgs_work(struct work_struct *work)
+static void btrfs_reclaim_block_groups(struct btrfs_fs_info *fs_info)
 {
-	struct btrfs_fs_info *fs_info =
-		container_of(work, struct btrfs_fs_info, reclaim_bgs_work);
 	struct btrfs_block_group *bg;
 	struct btrfs_space_info *space_info;
 	LIST_HEAD(retry_list);
@@ -2111,6 +2109,14 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
 	btrfs_exclop_finish(fs_info);
 }
 
+void btrfs_reclaim_bgs_work(struct work_struct *work)
+{
+	struct btrfs_fs_info *fs_info =
+		container_of(work, struct btrfs_fs_info, reclaim_bgs_work);
+
+	btrfs_reclaim_block_groups(fs_info);
+}
+
 void btrfs_reclaim_bgs(struct btrfs_fs_info *fs_info)
 {
 	btrfs_reclaim_sweep(fs_info);
-- 
2.53.0

