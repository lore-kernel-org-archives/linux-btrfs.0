Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC35429CCF
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2026 17:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789495102; cv=none; b=DROWgZDvq3pwbRqidTeFCxrHDVSPQKcvPAzgWeYPAtUnC1nJpR8fYDhSBke1XhAZN1IGJATlct9HJZLBaNF7+OfM/1HfpE+EHDRViBm5rs88w7E4GI9AvX6TNWnLEaUtJVsTJQvg8fXX/NvSi4iUw1jSPEuJok1XY1lP7QYKHso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789495102; c=relaxed/simple;
	bh=6hTjrxzR4G7LO83OPFUt8ATSlyzxzfFkG/KnQ+TKkBo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kre0S4oa1fgKvgpzgEHFP2QL0g+1SuLqDz1SIfVAleIpiqmSD3q7Jt6OrUr0V48NTD/FnOo15YoICjWpu02l+zMw1dBT4/XM6nK/c2UgFQsWWdeycyE2+JUEAAkKRbXJPf6gle0yd89XZrolfZI8baVuRWRjEycCW0CWxmrxCCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=NNtJlpHX; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=EQXx4tvq; arc=none smtp.client-ip=202.12.124.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="NNtJlpHX";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="EQXx4tvq"
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfout.stl.internal (Postfix) with ESMTP id 6E3FC1D00221;
	Tue, 15 Sep 2026 13:58:19 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Tue, 15 Sep 2026 13:58:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789495099; x=
	1789581499; bh=nWRBUhXAczwlCMjsiuKo8lAgorcPl3215OBlqlI+oQM=; b=N
	NtJlpHXzUrumnSVDvHxrVDE84a3eYA9jwI3TFKq9XwRIQoQCvvBGPyXy8tUjaIoB
	EqQYSIv8iPP1nkmiCk8LfvEmkDvpytNBYpHvilXfG9Uh9HIrlQYqz5ZWR+sUwIwm
	nYeRJBCL4i2v9U0CJmSe65WJ1kw1t9cFys8dEpnKIw56jkt3BGSRok8uLU04S7Ee
	US12Xo4x+Jh/20I9MXOXYAmoG1ZHuaEypqmAHWFaGXYt8FiJkucp4xcMJHkL2k6P
	he0nOJY2eLardUZyVgG8zjKPLS9r7kY2O9sxobKELHsHPVVbE5Cs0A7Kcmo+Uymg
	dhPPwrpgvDLKYT9wxToPA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1789495099; x=1789581499; bh=nWRBUhXAczwlCMjsiuKo8lAgorcP
	l3215OBlqlI+oQM=; b=EQXx4tvqPn4euA7e6/yzXUhDRzxObIMHdjCgzk2Bksbt
	ctihpWYQqYxBUKDVrNc38IJlOwQgYnzOJlmB7QFmuYLAf1iI+IZXsJR5DG/Dnc0A
	Y59ms8rRIi6goRjrwGtd8UlZLLimA113wIwy5S4FoV6KQdWX2mnqh+JQQsfHLmW3
	FFBcF5WtC2nBcXWuEYTc8+leUWa1yAvy2llbE5Vy6FUd62CHNU2DT9hE0mu3ULXF
	ryn55M2cDdalKIECl1QUltgURcpD0D5JASELJhKYX1cGHs98MceYCEa9QkftDH//
	7RYI8KPiKzMN1dGS4jUG7VjdRB0U0h0wQ5d8lCCNkg==
X-ME-Sender: <xms:O4epaoJaoRPE7BA6yItlSF3kokkheEsmBc77GBfPRBQZ14PnyiDgtQ>
    <xme:O4epauL0b1ce2tGm0TLvFSjFJBNyvbHOpE36jLAU40MpGbUdcqshQzGeH3vgRnCkW
    ryF4nDdjM8IRc7v3-JyE8vovb3nVIRK1BlNCvpyBSijEOV8TMXqL1dd3Q>
X-ME-Received: <xmr:O4epamVGT8FDjdsk0IGnHHsT6M9TwGVIupKTKxWavHUbPTnbfOF9MZc>
X-ME-Proxy-Cause: dmFkZTFQMm4JHICtzTDS3CcC10keKNmdTwpbleNNC+5TGYJanvsOjSZ062Wy5OyIu1ikia
    B08N4mNMHaBUHCtK+Xcb1qwmAxWj0xgc23fQHw2lCsm+A/GzWYryUXpQcHjVLQmxA1Ds31
    +ImfWoap2usUY2+DSsTgMn6ZoIlJka8cFdCdOxYbK5VHOM3rt+vM8LVYa9z3bxZ7iATdmr
    EoQtN5ScuEcaPNK4O2xkYO6tRMfuVHsTjEmbqdBwSVLCeleix81Ga+VParVPlKtyE7IC9R
    eJLhcOz2vC4MARlo77XB5QRDglPiaokwAIv+XfuqVdCWNrlqSkgIq4L4wtp++CckPSE0Es
    Auli561BhjbVmtbPiaRJcXFV/I+Id20IPT7G50KK5XsH2anGsbF2GCZUAx8O35C7DXb2+3
    l+YUP53NwB9Fmie5WFJZu1iapHhsyEfRwjl59aH2DfWX+G4HzRdfPcGLfrdId7gKVPGssn
    mxjJgpEO/3fS8tWDRO85cWCrb2LSVHV32SamtMPHNnDpPTfLn9ws0i8PHNSXPlrzb4umEw
    MsPh6KIN0kCxcMctqAvUgd9kz8MYyWlOYReR1WvzlfLsBQW4rqT7ptCdTj4FYV5i4kp+1A
    ELWL3k4fchmdIrdumUuA/PvlxWkSANxwlBXXbuLBmieIJE8mGCnsv1rrTTJg
