Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.157
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795642472;
	b=C52tYEWKsU8ePPC4yM8RrnfVWCaJRcmAQJRQEExi/MjKI0q5rELIp8xDrxcHd6y9ajwh
	 lGbypKs8cJYnEZXP9XVKLJipqGSiYFHsaXLmJgwEYrEudQzFK5iQQrnBQnrXUsvZXaTT4
	 GboSNqJozkjq2j/dDI1FrpyIwfnSnyavnD9tdZVvzJLgGHYsLcVzLVbGPzw3RXwSBXl66
	 dL69vMC6NMjVsFCtPUNV4JjQHq8ZNXaPStCXht0SbcO/Nmg/oRvLYC2PvASx51WAcZDLR
	 78bar/um6PnU26V2zqYZVaEo9KV5+m0tNa1wR2fsoNML5wH0vXFhACXQ6SuNZJpZ9gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795642472;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=iwdb0mv6V1tHSPxPpaaFHlgEf7z5iv+5Y3mTJTmUUIo=;
	b=zlZKarJgRhRijrnCYaqT2WtHcDeUwKE7EyobsIP9XVf0o0XngaoWcQcAmnjfxmRcy5vI
	 h2YZh6t0w44TzqCnVRQdOmYspDzq1QkAUtLGTSVZr4Uira2qI5qhPLGoG8//EQ422Pdpn
	 usgBATG5xGChLY+qspLccylhtaJRaKD2xq8DjuwFSR1DjB6HIlYG1ugZqXhbk/IXdyOxH
	 wsZ6bmTGyG8tLWpFXi/OAwAjerPAkQaB4HXpK1r76IJDTHQaDVZpuB7lfOsCrnSpVZ2W5
	 bqy1bEN1y6xfEfUyzncKXxYsfK3gr3t2/Nt/6nVxx5WQ8Z/wmA8onyCkIsBRUoqsueA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=bur.io;
	spf=pass smtp.mailfrom=bur.io;
	dkim=pass header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=RINlUL9V;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=gh1awpam;
	arc=none smtp.remote-ip=103.168.172.157
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51329606A32E
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 21:34:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51329606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=RINlUL9V;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=gh1awpam
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 80A571400385
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 16:34:31 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Wed, 25 Nov 2026 16:34:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1795642471; x=
	1795728871; bh=iwdb0mv6V1tHSPxPpaaFHlgEf7z5iv+5Y3mTJTmUUIo=; b=R
	INlUL9VIxZrTWpah1ndBH2o3XEQHCSsO3N4kFVipg76JNdRLn6CyyiwQJ3DPlg84
	DWT4UTAnWBSsNA2iWxEjtMx61r1Z0vQY1N6OwE/8O8sXcGH2Oi2E8TnhmuvGtHti
	hC9Jzc11t9JWT2W+R8NJUViVh3NuQyzof8UA34ziM3xdZVfxdhvW9ZTxJ/ol7yAO
	8sEkdym18ielkU6sK/PgXqNyGKW8diVomSi3Ir7Dp8kCCyvn7dWFXplR+C/LkQDr
	CZn493URsJPAG31X4G0CeTkguVnCXAmZYjBnI7UszbiTnKAsj2ZlZBcVNpSJXsts
	FOQ8OQIQ/c1eJxKkybbRA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1795642471; x=1795728871; bh=iwdb0mv6V1tHSPxPpaaFHlgEf7z5
	iv+5Y3mTJTmUUIo=; b=gh1awpamArGFGY1vUlOo60nozgvuT4dWXGpjhErOpbAl
	CjMABwKdYrbm+/BBrCxRrTnWHrDa5huau+/gdgBlx2ZSrHrIH3qRVmrGIb7J0Flx
	LpcZgDPGLwmajjshLOj6XuPfEVe8B0G9Xm9LK9isUV5KY4GKPGxgAGPb8aDk17vn
	Hfu36Y5JZRv3fk69YolvJmSPd1C53mSDemX75zXmm/wiYFbCJBtJ+QTpEMdlKwbh
	pF+DtEwu/Vy7Cc2n/Wd/sN2vl/S6SX5yPgICFGxns2cgWQl4r/TA34wzrx5/fGbZ
	2rbu2UFbtXGkhNheZBS72PCyA+Xec33mMA9LjBymYA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=bur.io a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795642471; d=bur.io;
	mf=PGJvcmlzQGJ1ci5pbz4=;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm1:rsa-sha256:ilX0irLVw1KsNttlqtoJ38q4LNlNoVDxKsYrFt/1q92Py5z
	lHoFGeoxcjn++RgbvYiuwRlrV6nwTHelIPYaxDclzy//doFxU9X79Bwy5K0fpbCR
	3DnYBBaiUoKNf29miZJ1Mn5o9V5xF7VRnq+w1KVVMk4T1VbCPv9qhltPelQv80ns
	C6Mdf8mVvTKUXHkxBXlHMYKrUT/9A014ebF4DIolP9h1TauMIqBtn2j7QoJpUpC8
	mEfgCuAHkVgPtfZIlxgBHlkIN1aqJN2fDaoCoEXmjU/2bLGR4VYMTqrhbjkTiLum
	BHyn+U67yw5v9dK7VWHX3vFgPEEY85PPuDzo1Xw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=10;
	hn=content-transfer-encoding,date,feedback-id,from,in-reply-to,
	message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:s5/en+hnwA8ufso0aFzynqwNnDKCMfhreMFK13Y8qPo=:jBT7LWmPqIfcABaptRH9Yr4g40Ydm/79MpdtOaFE9ao=;
