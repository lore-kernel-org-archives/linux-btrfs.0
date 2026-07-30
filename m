Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0CB54652
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Jul 2026 00:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785373136; cv=none; b=R0x2uRGl34JuH0KSUCjSrB483KsvGs8P1JtJoFRYi0AEZmJ+eblrb5/PBbt2waljn7Ep3UqrH2y3s4L6sJBN+dLgog6UWkSTw2qSopBDa4hwrwcfOyN+eHS4zcz16ySfce4TKY51p2rY+o/fZt/zYiEr2VYuB00Qqz0ReA/p4gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785373136; c=relaxed/simple;
	bh=c6TWExPFrMYAwbfDK62thCDb1w3dahQxyBw0XzR3qII=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=A01/VSxxJ5SQ4GpKSouUyHS8KS7RBQGzbhpQAJNbj3NTO6dMmlXfCj5NJeXCE+tnu+vFRwmfduC8MZJ3ZwnghW/FbA0qlXFU9nCh42zZFDEMOp+h7TLZlqjnsOA4arfI/laZY1snzaZVhiwFXN8JbOmhzP//8q+KHw/2qki+F80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=HwTjRCmu; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=kC7QgRzL; arc=none smtp.client-ip=202.12.124.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="HwTjRCmu";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="kC7QgRzL"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 25D147A053F;
	Wed, 29 Jul 2026 20:58:53 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Wed, 29 Jul 2026 20:58:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1785373133; x=1785459533; bh=EFTGtn3+Faj//vKsxFt9Q
	UAR0pAstgbCWE+bdSut9zs=; b=HwTjRCmuOcb/rl8o2B/uXivEKtxMhHak88+wu
	gwl9gSwrBGmE3uHGYOXeNnGHxvrLU9sodwJC88o6AuNbM8dhVmFxEEwLvFPNjleg
	KVJ9DIGnQGd21/wfbzGw4LxvI4ad3oXoUknFF3LqbVb9seEcglXkqdFXowm21780
	Lg+El68un1C4pgzY+rnIHJuEbIDFquyI3Sg92gDwbUcK/N4RlfoZm99cNkbnRqRS
	1eLnlu2uDIjP+1cwxlHeBfIFWX/52VonpJiLh36Sj/o4a+LqnaT9WMZPeE1glG08
	jWkpQmw80ACjH5bTJIYgRdHa9D19zzYnnOQi/WHhRxTcADMGQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1785373133; x=1785459533; bh=EFTGtn3+Faj//vKsxFt9QUAR0pAstgbCWE+
	bdSut9zs=; b=kC7QgRzL47OF9RZQi1iymNfgNzmc/YuSYgof9uU6p1qnzf1t2Zm
	usdoKPDGlcHZfcyRrNpKguhGJTgaY5Ez7n0ybBy2RC6Kz9v6EM0q7ZJZsHZITWmv
	I/J+lkrAkxuhxkmz76dP5icXoKaHThPBB35rRyR/IRtbXSBNq5JfKpz/6iJGlwGX
	9+sgc/5Rsj7oD2xpBl9UHIStYrd9aewUZTivKTzaRUZ7t8sGhSGriN/49W2RyMYh
	74ML6/kVazsf6vWaKarvhDD9ZMrBm6uCPzvBgbC/DUyu3427Rfi+G/XQMgX6dlm7
	dXXFpLIvHSEcWpQD1I5At7yeWByVGX7FksQ==
X-ME-Sender: <xms:zKFqai4qYk6nRE0I6T8AyWrlTdOuxhHTWl-JUruUXS_rcrRIVkqd_A>
    <xme:zKFqah7prDAtyOn25yhYSE-RuhnM1CoH_3C3IombDKIB3VTtgYBhB--k9PvUi3AvK
    vTgW5Qnf5kVNjGZ1ic-lMhHeoLJk_MdcakUPMjCLsA4g9uP7iVKgNo>
