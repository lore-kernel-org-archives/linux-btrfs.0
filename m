Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B67349CF8
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2026 00:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790641706; cv=none; b=NsN4t2r2nHVi+xug5SuM2pQqYXZOK01FokQzX6/wkttcjDW5kFIRTulDJ0FeLnqEFxF0XO6XOCxq/Vqg5br0I0x6e1E60Nia40+LSLJtsG7O1ZwS7xpyqn9IhreuJmKlTMJjzNlcxe/i5mxmnCaHnQbOp+XRzWD38an1Qrapa3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790641706; c=relaxed/simple;
	bh=C4SKYvsjwofceDM8kMvIl5OrAV7bigzadtuMke43JM4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X98EM48TwQENKmvfk3PYWukmNu3eQduJSvYLEhq4joEjU0duKWaJ2NGmu4ZZ2t/zn1sXbJ7k29iIoUnrloZtQVOFGHD7Vx7DGmCQxPyONh03Cd6gCcfiR8mbebsQ68xHVi0zJ/1g/zAdMsZZUHvv1rNdAmrkn2b+sUiZ8Jg42pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=YcP7wpPQ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Lz0ikTIy; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="YcP7wpPQ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Lz0ikTIy"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id 0A2B2EC01CA;
	Mon, 28 Sep 2026 20:28:24 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Mon, 28 Sep 2026 20:28:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1790641704; x=
	1790728104; bh=tEoqHBui4HPEx4D8wrfIs3TR//gJ59qrLicYn9yHfME=; b=Y
	cP7wpPQTnz6nymjD8JLVrRvj1w9I61vbHYRWlZW6TwpbgAYl9+0v/jGU+aZdY4xj
	gFEmgYqQoyYehizF4fyaeKj18NfBcGYJOaSDX1oCpatgfKZ5T/FQFG/sTXkDaDAX
	kBkgv74sYKP0EwlpDbI9q6AT6kVxSgvAzLNCLtaB01hKyjewx+gP8q8UfXWgFXQs
	ju1omu53tHzPpMMhDGSZk2E9N2hko1MqAGKCsa6Ecbzf5yh8doC0u1RBldOBRxL1
	aeD/4q1VIuKENNcfyooI9Ghy/5c4In9vozvK/DyGMJsoIH4NMC4E5G2TFihsjTYQ
	lkZOx0JqDxwpW/iOnYrxg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1790641704; x=1790728104; bh=tEoqHBui4HPEx4D8wrfIs3TR//gJ
	59qrLicYn9yHfME=; b=Lz0ikTIyqCriV1dI0jd7ij2iusamLw2aJttK9Gss99oL
	ZbhmooC3qfXjulOVpQrF8/BTQakogqm40kn2xmk6j58qx9nmM5R/5RpvfGpZPjEQ
	/FVV592oJx2B5l63HVP5AuXu8WTgN++qIz+VbJvu6i8gIfMgb86WjOqrrPOda/8O
	HwRKRr9HjfqyUXA/GdFUPBDIMTDXFVxy9Z/IY3nI9V/Xf3Z8qkuAB+gClKDb1hry
	wslkDDhAG2QqFcMkTx3dYy4EsbLBTg5aRaRL661YXtSHEfX8H/+/jN80ZaF86D3V
	aejYK837LzVFshNPqyT3PIt+r1ilPRl8Wf1ppvOEMg==
X-ME-Sender: <xms:Jwa7agYAYkw0T-TsteiTF3SIY_NBDAvt0gktWKCdZ4v4onijtZmCXg>
    <xme:Jwa7ahYG26N21l7Ob6jfNm73mHuI220-5EHtFE8CbdZqlMADecMzSsQprM_nbEdN0
    iJL4v_ywca-hhdThb9wSVLTMxW9bltZiePPO63EqzMPRF004JJokKBp>
