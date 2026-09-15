Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC3342E404
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2026 17:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789495105; cv=none; b=BBNSVPlwt0xS23igwsSYK9c1hwZSyQPJBCrUNQRYMPPs21LVN3jViicXeP/Hp5jP7AyQ3GXzU3IONXiVUwWGaqqIU5okZ7UGAyXcCnbclXSEKcXMrve07owhOqOJhZK1g2fMpET9VqgukOyvw3pP7gecpLh0q4SsK5o1dp7nHSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789495105; c=relaxed/simple;
	bh=PbVZhkufGPjkaXt/8a8sq1u2RrJsVjbUm4zaNMIJc8g=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/ig3tcpCHVmqVuTwwfJXStGUEjKOSxhzx8T2U+X6mIejO0LVU2i/z6liW1pkBoZLBpT9u865b9ZYgVqFYrtXlQmMb8MDvFV7au8+s51lI3sUybndUhFUmBVd7D+fM0qtnDdUNpIHoQizQrB1ud1e1XhN+Uv6WoxkayLqe+Q1BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=V7VxKffB; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=bH2tXZuW; arc=none smtp.client-ip=202.12.124.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="V7VxKffB";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="bH2tXZuW"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id 2EFE71D0013A;
	Tue, 15 Sep 2026 13:58:23 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Tue, 15 Sep 2026 13:58:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789495103; x=
	1789581503; bh=XubQtVF+tUEBwxJU0/7TfZYhEFA6bxYUhRDPezfmn8E=; b=V
	7VxKffB3DlpYH4Juovw8kSfVsWx56+T+XTp2+sFCb0pHLuVur/L1peyxeshWZsLG
	IwqqnRpFZuBKzG0SopfE+2YwKQSJcaKKhdCAXQCu3kX2pdt37UTBpswEDh9NTcz2
	T1zYig7344NmptZpAjH/pBXieGuXc5kQg9q2iHnPJF4KnNVIXBWmBkVxkTWo/XZm
	5Y+YiuWLp1kTbxTA8mP9BnEN0iyhZYpOpC710FvSnXWMUJ9A5I/qX+E/JKfuD9bm
	kG3UQxr01hy19yoyoDJk+OX+w1klP98IksJt81jyAC23TKmbswAwmJWYf/zO4rHW
	Q3VtnCfXH3dl1HG0h2BfA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1789495103; x=1789581503; bh=XubQtVF+tUEBwxJU0/7TfZYhEFA6
	bxYUhRDPezfmn8E=; b=bH2tXZuWJCq9LOfmDkd/F9kdvBnA5dlCIvR8p4oNjoyB
	XVr90ajLuRk7G8ndEA/10SNTSsr8fHeQDE7ppToq3aJ8VO1mNBNbDys81nLhE92x
	5Xn+lIv6gUFMmy/t6m9jA6YLvhNS/Ledf2em0sfSwGSomozrHCfVsbhU0wlcFdki
	qV2GhAcaTh9ZSW7V7o+ZJaydUPo3/mG7SVHkCEc3mkUb3ZKS4C4jxOH0Ng1kL8xZ
	oh2e9Iq8cOqgnQ2ACNbSSXTicBkKqK26vz/pZfaH6sqybPOly9VJr+r6bPFxpKMJ
	Bibs6SAf/+e/3PepSkEuigqIHazAOIQveWu5ZqL4og==
X-ME-Sender: <xms:PoepakLLoyqAK8QDEgp2Hp65kxdfMXIYMsqfi3oZRie4n7G-lT2xuA>
    <xme:PoepaqJ2xsWsKY7huCOzCBqhJ_1jm99oCO8KGUhos_rW0ifYxWh9bOzVMz1HF8G1m
    PefgBW26kMw_qN9D-8UAbXvWli504L0fo9co96Af08SXrTRc9tFeFr4sg>
