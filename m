Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4172772D
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 11:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782214773; cv=none; b=bEsjO1vLOoLd1keqew3MjmyRbPZXxOUSCuFRlDxscMBX1nANeJTu//apPo9HueaYr419bMn1xY3ngWg1swWTNJBYAUrLyWpTJ09g5XmKw34OkAfKhK5dtqX+50gRqKxy+1/Za8SBCtCm31xwiEA+w5TQvDfSKZ3Io/qRNisk00s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782214773; c=relaxed/simple;
	bh=C6QU1lF6KPlr0v2QUJKpfrJVPBwKx1gdPWkXVEVZjlU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GNAIv9oxTP2R7qapnz4DKiN7WYv/keSFVL6y4EnFV1+hnb/gznc7ZBl3ZLK1JGIvHza9QkTxtWT91j9XPqyKGF0UskxemmlUGonoLevSigRpWNepnOpx0MoNbhH1THN+Yga4KpyrRUMJ/BCQD6dl1UpMYbaUntuEq6KHs+B4aNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=SDkeQNgD; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="SDkeQNgD"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1782214772; x=1813750772;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=C6QU1lF6KPlr0v2QUJKpfrJVPBwKx1gdPWkXVEVZjlU=;
  b=SDkeQNgDPAITZj7i60fn+CGzgehAZMUF8UyUX73GNBSYc0aL66LxmKWR
   sF43K24aWptqso4vDHEyK8Ucd1HI+y1mA/5ubgXvk7doXESVPM1ad+GiW
   X/KRuDKFV6/1rbAZWlvHNTfbi8R3a1WGzy8qMDv1vTCouMUWfANSnxiew
   VCh9a9bVfO3qCaIEwxBF+QYO/kgqfzaqMCH1LvaNRRQCo9WB+dQFKrsXS
   elaPyAkvOrLfDsSamoeN5jQLcAwFoVYrpQQMwtGaB/NMq3bNZ197ONwYv
   nJibaaJFuVR4s1OSARQKnPVBDgznLUNXL8Y6SmmLHW19e1q2MVBMcGGWm
   A==;
X-CSE-ConnectionGUID: bcf42PiXROiyWpOnoa3LTA==
X-CSE-MsgGUID: AJG0+oFwTnWdhAZ2IUPR/A==
X-IronPort-AV: E=Sophos;i="6.24,220,1774281600"; 
   d="scan'208";a="149668424"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 23 Jun 2026 19:39:26 +0800
X-CSE-ConnectionGUID: ZcptJYxZSsuZKhd7L13bGQ==
X-CSE-MsgGUID: xjPde6m3Tg2I2tpFYIJbQg==
IronPort-SDR: 6a3a7054_t5qDC08j00mFXX4zHA/fEAesRWQslaEhWk8W+VFWNuUSmdh
 ASQ/4ATIHAq6AZONs/CyBUegyj+XZSjwDwrL4Xw==
Received: from uls-op-esai2-o.wdc.com ([10.248.3.38])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Jun 2026 04:39:00 -0700
X-CSE-ConnectionGUID: LpgN9SLeSpeZy0J8rNBzYw==
X-CSE-MsgGUID: /dzy79odSjGJZPK2XnFcYw==
WDCIronportException: Internal
Received: from wdap-m04x2wnwan.ad.shared (HELO neo.fritz.box) ([10.224.28.107])
  by uls-op-esai2-o.wdc.com with ESMTP; 23 Jun 2026 04:38:59 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH v5] btrfs: zoned: don't force read-only on transient -EAGAIN from reloc merge
