Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB06136A009
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2026 00:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790641698; cv=none; b=KkowQwXLnuLDlk30s3lU96+mEovD9T6afNvsb73f9t2u5owElRdXd9GbrMLP9/Y5lQFhLEandn0FR1wswj1BPky0fdpdPHngDcMfka1dT/bEwBb8Lcf5jLUAe5IXHgXWDOdhipg36vP2NpKwdA4+Vcol0rED3SVt59NUSSb/aTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790641698; c=relaxed/simple;
	bh=zINgcovID2ugq3H4w96QpOGL1/wZ3umUaf9wzOZYTTQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHKnFdroJF/V3KMFzdW8jdBO5rdKaxWp5JPiwBXRjUGEV71pp24wbv1iOcDdLcGOVIjao5pF84M5Kdm9O9oa08Wrw1POyxhSPuV/kkcHrJJOntdY22L+WL6BVdq+lRk6wsyKeBk8+YK7kaciC+me9ygNe43H4kKJm+N9KfaFmPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=U9Kr23pG; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=puCTEOLn; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="U9Kr23pG";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="puCTEOLn"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id BD74FEC01CA;
	Mon, 28 Sep 2026 20:28:15 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Mon, 28 Sep 2026 20:28:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1790641695; x=
	1790728095; bh=pWoG0yKvXhk/DYor9NNI5RS4xccUG96vW185dHHmioI=; b=U
	9Kr23pGlm+V3fy0X763kOpJ+fLywEy2JCMS9jmxL5dWx4A/fHMgKtvoXXbVmLcfi
	XzEceG/nyHAVv9Uu7ts0ZYjW0gDJ9A1jnGsadSdsKyPC2wjt+KoYJDmwIYVHWK91
	WZmSd9R/RDOTIgI2YowabBPAgFqT+lY6anER07DrwtB0GF2rnmQuyFPsBxIq/lS6
	yX2sHt/TMPq7ov2sGISWoWGqzXkYa8QNilFUfLOWLwf/sjee4fyr9kfoL9vFdqH8
	MSEI5BE5YlDjq1/CFaTWCyMElKKqOtBV2uNOb1eoL01FGWmgU4vB9Fml9+VGs08V
	3Z6yzqWdtSxRekTCeyAiw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1790641695; x=1790728095; bh=pWoG0yKvXhk/DYor9NNI5RS4xccU
	G96vW185dHHmioI=; b=puCTEOLnRdAqfUSPkTnuV353LninyljWbURqewWFetCm
	fpiBs4v0QTusj0oxgdwMfrgG2NPDQvYaEEygSJ2M1W9Dzfc1j5FFYfGD2NoSjR+I
	ZBGgpY4ZPsroS2KKs+3gudW0u2jto7OQxUjjncrzp9/CLwifGeIVFDxWGuk7kIfh
	KLlIsxob8DamJSvWTGUgAyYCgVKlrSo3Q3dz3qrVTrrdWcMktqVtHX+HQWefmvua
	lWuAjCqwSFfT3TQ52YtM6GuSlSyfwDb+tDkJ9Hvdi6gtskb/rii1Tm/LfmIJCAfh
	aBzOpqck2R+uLT7bFJX9Z+SkvtByHMV91nMCrZaMuw==
X-ME-Sender: <xms:Hwa7anfN63vGDCN8iHttxKn2cXH_bSx6QZ0_Vz9QPM6NaA1AB7vs0Q>
    <xme:Hwa7ajMFRxLr5ZBhJgdSjF9H6aEvq3zmGZ5pvjB6qWHO9klTu903hE5PNt3ecIT1P
    R2bx9T-csYpfcQJuj_j-i2nX-nuQYShMVebibYkO_B2SLkmY4wAp58H4Q>
X-ME-Received: <xmr:Hwa7auL-NdD4qJjMMeUEAxrEEkxSHTLSlFFOmf4khK5YT_ksO6lqdMU>
X-ME-Proxy-Cause: dmFkZTEofP8WGqf2EtdVMzKPCCLwEu0pfHaE1w4A8JANlNiIYKsml1WMqn4tMt4LPPFwt2
    2/ICfQw+EmKsZYICPJM7nzFgFGIkO2TYDk/1PP3A98HHKWRMqzFlfBLEWvGq+Tqbkd4Rqu
    5cZUMPPPKRoDepRicY7ztA3brMLqflRCdaXL0p8bPfXuGkO4U2M8M9I30xHRxbtVp83aBu
    V9HW/0C67w85Xghbbsq+ISxT57sOdwZgM+H5yfUsAPQyCmPag+aqyboItYF1E2rz5KLc25
    J7rW9fDDzor0dd/AQxap+nc+R8mHht2xKyj4WXV/ooL8A0HbB0VsmhTsE2Twae4EAFK9p4
    FNhFcPtDgqoUtQnB3ukZYW12rllBJ7h/0XvVXgiqCcSTXC0r9fpNSF21NBEMNTtZk5e6xE
    qYfl3442/73l0kxAFBtM4v3wVEAV0QnFPZyzs6XrTwTqPCaSaFZGXgnPveGfZ4CIBGhdWh
    TI4xjzLaFMRIWrLwf4VoRUGrrRv8sFyAqUzVsicvX6BMEAn7097/0pUR9ADO2lcKCUUey7
    T2RBgMqAOoaE0a98yHKEoBpY8eResxoEvrI4fbCE/2Z5p14P9aUCn7Tez0PdcUlOwVowwL
    uX+WnGl2+whV2q9CiY5I6asqFtrbaG+zn5fKQPY6PAxGeckic8yNqe8nqDag