X-ME-Received: <xmr:zKFqavErATOEnYVvVX9TkJwadv1351jDVoJ64_pv6zPE7iTE8AxmsxGUVtYoEd8zO0nhtAFm0KDQUD72h_fE2bdt6Jk>
X-ME-Proxy-Cause: dmFkZTEzCEiCAsiSuy1CJeluZwLcHk/l8E6RQgob1R2VxHSzJuwf/PhHdYAtXK6NN2oYWz
    3i8x0bW/iMq+qs7/oSGA/ZM8bCHIVMa61oN1T/jkl/S9/xSTG6/NWbwgpLjNMIAV4oC4wM
    BREfOYHcQkX2g4T0SQMbybuDZbMbIqeJCs3bTy+QJ6i3751BTIYH1DYISUlwm0va3N0FJ6
    RKn3ng3TeAgNw6wIkJLzydutj8ZeMEtYv6+97ME6p7eF+bw0e8nbNjDfWAUOJFc9HCny97
    ZgUFEn+vwFQmS/3JYbyF781iobXVOQ/6B8mcNalb2LBK6sLGACyf7wdxGXXH9NmTswgoYH
    Z7DG/yte/446DR9qRuoHXN9cBWJuynMvsdEXUvDkkh7LVjajVLWaBnbYVrhBpXt0TEu9aF
    et6HcGEUiQSJ6nwiBoBkOVCy3jHg2jUQUKYLUGbXzG7ZOnD+gq01/g4Fm89D+2+c7yCwMJ
    3bSNkqyCKWGKN8x7+WdkHeZRGFJkY2R1oNrdcXZReTkFYBn9OE3OBoKZahQOqOwhOftUUW
    pUXfQefdU22JKPBDs3aOa7fokg/kDV4SzXU6Awls76jVzr/NGnuqYrB6MvxYC+QRJz10Hp
    0neeYwO4poOhKnzAJEjWNA01y0Y5Z10rZyRkZWG7hCRxXMntq79dKsxG/Waw
X-ME-Proxy: <xmx:zKFqaqSEAG3Nney3fUvRJc9ekQnhBFRNwLAVgujk36foKnUK9ERuAg>
    <xmx:zKFqaotPWknPVQ5jqxuXFe0PgCTL4HlG-EwD--I_nD8s1oNJsBBcYg>
    <xmx:zKFqapyrpto3vQCS8Alk76bk6jiPWpB6YvTaiQXCRuwSBrJEmIyq_Q>
    <xmx:zKFqai7siS5WBSRsLu0M7hMo8aiRNcTTCMJxDwpJGSqYjuUp8-YjkA>
    <xmx:zaFqalc5fncrZNUXg14vLw3XHpCpUkjor46k4ZmwLqiBJ3bmjrXtCNQT>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 29 Jul 2026 20:58:52 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v1] btrfs: flush the fixup workers during close_ctree