Date: Tue, 23 Jun 2026 13:38:51 +0200
Message-ID: <20260623113851.616247-1-johannes.thumshirn@wdc.com>
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
Changes to v4:
- Gate EAGAIN checks behind btrfs_is_zoned()
- Fix comment style

 fs/btrfs/block-group.c |  9 +++++++-
 fs/btrfs/relocation.c  | 51 ++++++++++++++++++++++++++++++++++++++----
 2 files changed, 55 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index ab76a5173272..9e937407d12a 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2047,6 +2047,12 @@ static int btrfs_reclaim_block_group(struct btrfs_block_group *bg, int *reclaime
 
 	trace_btrfs_reclaim_block_group(bg);
 	ret = btrfs_relocate_chunk(fs_info, bg->start, false);
+	if (btrfs_is_zoned(fs_info) && ret == -EAGAIN) {
+		btrfs_dec_block_group_ro(bg);
+		btrfs_debug(fs_info, "deferring reclaim of chunk %llu",
+			    bg->start);
+		return ret;
+	}
 	if (ret) {
 		btrfs_dec_block_group_ro(bg);
 		btrfs_err(fs_info, "error relocating chunk %llu",
@@ -2113,7 +2119,8 @@ void btrfs_reclaim_block_groups(struct btrfs_fs_info *fs_info, unsigned int limi
 		spin_unlock(&fs_info->unused_bgs_lock);
 		ret = btrfs_reclaim_block_group(bg, &reclaimed);
 
-		if (ret && !READ_ONCE(space_info->periodic_reclaim))
+		if ((btrfs_is_zoned(fs_info) && ret == -EAGAIN) ||
+		    (ret && !READ_ONCE(space_info->periodic_reclaim)))
 			btrfs_link_bg_list(bg, &retry_list);
 		btrfs_put_block_group(bg);
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 1819d49d19c3..df69b401ca8e 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1530,6 +1530,36 @@ static void clear_reloc_root(struct btrfs_root *root)
 	clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state);
 }
 
+/* Drop the reloc trees of a relocation that is being deferred and retried. */
+static void abort_reloc_roots(struct reloc_control *rc, struct list_head *list)
+{
+	struct btrfs_fs_info *fs_info = rc->extent_root->fs_info;
+	struct btrfs_root *reloc_root, *tmp;
+
+	list_for_each_entry_safe(reloc_root, tmp, list, root_list) {
+		struct btrfs_root *root;
+
+		root = btrfs_get_fs_root(fs_info, reloc_root->root_key.offset,
+					 false);
+		if (!IS_ERR(root)) {
+			if (root->reloc_root == reloc_root) {
+				clear_reloc_root(root);
+				btrfs_put_root(reloc_root);
+			}
+			btrfs_put_root(root);
+		}
+
+		btrfs_set_root_refs(&reloc_root->root_item, 0);
+		memset(&reloc_root->root_item.drop_progress, 0,
+		       sizeof(struct btrfs_disk_key));
+		btrfs_set_root_drop_level(&reloc_root->root_item, 0);
+
+		list_del_init(&reloc_root->root_list);
+		list_add_tail(&reloc_root->reloc_dirty_list,
+				&rc->dirty_subvol_roots);
+	}
+}
+
 static int clean_dirty_subvols(struct reloc_control *rc)
 {
 	struct btrfs_root *root;
@@ -1870,7 +1900,7 @@ int prepare_to_merge(struct reloc_control *rc, int err)
 }
 
 static noinline_for_stack
-void merge_reloc_roots(struct reloc_control *rc)
+int merge_reloc_roots(struct reloc_control *rc)
 {
 	struct btrfs_fs_info *fs_info = rc->extent_root->fs_info;
 	struct btrfs_root *root;
@@ -1968,7 +1998,15 @@ void merge_reloc_roots(struct reloc_control *rc)
 		goto again;
 	}
 out:
-	if (ret) {
+	if (btrfs_is_zoned(fs_info) && ret == -EAGAIN) {
+		abort_reloc_roots(rc, &reloc_roots);
+
+		/* New reloc root may be added. */
+		mutex_lock(&fs_info->reloc_mutex);
+		list_splice_init(&rc->reloc_roots, &reloc_roots);
+		mutex_unlock(&fs_info->reloc_mutex);
+		abort_reloc_roots(rc, &reloc_roots);
+	} else if (ret) {
 		btrfs_handle_fs_error(fs_info, ret, NULL);
 		free_reloc_roots(&reloc_roots);
 
@@ -1994,6 +2032,7 @@ void merge_reloc_roots(struct reloc_control *rc)
 	 *
 	 * The remaining nodes will be cleaned up by put_reloc_control().
 	 */
+	return ret;
 }
 
 static void free_block_list(struct rb_root *blocks)
@@ -3723,7 +3762,9 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
 	 */
 	err = prepare_to_merge(rc, err);
 
-	merge_reloc_roots(rc);
+	ret = merge_reloc_roots(rc);
+	if (ret && !err)
+		err = ret;
 
 	rc->merge_reloc_tree = false;
 	unset_reloc_control(rc);
@@ -5692,7 +5733,9 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
 	if (ret)
 		goto out_unset;
 
-	merge_reloc_roots(rc);
+	ret = merge_reloc_roots(rc);
+	if (ret)
+		goto out_unset;
 
 	unset_reloc_control(rc);
 
-- 
2.54.0