X-ME-Proxy: <xmx:Hwa7akHbLkZFT-NOuGF2VNyCJ2gKWl62Y9xwWyFy-irsUYeFV94V2g>
    <xmx:Hwa7amQ-omKnUnrxF-v4oQYwlenq-ptSEjmK1WQG-TR96YkDj6CHWw>
    <xmx:Hwa7agFU6pwcpjX-kYXh_4dEwJYuAkOp5e8S1dLTy9-VVRR3Q_lDZQ>
    <xmx:Hwa7ai9dv4FPcnDDpj9fNC9x-oY9HYQagulOY7twX3drx1var1c_uA>
    <xmx:Hwa7atdFdpE-NwyrBd27AcLy89TSxqIhJR-0Htp7903Tv8TYmX5yGg8q>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 20:28:15 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH 1/6] btrfs: skip unhelpful size class relaxing allocation loops
Date: Mon, 28 Sep 2026 17:28:02 -0700
Message-ID: <d117b99b7cdb006ee7f8b3376ed94d2ee039174a.1790641462.git.boris@bur.io>
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

When size class was not a factor on a previous loop, there is no real
point to running a loop with relaxed size class rules. So track whether
we ever actually skipped a bg due to size class and only do those loops
when it is relevant.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/extent-tree.c | 12 +++++++++++-
 fs/btrfs/extent-tree.h |  3 +++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a0d5ab03aae2..f43ee0ab24bc 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4365,6 +4365,9 @@ static int find_free_extent_update_loop(struct btrfs_fs_info *fs_info,
 	    (!ffe_ctl->orig_have_caching_bg && full_search))
 		ffe_ctl->loop++;
 	ffe_ctl->loop++;
+	/* Relaxing the size class cannot help if no block group was skipped for it. */
+	if (ffe_ctl->loop == LOOP_UNSET_SIZE_CLASS && !ffe_ctl->size_class_skipped)
+		ffe_ctl->loop++;
 
 	if (ffe_ctl->loop == LOOP_ALLOC_CHUNK) {
 		struct btrfs_trans_handle *trans;
@@ -4404,6 +4407,9 @@ static int find_free_extent_update_loop(struct btrfs_fs_info *fs_info,
 			return ret;
 	}
 
+	if (ffe_ctl->loop == LOOP_WRONG_SIZE_CLASS && !ffe_ctl->size_class_skipped)
+		ffe_ctl->loop++;
+
 	if (ffe_ctl->loop == LOOP_NO_EMPTY_SIZE) {
 		if (ffe_ctl->policy != BTRFS_EXTENT_ALLOC_CLUSTERED)
 			return -ENOSPC;
@@ -4418,6 +4424,7 @@ static int find_free_extent_update_loop(struct btrfs_fs_info *fs_info,
 		ffe_ctl->empty_cluster = 0;
 	}
 
+	ffe_ctl->size_class_skipped = false;
 	return 1;
 }
 
@@ -4581,6 +4588,7 @@ static noinline int find_free_extent(struct btrfs_root *root,
 	ffe_ctl->index = btrfs_bg_flags_to_raid_index(ffe_ctl->flags);
 	ffe_ctl->loop = 0;
 	ffe_ctl->retry_uncached = false;
+	ffe_ctl->size_class_skipped = false;
 	ffe_ctl->cached = 0;
 	ffe_ctl->max_extent_size = 0;
 	ffe_ctl->total_free_space = 0;
@@ -4742,8 +4750,10 @@ static noinline int find_free_extent(struct btrfs_root *root,
 			goto loop;
 		}
 
-		if (!find_free_extent_check_size_class(ffe_ctl, block_group))
+		if (!find_free_extent_check_size_class(ffe_ctl, block_group)) {
+			ffe_ctl->size_class_skipped = true;
 			goto loop;
+		}
 
 		bg_ret = NULL;
 		ret = do_allocation(block_group, ffe_ctl, &bg_ret);
diff --git a/fs/btrfs/extent-tree.h b/fs/btrfs/extent-tree.h
index ff330d4896d6..ecb2a1bf2435 100644
--- a/fs/btrfs/extent-tree.h
+++ b/fs/btrfs/extent-tree.h
@@ -59,6 +59,9 @@ struct find_free_extent_ctl {
 	/* Whether or not the allocator is currently following a hint. */
 	bool hinted;
 
+	/* A block group was skipped for its size class during this loop. */
+	bool size_class_skipped;
+
 	/* RAID index, converted from flags */
 	int index;
 
-- 
2.55.0