X-ME-Sender: <xms:Z1QHazYRR-HlJ671TPbmSxNWNCCQwGbt7JrzLgyGR3YL2EC416gFTA>
    <xme:Z1QHa4Z3FE-kQJYqVMQOg-MRLotLgaza_j9xufO1eziZ19qlkvGOcD0-noE0tm56u
    4MSc_V9bv-PkOPd2Of4_q2iQOUBAuqieS3MrxE6OEvKptnD8sEAfHyD>
X-ME-Received: <xmr:Z1QHazk-6qZ3bw4LnUq5RDvQGtKOuKMmzbgavTMnV0THOFeHLlWm6huX>
X-ME-Proxy-Cause: dmFkZTE6X4ededCa774X9N3oU8PaP7eBbphXYjPAJIQ9yIpGOpNu8Uo7KIqh8Rxm76olh8
    q7IaLvvmrA51+TnYnZOU/MK5rLyWmBHy50m+5C8wMNygPRsJh/GINbXhIw5hzFeAA0zGpx
    7FksVL1P/QVitE3JgZCAr8OZXiidCGT+fXwCx/Pb9DW+Zz5Wr3wgoQ841dKvuDQYJSjzmx
    +paGJ7mt0dcqbWfa4Esh8wChOVkL3h8I4gj0bC2t4GgW92SKsFKr6+mqVUU9ST/FI7YyzL
    l+o3dxunGlBUICLsSMIf+M2epG95fUcn39V0TICel47WQtjaQHWyqdMReXYgr/IL9y62XQ
    G1R8dBlGPhLSwUvUTz9NiaM3I2EOjzFdatZNKPp+sy6+peC3t60F5CA3PE5AHHf+4jOtcI
    FIDrP1P4mLeRXaLjMliZNK73P/rlYc2QedFGQtUSR17fAwsbXUIt0PQ1rL4ctL+HfLkB3h
    0cA49jr6xCZvBQLcm4megEqAZCLMK6dKjTOJ2OLoQzFT3TqCFNwbvNb5122NLm5P67fpU6
    4xG23f49QRCkMjgh2XAmn1jdtKuzOvYxR+4r2SU1CTMpUrqbmVyeVr/LgmUQWAa+HU1rO/
    tRbanffJDURXGDuiqlQodBvgO8lf3g91skIp58GzU+Ie76lP5sTS/UTIRwGg
X-ME-Proxy: <xmx:Z1QHa0z9CXjXsxT8fW0S5G0pBKGz36cq312CZMhIMqhe84Cydw5b8Q>
    <xmx:Z1QHaxOfqWmNi4ocvuyQj2k4ydzhwamUhGhCa6XfZqb-Sti6W0tZ-A>
    <xmx:Z1QHa4S4Px_kEgOpfi2_I72m7UJ-c7ftFRnoSEQuJfFA5quG3DxvyQ>
    <xmx:Z1QHa_baLPs9T7OeWVCquL2ZzixMStgzWgSF4Dcy3AAL0C4Ugr-8Vg>
    <xmx:Z1QHa9ai_3gU5AZRfiHRaLvowqo5J-HVKhQ7UBuML4P4lIYpolsNjzvS>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Nov 2026 16:34:31 -0500 (EST)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH 1/4] btrfs: scrub: release the commit root paths before pausing