Date: Wed, 29 Jul 2026 17:59:10 -0700
Message-ID: <8b2ac16ef9cce964c2546a71249514899268cfa5.1785373134.git.boris@bur.io>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reintroducing the COW fixup worker brought back the unmount race fixed
by commit 41fd1e94066a ("btrfs: wait for fixup workers before stopping
cleaner kthread during umount") without bringing back the fix.

A fixup work item queued by the final writeback pass can still be in flight
when close_ctree() stops the cleaner kthread and frees the fs roots.
While destroy_workqueue() drains the queue, that happens after the
cleaner thread was freed, so btrfs_add_delayed_iput() called from the
fixup worker is no longer safe (not to mention that we are already in
BTRFS_FS_STATE_NO_DELAYED_IPUT when it runs).

Therefore we need to bring back explicitly flushing the fixup workqueue
as in Filipe's original fix. The first flush will catch all the fixup
writeback queued during the final sync before umount, but some of that
might hit memory allocation errors and stay fixup in the blocks/folio,
leading any subsequent writeback triggered *inside* umount (e.g. reclaim
workers shutting down) to hit it and queue again. To fix that, and the
possibility of any really long-lived pinned folios getting marked, deny
queueing new fixup during umount. That allows us to flush twice (once
before doing a real writeback pass to get the actual data, second time
to clean up any rather unlikely stragglers right before declaring
BTRFS_FS_STATE_NO_DELAYED_IPUT) and be certain nothing got re-queued.

Reproduced by injecting a one-shot 30s sleep at the head of
btrfs_writepage_fixup_worker() on a KASAN kernel, running the normal
reproducing read dio workload before unmount and then observing:

  BUG: KASAN: slab-use-after-free in _raw_spin_lock_irqsave+0x35/0x50
  Read of size 1 at addr ffff88810b4b08f8 by task kworker/u32:5/219
  Workqueue: btrfs-fixup btrfs_writepage_fixup_worker [btrfs]
  Call Trace:
   _raw_spin_lock_irqsave+0x35/0x50
   try_to_wake_up+0xc0/0x18c0
   btrfs_writepage_fixup_worker+0x7f3/0xf20 [btrfs]
  ...

Fixes: 4be9c7da6860 ("btrfs: trigger cow fixup via dirty_folio()")
Assisted-by: LLM (reproduction, analysis)
Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/disk-io.c | 21 +++++++++++++++++++++
 fs/btrfs/inode.c   | 15 +++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7a2f7006085d..cc4dcd10631a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4377,6 +4377,18 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	/* clear out the rbtree of defraggable inodes */
 	btrfs_cleanup_defrag_inodes(fs_info);
 
+	/*
+	 * Before the unmount, we sync down all the writeback which can
+	 * generate fixup work. We are about to run delalloc for autodefrag so
+	 * piggy back on that by also flushing the fixup work which can also
+	 * generate delalloc we would like to get run.
+	 *
+	 * After this, it is still possible that some thread doing writeback is
+	 * in btrfs_queue_writepage_fixup() and might finish queueing some final
+	 * work, racing the btrfs_fs_closing() check there.
+	 */
+	flush_workqueue(fs_info->fixup_workers);
+
 	/*
 	 * After we entered close_ctree() autodefrag could be running and before
 	 * we parked the cleaner kthread, it dirtied folios of some inode.
@@ -4469,6 +4481,15 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	cancel_work_sync(&fs_info->preempt_reclaim_work);
 	cancel_work_sync(&fs_info->em_shrinker_work);
 
+	/*
+	 * Reclaim workers can run writeback which can queue fixup.
+	 * After the above cancel_work_sync() calls, any such queueing attempts are
+	 * guaranteed to see btrfs_fs_closing(), so at this point we can genuinely fully
+	 * flush the fixup workqueue. This relies on the belief that *now* no thread can
+	 * still be sitting in btrfs_queue_writepage_fixup().
+	 */
+	flush_workqueue(fs_info->fixup_workers);
+
 	/*
 	 * Run delayed iputs again because an async reclaim worker may have
 	 * added new ones if it was flushing delalloc:
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 78143e241ca4..51d460572317 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2964,6 +2964,21 @@ void btrfs_queue_writepage_fixup(struct btrfs_inode *inode, struct folio *folio)
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct btrfs_writepage_fixup *fixup;
 
+	/*
+	 * Disallow queueing more fixup during unmount to break the cycle
+	 * of writeback queuing fixup queuing writeback etc.
+	 *
+	 * If it actually hit, then something which was fixup wasn't written
+	 * which we should warn about.
+	 */
+	if (btrfs_fs_closing(fs_info)) {
+		btrfs_warn_rl(fs_info,
+	"dropping unqueued fixup blocks at unmount. root %lld ino %llu folio %llu",
+			      btrfs_root_id(inode->root), btrfs_ino(inode),
+			      folio_pos(folio));
+		return;
+	}
+
 	fixup = kzalloc_obj(*fixup, GFP_NOFS);
 	if (!fixup)
 		return;
-- 
2.55.0

