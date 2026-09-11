Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1732773D8
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 00:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789086358; cv=none; b=iFDDXcOiWB4NLgszD2Sn9zHu2DfmJdEfc3LUR7b+7AXtRyXxKEjRLcT0GK75GIs6H6YqmWEPwBejWuvyH5QK6yMFi6GPDH5eNiiGa7vxeCyKtwkMxuYL3+zAvRsndFWUmJdXBO4Fj1czDBdZan3tKYIJab+kCW8mtzduoYqvNik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789086358; c=relaxed/simple;
	bh=/6kc68azvn46xRVN2C7kEKW2QUtKqw126JcrIMgz1uA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XljBO5jpLzQFL9WI1DdU/BDHlJIpSpUWKotiksAZezfR1lEiMeVPG8CwYpYkAThlDFJNchbV0SRSl6uuQtPGjMhe4VetnBJhP5Bz9kN/QDxC8ha9Hg3lwBC2knlPbSH4ohZO/5aEXH2ISq4TJYyaIhuMxm+UMLkQjU8/2mypbvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=gdN9UHMa; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=HnIAr2tn; arc=none smtp.client-ip=202.12.124.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="gdN9UHMa";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="HnIAr2tn"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 77AD37A00F8;
	Thu, 10 Sep 2026 20:25:56 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 10 Sep 2026 20:25:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789086356; x=
	1789172756; bh=sMJfA5Jd2/xkFgIG7Ou7jR56hYr15oHw4CpdaHc1UYE=; b=g
	dN9UHMaDqRaB4ztPp/3ScJlL3Fl1fkoU9yRHW/+ZKzX3UA3r1iWiOKdaE9ze0u0Q
	QtiHWRJu/MJKBDk/P+Tmm3/KAJ4jPWZqrBOfjyJyPACyO3kWd4ZHmXj2kll6/ARv
	A4PrRywrlxqaiAMEm1dJHhMNcVW8apXykieN3dIj3/oRbe0BBY9swMZgQA3EzSnu
	R35Aoy5DddIePlSUQqF6JqcdEgernK2nFeAYvp+IcBMLdfZXxZwH7iVVDQmcEtM7
	DeWYzUlOTT2FdR8lfQxlV8o3ZOxk2ZhXtAju2qxdsgbS/UGBcrXm/g5b/R8z/afS
	2BpKKCSXFNRblQriV597g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1789086356; x=1789172756; bh=sMJfA5Jd2/xkFgIG7Ou7jR56hYr1
	5oHw4CpdaHc1UYE=; b=HnIAr2tnH4/NIb+HE+bfSig4BLpB5r3NUMDz/QcC3LTt
	aKEzN8uM8COOiaddLET0jElBtIGG6tD0RTFv5o86GwqICI96tdjGeZp4s4uIkIBe
	xo2ClVxxHRYAqGFI+oCmzB87RGyBi3t+SUycSi2JRI8bEoStOole/C+ZPM7qsP6D
	AhRoUwVODJ9jNLgQtp21zC8B5XkITCVX9XnClCpTTSvaxp3NZeV8z1WzCK0qlXQM
	J/ZFweBd7Vb6dyeLAI4StTwliqcTS8TmbTGAUMuG0E7Z5Ve2IvoJQgdg5wNMYu8I
	IBAAOWUVZ7BNTiooj1x94cbesOm490J2+YAkwj5Lxw==
X-ME-Sender: <xms:lEqjaiOKiLkKzWw7VP3QeAKrTwJTnn-JDfCbBhDTxr_1ds5PpYTF_w>
    <xme:lEqjam_iFTZv4pofruDtr6yNqtCHL2u7M3gbT0OgOV1DCaFx9cZjJYBfBYgQayoxY
    Fub38sF_onAmDHokc2YulQgSIJlPUa5yO_M_U6FGPzMwj4fpkwDQkM>
X-ME-Received: <xmr:lEqjam4ZXuX68mmajM4VMOvRJStUs5yGbweQVFnPAXH8Jb3glmhVu9A>
X-ME-Proxy-Cause: dmFkZTG0Q3B5PBW5Xp+1KKG6/++KrTpZKC6wtfqmOinzqQW+KAbeF+f7Hw3YY7gpCmUjUH
    aBuHVCUK+s+glbMAv1F527tdaKEkxcKuyeSKWYgTJfpIv5GaLLWKigXrUO7ZSBTBAHkXAF
    7x6+Nse5eNCnkEuijA6Ms27XjDTKY4urvwcNSBmS8G6wPM4qNmpZurV8pSa1vlnX+ZfdOR
    1VGcUaB1OgM4rlWevV1laUVfSeRtko8tmooAbRxFf4Fbr8GANx2MmQgNyYGg6ODov5TWJg
    +AIdHF2armVU0mPtRAlm5KDPLIWL/IPeIofvBZvSs2IFVp3IKllhKE3+8UtzDcFLyJQYAQ
    GFwQpVvsJdw99wyNVm4oYMovJ5PXMjvW8mn/QOtt2hEDuksYp6KQlUAfyn2Fq7hS2dHGDo
    iPu3FbUqMkZM1ytKSDQcS+4Fep14et7yVhAodCufQQVAmNMJS/73TLNAKCvl+QykOfzcnW
    VWe+oe9daW1eLtCsPRrHhdHFaqOZEIcEWf2Cbfd1m0MaYvUViYbll/rvgP9AlS0xZ3cMEQ
    v+hn1Yk1FNkQIvM90q8z2cYeEAfgUv4BF/vQueR3/H0PCDATcWMWRI8Oz21NxcN9OmK5pu
    lb7HE3/4yPllwpFJkVaQJAZVPpEJGsWjKziWzuKHDa46P9QzFiMlFCpsu4Fw
