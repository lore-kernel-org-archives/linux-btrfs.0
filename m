Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123D9416869
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Aug 2026 11:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786619843; cv=none; b=FIqcyw6tVNeYZeg8/BowcgidRAeVr6B12l+oNV+sLMblUnDAP7Dr0qALSS/aCg3Le9RUQZu9O8r1rcUUti3wZfNHfKPFVzdxG8oRS9DfH40+PYwt5CXBL+vfowsXxvErXbEtOGUtvEAM9mPIAdM8iZb1gTfz6reyrznF9BDVFGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786619843; c=relaxed/simple;
	bh=pncr+3AAUskME8Gk3iiyUJk6taBi6rFyRMAmMpqFscQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=XAfA/hcJCxrTw+LmA4a6RVZKygihsGFf2pA9hnzjcr+qxpWNMeYwtgxa8t5m0LbFUhY2aVTycDOJUxE1N0W/emlQBsHFoXENm+7r/UsaWlfGP/m/JPM9Op7WW7c5sVE55GFaRv6UfdQs+/p+EA/siZF6Vq+NjenA8svsjRGC1Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JlBrFtuv; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JlBrFtuv"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-496bb7cdf51so23941835e9.2
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Aug 2026 04:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786619834; x=1787224634; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xJfcjlACAPt4pLrdOvLgFHFNryF7r2+1t+FJ5noYi5Y=;
        b=JlBrFtuvETreQMUsleoiKlKKOu0yPVaPsbKFYBSydLUWsWBZepV1O1gdgF/hBnxEQ9
         DKch7VPXfKiMjuebH1d/Eiz9ousDC9wySy8ucCIBsX5Kp1DqKKi46Rat4blMCJmVfg/+
         7WpS7QJieEk78bu6FbdD8IHCOoDUHSCd+NMvEfpoGHE2pC/gpIwc5mZV2ZoKbzyiY2uE
         5MAksGxEQQVwQ1XOwcq8n1xv2QIOdfa6Tl6raLS+0UOQqp461LVd0w/yz98fW2uoOVUP
         poB+1bd1hO8lGryy86eFkAhH8+QIdeKW84V2vFlPySvm0Ci6GSasT2VzTXOfd02hsQE8
         SjtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786619834; x=1787224634;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xJfcjlACAPt4pLrdOvLgFHFNryF7r2+1t+FJ5noYi5Y=;
        b=DVo58u/fXHR61izpBMs3y5ctvFRZOoTQGR0UauWrz5dEXOeYZzZGeoNhVJkcHcWVzD
         d0uo32ZpfWpKBY88zbTU3tuH7kV58CsoDsk2j3l734cKqmU8A1nBmICMBs3W6YDbKYwr
         vMvCYPf/lrrdLy72u10nzCa0tb+QB5DQbLxp13mSAoxY9bhzkoOYmWSdPlRpUsXWIN5J
         5fJEERWiFz+P+K9b9iYXfZ1lwNiXLpkFt+dHCd4OM41zJ8YdLV1HiNVl0BXXm5X6uBSc
         sdSOn7P13QzCc44gYFZHo0TTLajzLo8k2U8/XX08adP67Hxm72PX1HqnEvetMbqRpoAF
         GjZw==
X-Gm-Message-State: AOJu0YxQcWBblyOK7RJhfQxxAGVUjsbddpLxbgMAnIPhppZIPFMRIzK4
	qSmmstk03zVkKVAZqxWdMiJZIrN6IKXaFhr8lWU67BlkZwQLHd/hcBwK2HtHyZLKBPBhqw==
X-Gm-Gg: AR+sD110cSqoRqQQJZTaJfPKQMOv2YuYyhnznKI7Xd2Tu0yWhUm3cigPbOjJu5qyp3p
	oV/uDGJ9nvrdyGGCHMm/jnClQ4IVGyHxj6REmtL3dB+ZSAppodrlQ3TFk+N/IaItgAazktNSGVW
	1X6vFsHHBgOfP+8RWtlR7V9KewLXmxP+bGLlKRMbPjXaXV0cA3rGDbtaBYmejedJ5P7SNcHm5Yt
	BMajIgMGDSCY1/bDb/6E3C66rx2WOl/3JZP9Km9GpKHCux5vXL7Gi946dZo6JNWP8CC91N3PIDG
	zWkvuKvvFbDku4uPVcBPkD/WyAxzpc2KpptO28tCcmBkmX3vV4JHgs7+uxQPQbBlQ/YpMJWRzfH
	o/u/bNG96vBouGuxJK9CDrd1WKvTUZ7Nooqx1YLCZa/BrMaGo4RFVVr696FbV2fS450bx138eY7
	oqY1l+aJZlV/AKIRKFG/+yH6IYDJGzXqQ2R4jWfmcR7HIDLlLcQ+MfPqZiEUs8DJjl9W/h1MzBN
	c+z4sgT+vdrN00=
X-Received: by 2002:a05:600c:3511:b0:495:4e1d:82df with SMTP id 5b1f17b1804b1-499821f000cmr52259835e9.10.1786619833877;
        Thu, 13 Aug 2026 04:17:13 -0700 (PDT)
Received: from localhost ([37.30.50.141])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49981dd6825sm31796215e9.1.2026.08.13.04.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 04:17:13 -0700 (PDT)
Date: Thu, 13 Aug 2026 13:17:12 +0200
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <wqu@suse.com>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, "Yan, Zheng" <zheng.yan@oracle.com>, 
	linux-kernel@vger.kernel.org, syzbot+021d10c4d4edc87daa03@syzkaller.appspotmail.com
Subject: [PATCH RFC v2] btrfs: keep mixed block group writable for relocation
 setup commit
