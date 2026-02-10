Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423AF33D508
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2026 10:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770717685; cv=none; b=F/faHWdjqVw0xq/ux7GPB6yOvW+bUVXxpcrFOiSt9E3/DQL7cI3nSsH+n6fNQa7jQ2DIuraBwcVk+5guef86DyszCrLM0decq3UnakwGKgdXtIKdzW8aOTsnMYLheJ8fAoh5/pGOvebA2dNeoKpaRC+uEZTRqujv9SyEXVQCXNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770717685; c=relaxed/simple;
	bh=UaC8HwuNsthqNqvwjkFjqPuGLg18e4wnFZ9vfuRs+O8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=APj/384pZVkS50y1CdU+S/9qq9Wga0JFaHbXmcIi30qSgW9NAHp+AWHZngLCqVcJRckPPSWPTdOCGLapIXzK1bHQQsLfjlapPFL88lvP9NfOPHPHPqOVS/51gsmqrFfrk0LcExHExsxq8XIej1QBDL5tOlMiTcqcodJ+XfD8M7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=mpGsuGfW; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mpGsuGfW"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1770717684; x=1802253684;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UaC8HwuNsthqNqvwjkFjqPuGLg18e4wnFZ9vfuRs+O8=;
  b=mpGsuGfWXM/+xUG2ObWIml0fFpmIPyoPbQpx0TZFOHOVWmtsaUY4vpGn
   A5zhoxePdNm3upfFWmp/NTcfXY0zVX4Rgq32wvxB8fgNQU8KTTbltJ7BY
   Kjjdw0m57jtkw6LhC3j5DN/frgxd7MIEI1kT4Yq3Tw9Nju7ulb4gLpTou
   PBgiBixGfMwAlw4a1Tr1aj3OKV/itjEnnd1fKGWhSnSj6CEJaegitq1LX
   Gla+alUg7ZXDqZgICo+K8MYLYUYNEe2aP3/3icg6ZQi/TrFcTQQAYYMRk
   r0b+nghHA/QofzXCATWINRC5piwv2koVyJvkdsBEE4VPagFpoznpIqiDi
   Q==;
X-CSE-ConnectionGUID: IH5bKXqHTAKNiUrN2KYYvQ==
X-CSE-MsgGUID: DWe7+N7XTs2klT9vut36Ew==
X-IronPort-AV: E=Sophos;i="6.21,283,1763395200"; 
   d="scan'208";a="141056533"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Feb 2026 18:01:23 +0800
IronPort-SDR: 698b01f3_HE8Mie/touwzadaAzItbgEM/cabwy2R2FO0058YpXq1+r+c
 2/MwCoukNAM/GC+DWTe+nhghaJceVvbYHoIF8uQ==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Feb 2026 02:01:23 -0800
WDCIronportException: Internal
Received: from unknown (HELO neo.fritz.box) ([10.224.28.118])
  by uls-op-cesaip02.wdc.com with ESMTP; 10 Feb 2026 02:01:23 -0800
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH] btrfs: handle errors from cache_save_setup
Date: Tue, 10 Feb 2026 11:01:15 +0100
Message-ID: <20260210100115.235406-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While looking at call sites calling `if (TRANS_ABORTED(trans))` I
stumbled upon `cache_save_setup` and realized none of it's callers is
performing error handling.

Check if `cache_save_setup` returns an error and if yes handle it

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index e3e7852dd3e0..47a3ca76e304 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -3470,8 +3470,13 @@ int btrfs_setup_space_cache(struct btrfs_trans_handle *trans)
 	/* Could add new block groups, use _safe just in case */
 	list_for_each_entry_safe(cache, tmp, &cur_trans->dirty_bgs,
 				 dirty_list) {
-		if (cache->disk_cache_state == BTRFS_DC_CLEAR)
-			cache_save_setup(cache, trans, path);
+		if (cache->disk_cache_state == BTRFS_DC_CLEAR) {
+			int ret;
+
+			ret = cache_save_setup(cache, trans, path);
+			if (ret)
+				return ret;
+		}
 	}
 
 	return 0;
@@ -3558,7 +3563,9 @@ int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans)
 
 		should_put = 1;
 
-		cache_save_setup(cache, trans, path);
+		ret = cache_save_setup(cache, trans, path);
+		if (ret)
+			goto out;
 
 		if (cache->disk_cache_state == BTRFS_DC_SETUP) {
 			cache->io_ctl.inode = NULL;
@@ -3685,6 +3692,8 @@ int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans)
 	 */
 	spin_lock(&cur_trans->dirty_bgs_lock);
 	while (!list_empty(&cur_trans->dirty_bgs)) {
+		int ret2;
+
 		cache = list_first_entry(&cur_trans->dirty_bgs,
 					 struct btrfs_block_group,
 					 dirty_list);
@@ -3710,7 +3719,11 @@ int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans)
 		spin_unlock(&cur_trans->dirty_bgs_lock);
 		should_put = 1;
 
-		cache_save_setup(cache, trans, path);
+		ret2 = cache_save_setup(cache, trans, path);
+		if (ret2) {
+			btrfs_abort_transaction(trans, ret2);
+			return ret2;
+		}
 
 		if (!ret)
 			ret = btrfs_run_delayed_refs(trans, U64_MAX);
-- 
2.53.0