X-ME-Proxy: <xmx:lEqjat3wKzEBQNYhUziz3P2JRHpy7zxxzRrx-1pPQtwHcm_E-8DsSw>
    <xmx:lEqjatCZngVR0U_ra1xk2t69gS3xPpYts464mQ0xLRQYppN9dFnTMQ>
    <xmx:lEqjav1IEKz2CkAW50G4VlCg7LYpX_LOsLV5qW5reAQ62l3fbwx9gg>
    <xmx:lEqjansUU2-PKoAGnH_L16XPQlVSLJqQiX5j-P7A4PQ-gBo98vPaBQ>
    <xmx:lEqjaoPLgFuxB5V5CborkCTcy-CMDF9qxaosRnLM1BnIIP4Sbutky9kw>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Sep 2026 20:25:55 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v2 1/3] btrfs: pre-flush reflink source before taking inode locks
Date: Thu, 10 Sep 2026 17:26:17 -0700
Message-ID: <4ef5a4ea85bf903e058b0a8c88549e15745729c0.1789085863.git.boris@bur.io>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1789085863.git.boris@bur.io>
References: <cover.1789085863.git.boris@bur.io>
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

Therefore, do an optimistic single backwards pass which completes latent
OEs while relying on the calls to btrfs_wait_ordered_range() under the
locks in btrfs_remap_file_range_prep() ensure correctness. In the worst
case with concurrent writes while unlocked, we can end up doing the
writeback twice, which I think is a reasonable price to pay to avoid
victimizing innocent readers in a common case.

With and without this patch, the above reproducer runs the reflink in
the same ~0.5s on my system. Without the patch, the direct read blocks
for basically the full duration of the reflink while with the patch it
returns in a few milliseconds.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/reflink.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index d2a4101912bd..7bab391f1be4 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -923,6 +923,46 @@ static bool file_sync_write(const struct file *file)
 	return false;
 }
 
+/*
+ * Do a single backwards pass waiting for ordered extents on the inode.
+ *
+ * Backwards is helpful because it avoids picking up concurrent appended OEs
+ * and the intent of the function is to wait on pre-existing OEs without going
+ * to the extreme of locking the ordered_tree and snapshotting its contents.
+ *
+ * This is only useful as an optimization for waiting for ordered extents outside
+ * locks. It DOES NOT ensure that the range is free of ordered extents.
+ *
+ * Returns -EIO if any waited on OE had the ORDERED_IOERR bit set and 0 otherwise.
+ */
+static int wait_existing_ordered_extents(struct btrfs_inode *inode)
+{
+	u64 orig_end = i_size_read(&inode->vfs_inode);
+	u64 end = orig_end;
+	int ret = 0;
+
+	while (true) {
+		struct btrfs_ordered_extent *ordered;
+
+		ordered = btrfs_lookup_first_ordered_extent(inode, end);
+		if (!ordered)
+			break;
+		if (ordered->file_offset > end) {
+			btrfs_put_ordered_extent(ordered);
+			break;
+		}
+		btrfs_start_ordered_extent(ordered);
+		end = ordered->file_offset;
+		if (test_bit(BTRFS_ORDERED_IOERR, &ordered->flags))
+			ret = -EIO;
+		btrfs_put_ordered_extent(ordered);
+		if (!end)
+			break;
+		end--;
+	}
+	return ret;
+}
+
 loff_t btrfs_remap_file_range(struct file *src_file, loff_t off,
 		struct file *dst_file, loff_t destoff, loff_t len,
 		unsigned int remap_flags)
@@ -938,6 +978,14 @@ loff_t btrfs_remap_file_range(struct file *src_file, loff_t off,
 	if (remap_flags & ~(REMAP_FILE_DEDUP | REMAP_FILE_ADVISORY))
 		return -EINVAL;
 
+	ret = filemap_flush(src_inode->vfs_inode.i_mapping);
+	if (ret < 0)
+		return ret;
+
+	ret = wait_existing_ordered_extents(src_inode);
+	if (ret < 0)
+		return ret;
+
 	if (same_inode) {
 		btrfs_inode_lock(src_inode, BTRFS_ILOCK_MMAP);
 	} else {
-- 
2.55.0

