Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793875502;
	b=VkgcmLQQJTx6S0g/OVmt+RhatTbh2TYc82LkdZdmvwjjq2RNbQvEvj35ZKZtOweYD/VL
	 tavZb9saL0vJWs7Iy8QNM2/6r1P4HUNChFomQICJV8lwR+Sy6eVFPA6suu1xnp0jBDmKR
	 A3POaui48KAwa3HdlEOudqqHlUPzxFB35jEbX3UhjJ+ojRbYNHqbjHS/J/6QLCO2qL2TE
	 1Pdnoj/6KOYi9oCpEBFfQUCTwwZDomDAGMtS+e7DeVQ/y6BLOGxFC97Ei56maLDxPCOZa
	 5h9naDmIWVObNxGhbtWlhE8iIn3yG5D34BQ3a1WxFKrivVH6tRD3lX4DLdvy+HEJ0Iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793875502;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0ZC/iI28vwrYalQvm6SZLMWN3Zv4hpCuCa2ER9t16Xo=;
	b=I8MQdutJz3EHI1+Skpxq7FmGbmNlxCf1/blcW+woIeleVU/ZlREF26EYVC0xGMtyPz5n
	 Jj+ekLGpjgFgY0Kt9bGsKcDULQjE9kt7tEPSmGVGf8itNHK5lPdB3+qEj71WUSrvMnr9Z
	 3LCZ4ZNpXHqYiKG1nd2lZTb58DFtlDMrMrXBslqSLGeg960nZ8VAa4rjm5XpzjYRG4Lfc
	 4UyAxsfiOG6CLTvfKSzogBcRvDVd5EHNTTEIBjg6Il7CWw3KU7puzI+zmV40gScZtcA9m
	 emq4wV8sI8aeBZeYuxhNPWPfgZggjwLMwLs4XNKYlM4QC5mMduwDEifY894KCM/la2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=RgheXv6s;
	arc=none smtp.remote-ip=111.22.67.139
Received: from cmccmta6.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 498B8606D823;
	Thu,  5 Nov 2026 10:44:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 498B8606D823
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=RgheXv6s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=RgheXv6sTuIm/kK5vHWxL6k1I3SnVLdR2SidqHevJtVo9H9MmSxibIibiXJ+Pom36W/tsm7mIfY9G
	 RTTkKhWd2+jhdOyI7o+lV/XVDrJA2iDRFdj95t26DXU1qbGJ/VD7JdIf42bEy4xgHcZ63tcqFs+0ay
	 0XrdE6XY6V8gbl1o=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app01-12001 (RichMail) with SMTP id 2ee16aec5e2976d-82894;
	Thu, 05 Nov 2026 18:44:58 +0800 (CST)
X-RM-TRANSID:2ee16aec5e2976d-82894
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from utest (unknown[223.108.79.103])
	by rmsmtp-syy-appsvr08-12008 (RichMail) with SMTP id 2ee86aec5e2512f-467e7;
	Thu, 05 Nov 2026 18:44:58 +0800 (CST)
X-RM-TRANSID:2ee86aec5e2512f-467e7
From: Shunbo Shi <shishunbo@cmss.chinamobile.com>
To: fdmanana@kernel.org
Cc: dsterba@suse.com,
	mason@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+7ec60f4482abeecb0fd8@syzkaller.appspotmail.com
Subject: [PATCH v2] btrfs: fix delayed_refs_rsv leak when realloc shrinks an extent
Date: Thu,  5 Nov 2026 10:44:53 +0000
Message-ID: <20261105104453.2151-1-shishunbo@cmss.chinamobile.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAL3q7H6w1sY5R_+Ajg-uHYx_=KjeUwyt5Aw=Zj+qViLXKcB+_A@mail.gmail.com>
References: <CAL3q7H6w1sY5R_+Ajg-uHYx_=KjeUwyt5Aw=Zj+qViLXKcB+_A@mail.gmail.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a data extent is freed and reallocated (with a different size)
before its delayed refs are processed,
btrfs_alloc_reserved_file_extent() reuses the existing delayed ref
head and update_existing_head_ref() updates existing->num_bytes to
the new size, but neither adjusts the space used for checksums nor
releases excess space from the delayed refs block reserve.

The csum space for deleting the checksums was reserved for the
original size in add_delayed_ref_head():

	pending_csums += head_ref->num_bytes;
	trans->delayed_ref_csum_deletions += csum_leaves(num_bytes);

but when total_ref_mod later turns non-negative,
update_existing_head_ref() releases the reservation based on the
new num_bytes:

	pending_csums -= existing->num_bytes;
	btrfs_delayed_refs_rsv_release(fs_info, 0, csum_leaves);

For a smaller new size the difference between the old and the new
size is never released, so delayed_refs_rsv.size (and .reserved)
stay above zero forever.  At unmount this triggers

	WARNING: fs_info->delayed_refs_rsv.reserved > 0
	at btrfs_release_global_block_rsv

and at runtime the leaked reservation keeps inflating
space_info->bytes_may_use, which can lead to premature ENOSPC.

For a larger new size the release subtracts more than what was
reserved for the head: if the rsv does not hold reservations of
other delayed refs, delayed_refs_rsv.size underflows and leaks
reserved bytes; otherwise the rsv prematurely releases reservations
belonging to other delayed refs.