X-ME-Received: <xmr:PoepaiUFt5GfxeA9Cq7rZHGGSNl-31H3nb95ksK7oBSQUdt3vcrga54>
X-ME-Proxy-Cause: dmFkZTFQMm4JHICtzTDS3CcC10keKNmdTwpbleNNC+5TGYJanvsOjSZ062Wy5OyIu1ikia
    B08N4mNMHaBUHCtK+Xcb1qwmAxWj0xgc23fQHw2lCsm+A/GzWYryUXpQcHjVLQmxA1Ds31
    +ImfWoap2usUY2+DSsTgMn6ZoIlJka8cFdCdOxYbK5VHOM3rt+vM8LVYa9z3bxZ7iATdmr
    EoQtN5ScuEcaPNK4O2xkYO6tRMfuVHsTjEmbqdBwSVLCeleix81Ga+VParVPlKtyE7IC9R
    eJLhcOz2vC4MARlo77XB5QRDglPiaokwAIv+XfuqVdCWNrlqSkgIq4L4wtp++CckPSE0Ke
    vH1tgr7mA8iN3wHPiGppfuIxs9KUl0ct/C6UYlIiw1dL105CT4pMkaUZOs7e4o6AHxNvJK
    fgzKJOBq5Fdso0uzIvuG/sAqx8ysBgRSbYQ6VDGUYigC9O3I+6ehE44dlGe1VB3FmPlLvc
    OUcqpVsjLCLjOzF07Y7n1OM69JhqwC9192ZxVhV3L6EnQfNwDpQ6rieG+V/WYZWThJVKCO
    qUs1stMWEfGKC2ziiBKpuFp+MoNu7yZqVAiryqp+oeiSnzrelEr4A6XaGXz26fo74eCcP1
    qeUi9Yx16ErghQ6XP+4K9ZI+dMW98O7FhszpkQ5C+PefDKBp1Kftldg7qOTg
X-ME-Proxy: <xmx:Poepasi3gnXRDZFSmUu6Ux12WOYb8mRsBthXkMJBU0zyHpLRJ9Gk5g>
    <xmx:Poepat9t7D9eCwHeID7LbRdKzQxsN_phcGmUnTXT5zx0YK7Ea7oQyQ>
    <xmx:PoepamANjesWOqqy6HVkHQGLzBamOaUueR-nQ0cC0fon8biG4Q9SCw>
    <xmx:PoepaqKkJ3VGebDCn_YoqnZfcx66oNK6a4nwRlYNs9wjB4yQuQmWkA>
    <xmx:P4epauJt2j4laPSOOR1IEdbGthRTpmFJufGJMtk4PoyT8_qVPodhmR3i>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Sep 2026 13:58:22 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v3 3/3] btrfs: downgrade the reflink source inode lock for tree walking
Date: Tue, 15 Sep 2026 10:58:33 -0700
Message-ID: <069b34c29713b4574ad37cfe55e728d555e019b2.1789494885.git.boris@bur.io>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1789494885.git.boris@bur.io>
References: <cover.1789494885.git.boris@bur.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When doing a reflink, we are not writing to the src inode or modifying
it in any way, so it is counter-intuitive to have to lock it
exclusively. This has the cost of blocking other shared lock users of
the src file for the duration of all the writeback and reflinking.

There are two important gotchas to do with direct io that must be
addressed to make this idea work.

The first gotcha is that dio writes that come in under EOF try to take
inode->i_rwsem shared, which would result in messed up views of the
extents in the reflinked file. Therefore, add "being used as a reflink
src" as another inode flag exception for the dio write shared tests that
already exist to check for other dangerous conditions. In order to
ensure that this flag is visible to the dio writer, reflink must first
take i_rwsem exclusive, then set the flag, then downgrade to shared.