Date: Wed, 25 Nov 2026 13:34:02 -0800
Message-ID: <b0805ac31ef24ee19db794633ca7ef1ebe912ebb.1795642270.git.boris@bur.io>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1795642270.git.boris@bur.io>
References: <cover.1795642270.git.boris@bur.io>
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

Since commit 1dc4888e725d ("btrfs: scrub: avoid unnecessary extent tree
search preparing stripes") scrub keeps sctx->extent_path and
sctx->csum_path across the stripes of a block group, so the paths are
also held across the implementation of scrub pause in scrub_simple_mirror()
and scrub_raid56_parity_stripe().

Both use searches that set search_commit_root and skip_locking to true.
Meanwhile, the transaction critical section is exactly what issues a pause.
So if we populate sctx->extent_path/csum_path with nodes from a commit root,
then pause, then complete a commit critical section, those nodes refer
to the previous commit root, by construction.

These nodes could have been cowed and thus unpinned by the conclusion
of the transaction. It is generally not safe to refer to nodes from old
commit roots.

Therefore, we must drop these paths across pauses to ensure that after a
pause we do a new search in the current commit root. Otherwise we would
need to block the commit on the scrub which is obviously unacceptable.

This issue becomes particularly nasty with dev-replace scrubs which can
then try to use an invalid reallocated eb to populate the new device.

Fixes: 1dc4888e725d ("btrfs: scrub: avoid unnecessary extent tree search preparing stripes")
Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/scrub.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index c8da03e14094..1a721623813f 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -418,8 +418,16 @@ static void __scrub_blocked_if_needed(struct btrfs_fs_info *fs_info)
 	}
 }
 
-static void scrub_pause_on(struct btrfs_fs_info *fs_info)
+static void scrub_pause_on(struct scrub_ctx *sctx)
 {
+	struct btrfs_fs_info *fs_info = sctx->fs_info;
+
+	/*
+	 * These paths are populated from the commit root without using
+	 * commit_root_sem so they are not valid across pauses.
+	 */
+	btrfs_release_path(&sctx->extent_path);
+	btrfs_release_path(&sctx->csum_path);
 	atomic_inc(&fs_info->scrubs_paused);
 	wake_up(&fs_info->scrub_pause_wait);
 }
@@ -434,10 +442,10 @@ static void scrub_pause_off(struct btrfs_fs_info *fs_info)
 	wake_up(&fs_info->scrub_pause_wait);
 }
 
-static void scrub_blocked_if_needed(struct btrfs_fs_info *fs_info)
+static void scrub_blocked_if_needed(struct scrub_ctx *sctx)
 {
-	scrub_pause_on(fs_info);
-	scrub_pause_off(fs_info);
+	scrub_pause_on(sctx);
+	scrub_pause_off(sctx->fs_info);
 }
 
 static noinline_for_stack void scrub_free_ctx(struct scrub_ctx *sctx)
@@ -2204,7 +2212,7 @@ static int scrub_raid56_parity_stripe(struct scrub_ctx *sctx,
 		return ret;
 
 	if (atomic_read(&fs_info->scrub_pause_req))
-		scrub_blocked_if_needed(fs_info);
+		scrub_blocked_if_needed(sctx);
 
 	spin_lock(&bg->lock);
 	if (test_bit(BLOCK_GROUP_FLAG_REMOVED, &bg->runtime_flags)) {
@@ -2350,7 +2358,7 @@ static int scrub_simple_mirror(struct scrub_ctx *sctx,
 			break;
 
 		if (atomic_read(&fs_info->scrub_pause_req))
-			scrub_blocked_if_needed(fs_info);
+			scrub_blocked_if_needed(sctx);
 
 		spin_lock(&bg->lock);
 		if (test_bit(BLOCK_GROUP_FLAG_REMOVED, &bg->runtime_flags)) {
@@ -2492,7 +2500,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 	/* Extent_path should be released by now. */
 	ASSERT(sctx->extent_path.nodes[0] == NULL);
 
-	scrub_blocked_if_needed(fs_info);
+	scrub_blocked_if_needed(sctx);
 
 	if (sctx->is_dev_replace &&
 	    btrfs_dev_is_sequential(sctx->wr_tgtdev, physical)) {
@@ -2837,7 +2845,7 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 		 * -> btrfs_commit_transaction()
 		 * -> btrfs_scrub_pause()
 		 */
-		scrub_pause_on(fs_info);
+		scrub_pause_on(sctx);
 
 		/*
 		 * Don't do chunk preallocation for scrub.
-- 
2.56.0

