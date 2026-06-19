Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8BA23ED5B
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 06:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781850769; cv=none; b=OrX0QJWHPBMyvvKf9pn0oBdgurCdUmHVYfru46jLNVVKPuXck/4InITwhyDcxewsuEZhmXFIjxotLwpbBocOOuwolNkCVb7oCzGe1fd3kG1eceoSh1h2sX3cps66VDfNNj8Ncwg/O/1Y+dLn93ScBjxafCVGHPdRn9P4TE1J68Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781850769; c=relaxed/simple;
	bh=5hA9VIHH1p6nZ/l+U4nqisp/1YNKk7hEwkWTzyzdPAw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y9zhP81R0MC6F2qLSA3HFw0+j5R9TpBf5H+zgDVG1Bkh/oq8HlqwzmgKB7kH95yhTygpF4F3UP6mZdcrqXQkHjkoN8p/G8Co+3TzXJ639sBzdLlpbcc+M2JNaxRC8tQWkflicrwNVGgECs9eu+t9Xog0dk0azeGq/1+4854zeLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=fLnW/QvT; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fLnW/QvT"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781850769; x=1813386769;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5hA9VIHH1p6nZ/l+U4nqisp/1YNKk7hEwkWTzyzdPAw=;
  b=fLnW/QvTlHMkSIktS1gq7HQitXJE4HEA0+Ur+j6UlBQSMKLRaImaoLkQ
   /vNs0IgRcSSozWqyicMWY0C+bw7jvDPcrCS4y1ucXBk6W4mXlX/KOwxOK
   +4CmUE8bFFmuwr8Iw+eGBUAJjcbldgb3urUhXH43K5faQ0CBhN/BB6HX8
   QWzmOfC3EDMx5lAUOcAyQqbaDm/VNBxKBcpnSecMDr1L26u2Q0b9bOTtz
   QvFrogSwZNGy231MytGkrkW92D0oc/ylCR7FfiURzviRuFiRFLFtDVpJ+
   nvATK5zMRy7TuOmyh8o2hIfchjQkdtO/Pfm4EbAO8yOXYltsL/jweIjKk
   w==;
X-CSE-ConnectionGUID: 7S7c75EMS6usdCNUjpn7cQ==
X-CSE-MsgGUID: XMzxYcO2QHOscLHSyUCjpQ==
X-IronPort-AV: E=Sophos;i="6.24,213,1774281600"; 
   d="scan'208";a="147944383"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jun 2026 14:32:48 +0800
X-CSE-ConnectionGUID: piMvPXsWTESuvVvbEwSfVg==
X-CSE-MsgGUID: qt/ZTBWyQJK6T1ecfOSxww==
IronPort-SDR: 6a34e267_67cuXIPTlTh3qDvo0TarogumDoHGqEu9FVIE69g/MJVVXSc
 OtlY70hBj+RZCfiSFQqRj6ury/UHFjI0pcilNJg==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Jun 2026 23:32:06 -0700
X-CSE-ConnectionGUID: XsvGybuxQFm3WJotafFodw==
X-CSE-MsgGUID: rNIFli3MRXCpmv0gir3RWA==
WDCIronportException: Internal
Received: from wdap-62juwqezoj.ad.shared (HELO neo.fritz.box) ([10.224.19.3])
  by uls-op-esai1-o.wdc.com with ESMTP; 18 Jun 2026 23:32:06 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v3] btrfs: zoned: don't force read-only on transient -EAGAIN from reloc merge
Date: Fri, 19 Jun 2026 08:32:03 +0200
Message-ID: <20260619063203.448055-1-johannes.thumshirn@wdc.com>
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
Changes to v2:
- Drop the reloc trees on -EAGAIN otherwise create_reloc_roots() will
  fail with -EEXIST

 fs/btrfs/block-group.c | 11 ++++++++-
 fs/btrfs/relocation.c  | 52 ++++++++++++++++++++++++++++++++++++++----
 2 files changed, 58 insertions(+), 5 deletions(-)

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
index e1dd9939f4f1..8cac49fa6f6f 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1532,6 +1532,36 @@ static void clear_reloc_root(struct btrfs_root *root)
 	clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state);
 }
 
+/* Drop the reloc trees of a relocation that is being deferred and retried */
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
@@ -1871,8 +1901,9 @@ int prepare_to_merge(struct reloc_control *rc, int err)
 	return err;
 }
 
+
 static noinline_for_stack
-void merge_reloc_roots(struct reloc_control *rc)
+int merge_reloc_roots(struct reloc_control *rc)
 {
 	struct btrfs_fs_info *fs_info = rc->extent_root->fs_info;
 	struct btrfs_root *root;
@@ -1970,7 +2001,15 @@ void merge_reloc_roots(struct reloc_control *rc)
 		goto again;
 	}
 out:
-	if (ret) {
+	if (ret == -EAGAIN) {
+		abort_reloc_roots(rc, &reloc_roots);
+
+		/* new reloc root may be added */
+		mutex_lock(&fs_info->reloc_mutex);
+		list_splice_init(&rc->reloc_roots, &reloc_roots);
+		mutex_unlock(&fs_info->reloc_mutex);
+		abort_reloc_roots(rc, &reloc_roots);
+	} else if (ret) {
 		btrfs_handle_fs_error(fs_info, ret, NULL);
 		free_reloc_roots(&reloc_roots);
 
@@ -1996,6 +2035,7 @@ void merge_reloc_roots(struct reloc_control *rc)
 	 *
 	 * The remaining nodes will be cleaned up by put_reloc_control().
 	 */
+	return ret;
 }
 
 static void free_block_list(struct rb_root *blocks)
@@ -3725,7 +3765,9 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
 	 */
 	err = prepare_to_merge(rc, err);
 
-	merge_reloc_roots(rc);
+	ret = merge_reloc_roots(rc);
+	if (ret && !err)
+		err = ret;
 
 	rc->merge_reloc_tree = false;
 	unset_reloc_control(rc);
@@ -5694,7 +5736,9 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
 	if (ret)
 		goto out_unset;
 
-	merge_reloc_roots(rc);
+	ret = merge_reloc_roots(rc);
+	if (ret)
+		goto out_unset;
 
 	unset_reloc_control(rc);
 
-- 
2.54.0