The second is that dio reads increment inode->i_dio_count which blocks
inode_dio_wait() in __generic_remap_file_range_prep(). Therefore, we
must remain exclusive to dio reads through finishing the prep or risk
starving the clone on a stream of dio readers. There is still O(extents)
work in btrfs_clone() which can be done without holding the lock
exclusive, so we should downgrade to shared and admit dio readers (and
other shared lock users like lseek) after we are finished with
inode_dio_wait().

By running concurrent clones and lseeks or dio reads on a src file with
32k extents on a vm, I can demonstrate 100ms+ stalls on the readers
without this patch and they go away entirely with the patch.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/btrfs_inode.h |  6 ++++++
 fs/btrfs/direct-io.c   |  7 +++++++
 fs/btrfs/reflink.c     | 17 +++++++++++++++--
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 46c62f980c24..03c00c99099d 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -99,6 +99,12 @@ enum {
 	 * range).
 	 */
 	BTRFS_INODE_COW_WRITE_ERROR,
+	/*
+	 * Set by reflink while it holds the source's VFS inode lock shared.
+	 * Direct IO writes also take that lock shared; one that finds this bit
+	 * set after acquiring it must retry with the exclusive lock.
+	 */
+	BTRFS_INODE_REFLINK_SRC,
 	/*
 	 * Indicate this is a directory that points to a subvolume for which
 	 * there is no root reference item. That's a case like the following:
diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index 3075d7992713..ed3914257d39 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -913,6 +913,13 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 		goto relock;
 	}
 
+	if ((ilock_flags & BTRFS_ILOCK_SHARED) &&
+	    test_bit(BTRFS_INODE_REFLINK_SRC, &BTRFS_I(inode)->runtime_flags)) {
+		btrfs_inode_unlock(BTRFS_I(inode), ilock_flags);
+		ilock_flags &= ~BTRFS_ILOCK_SHARED;
+		goto relock;
+	}
+
 	ret = generic_write_checks(iocb, from);
 	if (ret <= 0) {
 		btrfs_inode_unlock(BTRFS_I(inode), ilock_flags);
diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index fe765ab27c82..72c1e0db57b7 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -939,6 +939,7 @@ loff_t btrfs_remap_file_range(struct file *src_file, loff_t off,
 	struct btrfs_inode *dst_inode = BTRFS_I(file_inode(dst_file));
 	bool same_inode = dst_inode == src_inode;
 	u64 wb_start, wb_len;
+	bool src_downgraded = false;
 	int ret;
 
 	if (btrfs_is_shutdown(src_inode->root->fs_info))
@@ -976,6 +977,12 @@ loff_t btrfs_remap_file_range(struct file *src_file, loff_t off,
 	if (ret < 0 || len == 0)
 		goto out_unlock;
 
+	if (!same_inode) {
+		set_bit(BTRFS_INODE_REFLINK_SRC, &src_inode->runtime_flags);
+		downgrade_write(&src_inode->vfs_inode.i_rwsem);
+		src_downgraded = true;
+	}
+
 	if (remap_flags & REMAP_FILE_DEDUP)
 		ret = btrfs_extent_same(src_inode, off, len, dst_inode, destoff);
 	else
@@ -986,8 +993,14 @@ loff_t btrfs_remap_file_range(struct file *src_file, loff_t off,
 		btrfs_inode_unlock(src_inode, BTRFS_ILOCK_MMAP);
 	} else {
 		btrfs_double_mmap_unlock(src_inode, dst_inode);
-		unlock_two_nondirectories(&src_inode->vfs_inode,
-					  &dst_inode->vfs_inode);
+		if (src_downgraded) {
+			clear_bit(BTRFS_INODE_REFLINK_SRC, &src_inode->runtime_flags);
+			inode_unlock_shared(&src_inode->vfs_inode);
+			inode_unlock(&dst_inode->vfs_inode);
+		} else {
+			unlock_two_nondirectories(&src_inode->vfs_inode,
+						  &dst_inode->vfs_inode);
+		}
 	}
 
 	/*
-- 
2.55.0