Fix this by adjusting the csum accounting to the new size at the
time existing->num_bytes is updated, while the head is still in the
reservation state (total_ref_mod < 0): release the difference in
csum leaves for a smaller size, and grow the rsv size by the
difference for a larger size.  The grow direction must take effect
immediately (btrfs_delayed_refs_rsv_add()) rather than via
trans->delayed_ref_csum_deletions, because the total_ref_mod
transition below may release the new size in the same call, while
the trans counter is only folded into the rsv afterwards by
btrfs_update_delayed_refs_rsv().

Fixes: ba2c4d4e3bda ("btrfs: introduce delayed_refs_rsv")
Reported-by: syzbot+7ec60f4482abeecb0fd8@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-btrfs/6ae88b9e.64e51036.15cf6a.0027.GAE@google.com/
Signed-off-by: Shunbo Shi <shishunbo@cmss.chinamobile.com>
---
 fs/btrfs/delayed-ref.c | 61 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/delayed-ref.h |  4 ++-
 2 files changed, 64 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 8bc1929237f7..45e269670068 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -63,6 +63,31 @@ bool btrfs_check_space_for_delayed_refs(struct btrfs_fs_info *fs_info)
  * Drops the delayed ref head's count from the delayed refs rsv and free any
  * excess reservation we had.
  */
+/*
+ * Grow the delayed refs rsv size for csum items to be deleted.
+ *
+ * Unlike trans->delayed_ref_csum_deletions, which is folded into the
+ * delayed refs rsv by btrfs_update_delayed_refs_rsv() at a later point,
+ * this adjusts the size immediately.  It is needed when a ref head's
+ * num_bytes is updated to a larger size and the head's reservation is
+ * released in the same call to update_existing_head_ref(): the release
+ * path subtracts from the rsv right away, so the size must cover the
+ * new csum leaves before that happens, otherwise the rsv would
+ * over-release reservations of other delayed refs.
+ */
+void btrfs_delayed_refs_rsv_add(struct btrfs_fs_info *fs_info, int nr_csums)
+{
+	struct btrfs_block_rsv *block_rsv = &fs_info->delayed_refs_rsv;
+	u64 num_bytes;
+
+	num_bytes = btrfs_calc_delayed_ref_csum_bytes(fs_info, nr_csums);
+
+	spin_lock(&block_rsv->lock);
+	block_rsv->size += num_bytes;
+	block_rsv->full = (block_rsv->reserved >= block_rsv->size);
+	spin_unlock(&block_rsv->lock);
+}
+
 void btrfs_delayed_refs_rsv_release(struct btrfs_fs_info *fs_info, int nr_refs, int nr_csums)
 {
 	struct btrfs_block_rsv *block_rsv = &fs_info->delayed_refs_rsv;
@@ -694,6 +719,42 @@ static noinline void update_existing_head_ref(struct btrfs_trans_handle *trans,
 		existing->must_insert_reserved = update->must_insert_reserved;
 		existing->owning_root = update->owning_root;
 
+		/*
+		 * The extent may have been reallocated with a different
+		 * size before its delayed refs were processed.  The csum
+		 * reservation was made for the old size (see
+		 * add_delayed_ref_head()), so adjust the accounting to the
+		 * new size here; otherwise the release done when
+		 * total_ref_mod turns non-negative below is based on the
+		 * new size while only the old size was reserved: for a
+		 * smaller size the difference is leaked, for a larger size
+		 * the rsv over-releases reservations of other delayed refs.
+		 *
+		 * Both adjustments must take effect immediately: the
+		 * total_ref_mod transition below may release new_leaves in
+		 * this same call, while trans->delayed_ref_csum_deletions
+		 * is only folded into the rsv by
+		 * btrfs_update_delayed_refs_rsv() after we return.
+		 */
+		if (existing->is_data && existing->total_ref_mod < 0 &&
+		    existing->num_bytes != update->num_bytes) {
+			u64 old_leaves = btrfs_csum_bytes_to_leaves(fs_info,
+							   existing->num_bytes);
+			u64 new_leaves = btrfs_csum_bytes_to_leaves(fs_info,
+							    update->num_bytes);
+
+			if (new_leaves < old_leaves) {
+				btrfs_delayed_refs_rsv_release(fs_info, 0,
+					       (int)(old_leaves - new_leaves));
+			} else if (new_leaves > old_leaves) {
+				btrfs_delayed_refs_rsv_add(fs_info,
+					       (int)(new_leaves - old_leaves));
+			}
+
+			delayed_refs->pending_csums += update->num_bytes;
+			delayed_refs->pending_csums -= existing->num_bytes;
+		}
+
 		/*
 		 * update the num_bytes so we make sure the accounting
 		 * is done correctly
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index 5ce940532144..f8434347b80b 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -408,7 +408,9 @@ struct btrfs_delayed_ref_node *btrfs_select_delayed_ref(struct btrfs_delayed_ref
 
 int btrfs_check_delayed_seq(struct btrfs_fs_info *fs_info, u64 seq);
 
-void btrfs_delayed_refs_rsv_release(struct btrfs_fs_info *fs_info, int nr_refs, int nr_csums);
+void btrfs_delayed_refs_rsv_release(struct btrfs_fs_info *fs_info, int nr_refs,
+				     int nr_csums);
+void btrfs_delayed_refs_rsv_add(struct btrfs_fs_info *fs_info, int nr_csums);
 void btrfs_update_delayed_refs_rsv(struct btrfs_trans_handle *trans);
 void btrfs_inc_delayed_refs_rsv_bg_inserts(struct btrfs_fs_info *fs_info);
 void btrfs_dec_delayed_refs_rsv_bg_inserts(struct btrfs_fs_info *fs_info);
-- 
2.53.0



