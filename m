Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD7E433E63
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Jul 2026 16:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785429473; cv=none; b=NgshZ/dfBQHl16j863YpckZD5oPCSkVoAW4N3m2Kr5zACC92VAtY2DQXzLGUHyqcAdrh2xvHqwhnLzcc0Hq7a6ZwFKyzeLXL//zl6pH+jX+mK14DfoedGW0yG55UarAhxauromp6HrSQslh/xmPlmoA0Os21JA6/kqN5YevxHCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785429473; c=relaxed/simple;
	bh=8s4sVHfyi/AK7niu0UKCXnLtVvjbxxEMDB196FnzFM4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=k9qECmYtmHJkqySn1XLFMZteZug45hFoBQUsMCHdPGBXTUFct7sakZregXj92wdOHSk9SZ8ZgC79WdWNdIIIILVP+dUVLlF9ahcsWbZrXKO63UEmoJrI3KTvVdUBqp3DJPx4qtXNbVJmD/YQovDKuGiaRk2gLCzwlu7OPq65FQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=JAQYZLTu; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=hvQPUEMY; arc=none smtp.client-ip=202.12.124.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="JAQYZLTu";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="hvQPUEMY"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id B01D21D000BC;
	Thu, 30 Jul 2026 12:37:50 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Thu, 30 Jul 2026 12:37:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1785429470; x=1785515870; bh=9jrVpd56Tf3yowEnuUu7j
	Sj7iwOk619D6DTtRryQ0n0=; b=JAQYZLTuUqgPchIOqdwpQEcmyX0VxxsVg+MjO
	Z3lb7RBdIxT6C+m1EjIrgKnrJLaQS8UF4o+EHX6tKv+cPHDT21P0/C2JHyLjJRfQ
	sBz89QvYU+l5ub/8BaVE8ViaXbjTf7UxEbVWGnxbKqiKZDWKX55s7FKvUoHEP23u
	JcRBFHrZItsv+nuFqkEZic3/m8QgPZmzuID8x1whPqkeG/bzY7VONlpEJuVk/Vp/
	u3kxLfFc82yyMg2b7JsrWot73j05P5fsMjsEcDoGWG5msn9gp5BwXe0TK4HaTSK/
	0Vgpe5R3f1PorzrvHYzyYQjtPwE2VQTGE7x3hPT0hoA/mwZzA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1785429470; x=1785515870; bh=9jrVpd56Tf3yowEnuUu7jSj7iwOk619D6DT
	tRryQ0n0=; b=hvQPUEMYRZnXd9wQriNJIB2bp2pf/MrGjcY9EtFe1UTJniDL0SC
	lhF3/nLXajHZ+mXxlJH8MI4nt5Pgiw4Ul64prOemT/dACYFvYiTr0eA+6OMUUqRP
	Ji1nxrwmrC5fBKjfbUKmDPoc0SkYcsFgqp4wSRQHvpQsv4tYrz9SEd/lo9415el9
	vairG1Xn6ZjeTMwwKDvnjPI3yI3gaxiXefAKKRAohBCwiLf79GP9K2Ejt/K7e7ij
	qMaPTdLXIEguJouOdHWBXZ+A1WltVhe1P2lADNc2j0iE7jun6Fjb9BhNwcTyxrrc
	SUKyP9FxMUyO9KI1sxKMQ0K3MPZ3mcC3/mw==
X-ME-Sender: <xms:3n1rav87pdTyhJqs3-XrI2pl7fWTAc6DypV-1Sm7OUKkhrUTnFfsfg>
    <xme:3n1rahtF6Ue9T_Xc3iWb1ScpwhUJKj-VwWDy5zqq5hVJVeXKLzmKwXDwK_aEbu6z-
    RuJBky3zUPyBgKNtwLzDn4dzafafHZvuIyoJa-Ks2aNcYpBapLgsl1->
X-ME-Received: <xmr:3n1raqqklYUrNbLcv3ql8ErXz4-m5IHTXY5dm8JwywkEoh8DiawhOice02Pj6Be_3PhY-icqUWSNBnB_h3q89euCTsk>
X-ME-Proxy-Cause: dmFkZTFc6/oxRDqaM9QmteFbqlkdL3gdat1HPOPAR3Z8aB8frWlNr5o6/FBdKiNohCrzeQ
    oK2NR31KbILUyrVdhR8UHKLspza5QKjt8q0AbarMi1P+rrEMGUGEVPJ4eSxlAmvHyD66kZ
    Yjzp6I1IM5FHh9UaNDUd5p2mhfgyJpeFQwKzelQBhSVN300N7XA+CndNFuni5++8a4Mim2
    Yv+A1TKS9Z5naAzUL7DkaJ5wPPj5kiZB7MeNzxIxjFn7eDxR35K+eoD24yl1cT5xLmZ1Qm
    Z9vhFQd3vhDXKcPpQZxgrm5Xnl0s8JgQRJ9CGGGwS7eowAt3OpHeccvPy6f6/nW433TNl2
    PhIF+mzznN1re1q4rB17kluodILjWz3FM4Yfhz/bkZ4vyjy2nWB751eWWMsmBXUyEXCe4T
    7M8cVNhBMDH/XVTkd8FNBC6n3wIf7EzmYEhw5kkyjXhA5Ut4o5biAKNquDtxnfIYY37LPx
    Mv5Gy61FCj9O1DRBSSj6eZSb+RVKcq4ONgSksgoUnil1dJZmGFkXbp4/Gf/+E/me34GbUN
    pDyNZrz3STPfv0HH8oZqSSQWFFknPj2/PjYVLh1wRI5BTZ2nnUaOuQB2muGjUkmrPCiW6n
    epKvWfTbFnwtAp133vrM7/mJld5kLIYrYSksj/VoLKiCfgD7iNNT/2Kb/7lA
X-ME-Proxy: <xmx:3n1ramkhOrMFSeof6SpbX51PmPUotvJ-eIwaPaSDfXdpQEEMuYYmyA>
    <xmx:3n1ramwNV047LP3KuC7ojOr4N28qmrON5WKKbnZm3FKo6sChwie2Yg>
    <xmx:3n1rammqRzY7uNamzA4bDX5FTjAIW8J63o9l-Hdv7adtp2x8Y-RHEg>
    <xmx:3n1raneX_oGLQEO9KqL6SP25YXbn8JEs-ZDGkVO_UuriaA4UakuzHQ>
    <xmx:3n1rarh7_Ay38I3tw1SmjefiEy24ln0Zun2_beZivAToXsyEHZIQbS1Q>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 30 Jul 2026 12:37:50 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v2] btrfs: flush the fixup workers during close_ctree
Date: Thu, 30 Jul 2026 09:38:02 -0700
Message-ID: <97d1b25314a0006e8fa3be0c66cb850f6d08523f.1785428166.git.boris@bur.io>
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
Changelog:
v2:
- clear fixup on skip, following the model of errors in the worker

 fs/btrfs/disk-io.c | 21 +++++++++++++++++++++
 fs/btrfs/inode.c   | 17 +++++++++++++++++
 2 files changed, 38 insertions(+)

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
index 78143e241ca4..04efe183d57b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2964,6 +2964,23 @@ void btrfs_queue_writepage_fixup(struct btrfs_inode *inode, struct folio *folio)
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
+		btrfs_folio_clear_fixup_dirty(fs_info, folio,
+					      folio_pos(folio), folio_size(folio));
+		return;
+	}
+
 	fixup = kzalloc_obj(*fixup, GFP_NOFS);
 	if (!fixup)
 		return;
-- 
2.55.0

