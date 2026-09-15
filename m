Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028B043DA5C
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2026 17:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789495103; cv=none; b=Th+Gq0I3TQnIcMrSJ022Huz/s4ktwys/I4u/6xYOhCQ++TEr/pWQnSTq3U1GWKbMS8YrTXaMq6fTL3VGslVU6ENW9zajsZ/t67222/hxdPVCyxgg15Jh/TlzaU7t+vdCItV5BVGmlfhCg8OhgdblOc20AYGCXKKGgtXamXIt76w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789495103; c=relaxed/simple;
	bh=mTnVEzHxOLyuX8cOWkk17Uu7ODAtsMsVp2eWgtxwfT4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nVk0rqWg6wDf49dfWv4fyRzTqsmldQxcTnrG+hcyU996nTV+OcF/PrZ0YcfofD5eahlgFA6OfLEgFi4LwT60U7reCUW1ZKkO7PbV/oE5a5EFbTXBzkcjWOef4Dd/sLOJfoj30GHWA9am4+iJmmO7vid6AHhpfzHK+VLHERbdBXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=rYax99kF; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=oLHHGIH+; arc=none smtp.client-ip=202.12.124.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="rYax99kF";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="oLHHGIH+"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 3DCB87A01BF;
	Tue, 15 Sep 2026 13:58:21 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Tue, 15 Sep 2026 13:58:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789495101; x=
	1789581501; bh=F40LD+jQS/40taUNzvRxiqJaXjCs9o1AXSmXSkWStdY=; b=r
	Yax99kFAH0zPdDfdP8J0OXsLcw1RmgIqvuz8lsnn5mB5gp9WuW8Whvz5NI3FxjGD
	9RxE1zVsF2IC/mcUQ2at+j8+6SA/2Si8MmZ8qiRhSHMcdysXp9ztVELnhzCeHNtq
	XyQkemqQuuMbz/V4fKF114oLfwN8Vma3h1NyifZJ+GoaZQL1jRTh0SlteAswQCLi
	D39OLecG1w2bZhmywW+0qkIe7v6G5Y2SBc9u7LB/PB8Bt07Zs8OTAOYXelInPX46
	Gln7oX0jdWbNIMgkaeGB4kMbY5S+pay7u9RBX0CZkqzsK16QJMfwQVBcN8FG/ZY9
	onHQwpJZAc4owxtD0aswg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1789495101; x=1789581501; bh=F40LD+jQS/40taUNzvRxiqJaXjCs
	9o1AXSmXSkWStdY=; b=oLHHGIH+ZWftQfeD33MiAaWZnzSAhRCFC/UbQNbtD3GA
	1+2WOn5v3+3qALS5CNhI62XCpP+/MVDWeyuEiowjce4WWBh/CIxkssXUA+KzvSa1
	YhU1dgG1oFEuIC7MTAaj4QI2JxT5zHwsCfNBCqAd5xa0OcOBBr97uA+tK1lSlizI
	VLFYM+91UYM8148bzloWLd95ovb6NuVxL1Mt/cofo6E1W42EolBAAymj1yRqd1Dv
	rkoX8ymN87J9JUbuB9vKxoA3j67s57L0jIhR2j3LhhNdIpm13Qo0MWMQLjBt4WlB
	8apZmeE8n3CR6VR/5fEGrgYtmfaoWwmx2Er7s+l2HQ==
X-ME-Sender: <xms:PYepavP0J2jcgC6xNkwJgZF9DTRj-WEOnFvFByrkUdlKoxhZHzE-3g>
    <xme:PYepav88raHSNNX72pVuGJHGsD7cgB1ESJFFxaXaZFhZ5yURjwWcwlAm1tJeEjbL9
    23SLs6CvBttvhhPwfxRn1xVbf8EsuU3S7AodC89yH5iFQ4AoPveYzAv>
X-ME-Received: <xmr:PYepar4I7Qzfu3XXrZSYzRjrlHRY2_a37x03-rNFgohZEakqf1cPVjA>
X-ME-Proxy-Cause: dmFkZTFQMm4JHICtzTDS3CcC10keKNmdTwpbleNNC+5TGYJanvsOjSZ062Wy5OyIu1ikia
    B08N4mNMHaBUHCtK+Xcb1qwmAxWj0xgc23fQHw2lCsm+A/GzWYryUXpQcHjVLQmxA1Ds31
    +ImfWoap2usUY2+DSsTgMn6ZoIlJka8cFdCdOxYbK5VHOM3rt+vM8LVYa9z3bxZ7iATdmr
    EoQtN5ScuEcaPNK4O2xkYO6tRMfuVHsTjEmbqdBwSVLCeleix81Ga+VParVPlKtyE7IC9R
    eJLhcOz2vC4MARlo77XB5QRDglPiaokwAIv+XfuqVdCWNrlqSkgIq4L4wtp++CckPSE0K5
    5rllFuiDWEucs4in6zhR98ulIEn51nyS1SLHBSddkndJbLx9zbdmbtyFKeDxCsmEnR3BnG
    neuw2OAks0m9zPWjQX2kM18cBLrSLxXuFsoAwvEAr1asM8FATLDZ8Gf7TON+sDi/Bi3CU5
    iYVL14JEk0n0HbplfBJSwu/u498XfQhFYXz8aNdzs+HtZ9+YGd+7c6WXfBk5n4MHz3yM5D
    FQRPxrnsVBnux1c7VHS4eP3hYpUTvKFTtqV+E7SVOWI2G8o0aEH7J1FtN6T5xLC7TitrMG
    a+Sz3YwPT83tivut6lLRdhYVkV0QPTNd7Dw0NNSHMY+D0rK/DrgfTdMcUmmg