X-ME-Proxy: <xmx:O4epaggA9ipcxslAhyZlhfd9r7QtdN1s0BoaUUNSM2P32PgubDMDhw>
    <xmx:O4epah-x6y9afkCLLscKcRR5aSzc8tizjSq6FGbBQTijBSJQ2NrrDQ>
    <xmx:O4epaqAvqPDP-A348ww1S9S1DbD3V37-cXEbgOcKwDc-QKMzydFR6A>
    <xmx:O4epauK5ehXh2o4se3t1-x7cpgP1uWiNCQJgdAFvh_L3lIsk1vTa0A>
    <xmx:O4epaiLt-rbGfZKaMMvPrY9Azh7GEez459-9bPEzI3t6TzBuxudkx63F>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Sep 2026 13:58:18 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v3 1/3] btrfs: pre-flush reflink source before taking inode locks
Date: Tue, 15 Sep 2026 10:58:31 -0700
Message-ID: <be489f34105166f30d55d071f7acf7a4c46772fa.1789494885.git.boris@bur.io>
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

Consider the following sketch of a shell script:
  dd if=/dev/urandom of=/mnt/src bs=1M count=4096
  cp --reflink=always /mnt/src /mnt/dst &
  sleep 0.1   # let the clone reach its flush
  time dd if=/mnt/src of=/dev/null bs=4K count=1 iflag=direct

The current logic in reflink ensures the existence and stability of both
the src and destination inode by locking them both and then flushing all
dirty pages / ordered_extents under the inode lock. This blocks
concurrent usage by even readers of the inode locks, like direct reads
or seeks for the duration of writeback on the entirety of the two files.

We observe this particular contention frequently in the Meta fleet.

It is also a relatively common pattern to write the src file, then reflink
it while it is still dirty, so that typical path naturally hits this
contention. This workload motivates a relatively simple optimization:
trigger the unavoidable src flushing outside the locked region.

It is tempting to try to move the writeback out of the locks entirely
but this is fraught with all kinds of consistency errors under various
patterns of concurrent writes. fsync is able to manage such a pattern,
but with significant infrastructure investment I don't think is
justified for reflink.

Therefore, do an optimistic btrfs_wait_ordered_range() without the locks
while relying on the calls to btrfs_wait_ordered_range() under the
locks in btrfs_remap_file_range_prep() to ensure correctness. In the
worst case with concurrent writes while unlocked, we can end up doing
the writeback twice, which I think is a reasonable price to pay to avoid
victimizing innocent readers in a common case.

With and without this patch, the above reproducer runs the reflink in
the same ~0.5s on my system. Without the patch, the direct read blocks
for basically the full duration of the reflink while with the patch it
returns in a few milliseconds.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/reflink.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index d2a4101912bd..24c0b226bc31 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -833,6 +833,17 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 	return 0;
 }
 
+static u64 calc_remap_wb_len(struct btrfs_inode *src_inode, loff_t off, loff_t len,
+			     unsigned int remap_flags)
+{
+	const u32 bs = src_inode->root->fs_info->sectorsize;
+	const loff_t isize = i_size_read(&src_inode->vfs_inode);
+
+	if (len == 0 && !(remap_flags & REMAP_FILE_DEDUP))
+		return ALIGN(isize, bs) - ALIGN_DOWN(off, bs);
+	return ALIGN(len, bs);
+}
+
 static int btrfs_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 				       struct file *file_out, loff_t pos_out,
 				       loff_t *len, unsigned int remap_flags)
@@ -876,10 +887,7 @@ static int btrfs_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 	 *    not for the ordered extents to complete. We need to wait for them
 	 *    to complete so that new file extent items are in the fs tree.
 	 */
-	if (*len == 0 && !(remap_flags & REMAP_FILE_DEDUP))
-		wb_len = ALIGN(inode_in->vfs_inode.i_size, bs) - ALIGN_DOWN(pos_in, bs);
-	else
-		wb_len = ALIGN(*len, bs);
+	wb_len = calc_remap_wb_len(inode_in, pos_in, *len, remap_flags);
 
 	/*
 	 * Workaround to make sure NOCOW buffered write reach disk as NOCOW.
@@ -930,6 +938,7 @@ loff_t btrfs_remap_file_range(struct file *src_file, loff_t off,
 	struct btrfs_inode *src_inode = BTRFS_I(file_inode(src_file));
 	struct btrfs_inode *dst_inode = BTRFS_I(file_inode(dst_file));
 	bool same_inode = dst_inode == src_inode;
+	u64 wb_start, wb_len;
 	int ret;
 
 	if (btrfs_is_shutdown(src_inode->root->fs_info))
@@ -938,6 +947,17 @@ loff_t btrfs_remap_file_range(struct file *src_file, loff_t off,
 	if (remap_flags & ~(REMAP_FILE_DEDUP | REMAP_FILE_ADVISORY))
 		return -EINVAL;
 
+	/*
+	 * Optimistically write out the src inode before taking locks.
+	 * Consistency is properly ensured by the btrfs_wait_ordered_range()
+	 * inside btrfs_remap_file_range_prep().
+	 */
+	wb_start = ALIGN_DOWN(off, src_inode->root->fs_info->sectorsize);
+	wb_len = calc_remap_wb_len(src_inode, off, len, remap_flags);
+	ret = btrfs_wait_ordered_range(src_inode, wb_start, wb_len);
+	if (ret < 0)
+		return ret;
+
 	if (same_inode) {
 		btrfs_inode_lock(src_inode, BTRFS_ILOCK_MMAP);
 	} else {
-- 
2.55.0

