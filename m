Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5FE3BB680
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Jul 2026 22:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673768; cv=none; b=pRk4+jDxwGCwAXO7jLl6ziiEoUHuA4VLBfJreDTT27g3xEojD5QHp/6CIrPkavt4z69KLNFywr/mmunbqjjuGP1QDSqpvGrbDi45s3YbWMPsCB9dNuQmKAxHr1NzB0cuMshyMo65kHE9N9wLUIZ3Ifxxw1jLIcrTojysz2hQhuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673768; c=relaxed/simple;
	bh=X3/mNgIFnOAxg8JDuobaTeG3tjwdGzqVknc99oZDcSA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QchBeKCGHGPChaY8JOpH2/xAy2l4qWyAtrLLmdot3Ub7QfnRmWOisGUTKyOlPBPmD2esdiUL7Xis2gnNtADMqZkr0927r0NZzL14V99++dgizW5XJWWqoD/hsiPfkal7AM1VsPMdqSiZ7ULn5PI0vAqcjw0hjThUkCckOgll23w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=ieQlv4cx; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=PpzWLeXj; arc=none smtp.client-ip=202.12.124.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="ieQlv4cx";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="PpzWLeXj"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id 5631B1D000AE;
	Tue, 21 Jul 2026 18:42:46 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Tue, 21 Jul 2026 18:42:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1784673766; x=
	1784760166; bh=bLpJrCTm8YwqDOAjTO83TvB18upjhoSFrhziXM94KtA=; b=i
	eQlv4cxVlylcFQmWfgpSoSOrHOfH0jBn8ZfAn3DivV5hzpEJkpcxaKRceFE36nus
	IeeWgaD0mCeMpkTrVnX2vCrFFbDR+ZQ29OV/e8Fqf9Ez2S7rYE9yIyZa2IKsG11m
	LvtZD/YqiC8b++0a3ou8N83g0n+cin6tlHwtPo7wd+wP9HSG7GJ+KYnEDUY5uiYp
	UvzpdQrI9UNMpxPwCxKa4eaFKAz43X0KS4rynum+FbKsDF10b6wjoidOL645Ua72
	Tw+Ff7/ewohozl/ZcIRGpF+aQBiR69PrOpFWxyox9IuckjQUbrevDVRe1X50m8jX
	34kVelq4fsIczAdaB4nJg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1784673766; x=1784760166; bh=bLpJrCTm8YwqDOAjTO83TvB18upj
	hoSFrhziXM94KtA=; b=PpzWLeXjIaSYC7Wm38c7BXFUexgHqnm4V8APlldZTBin
	/9ij4cai1XvIel+NU1CoD1UeUMg6qccTtdmhY9Eod6S7Brld2zbwWgzjU/RZfV9Q
	M+XOe3REucqbLLoIUpxxnx2rh4RDSoEd11S2QOahexim/pSQ9y/KSTQB/hYrAe6w
	yqEUyF9QjFZYWXGbCE/LVjfHdZLG3EJDHuDT5hzpZ2V2o7mpB6/7I97COD2RbKbm
	oh6cxXHf80pBqTS/yY1cYygIeS2chvPAakxllZLDNXiq+6Lsn1NaYltJo05mE1Ur
	4nWwwvQa9GzUwOePWRKobifvQSCbDBNVy4xqcI66cw==
X-ME-Sender: <xms:5vVfavBbCiaQOwhvQvMo3G9QTG-Qyx5XcWtQynzNU2NIwUNgVKvOkQ>
    <xme:5vVfarhk1jqlDfk1a2EN_1YNhzQnYyOMpEyVVqgab42NnsTTtpNnTef0H5C5tA0cT
    P1vCgBf-iHXkKf6SCMiknMVWdU6XOZDJ03Roz58qfZGr1bIKOmAmg>
