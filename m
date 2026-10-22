Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.147
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792688798;
	b=awOtJ19gJba8gEqMHdLMF1mwrHcgkxLy9kVcgRlrk1x6UPlhbWOg+1rOArHGt6iQWdlp
	 TP6UlsRy5KCdCjbmtW/eABJXs/+gOYlCvw3T0Eydjsi9vGBzyHO2127XuwaD4ScAaI3j/
	 aE6rvTkm8G+6wg4rsTHvcZVSDAsJwhrycS/IQgHH/hspLV3YkMpkVT2uJkV3N51+Oaxbx
	 maiopYBkGSd+5FfjBkxwA986yUVY0pSWFJilT7RB8SjTS82YMTNvuljaOZLAJlamqdEzG
	 3DTIyDiIt7Nu+ar0hrOs3r41G0KqK6Qy6Id4TeYg7WFY4EntI/FL9P5nt90WdGHYQjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792688798;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=aHT3vMfby0bqzOXUrcwxNevwP4+02H25JJ02Vz8W4t8=;
	b=Y2zLWwVYYsZbXQ2oh+JggWGsYzlZOQpfqK9Xo868pYXG6lwuUcm8m9L0nl0kxTlQejgp
	 bmRdx+9t/s6xGbhgOv2XFMR7JTk96hC2+1OSVabNWvsT0E+WoJhBCS/M5FmGr4aKS00mh
	 V/2+aVDidA4tTTAw1n0uaiJuSP6N4+ZhEXj3y4Bgkug+wt0DStoeL2l+jP/VZ2FxCugyt
	 loiukyWLmd/zFH//Y62PssvMDHznM35lIQn+66zvrvSvQnbjMCwoaAsFTd6YyWjiygc8w
	 v+fWkwG15SXp+GL8rvzpJiyLCd1yerJ6YXgTDxDGOjoWGYnDv7YoZWk1B9x4yCLp76A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=bur.io;
	spf=pass smtp.mailfrom=bur.io;
	dkim=pass header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm3 header.b=R11GAxJW;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b="By/Apmsq";
	arc=none smtp.remote-ip=103.168.172.147
Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CFC606A31D
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 17:06:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8CFC606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm3 header.b=R11GAxJW;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=By/Apmsq
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id 1B003EC012D
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 13:06:37 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 22 Oct 2026 13:06:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1792688797; x=
	1792775197; bh=aHT3vMfby0bqzOXUrcwxNevwP4+02H25JJ02Vz8W4t8=; b=R
	11GAxJWI97WYOzokO5vw/QbSzsrgp3Oc7IgjPcWQ+kIMJfJ5xs/7y3Df2D9Y4h8P
	1hhtKctWD9VilGGEsH07X4x6+9vTl4y7YZZYRPNyJyvuQdEc1fQra0r7PC25Q6ws
	ynpHAU4WhSj7CR9jV/SshF/gU0MgK3xoTu1u7oE4yOxKa/Q8yUKo9GYj1w//9Z55
	jlmc2I/qSxvQ4sMNBp6QJDAntPPkxjS9cmY4XpVv0psY/NeXczeNwBIwz0Qgqvhj
	CLyzeAqB6r8TJeeGt96mHFymqMDx/KcYmCi8p54a6hMffFr9ca1zdDQ1awERSnDc
	GQaShPmuXEvv9ltR7FyAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1792688797; x=1792775197; bh=aHT3vMfby0bqzOXUrcwxNevwP4+0
	2H25JJ02Vz8W4t8=; b=By/ApmsqoBRyh1DO8Lb9vxH8O4HSGUbiW5rv9tQjpOVG
	Idsek9zjVY1FQRDduqxv/nu4gdkZGmv/10uhIMKpfkCfBzAkNM7F+KoBzUBXXmO6
	0IiGTWllJXCT9HPHx+f80RHchn8PLpHwua746JP6Ak+FCbi7n0qd1PFR/6279Oxa
	//LRTzDDHLsb4BjHhyJNfEJcdFc8HejabW57Ad46kHi49cAdKohB0n6RtvhnAaek
	msMhWSSO1iFJ7TzmtieiSpSKsRK64r+GZZt5PcZCd4FTLNtvQysLYQoiIxQp+qiJ
	RDCAkMtc5Xi9pe+AEZiBLUI4Rgfd9GU8OHpPc3RV8g==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=bur.io a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792688797; d=bur.io;
	mf=PGJvcmlzQGJ1ci5pbz4=;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm3:rsa-sha256:U6Z/MEFQapiJ53Yux5WGm2zIfMcJpQFViscI5/WuVdeTj6/
	TrNU7Ot06HHXye4oEWIfPVph9a49VU08XhEmySA4BeAXt7oDguUTQPPjCar4aJeP
	u5tDuk8UOQP3Ckor35Tc7ejjnC76p9l7R6egABLXE+ShHzcWHPzJvVaQkwSSHzPt
	BFu3YTfQ60KHTLdfbXRMw1n2BAQus0PQGLS1b3yGE4R2rTchBrn8Irnc4ZjypKo/
	fL+vwqffqjO65ZZ3vE2KAU5yvoHXsVGAhfAEinfAj/jdGc/iKbHEPQw9oarMIVPn
	25eH53VxvEl5W97VfXBvSc1FrCJYtO9jJTIhqdg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=10;
	hn=content-transfer-encoding,date,feedback-id,from,in-reply-to,
	message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:ld0JppWZvRlODnh42s2/85Beq6Mq7hzIEpj0DbfURi8=:P1NEQ1xzh0MA1PfqBAifEe8pHWgYjFg5sP3+R/Uc9SI=;
