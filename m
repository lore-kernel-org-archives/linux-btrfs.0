Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145611FC7FB
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2026 06:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781592738; cv=none; b=spl2Gb0e2+bWbg5GoCCiDhfp3UoSENcUgAlRbRoAsEkChsOoMj5DtN6hZJ3DXma5sSU/DSx4wF2lTydmVhQDFsdxwxJfU+7Nkzg7XL0NSbeR0e14GiQawfkjgYdvuzdmuzFK8c6DZqgzxNs58W2ibJEzJ+X31P4+iZLR5bFxEac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781592738; c=relaxed/simple;
	bh=SY2dfqTqYLqEx3o7ACNfRbAAvtg0VWEz0YlfRyfMULc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tuQF6vMUgX3LORXVmN4TOf0JVhKoqoMmqYAX4dPynxglmaTCLhxT7SBnV0FOQmCOb7bt5wKg8bCSMTUPuVkiSVDdwpqNnJcE6VjfCvvFqhNJuSyNCBGbIJfQ9H7J1kiWQTdk9gaYnTmXTfY1J5HhQE3vStvFSosBOJ67V+JxmxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=quqLRYhV; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="quqLRYhV"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781592736; x=1813128736;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=SY2dfqTqYLqEx3o7ACNfRbAAvtg0VWEz0YlfRyfMULc=;
  b=quqLRYhVQuuNGnV8YNWZ/95i3GuBLPNcFitQmBjTpbK9fZE9F66JKDmH
   u9F0uuKs4SwvujqSNRws47ESD9ziQNsFZHdPLw18elSZ3/P2095KSyhne
   9kL+29FiDDgVmRrp8dUFxcWG+2OT1+PeGsfkGuNrA+MTEt80uZcpLBo57
   ZAZuiY1Zsw85PhzoX3uomQ9/vv3XG3v3/b/LvrWUPf7t/hQ5ecFV7aAnG
   VB/DJgDEGQR1OyOMokkvp3oft0wX/YDDtS3Y6ngOq2GicK36I35A47dLb
   Y/vrMDdvG3IqXJZPuTe2a6DDy8iONG3LxzcVMBo0fMCjJeRP/YiIzN6JO
   g==;
X-CSE-ConnectionGUID: IJeF4cm9TBybhHFa5dVV9A==
X-CSE-MsgGUID: 6O0P9QPbQMyA7ImrY0Xzpg==
X-IronPort-AV: E=Sophos;i="6.24,207,1774281600"; 
   d="scan'208";a="148878248"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 16 Jun 2026 14:52:15 +0800
X-CSE-ConnectionGUID: 6Cik5XTzQZeTuvEUyWrPDA==
X-CSE-MsgGUID: oeAsIjWGS2mJcRCWFeL+3g==
IronPort-SDR: 6a30f277_aPQ0af8WVWJNK97lEMq0CXt6at0vSvBqNe2pW5W8nCJynOq
 Ekx9v42vNG+zfeniqGV1eFJyxnf5gwl0sP+Nezg==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 Jun 2026 23:51:34 -0700
X-CSE-ConnectionGUID: haK9ImHnQFWvUH8Ot0mrBg==
X-CSE-MsgGUID: /CBdQmf5QSixRQgqwQKmGQ==
WDCIronportException: Internal
Received: from wdap-kgxbdpyiyg.ad.shared (HELO neo.fritz.box) ([10.224.19.10])
  by uls-op-esai1-o.wdc.com with ESMTP; 15 Jun 2026 23:51:35 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH v2] btrfs: zoned: don't force read-only on transient -EAGAIN from reloc merge
Date: Tue, 16 Jun 2026 08:51:29 +0200
Message-ID: <20260616065129.318703-1-johannes.thumshirn@wdc.com>
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

Reported-by: Damien Le Moal <dlemoal@kernel.org>
Fixes: 7bcb04de982f ("btrfs: zoned: cap delayed refs metadata reservation to avoid overcommit")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

---
Changes in v2:
- Don't use two 'if()s' for moving a BG to the retry list (Damien)
- Gracefully handle -EAGAIN in btrfs_relocate_sys_chunks() (Sashiko)
Link to v1:
https://lore.kernel.org/r/20260612100429.214341-1-johannes.thumshirn@wdc.com
---
 fs/btrfs/block-group.c | 10 +++++++++-
 fs/btrfs/relocation.c  | 14 ++++++++++----
 fs/btrfs/volumes.c     |  2 +-
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index ab76a5173272..77b7f23d0865 100644
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
@@ -2113,7 +2120,8 @@ void btrfs_reclaim_block_groups(struct btrfs_fs_info *fs_info, unsigned int limi
 		spin_unlock(&fs_info->unused_bgs_lock);
 		ret = btrfs_reclaim_block_group(bg, &reclaimed);
 
-		if (ret && !READ_ONCE(space_info->periodic_reclaim))
+		if (ret == -EAGAIN ||
+		    (ret && !READ_ONCE(space_info->periodic_reclaim)))
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
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 6eab4cc73ce4..63dfff0ea99b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3732,7 +3732,7 @@ static int btrfs_relocate_sys_chunks(struct btrfs_fs_info *fs_info)
 		if (chunk_type & BTRFS_BLOCK_GROUP_SYSTEM) {
 			ret = btrfs_relocate_chunk(fs_info, found_key.offset,
 						   true);
-			if (ret == -ENOSPC)
+			if (ret == -ENOSPC || ret == -EAGAIN)
 				failed++;
 			else
 				BUG_ON(ret);
-- 
2.54.0