Message-ID: <vu6cjfyamplqqiy4hbu5eobbp65cy4fzv2jci4n5lfalanvmlp@pf5bfsi33gl7>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Relocating a nearly full mixed block group can abort the filesystem
transaction with -ENOSPC and trigger a warning in cleanup_transaction().

Making the mixed target read-only can lead to a condition where
metadata COW cannot use its free space. In particular,
btrfs_relocate_block_group() marks the mixed target read-only before
prepare_to_relocate() commits the setup transaction. find_free_extent()
then skips all free extents in the target. Commit-time COW still needs
new tree blocks, so the transaction can fail with -ENOSPC when no
suitable extent remains in another block group.

Committing before the read-only transition does not fix the bug.
Another workload can reserve space or start transaction N+1 between the
commit and btrfs_inc_block_group_ro().

Keep a non-zoned, non-remap mixed target writable until its relocation
setup transaction finishes. Fence data, tree-log and NOCOW admission
while ordinary metadata COW remains allowed. Drain operations that
crossed the fence before committing the setup transaction with
reloc_ctl unpublished.

Implement the boundary at the source files that own each state:

- block-group.c owns the setup fence and final read-only transition,
  treats the fence as read-only for NOCOW and swap-extents admission,
  and makes other read-only holders wait for setup completion;
- extent-tree.c rejects data and tree-log allocation into the fenced
  target, allows ordinary metadata COW, and keeps block group
  reservations only for data allocations until ordered extent
  registration;
- inode.c treats the fenced target as read-only during NOCOW checks;
- relocation.c drains each pass, binds setup to the running transaction
  and owns the read-only and reloc_ctl lifecycle;
- transaction.c completes setup after switching commit roots and before
  transaction N+1 can start;
- disk-io.c cancels a pending setup when its transaction is cleaned up.

At the transaction tail, either mark the target read-only and publish
reloc_ctl, or return the read-only transition error to relocation while
the transaction completes and the target stays writable. Apply this
boundary to every non-remap mixed relocation pass. Keep the existing
paths unchanged for zoned, remap-tree and non-mixed block groups.

Fixes: 3fd0a5585eb9 ("Btrfs: Metadata ENOSPC handling for balance")
Reported-by: syzbot+021d10c4d4edc87daa03@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=021d10c4d4edc87daa03
Link: https://lore.kernel.org/r/9d9d207e-ad2a-4af6-9d0b-9a2bfc61d442@suse.com
Assisted-by: Codex:gpt-5.6-sol syzkaller
Signed-off-by: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
---
Changes in v2:
- Drop the pre-commit-only approach because it leaves an admission window
  before the block group becomes read-only.
- Keep the mixed target writable for setup metadata COW while fencing data,
  tree-log and NOCOW admission.
- Bind setup to the exact transaction and publish the read-only state and
  reloc_ctl before transaction N+1 can start.
- Apply the same boundary to every non-remap relocation pass and handle
  abort cleanup explicitly.

Tested:
- Focused and full x86_64 builds.
- The syzbot C reproducer completed 16 independent runs without a crash.

v1: https://lore.kernel.org/r/a06b5077-baa5-473f-9c65-bf72ac651b14@mail.kernel.org

 fs/btrfs/block-group.c | 128 ++++++++++++++++---
 fs/btrfs/block-group.h |   8 +-
 fs/btrfs/disk-io.c     |   1 +
 fs/btrfs/extent-tree.c |  19 ++-
 fs/btrfs/extent-tree.h |   1 +
 fs/btrfs/inode.c       |   4 +-
 fs/btrfs/relocation.c  | 280 ++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/relocation.h  |   4 +
 fs/btrfs/transaction.c |   4 +
 fs/btrfs/transaction.h |   3 +
 10 files changed, 395 insertions(+), 57 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 8def7abb728f..332fc2721e01 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -21,6 +21,7 @@
 #include "fs.h"
 #include "accessors.h"
 #include "extent-tree.h"
+#include "relocation.h"
 
 static struct kmem_cache *block_group_cache;
 static struct kmem_cache *free_space_ctl_cache;