X-ME-Sender: <xms:nULaavXig2O6swp_5rsPc-ZIbh7osu3jVQ-MDOWMJYLNWM7vN04Xiw>
    <xme:nULaatlff2WpEFsv1mFSDsgKyc-tQCsO_CxgNFpHOlGQextqnIN8nPzfUjqD4vE6L
    e2n_TL2nTlu2ItlBHG07iLkDz2OwutGhPM_JkKDZ5SThXpaHy_liHHd>
X-ME-Received: <xmr:nULaapC7rWVQlsMmM62hfKIV1PNWFTSZPjdXWyqwBdx22o0YRAo1VkPm>
X-ME-Proxy-Cause: dmFkZTGo7KXOo33eieq5nMsRjOSwHz9+hhImkv8A0hxPL8zuxKOTnBT+sojaF6n+LM7vdW
    rYYfx56wN9ocYwshU8g5d5f9hODpQfmKOqvzKfPboZIMajRMAQvqBxdabH2ENoHlsd4aA0
    HziJjuyE5sucnllIVnYGhF2KFrN2fW9rwwYPS0xnyRGXh/XbYsT5NWU+BhHQuTgPHBWDJK
    yRcomUXT5QcVDqG8iHuMEh3wXRozUGxGmZTw2DbvFnv6HFhGrK820YI4Xum9YRJPYEmZ9q
    XE6GODBlarc+alz7dKiFWL92D6EktVj14lG6GHStARwy7F6gd1ruVjFGQDKM9kAdv9r9HZ
    O/ybWnLYq0BJkgjkvFjjYBTzHTUEXF87yP6I7bm2q9cDQTJRSSjKan86WcZPdi/L8rpoon
    eB+ginU7Y0r9M1M81cPKQLyHixM5fzmX9ZA/QHtl2x4Blk4/8aORDeiTkncHvbJmw5xfNQ
    5okeJojweJMx1QjAxeyyFInzWNpcOykMUGRQwiHyl6B6HQTLi1jHYn6gCmVVcIPDePyNiQ
    LDARHTblOSITZ2zYXdy4EfKkW9/LOPzBYTinJsWuRGEeded5AM2QIU8JL1mWx+L/aqnzU+
    /z17voKtBosHAs6cqp4g1pYd9fXo+5S25nBVEC+Cuec7icZa6kdNzYDzFTwg
X-ME-Proxy: <xmx:nULaaleFFlLQcErj5phru8JYdgTeS-gdSh8GRM5a_s-Q5cxr4dT60Q>
    <xmx:nULaasJtXXf3ASnAwopVMZO4crBnnK6j-pBNcO96-ynS8TGZtveJgQ>
    <xmx:nULaagfz08scYPIoD6gPgiG6csUvaCUJQocD_kJMXpiGmBgzdLExFw>
    <xmx:nULaar12ny0P0-0Y8aDXgAOOuys-C-jEsMvzPNf15kpkvQtRo9PE0w>
    <xmx:nULaatUNiYzkLVFmxgf1oq5hw-vbJYHcA0pGRF72Epw1LxYk36vJSVnC>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 22 Oct 2026 13:06:36 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v2 5/7] btrfs: find_free_extent checks full block groups unlocked
Date: Thu, 22 Oct 2026 10:07:03 -0700
Message-ID: <997a4fc56fd49e18984361a0d6bfaab1ceff813b.1792688736.git.boris@bur.io>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1792688736.git.boris@bur.io>
References: <cover.1792688736.git.boris@bur.io>
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
index 67765797554c..8b57798c2d94 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4320,7 +4320,23 @@ static int can_allocate_chunk(struct btrfs_fs_info *fs_info,
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
2.56.0