X-ME-Received: <xmr:5vVfaoMor0lDCAbR5z_KXTTZyD2kvJ1tzH5Y267sHEXVBPPw0MId51UrLhEl26NYygm10V4M5Dwf7IhSs7KGPtc6THQ>
X-ME-Proxy-Cause: dmFkZTE6tUjMYsQUsR34gCpt2nSr/69ApxXSMyG5rrTD08NxB81cfGeohUWD/e33uyicNC
    y+WdnSBRhdiyS4cGhmQxf1TnGYTqxxcxEO3rUlbmYbcj+dmC2hh05IsOuXCGDQHgXK7/Kt
    io5klZ80UiOeUvrki7josxkbC4J0dN1UIsgcq0XdhgrWljvrFwX+DJA2mw0Q55MTEE6Eiz
    5gQe7xhLHZsj0R9Y2bU7/i0dGZRak2Su7TqDV2A6n64gu/AaoLWRvVnv135mT2iLc0589p
    t6A1wC4ak0d2ZD88xY/eA+Jo3Ht9YK2E+Y5EqyNvjk5wJs0M+14Sek2BEWbgC292ApLjkA
    51hg1TTi7u4V2CwFQJziWwDDfhzbcwnoPwGeCfsUbcSLu6k2hfSQEwDHdkQ1CJhudEL9JN
    l0eizhN36tK51EkdozfuNsGodhEpdnX0kBHbiUqKRF6pojLo/AMFsRk3jAwn7nRE2THRAU
    HPY+EwD2yyssyj3KpTdoEAjgg6QeNoothG3tsy6ppUSBcaGI3uH1p+UXRnek8ZgYCO9Prq
    YWOA7SfZAaD2JaMjDqOLQL36Yb5HLOVAGUVRJfuRkbO0t+/dmqWSbRuTAaJo8B5ZuBB52p
    RCOvF4BREk2qOPGIawj6y0bnMLoCtI/DU2EubGUQDH2sCJIzRFByvUYb/y/A
X-ME-Proxy: <xmx:5vVfas46mNiwKGIOCyju9ID1Dbu6JKZbx_f6XMcr9JiJuqdVhOl3aQ>
    <xmx:5vVfam2bVMHuwAymmxcMr94h-HzxTL_1gNKXcAn2Pj-XyVB4W6MzUA>
    <xmx:5vVfatYGvsBXsbORatghAR9BYSAlZgsKGbb43HA9zUt0TaKFwxcTgA>
    <xmx:5vVfauDf6YfDMRJBnJJu-TtA5aobhB6zbJtbiU2uCKPXi0djT7Yv4Q>
    <xmx:5vVfajkexg5Yjsov6lnMW4G1gwVVxj5SBtPTChGk-ev8zixyQzzSlc3P>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 21 Jul 2026 18:42:45 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v2 1/4] btrfs: factor init_extent_buffer from __alloc_extent_buffer
Date: Tue, 21 Jul 2026 15:42:12 -0700
Message-ID: <5846bb4f9876b5a78761ecdfc03757cd92f46c4a.1784673567.git.boris@bur.io>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1784673567.git.boris@bur.io>
References: <cover.1784673567.git.boris@bur.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for preallocating extent_buffer data, factor eb
initialization away from specifically allocating it. This allows us to
allocate the eb, bfs, folios, etc. together in the main search_slot code
paths, but still share initialization code with the dummy/test/clone
allocation paths.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/extent_io.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d285bc98b0fb..3ab6b143dbc4 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3108,12 +3108,9 @@ void btrfs_uninhibit_all_eb_writeback(struct btrfs_trans_handle *trans)
 	trans->inhibited_ebs_hand = 0;
 }
 
-static struct extent_buffer *__alloc_extent_buffer(struct btrfs_fs_info *fs_info,
-						   u64 start)
+static void init_extent_buffer(struct btrfs_fs_info *fs_info,
+			       struct extent_buffer *eb, u64 start)
 {
-	struct extent_buffer *eb = NULL;
-
-	eb = kmem_cache_zalloc(extent_buffer_cache, GFP_NOFS|__GFP_NOFAIL);
 	eb->start = start;
 	eb->len = fs_info->nodesize;
 	eb->fs_info = fs_info;
@@ -3126,7 +3123,15 @@ static struct extent_buffer *__alloc_extent_buffer(struct btrfs_fs_info *fs_info
 	refcount_set(&eb->refs, 1);
 
 	ASSERT(eb->len <= BTRFS_MAX_METADATA_BLOCKSIZE);
+}
+
+static struct extent_buffer *__alloc_extent_buffer(struct btrfs_fs_info *fs_info,
+						   u64 start)
+{
+	struct extent_buffer *eb;
 
+	eb = kmem_cache_zalloc(extent_buffer_cache, GFP_NOFS | __GFP_NOFAIL);
+	init_extent_buffer(fs_info, eb, start);
 	return eb;
 }
 
@@ -3530,9 +3535,8 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 	if (eb)
 		return eb;
 
-	eb = __alloc_extent_buffer(fs_info, start);
-	if (!eb)
-		return ERR_PTR(-ENOMEM);
+	eb = kmem_cache_zalloc(extent_buffer_cache, GFP_NOFS | __GFP_NOFAIL);
+	init_extent_buffer(fs_info, eb, start);
 
 	/*
 	 * The reloc trees are just snapshots, so we need them to appear to be
-- 
2.55.0