@@ -363,7 +364,8 @@ struct btrfs_block_group *btrfs_inc_nocow_writers(struct btrfs_fs_info *fs_info,
 		return NULL;
 
 	spin_lock(&bg->lock);
-	if (bg->ro)
+	if (bg->ro || test_bit(BLOCK_GROUP_FLAG_RELOC_SETUP,
+			       &bg->runtime_flags))
 		can_nocow = false;
 	else
 		atomic_inc(&bg->nocow_writers);
@@ -419,7 +421,8 @@ void btrfs_wait_block_group_reservations(struct btrfs_block_group *bg)
 {
 	struct btrfs_space_info *space_info = bg->space_info;
 
-	ASSERT(bg->ro);
+	ASSERT(bg->ro || test_bit(BLOCK_GROUP_FLAG_RELOC_SETUP,
+				  &bg->runtime_flags));
 
 	if (!(bg->flags & BTRFS_BLOCK_GROUP_DATA))
 		return;
@@ -1434,7 +1437,8 @@ struct btrfs_trans_handle *btrfs_start_trans_remove_block_group(
  * data in this block group. That check should be done by relocation routine,
  * not this function.
  */
-static int inc_block_group_ro(struct btrfs_block_group *cache, bool force)
+static int __inc_block_group_ro(struct btrfs_block_group *cache, bool force,
+				bool reloc_setup)
 {
 	struct btrfs_space_info *sinfo = cache->space_info;
 	u64 num_bytes;
@@ -1442,6 +1446,11 @@ static int inc_block_group_ro(struct btrfs_block_group *cache, bool force)
 
 	spin_lock(&sinfo->lock);
 	spin_lock(&cache->lock);
+	if (!reloc_setup && test_bit(BLOCK_GROUP_FLAG_RELOC_SETUP,
+				     &cache->runtime_flags)) {
+		ret = -EAGAIN;
+		goto out;
+	}
 
 	if (cache->swap_extents) {
 		ret = -ETXTBSY;
@@ -1504,6 +1513,54 @@ static int inc_block_group_ro(struct btrfs_block_group *cache, bool force)
 	return ret;
 }
 
+static int inc_block_group_ro(struct btrfs_block_group *cache, bool force)
+{
+	return __inc_block_group_ro(cache, force, false);
+}
+
+int btrfs_bg_reloc_setup_start(struct btrfs_block_group *cache, bool drop_ro)
+{
+	struct btrfs_fs_info *fs_info = cache->fs_info;
+	struct btrfs_space_info *sinfo = cache->space_info;
+	int ret = 0;
+
+	ASSERT(!btrfs_is_zoned(fs_info));
+
+	mutex_lock(&fs_info->ro_block_group_mutex);
+	spin_lock(&sinfo->lock);
+	spin_lock(&cache->lock);
+	if (test_bit(BLOCK_GROUP_FLAG_RELOC_SETUP, &cache->runtime_flags) ||
+	    cache->ro != (drop_ro ? 1 : 0)) {
+		ret = -EAGAIN;
+		goto out;
+	}
+
+	set_bit(BLOCK_GROUP_FLAG_RELOC_SETUP, &cache->runtime_flags);
+	if (drop_ro) {
+		cache->ro = 0;
+		sinfo->bytes_readonly -= btrfs_block_group_available_space(cache);
+		list_del_init(&cache->ro_list);
+	}
+out:
+	spin_unlock(&cache->lock);
+	spin_unlock(&sinfo->lock);
+	mutex_unlock(&fs_info->ro_block_group_mutex);
+	return ret;
+}
+
+int btrfs_bg_reloc_setup_finish(struct btrfs_block_group *cache)
+{
+	ASSERT(test_bit(BLOCK_GROUP_FLAG_RELOC_SETUP, &cache->runtime_flags));
+	return __inc_block_group_ro(cache, false, true);
+}
+
+void btrfs_bg_reloc_setup_abort(struct btrfs_block_group *cache)
+{
+	ASSERT(test_bit(BLOCK_GROUP_FLAG_RELOC_SETUP, &cache->runtime_flags));
+	clear_and_wake_up_bit(BLOCK_GROUP_FLAG_RELOC_SETUP,
+			      &cache->runtime_flags);
+}
+
 static bool clean_pinned_extents(struct btrfs_trans_handle *trans,
 				 const struct btrfs_block_group *bg)
 {
@@ -1945,6 +2002,7 @@ static int btrfs_reclaim_block_group(struct btrfs_block_group *bg, int *reclaime
 	u64 reserved;
 	u64 old_total;
 	int ret = 0;
+	bool marked_ro = false;
 
 	/* Don't race with allocators so take the groups_sem */
 	down_write(&space_info->groups_sem);
@@ -2018,15 +2076,19 @@ static int btrfs_reclaim_block_group(struct btrfs_block_group *bg, int *reclaime
 		return 0;
 	}
 
-	ret = inc_block_group_ro(bg, false);
+	if (!btrfs_relocation_uses_fenced_setup(bg)) {
+		ret = inc_block_group_ro(bg, false);
+		if (!ret)
+			marked_ro = true;
+	}
 	up_write(&space_info->groups_sem);
 	if (ret < 0)
 		return ret;
 
 	/*
 	 * The amount of bytes reclaimed corresponds to the sum of the
-	 * "used" and "reserved" counters. We have set the block group
-	 * to RO above, which prevents reservations from happening but
+	 * "used" and "reserved" counters. Relocation prevents new data
+	 * reservations before it drains existing reservations, but
 	 * we may have existing reservations for which allocation has
 	 * not yet been done - btrfs_update_block_group() was not yet
 	 * called, which is where we will transfer a reserved extent's
@@ -2048,7 +2110,8 @@ static int btrfs_reclaim_block_group(struct btrfs_block_group *bg, int *reclaime
 	trace_btrfs_reclaim_block_group(bg);
 	ret = btrfs_relocate_chunk(fs_info, bg->start, false);
 	if (ret) {
-		btrfs_dec_block_group_ro(bg);
+		if (marked_ro)
+			btrfs_dec_block_group_ro(bg);
 		btrfs_err(fs_info, "error relocating chunk %llu",
 			  bg->start);
 		used = 0;
@@ -3131,7 +3194,7 @@ int btrfs_inc_block_group_ro(struct btrfs_block_group *cache,
 	struct btrfs_root *root = btrfs_block_group_root(fs_info);
 	u64 alloc_flags;
 	int ret;
-	bool dirty_bg_running;
+	bool retry;
 
 	if (unlikely(!root)) {
 		btrfs_err(fs_info, "missing block group root");
@@ -3145,9 +3208,18 @@ int btrfs_inc_block_group_ro(struct btrfs_block_group *cache,
 	 * Thus here we skip all chunk allocations.
 	 */
 	if (sb_rdonly(fs_info->sb)) {
-		mutex_lock(&fs_info->ro_block_group_mutex);
-		ret = inc_block_group_ro(cache, false);
-		mutex_unlock(&fs_info->ro_block_group_mutex);
+		do {
+			mutex_lock(&fs_info->ro_block_group_mutex);
+			retry = test_bit(BLOCK_GROUP_FLAG_RELOC_SETUP,
+					 &cache->runtime_flags);
+			if (!retry)
+				ret = inc_block_group_ro(cache, false);
+			mutex_unlock(&fs_info->ro_block_group_mutex);
+			if (retry)
+				ret = wait_on_bit(&cache->runtime_flags,
+						  BLOCK_GROUP_FLAG_RELOC_SETUP,
+						  TASK_INTERRUPTIBLE);
+		} while (retry && !ret);
 		return ret;
 	}
 
@@ -3156,7 +3228,7 @@ int btrfs_inc_block_group_ro(struct btrfs_block_group *cache,
 		if (IS_ERR(trans))
 			return PTR_ERR(trans);
 
-		dirty_bg_running = false;
+		retry = false;
 
 		/*
 		 * We're not allowed to set block groups readonly after the dirty
@@ -3164,7 +3236,19 @@ int btrfs_inc_block_group_ro(struct btrfs_block_group *cache,
 		 * back off and let this transaction commit.
 		 */
 		mutex_lock(&fs_info->ro_block_group_mutex);
-		if (test_bit(BTRFS_TRANS_DIRTY_BG_RUN, &trans->transaction->flags)) {
+		if (test_bit(BLOCK_GROUP_FLAG_RELOC_SETUP,
+			     &cache->runtime_flags)) {
+			mutex_unlock(&fs_info->ro_block_group_mutex);
+			btrfs_end_transaction(trans);
+
+			ret = wait_on_bit(&cache->runtime_flags,
+					  BLOCK_GROUP_FLAG_RELOC_SETUP,
+					  TASK_INTERRUPTIBLE);
+			if (ret)
+				return ret;
+			retry = true;
+		} else if (test_bit(BTRFS_TRANS_DIRTY_BG_RUN,
+				    &trans->transaction->flags)) {
 			u64 transid = trans->transid;
 
 			mutex_unlock(&fs_info->ro_block_group_mutex);
@@ -3173,9 +3257,9 @@ int btrfs_inc_block_group_ro(struct btrfs_block_group *cache,
 			ret = btrfs_wait_for_commit(fs_info, transid);
 			if (ret)
 				return ret;
-			dirty_bg_running = true;
+			retry = true;
 		}
-	} while (dirty_bg_running);
+	} while (retry);
 
 	if (do_chunk_alloc) {
 		/*
@@ -3411,7 +3495,9 @@ static void cache_save_setup(struct btrfs_block_group *block_group,
 		}
 		retries++;
 
-		if (block_group->ro)
+		if (block_group->ro ||
+		    test_bit(BLOCK_GROUP_FLAG_RELOC_SETUP,
+			     &block_group->runtime_flags))
 			goto out_free;
 
 		ret = create_free_space_inode(trans, block_group, path);
@@ -3981,6 +4067,7 @@ int btrfs_update_block_group(struct btrfs_trans_handle *trans,
  *              @num_bytes except for the compress path.
  * @num_bytes:	The number of bytes in question
  * @delalloc:   The blocks are allocated for the delalloc write
+ * @allow_reloc_setup: Allow ordinary metadata into a relocation setup target.
  *
  * This is called by the allocator when it reserves space. If this is a
  * reservation and the block group has become read only we cannot make the
@@ -3988,7 +4075,8 @@ int btrfs_update_block_group(struct btrfs_trans_handle *trans,
  */
 int btrfs_add_reserved_bytes(struct btrfs_block_group *cache,
 			     u64 ram_bytes, u64 num_bytes, bool delalloc,
-			     bool force_wrong_size_class)
+			     bool force_wrong_size_class,
+			     bool allow_reloc_setup)
 {
 	struct btrfs_space_info *space_info = cache->space_info;
 	enum btrfs_block_group_size_class size_class;
@@ -3996,7 +4084,9 @@ int btrfs_add_reserved_bytes(struct btrfs_block_group *cache,
 
 	spin_lock(&space_info->lock);
 	spin_lock(&cache->lock);
-	if (cache->ro) {
+	if (cache->ro ||
+	    (!allow_reloc_setup &&
+	     test_bit(BLOCK_GROUP_FLAG_RELOC_SETUP, &cache->runtime_flags))) {
 		ret = -EAGAIN;
 		goto out_error;
 	}
@@ -4832,7 +4922,7 @@ bool btrfs_inc_block_group_swap_extents(struct btrfs_block_group *bg)
 	bool ret = true;
 
 	spin_lock(&bg->lock);
-	if (bg->ro)
+	if (bg->ro || test_bit(BLOCK_GROUP_FLAG_RELOC_SETUP, &bg->runtime_flags))
 		ret = false;
 	else
 		bg->swap_extents++;
diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
index 790c2d467af5..d2b1dd01b45e 100644
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -95,6 +95,8 @@ enum btrfs_block_group_flags {
 	BLOCK_GROUP_FLAG_NEW,
 	BLOCK_GROUP_FLAG_FULLY_REMAPPED,
 	BLOCK_GROUP_FLAG_STRIPE_REMOVAL_PENDING,
+	/* Block data, tree-log and NOCOW admission during relocation setup. */
+	BLOCK_GROUP_FLAG_RELOC_SETUP,
 };
 
 enum btrfs_caching_type {
@@ -364,6 +366,9 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans);
 int btrfs_inc_block_group_ro(struct btrfs_block_group *cache,
 			     bool do_chunk_alloc);
 void btrfs_dec_block_group_ro(struct btrfs_block_group *cache);
+int btrfs_bg_reloc_setup_start(struct btrfs_block_group *cache, bool drop_ro);
+int btrfs_bg_reloc_setup_finish(struct btrfs_block_group *cache);
+void btrfs_bg_reloc_setup_abort(struct btrfs_block_group *cache);
 int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans);
 int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans);
 int btrfs_setup_space_cache(struct btrfs_trans_handle *trans);
@@ -371,7 +376,8 @@ int btrfs_update_block_group(struct btrfs_trans_handle *trans,
 			     u64 bytenr, u64 num_bytes, bool alloc);
 int btrfs_add_reserved_bytes(struct btrfs_block_group *cache,
 			     u64 ram_bytes, u64 num_bytes, bool delalloc,
-			     bool force_wrong_size_class);
+			     bool force_wrong_size_class,
+			     bool allow_reloc_setup);
 void btrfs_free_reserved_bytes(struct btrfs_block_group *cache, u64 num_bytes,
 			       bool is_delalloc);
 int btrfs_chunk_alloc(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2f1666d9544e..eab2fc5bf8b9 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4936,6 +4936,7 @@ void btrfs_cleanup_one_transaction(struct btrfs_transaction *cur_trans)
 	}
 
 	btrfs_destroy_delayed_refs(cur_trans);
+	btrfs_abort_relocation_setup(cur_trans, cur_trans->aborted);
 
 	cur_trans->state = TRANS_STATE_COMMIT_START;
 	wake_up(&fs_info->transaction_blocked_wait);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 624d76e0ca01..962af1840781 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4639,6 +4639,9 @@ static noinline int find_free_extent(struct btrfs_root *root,
 			down_read(&space_info->groups_sem);
 			if (list_empty(&block_group->list) ||
 			    block_group->ro ||
+			    (test_bit(BLOCK_GROUP_FLAG_RELOC_SETUP,
+				      &block_group->runtime_flags) &&
+			     (ffe_ctl->is_data || ffe_ctl->for_treelog)) ||
 			    (block_group->flags & BTRFS_BLOCK_GROUP_REMAPPED)) {
 				/*
 				 * someone is removing this block group,
@@ -4674,7 +4677,10 @@ static noinline int find_free_extent(struct btrfs_root *root,
 		ffe_ctl->hinted = false;
 		/* If the block group is read-only, we can skip it entirely. */
 		if (unlikely(block_group->ro ||
-			     (block_group->flags & BTRFS_BLOCK_GROUP_REMAPPED))) {
+		     (test_bit(BLOCK_GROUP_FLAG_RELOC_SETUP,
+			       &block_group->runtime_flags) &&
+		      (ffe_ctl->is_data || ffe_ctl->for_treelog)) ||
+		     (block_group->flags & BTRFS_BLOCK_GROUP_REMAPPED))) {
 			if (ffe_ctl->for_treelog)
 				btrfs_clear_treelog_bg(block_group);
 			if (ffe_ctl->for_data_reloc)
@@ -4776,14 +4782,16 @@ static noinline int find_free_extent(struct btrfs_root *root,
 		ret = btrfs_add_reserved_bytes(block_group, ffe_ctl->ram_bytes,
 					       ffe_ctl->num_bytes,
 					       ffe_ctl->delalloc,
-					       ffe_ctl->loop >= LOOP_WRONG_SIZE_CLASS);
+					       ffe_ctl->loop >= LOOP_WRONG_SIZE_CLASS,
+					       !ffe_ctl->is_data && !ffe_ctl->for_treelog);
 		if (ret == -EAGAIN) {
 			btrfs_add_free_space_unused(block_group,
 					ffe_ctl->found_offset,
 					ffe_ctl->num_bytes);
 			goto loop;
 		}
-		btrfs_inc_block_group_reservations(block_group);
+		if (ffe_ctl->is_data)
+			btrfs_inc_block_group_reservations(block_group);
 
 		/* we are all good, lets return */
 		ins->objectid = ffe_ctl->search_start;
@@ -4897,14 +4905,13 @@ int btrfs_reserve_extent(struct btrfs_root *root, u64 ram_bytes,
 	ffe_ctl.empty_size = empty_size;
 	ffe_ctl.flags = flags;
 	ffe_ctl.delalloc = delalloc;
+	ffe_ctl.is_data = is_data;
 	ffe_ctl.hint_byte = hint_byte;
 	ffe_ctl.for_treelog = for_treelog;
 	ffe_ctl.for_data_reloc = for_data_reloc;
 
 	ret = find_free_extent(root, ins, &ffe_ctl);
-	if (!ret && !is_data) {
-		btrfs_dec_block_group_reservations(fs_info, ins->objectid);
-	} else if (ret == -ENOSPC) {
+	if (ret == -ENOSPC) {
 		if (!final_tried && ins->offset) {
 			num_bytes = min(num_bytes >> 1, ins->offset);
 			num_bytes = round_down(num_bytes,
diff --git a/fs/btrfs/extent-tree.h b/fs/btrfs/extent-tree.h
index ff330d4896d6..74ba10a46951 100644
--- a/fs/btrfs/extent-tree.h
+++ b/fs/btrfs/extent-tree.h
@@ -40,6 +40,7 @@ struct find_free_extent_ctl {
 	bool use_cluster;
 
 	bool delalloc;
+	bool is_data;
 	bool have_caching_bg;
 	bool orig_have_caching_bg;
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2534cd9284d5..28c5902636d3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7398,7 +7398,9 @@ static bool btrfs_extent_readonly(struct btrfs_fs_info *fs_info, u64 bytenr)
 	bool readonly = false;
 
 	block_group = btrfs_lookup_block_group(fs_info, bytenr);
-	if (!block_group || block_group->ro)
+	if (!block_group || block_group->ro ||
+	    test_bit(BLOCK_GROUP_FLAG_RELOC_SETUP,
+		     &block_group->runtime_flags))
 		readonly = true;
 	if (block_group)
 		btrfs_put_block_group(block_group);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index fc5c14b5adad..92059ebc8345 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -173,11 +173,16 @@ struct reloc_control {
 
 	u64 search_start;
 	u64 extents_found;
+	int setup_result;
 
 	enum reloc_stage stage;
 	bool create_reloc_tree;
 	bool merge_reloc_tree;
 	bool found_file_extent;
+	bool fenced_setup;
+	bool setup_pending;
+	bool block_group_ro;
+	bool reloc_ctl_set;
 
 	refcount_t refs;
 };
@@ -3507,14 +3512,24 @@ int find_next_extent(struct reloc_control *rc, struct btrfs_path *path,
 	return ret;
 }
 
-static void set_reloc_control(struct reloc_control *rc)
+static void __set_reloc_control(struct reloc_control *rc)
 {
 	struct btrfs_fs_info *fs_info = rc->extent_root->fs_info;
 
-	mutex_lock(&fs_info->reloc_mutex);
+	lockdep_assert_held(&fs_info->reloc_mutex);
 	spin_lock(&fs_info->reloc_ctl_lock);
+	ASSERT(!fs_info->reloc_ctl || fs_info->reloc_ctl == rc);
 	fs_info->reloc_ctl = rc;
+	rc->reloc_ctl_set = true;
 	spin_unlock(&fs_info->reloc_ctl_lock);
+}
+
+static void set_reloc_control(struct reloc_control *rc)
+{
+	struct btrfs_fs_info *fs_info = rc->extent_root->fs_info;
+
+	mutex_lock(&fs_info->reloc_mutex);
+	__set_reloc_control(rc);
 	mutex_unlock(&fs_info->reloc_mutex);
 }
 
@@ -3524,18 +3539,137 @@ static void unset_reloc_control(struct reloc_control *rc)
 
 	mutex_lock(&fs_info->reloc_mutex);
 	spin_lock(&fs_info->reloc_ctl_lock);
-	fs_info->reloc_ctl = NULL;
+	if (rc->reloc_ctl_set) {
+		ASSERT(fs_info->reloc_ctl == rc);
+		fs_info->reloc_ctl = NULL;
+		rc->reloc_ctl_set = false;
+	} else {
+		ASSERT(fs_info->reloc_ctl != rc);
+	}
 	spin_unlock(&fs_info->reloc_ctl_lock);
 	mutex_unlock(&fs_info->reloc_mutex);
 }
 
+static void complete_relocation_setup(struct reloc_control *rc, int result)
+{
+	ASSERT(rc->setup_pending);
+	WRITE_ONCE(rc->setup_result, result);
+	WRITE_ONCE(rc->setup_pending, false);
+	btrfs_bg_reloc_setup_abort(rc->block_group);
+	put_reloc_control(rc);
+}
+
+void btrfs_finish_relocation_setup(struct btrfs_transaction *trans)
+{
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct reloc_control *rc;
+	int ret;
+
+	lockdep_assert_held(&fs_info->reloc_mutex);
+
+	spin_lock(&fs_info->trans_lock);
+	rc = trans->reloc_setup;
+	trans->reloc_setup = NULL;
+	spin_unlock(&fs_info->trans_lock);
+	if (!rc)
+		return;
+
+	ret = btrfs_bg_reloc_setup_finish(rc->block_group);
+	if (!ret) {
+		WRITE_ONCE(rc->block_group_ro, true);
+		__set_reloc_control(rc);
+	}
+	complete_relocation_setup(rc, ret);
+}
+
+void btrfs_abort_relocation_setup(struct btrfs_transaction *trans, int error)
+{
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct reloc_control *rc;
+
+	spin_lock(&fs_info->trans_lock);
+	rc = trans->reloc_setup;
+	trans->reloc_setup = NULL;
+	spin_unlock(&fs_info->trans_lock);
+	if (!rc)
+		return;
+
+	complete_relocation_setup(rc, error ?: -EIO);
+}
+
+static int bind_relocation_setup(struct btrfs_trans_handle *trans,
+				 struct reloc_control *rc,
+				 struct btrfs_transaction **transaction)
+{
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_transaction *cur_trans = trans->transaction;
+	int ret = 0;
+
+	mutex_lock(&fs_info->ro_block_group_mutex);
+	spin_lock(&fs_info->trans_lock);
+	if (TRANS_ABORTED(cur_trans)) {
+		ret = cur_trans->aborted;
+	} else if (cur_trans != fs_info->running_transaction ||
+		   cur_trans->state != TRANS_STATE_RUNNING ||
+		   test_bit(BTRFS_TRANS_DIRTY_BG_RUN, &cur_trans->flags)) {
+		ret = -EAGAIN;
+	} else if (cur_trans->reloc_setup) {
+		ret = -EBUSY;
+	} else {
+		ASSERT(rc->setup_pending);
+		WRITE_ONCE(rc->setup_result, -EINPROGRESS);
+		refcount_inc(&rc->refs);
+		cur_trans->reloc_setup = rc;
+		refcount_inc(&cur_trans->use_count);
+		*transaction = cur_trans;
+	}
+	spin_unlock(&fs_info->trans_lock);
+	mutex_unlock(&fs_info->ro_block_group_mutex);
+
+	return ret;
+}
+
+static int reconcile_relocation_setup(struct btrfs_transaction *trans,
+				      struct reloc_control *rc,
+				      int commit_ret)
+{
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	bool cancel = false;
+	bool wait = false;
+	int setup_ret;
+
+	spin_lock(&fs_info->trans_lock);
+	if (trans->reloc_setup == rc &&
+	    trans->state < TRANS_STATE_COMMIT_PREP) {
+		trans->reloc_setup = NULL;
+		cancel = true;
+	} else if (READ_ONCE(rc->setup_result) == -EINPROGRESS) {
+		wait = true;
+	}
+	spin_unlock(&fs_info->trans_lock);
+
+	if (cancel)
+		complete_relocation_setup(rc, commit_ret ?: -EIO);
+	else if (wait)
+		wait_event(trans->commit_wait,
+			   READ_ONCE(trans->state) >= TRANS_STATE_COMPLETED);
+
+	setup_ret = READ_ONCE(rc->setup_result);
+	ASSERT(setup_ret != -EINPROGRESS);
+	btrfs_put_transaction(trans);
+
+	return commit_ret ?: setup_ret;
+}
+
 static noinline_for_stack
 int prepare_to_relocate(struct reloc_control *rc)
 {
+	struct btrfs_fs_info *fs_info = rc->extent_root->fs_info;
 	struct btrfs_trans_handle *trans;
+	struct btrfs_transaction *transaction = NULL;
 	int ret;
 
-	rc->block_rsv = btrfs_alloc_block_rsv(rc->extent_root->fs_info,
+	rc->block_rsv = btrfs_alloc_block_rsv(fs_info,
 					      BTRFS_BLOCK_RSV_TEMP);
 	if (!rc->block_rsv)
 		return -ENOMEM;
@@ -3546,32 +3680,93 @@ int prepare_to_relocate(struct reloc_control *rc)
 	rc->nodes_relocated = 0;
 	rc->merging_rsv_size = 0;
 	rc->reserved_bytes = 0;
-	rc->block_rsv->size = rc->extent_root->fs_info->nodesize *
-			      RELOCATION_RESERVED_NODES;
-	ret = btrfs_block_rsv_refill(rc->extent_root->fs_info,
+	rc->block_rsv->size = fs_info->nodesize * RELOCATION_RESERVED_NODES;
+
+	if (!rc->fenced_setup) {
+		ret = btrfs_block_rsv_refill(fs_info,
+					     rc->block_rsv, rc->block_rsv->size,
+					     BTRFS_RESERVE_FLUSH_ALL);
+		if (ret)
+			return ret;
+
+		rc->create_reloc_tree = true;
+		set_reloc_control(rc);
+
+		trans = btrfs_join_transaction(rc->extent_root);
+		if (IS_ERR(trans)) {
+			unset_reloc_control(rc);
+			/*
+			 * The extent tree is not a ref-cow tree and has no reloc
+			 * root to clean up. Callers free the block reserve.
+			 */
+			return PTR_ERR(trans);
+		}
+
+		ret = btrfs_commit_transaction(trans);
+		if (ret)
+			unset_reloc_control(rc);
+		return ret;
+	}
+
+	if (!rc->setup_pending) {
+		ret = btrfs_bg_reloc_setup_start(rc->block_group,
+						 rc->block_group_ro);
+		if (ret)
+			return ret;
+		WRITE_ONCE(rc->setup_pending, true);
+		WRITE_ONCE(rc->block_group_ro, false);
+	} else {
+		ASSERT(!rc->block_group_ro);
+	}
+
+	btrfs_wait_block_group_reservations(rc->block_group);
+	btrfs_wait_nocow_writers(rc->block_group);
+	btrfs_wait_ordered_roots(fs_info, U64_MAX, rc->block_group);
+
+	ret = btrfs_block_rsv_refill(fs_info,
 				     rc->block_rsv, rc->block_rsv->size,
 				     BTRFS_RESERVE_FLUSH_ALL);
 	if (ret)
-		return ret;
+		goto abort_setup;
 
+	/* The transaction tail publishes reloc_ctl with the new commit roots. */
 	rc->create_reloc_tree = true;
-	set_reloc_control(rc);
+	for (;;) {
+		u64 transid;
 
-	trans = btrfs_join_transaction(rc->extent_root);
-	if (IS_ERR(trans)) {
-		unset_reloc_control(rc);
-		/*
-		 * extent tree is not a ref_cow tree and has no reloc_root to
-		 * cleanup.  And callers are responsible to free the above
-		 * block rsv.
-		 */
-		return PTR_ERR(trans);
+		trans = btrfs_join_transaction(rc->extent_root);
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
+			goto abort_setup;
+		}
+		transid = trans->transid;
+
+		ret = bind_relocation_setup(trans, rc, &transaction);
+		if (ret == -EAGAIN) {
+			btrfs_end_transaction(trans);
+			ret = btrfs_wait_for_commit(fs_info, transid);
+			if (ret)
+				goto abort_setup;
+			continue;
+		}
+		if (ret) {
+			btrfs_end_transaction(trans);
+			goto abort_setup;
+		}
+		break;
 	}
 
 	ret = btrfs_commit_transaction(trans);
-	if (ret)
+	ret = reconcile_relocation_setup(transaction, rc, ret);
+	if (ret && rc->reloc_ctl_set)
 		unset_reloc_control(rc);
+	return ret;
 
+abort_setup:
+	ASSERT(rc->setup_pending);
+	WRITE_ONCE(rc->setup_result, ret);
+	WRITE_ONCE(rc->setup_pending, false);
+	btrfs_bg_reloc_setup_abort(rc->block_group);
 	return ret;
 }
 
@@ -3937,6 +4132,14 @@ static const char *stage_to_string(enum reloc_stage stage)
 	return "unknown";
 }
 
+bool btrfs_relocation_uses_fenced_setup(const struct btrfs_block_group *bg)
+{
+	const u64 mixed = BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_METADATA;
+
+	return (bg->flags & mixed) == mixed && !btrfs_is_zoned(bg->fs_info) &&
+	       !should_relocate_using_remap_tree(bg);
+}
+
 static int add_remap_tree_entries(struct btrfs_trans_handle *trans, struct btrfs_path *path,
 				  struct btrfs_key *entries, unsigned int num_entries)
 {
@@ -5404,7 +5607,6 @@ int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start,
 	struct inode *inode;
 	struct btrfs_path *path = NULL;
 	int ret;
-	bool bg_is_ro = false;
 
 	if (unlikely(!extent_root)) {
 		btrfs_err(fs_info,
@@ -5455,15 +5657,24 @@ int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start,
 	rc->extent_root = extent_root;
 	/* Block group ref now owned by rc, put_reloc_control() will drop it. */
 	rc->block_group = bg;
+	rc->fenced_setup = btrfs_relocation_uses_fenced_setup(bg);
 
 	ret = reloc_chunk_start(fs_info);
 	if (ret < 0)
 		goto out_put_rc;
 
-	ret = btrfs_inc_block_group_ro(rc->block_group, true);
-	if (ret)
-		goto out;
-	bg_is_ro = true;
+	if (rc->fenced_setup) {
+		/* Keep non-metadata writers out until the setup tail marks RO. */
+		ret = btrfs_bg_reloc_setup_start(rc->block_group, false);
+		if (ret)
+			goto out;
+		WRITE_ONCE(rc->setup_pending, true);
+	} else {
+		ret = btrfs_inc_block_group_ro(rc->block_group, true);
+		if (ret)
+			goto out;
+		rc->block_group_ro = true;
+	}
 
 	path = btrfs_alloc_path();
 	if (!path) {
@@ -5494,12 +5705,14 @@ int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start,
 	if (verbose)
 		describe_relocation(rc->block_group);
 
-	btrfs_wait_block_group_reservations(rc->block_group);
-	btrfs_wait_nocow_writers(rc->block_group);
-	btrfs_wait_ordered_roots(fs_info, U64_MAX, rc->block_group);
+	if (!rc->fenced_setup) {
+		btrfs_wait_block_group_reservations(rc->block_group);
+		btrfs_wait_nocow_writers(rc->block_group);
+		btrfs_wait_ordered_roots(fs_info, U64_MAX, rc->block_group);
 
-	ret = btrfs_zone_finish(rc->block_group);
-	WARN_ON(ret && ret != -EAGAIN);
+		ret = btrfs_zone_finish(rc->block_group);
+		WARN_ON(ret && ret != -EAGAIN);
+	}
 
 	if (should_relocate_using_remap_tree(bg)) {
 		if (bg->remap_bytes != 0) {
@@ -5521,8 +5734,15 @@ int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start,
 	}
 
 out:
-	if (ret && bg_is_ro)
+	if (rc->setup_pending) {
+		ASSERT(ret);
+		WRITE_ONCE(rc->setup_pending, false);
+		btrfs_bg_reloc_setup_abort(rc->block_group);
+	}
+	if (ret && rc->block_group_ro) {
 		btrfs_dec_block_group_ro(rc->block_group);
+		rc->block_group_ro = false;
+	}
 	if (!btrfs_fs_incompat(fs_info, REMAP_TREE))
 		iput(rc->data_inode);
 	btrfs_free_path(path);
diff --git a/fs/btrfs/relocation.h b/fs/btrfs/relocation.h
index bb7a86e7dbe3..210d0bbd7d48 100644
--- a/fs/btrfs/relocation.h
+++ b/fs/btrfs/relocation.h
@@ -11,6 +11,7 @@ struct btrfs_root;
 struct btrfs_trans_handle;
 struct btrfs_ordered_extent;
 struct btrfs_pending_snapshot;
+struct btrfs_transaction;
 
 static inline bool should_relocate_using_remap_tree(const struct btrfs_block_group *bg)
 {
@@ -25,6 +26,9 @@ static inline bool should_relocate_using_remap_tree(const struct btrfs_block_gro
 
 int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start,
 			       bool verbose);
+bool btrfs_relocation_uses_fenced_setup(const struct btrfs_block_group *bg);
+void btrfs_finish_relocation_setup(struct btrfs_transaction *trans);
+void btrfs_abort_relocation_setup(struct btrfs_transaction *trans, int error);
 int btrfs_init_reloc_root(struct btrfs_trans_handle *trans, struct btrfs_root *root);
 int btrfs_update_reloc_root(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 8f9419728100..97556bdfdead 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -173,6 +173,7 @@ void btrfs_put_transaction(struct btrfs_transaction *transaction)
 			btrfs_put_block_group(cache);
 		}
 		WARN_ON(!list_empty(&transaction->dev_update_list));
+		WARN_ON(transaction->reloc_setup);
 		kfree(transaction);
 	}
 }
@@ -379,6 +380,7 @@ static noinline int join_transaction(struct btrfs_fs_info *fs_info,
 	INIT_LIST_HEAD(&cur_trans->dev_update_list);
 	INIT_LIST_HEAD(&cur_trans->switch_commits);
 	INIT_LIST_HEAD(&cur_trans->dirty_bgs);
+	cur_trans->reloc_setup = NULL;
 	INIT_LIST_HEAD(&cur_trans->io_bgs);
 	INIT_LIST_HEAD(&cur_trans->dropped_roots);
 	mutex_init(&cur_trans->cache_write_mutex);
@@ -2552,6 +2554,8 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	clear_bit(BTRFS_FS_LOG2_ERR, &fs_info->flags);
 
 	btrfs_trans_release_chunk_metadata(trans);
+	/* Resolve the relocation setup before transaction N+1 can start. */
+	btrfs_finish_relocation_setup(cur_trans);
 
 	/*
 	 * Before changing the transaction state to TRANS_STATE_UNBLOCKED and
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 5e4b1106fd90..bbf3c2b78ce1 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -23,6 +23,7 @@ struct btrfs_fs_info;
 struct btrfs_root_item;
 struct btrfs_root;
 struct btrfs_path;
+struct reloc_control;
 
 /*
  * Signal that a direct IO write is in progress, to avoid deadlock for sync
@@ -77,6 +78,8 @@ struct btrfs_transaction {
 	struct list_head dev_update_list;
 	struct list_head switch_commits;
 	struct list_head dirty_bgs;
+	/* Protected by fs_info->trans_lock. */
+	struct reloc_control *reloc_setup;
 
 	/*
 	 * There is no explicit lock which protects io_bgs, rather its

base-commit: f5bbbfec59b4e2fb7520a91de3df8a6174325d6a
-- 
2.43.0
