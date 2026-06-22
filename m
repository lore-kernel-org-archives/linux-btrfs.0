Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6719B390610
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2026 08:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782116869; cv=none; b=fWVoeVaUJc2quc+EdJpS0cVJ23PY8PRTlcnWLxOIqG7hhbnWnOTOerDvhIaO9/pWx/htkwUdrxDnoMrip0wT1acjre280Thhqp+5YciPg8SFSEf2Oz5Ui2bUXbPt08SlgdwbTBp0py7uJNTqnTidmcp25btEIE+21t2kj9ZiTdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782116869; c=relaxed/simple;
	bh=kKpVqDr+J9DctAKGcWrJdEd2uumzUnNr9UhQwvcR4O8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q2VsrYwu5LdkGi3ls0bchjtqxSrsW+V1I2mqcJhZ07Hp3NCR9QGCInY1A5zpzQDx2yA6p5C3rFCSjAjxU5eN2Pd1I19sipe9xWzK+LpXnks1i1uoe5GUSdm8Zj38htnbPfvgASi6icBvcjh7RgIz77sUXyqt8tbxU863nK28UMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=CYko8wAv; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="CYko8wAv"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1782116866; x=1813652866;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kKpVqDr+J9DctAKGcWrJdEd2uumzUnNr9UhQwvcR4O8=;
  b=CYko8wAv23Tr3I1049xwFqabFRl0nugVDTqNpOVAnYaCZHtxYX+rgF9I
   oU97i7v/S1TzklqrR8bMTxfO5JrrLYDtxevQpocx1UbS+bruWvN5l7eBB
   383IdOVunvaORGi7p/HQOk5V92rqdZUjnGqoZCIKfQsypY2OhKyh/fyrJ
   09i9Nzt8t1oLeUKfLEpI5/2XuK4Mg1bfaYpLSfHajQVZ/INQcsKVu37N3
   3s93FRp0na1cUoIICNCczoW6DhnJh5iAMqLbNOxlgKTjaZ1o2yzE4mk3R
   weFs6VXOlXj9/8Hl07xUyj/sW3/534EAdMMTPyQHinhv8qUdTe7BdhMd6
   g==;
X-CSE-ConnectionGUID: hQSVKEeRSOKXYgLGIMiqag==
X-CSE-MsgGUID: tz7ncDAZTqGO0GAvQ4NaVw==
X-IronPort-AV: E=Sophos;i="6.24,218,1774281600"; 
   d="scan'208";a="149592809"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 22 Jun 2026 16:27:46 +0800
X-CSE-ConnectionGUID: 7E3Axj75SWq6Y9QBfzvE8Q==
X-CSE-MsgGUID: meORti0kSZeGmnUjHLujpQ==
IronPort-SDR: 6a38f1ec_y12kDV+AbeiHK7YTBWdxR+34sgNxEl4IOr0lHdYUv+sN/42
 rP2io42D4oZNA6bu9ilBY1GODG9hToBCv48lXig==
Received: from uls-op-esai2-o.wdc.com ([10.248.3.38])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Jun 2026 01:27:23 -0700
X-CSE-ConnectionGUID: gq8Dt6kaSDqsqs+BgWTkOA==
X-CSE-MsgGUID: 2+gSeZv8ROiF35MU84km5g==
WDCIronportException: Internal
Received: from wdap-5pxzmrbogy.ad.shared (HELO neo.wdc.com) ([10.224.28.104])
  by uls-op-esai2-o.wdc.com with ESMTP; 22 Jun 2026 01:27:23 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v4] btrfs: zoned: don't force read-only on transient -EAGAIN from reloc merge
Date: Mon, 22 Jun 2026 10:27:20 +0200
Message-ID: <20260622082720.561049-1-johannes.thumshirn@wdc.com>
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
Changes to v3:
- Don't ASSERT() for zoned in case of EAGAIN in
  btrfs_reclaim_block_group but check for zoned 

 fs/btrfs/block-group.c | 10 +++++++-
 fs/btrfs/relocation.c  | 52 ++++++++++++++++++++++++++++++++++++++----
 2 files changed, 57 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index ab76a5173272..1327fd526b06 100644
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
@@ -2113,7 +2119,9 @@ void btrfs_reclaim_block_groups(struct btrfs_fs_info *fs_info, unsigned int limi
 		spin_unlock(&fs_info->unused_bgs_lock);
 		ret = btrfs_reclaim_block_group(bg, &reclaimed);
 
-		if (ret && !READ_ONCE(space_info->periodic_reclaim))
+		if (ret == -EAGAIN)
+			btrfs_link_bg_list(bg, &retry_list);
+		else if (ret && !READ_ONCE(space_info->periodic_reclaim))
 			btrfs_link_bg_list(bg, &retry_list);
 		btrfs_put_block_group(bg);
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 1819d49d19c3..73d9948b5382 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1530,6 +1530,36 @@ static void clear_reloc_root(struct btrfs_root *root)
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
@@ -1869,8 +1899,9 @@ int prepare_to_merge(struct reloc_control *rc, int err)
 	return err;
 }
 
+
 static noinline_for_stack
-void merge_reloc_roots(struct reloc_control *rc)
+int merge_reloc_roots(struct reloc_control *rc)
 {
 	struct btrfs_fs_info *fs_info = rc->extent_root->fs_info;
 	struct btrfs_root *root;
@@ -1968,7 +1999,15 @@ void merge_reloc_roots(struct reloc_control *rc)
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
 
@@ -1994,6 +2033,7 @@ void merge_reloc_roots(struct reloc_control *rc)
 	 *
 	 * The remaining nodes will be cleaned up by put_reloc_control().
 	 */
+	return ret;
 }
 
 static void free_block_list(struct rb_root *blocks)
@@ -3723,7 +3763,9 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
 	 */
 	err = prepare_to_merge(rc, err);
 
-	merge_reloc_roots(rc);
+	ret = merge_reloc_roots(rc);
+	if (ret && !err)
+		err = ret;
 
 	rc->merge_reloc_tree = false;
 	unset_reloc_control(rc);
@@ -5692,7 +5734,9 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
 	if (ret)
 		goto out_unset;
 
-	merge_reloc_roots(rc);
+	ret = merge_reloc_roots(rc);
+	if (ret)
+		goto out_unset;
 
 	unset_reloc_control(rc);
 
-- 
2.54.0