X-ME-Received: <xmr:Jwa7aolRSnB5glnwZDs6Yd65J7FOBe5hRzqXRhWYTJ5eKawE_gXkLNw>
X-ME-Proxy-Cause: dmFkZTExuF93JGdXfiGgW7nhIqu51hI8C5kNPxAejyYwywaiQdYYJWeJi45RH2Q3gCPa55
    VjA+ay/YFd/3pyl8KBeEfpt9QEJvrAosJUDjL4V6R+2haUET5XnHu73J4Q5b45C4HB/iIz
    RNT2T1+2L2LIxqlgyrrQlkjjODfNAxhX0/mc/NasjTh10Z3dHNiS/LO8GoXPoTpyRa+/jQ
    eSwiMTT1t6iRITMpyX7CIBaOxBehrbpLtNmxtIblZXMQrQUB1/pzyoZXtqtaUj7R82UdMI
    6d9FjH8VfZhN/8J8o+38loyKAtAaePXcnHUstIw4xJhFl+boltZk+r8HvaJoa84gUlwKLd
    0+jNly+VbToDaz8F8KSJCwQynzbgzi/A++RxAb45VqbWfR+SFf0k+FIqfuwsC7GQM3bBxt
    NADZ3KTSsUckBrIVf6xNdjOG8rJ/3N6fJIxH6J6f1NbEEB46PwilJTAJVUeIZA/HAKUyKB
    vAQK3kYf5l8MaLOwjoL3O/QNN/tzJRizPoVC6a8knjS1/5RljF9MjzhTauuyeFnG+Slizi
    PPoeEv3Dyk9f8PAohHCWzWfrjgvglz0OnjZtpY0JlfGMIEFzpgNtpLvWklmk6hkPrFqcq0
    CsKSipZmphAa7bUKmHM58E1oHE5baMTHNOnX8/GPXlXPHs9/IXsPHe6mXdmA
X-ME-Proxy: <xmx:Jwa7alwWDLWBQbZ3dQ1OMsVPaWG_mnO7CJ8BguYJqwgDOlIB3oXbDA>
    <xmx:Jwa7auOq0kDTo-QwEG71FNobUNUm5vfAzIto_dhVO8gjmoEisBanKg>
    <xmx:Jwa7ahSgFuDQlr80cWpZOKzHPKjQKmcyImiJR9rBdjcLl37NGlGCUA>
    <xmx:Jwa7akbTeIPpx9ja_DUypvvYfLOlkByBCicHVouCiChLZTAFYm4YJA>
    <xmx:KAa7aqaN3SCpMyR4R_Vp2qfiGvRcvU3LovYU2LreQcY4xlJM8eTjvLRr>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 20:28:23 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH 5/6] btrfs: find_free_extent checks full block groups unlocked
Date: Mon, 28 Sep 2026 17:28:06 -0700
Message-ID: <9b2ec3bafee9195d4fcb5e82a0f054068192f237.1790641462.git.boris@bur.io>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1790641462.git.boris@bur.io>
References: <cover.1790641462.git.boris@bur.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No matter how you slice it, a block group with less free space than the
allocation requires cannot satisfy the allocation, so we can skip it. We
can do this check without taking a lock because it saying yes does *not*
mean that we definitely do find the space locked properly later when
doing the real allocation. But racing with a free and skipping here,
even if we might have said yes could still have raced the same way with
the lock and the allocation still would have failed. On top of that,
this has many fallbacks like the multiple find_free_extent loops and the
fact that on failure we reduce the allocation size and try again.

This helps improve performance on a common case where we have many full
block groups in a large filesystem and want to rapidly skip them.

Measured on a 30T single-device filesystem on a tmpfs-backed loop device:
  20k sequential 1G fallocates:                           26.9s -> 6.7s
  sync of 20k new 64K files after 20k full 1G bgs:        12.7s -> 3.7s
  sync of 20k new 64K files after 20k 1000M fallocates:   12.6s -> 13.2s

Assisted-by: LLM
Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/extent-tree.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 01cab703ef3b..d96de10348c1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4324,7 +4324,23 @@ static int can_allocate_chunk(struct btrfs_fs_info *fs_info,
 static bool find_free_extent_skip_block_group(struct btrfs_block_group *block_group,
 					      struct find_free_extent_ctl *ffe_ctl)
 {
-	if (likely(!block_group->ro && !(block_group->flags & BTRFS_BLOCK_GROUP_REMAPPED)))
+	bool skip = block_group->ro || (block_group->flags & BTRFS_BLOCK_GROUP_REMAPPED);
+
+	/*
+	 * caching_thread() sets FINISHED under a a separate block_group->lock
+	 * critical section after it is done populating, so smp_load_acquire
+	 * guarantees we see the block group as populated by caching.
+	 */
+	if (!skip && smp_load_acquire(&block_group->cached) == BTRFS_CACHE_FINISHED) {
+		u64 free_space = data_race(block_group->free_space_ctl->free_space);
+
+		if (free_space < ffe_ctl->num_bytes) {
+			ffe_ctl->total_free_space = max(ffe_ctl->total_free_space,
+							free_space);
+			skip = true;
+		}
+	}
+	if (!skip)
 		return false;
 	if (ffe_ctl->for_treelog)
 		btrfs_clear_treelog_bg(block_group);
-- 
2.55.0

