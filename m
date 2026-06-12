Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC04131F98D
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2026 10:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258701; cv=none; b=gLa3k5WPhMWNOYxavUY48/Rj5De/vCZtJf0WMVmQvCPhGKHYFh74q3ecqrbVcqUpNo7ee/MsBmDM41gMyOWgkTEOwSDtcdsn8h2JVbrKwDgWNcOfgIhLlvavnp1louKfVavX4Xbkfe624kDOb7NdBGrlKQNqYGdPpX1U9pdw+Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258701; c=relaxed/simple;
	bh=Nat2qtbEppKyGLM+v+j2euhovn4HQeaQQXZDGzC6ew8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jZhfIkNGC5SbwLj5otB4DvSRg5zSejSz5T7rl0jZX+hF8N1sEr9ghTgzNGPMmLMDF0uIBAZOvVx9xjMKv8sZrISTjtL5R1+Uw+k2I/k3PpHADuLf+SMVDJY952hS1vobdj7WI2Lr2lMJQuRoCOmtdiozKbF15JOWuRSajzFou2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=fASx34Fy; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fASx34Fy"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781258700; x=1812794700;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Nat2qtbEppKyGLM+v+j2euhovn4HQeaQQXZDGzC6ew8=;
  b=fASx34FyHszloumG7HELVCuv2b8UNo1vF2uoEuTVcsIO06xwwsXCKi8p
   SnXQq+POwILcdo85eLOU2CGdbc8WXfTuF9Uaw/6IrKWCPkIBUiQ4Txhqv
   +IqrG6IhRuzSmLGv4K1KUP0sVXMLMeio0MY8f8LVteWmFa0F2nIDOL+Zc
   OqRtKSD4CadITH96qOwT/xll+Oft0QWjejok2dhOqyCo8tuXRtWDKwgoy
   3lMaeo+MGZt0Ih4Q8KXTUxwEZumbXpVQ0t4gCYnSMw2gewJXT8Ch/6Kjd
   FKv1LA8c1Fo0f0YDh3gNltcrA5aLfn5FGnx2ZFL+IwFwcL7faSC7qaiMV
   Q==;
X-CSE-ConnectionGUID: GA/SVBEYQSihVWXmjMilOA==
X-CSE-MsgGUID: fG87Up/XRimtvjlPnSgTKA==
X-IronPort-AV: E=Sophos;i="6.24,200,1774281600"; 
   d="scan'208";a="144863345"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jun 2026 18:04:54 +0800
X-CSE-ConnectionGUID: O9ZtkrNVS1SYtnh4UAU2cg==
X-CSE-MsgGUID: nfAS+AOVTfq0BeVmPhCd/g==
IronPort-SDR: 6a2bd9b1_3WoOhY7b0N/FX5d//xrmd33oKaX8XLv0N007/pnXHk2eelR
 Al/E4EVafOep9rbfbVthtbWfNobuU7YxzCwMkgA==
Received: from uls-op-esai2-o.wdc.com ([10.248.3.38])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Jun 2026 03:04:32 -0700
X-CSE-ConnectionGUID: 6jhKy/KJT4O6qQvaAPWNFg==
X-CSE-MsgGUID: TjlJLcrwTNWaFtawtzCckw==
WDCIronportException: Internal
Received: from wdap-kyufgunycc.ad.shared (HELO neo.wdc.com) ([10.224.19.10])
  by uls-op-esai2-o.wdc.com with ESMTP; 12 Jun 2026 03:04:32 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH] btrfs: zoned: don't force read-only on transient -EAGAIN from reloc merge
Date: Fri, 12 Jun 2026 12:04:29 +0200
Message-ID: <20260612100429.214341-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On a zoned FS, btrfs_delayed_refs_rsv_refill() returns -EAGAIN whenever
the over-committed metadata plus the zone_unusable bytes exceeds the
usable size in a metadata block-group to avoid heavy over-commit of
metadata and early ENOSPC in one transaction.

If this happens while doing reclaim, the transaction is getting
aborted.

Treat -EAGAIN as a soft, retryable condition in case of block-group
reclaim.

Reported-by: Damien Le Moal <damien.lemoal@wdc.com>
Fixes: 7bcb04de982f ("btrfs: zoned: cap delayed refs metadata reservation to avoid overcommit")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c | 11 ++++++++++-
 fs/btrfs/relocation.c  | 14 ++++++++++----
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index ab76a5173272..5fc0c20d8e51 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2047,6 +2047,13 @@ static int btrfs_reclaim_block_group(struct btrfs_block_group *bg, int *reclaime
 
 	trace_btrfs_reclaim_block_group(bg);
 	ret = btrfs_relocate_chunk(fs_info, bg->start, false);
+	if (ret == -EAGAIN) {
+		ASSERT(btrfs_is_zoned(fs_info));
+		btrfs_dec_block_group_ro(bg);
+		btrfs_debug(fs_info, "deferring reclaim of chunk %llu",
+			    bg->start);
+		return ret;
+	}
 	if (ret) {
 		btrfs_dec_block_group_ro(bg);
 		btrfs_err(fs_info, "error relocating chunk %llu",
@@ -2113,7 +2120,9 @@ void btrfs_reclaim_block_groups(struct btrfs_fs_info *fs_info, unsigned int limi
 		spin_unlock(&fs_info->unused_bgs_lock);
 		ret = btrfs_reclaim_block_group(bg, &reclaimed);
 
-		if (ret && !READ_ONCE(space_info->periodic_reclaim))
+		if (ret == -EAGAIN)
+			btrfs_link_bg_list(bg, &retry_list);
+		else if (ret && !READ_ONCE(space_info->periodic_reclaim))
 			btrfs_link_bg_list(bg, &retry_list);
 		btrfs_put_block_group(bg);
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 74687c75f763..b2dea3c3b23a 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1871,7 +1871,7 @@ int prepare_to_merge(struct reloc_control *rc, int err)
 }
 
 static noinline_for_stack
-void merge_reloc_roots(struct reloc_control *rc)
+int merge_reloc_roots(struct reloc_control *rc)
 {
 	struct btrfs_fs_info *fs_info = rc->extent_root->fs_info;
 	struct btrfs_root *root;
@@ -1971,7 +1971,8 @@ void merge_reloc_roots(struct reloc_control *rc)
 	}
 out:
 	if (ret) {
-		btrfs_handle_fs_error(fs_info, ret, NULL);
+		if (ret != -EAGAIN)
+			btrfs_handle_fs_error(fs_info, ret, NULL);
 		free_reloc_roots(&reloc_roots);
 
 		/* new reloc root may be added */
@@ -1996,6 +1997,7 @@ void merge_reloc_roots(struct reloc_control *rc)
 	 *
 	 * The remaining nodes will be cleaned up by put_reloc_control().
 	 */
+	return ret;
 }
 
 static void free_block_list(struct rb_root *blocks)
@@ -3725,7 +3727,9 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
 	 */
 	err = prepare_to_merge(rc, err);
 
-	merge_reloc_roots(rc);
+	ret = merge_reloc_roots(rc);
+	if (ret && !err)
+		err = ret;
 
 	rc->merge_reloc_tree = false;
 	unset_reloc_control(rc);
@@ -5694,7 +5698,9 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
 	if (ret)
 		goto out_unset;
 
-	merge_reloc_roots(rc);
+	ret = merge_reloc_roots(rc);
+	if (ret)
+		goto out_unset;
 
 	unset_reloc_control(rc);
 
-- 
2.54.0