X-ME-Proxy: <xmx:PYepau21yXGNpvbhCCxJcmMTFrJakFeRk8fDeKaXjs47q5cv9Q-BrA>
    <xmx:PYepaqDhl9LRF_HKt4doFLORw50kVabvm5robeX882uk3v1hsf9XhA>
    <xmx:PYepao28eHyUBva3fcv6wsq0P_XaZsQfr3cxX0FH4cOldgmifG-APw>
    <xmx:PYepasuoX2wAoPjV6wTZdyNSa7nFWWXT9y8m_H1faAPYfBIaA4c_Sg>
    <xmx:PYepalMyaCAlacDPyE86AcwYMilMLTI7MHuSV8Xhj7cdFgjAMDYUW27b>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Sep 2026 13:58:20 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v3 2/3] btrfs: skip unlocked reflink source flush if the inode has writers
Date: Tue, 15 Sep 2026 10:58:32 -0700
Message-ID: <6ffbf81411eae05272e54ce49460e030eb81f91f.1789494885.git.boris@bur.io>
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

The optimistic unlocked flushing is counter-productive if there is an
active writer dirtying pages, as it results in doubly writing back any
pages that get dirtied again before the locked flush. Therefore,
pessimize it slightly and don't do the unlocked flushing if we have
outstanding writable file descriptors or memory mappings. Since the
inode isn't locked, this is only advisory, any new mapping or fd that
sneaks in after the check but before the locking can still cause extra
writeback. But it trivially helps quite a bit in simple cases with a
long open file descriptor or mapping.

I tested this with two similar workloads. One was keeping and fd open
and doing continuous writes into the src file while cloning it and doing
lseek on it and the other was slightly meaner, constantly opening and
closing the fd to try to race this check.

Workload 1 shows a huge regression in write amplification and writers
and readers who experience userspace wall time stalls of 100ms+ with
just the pre-flush, but recovers to normal with this check.

Workload 2 is a smaller regression which is mostly helped but not fully
resolved with this check. So we must weigh this regression against the
benefit of the unlocked flush in the allegedly more common simpler case.

Workload 1: fd kept open, 60s of clone/write/lseek looping.
kernel        clones  clone mean s  device MiB/clone  writer stalls  reader stalls
for-next         564         0.095               119             10             10
pre-flush (p1)   179         0.338               405             94             93
skip (p1+p2)     540         0.100               116              9              9

Workload 2: same writer, but closing and reopening the fd around each
64 MiB write with some random sleeping to encourage racing.
kernel        clones  clone mean s  device MiB/clone  writer stalls  reader stalls
for-next         740         0.070                83              9              9
pre-flush (p1)   255         0.224               246             27             26
skip (p1+p2)     518         0.107               121             11             11

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/reflink.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index 24c0b226bc31..fe765ab27c82 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -950,13 +950,19 @@ loff_t btrfs_remap_file_range(struct file *src_file, loff_t off,
 	/*
 	 * Optimistically write out the src inode before taking locks.
 	 * Consistency is properly ensured by the btrfs_wait_ordered_range()
-	 * inside btrfs_remap_file_range_prep().
+	 * inside btrfs_remap_file_range_prep(). This optimization causes
+	 * redundant writeback if there is a concurrent writer to the src file
+	 * so try to catch anyone holding the file open for writes and skip
+	 * the optimization in that case.
 	 */
 	wb_start = ALIGN_DOWN(off, src_inode->root->fs_info->sectorsize);
 	wb_len = calc_remap_wb_len(src_inode, off, len, remap_flags);
-	ret = btrfs_wait_ordered_range(src_inode, wb_start, wb_len);
-	if (ret < 0)
-		return ret;
+	if (atomic_read(&src_inode->vfs_inode.i_writecount) <= 0 &&
+	    !mapping_writably_mapped(src_inode->vfs_inode.i_mapping)) {
+		ret = btrfs_wait_ordered_range(src_inode, wb_start, wb_len);
+		if (ret < 0)
+			return ret;
+	}
 
 	if (same_inode) {
 		btrfs_inode_lock(src_inode, BTRFS_ILOCK_MMAP);
-- 
2.55.0

