Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.147
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792688797;
	b=SuSm1K/LfuTyzIzOv6zs4LMVMmiqWQvt7bpX4WOMLRqZcEfhykcQtsexAV/jfQTvMKvM
	 y5OfuRaLBTPA51j8Nbn6SdNTWNzeUCPWS42+ZWH5YVZFxwI576dDCxyoH6BKgYrZInNnN
	 gi0QybQkSVn6KMGlaNhAlY98vNR5V34y8JSEIzfUNVGf/H6H7sUdjw05ZKmxmucEq+5+Z
	 Nba7dsPuc8zlULF2dG7Mp37iIuPJfGvnEO6vTRsCATb+B7BkAiJ4nOGDkyiuwzFfw7Nf2
	 VUgtlv1SvFT9wJosDXq9X0szJqRsE84YYYfcUbJS6ea0KitqhrbdIRccfUmLRMdn7Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792688797;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=FECDVPH3h7E4fJTHDHmRVxdaPr1jxY83MHGAe/n1COA=;
	b=q/lFFQZ1P5mZ14OC+oXbW6dDnvMsvKOBZ10RQ5rRLL9NrCS6Ioz/sePxaCKVbm9EkSYM
	 DNtAXnKnWJPphmkU1o3BP8s3a6j4JN8t1k0Ln2gm6KJgdDmIwCBduB0YfyhYE818DqNnk
	 YAvVXRRAzjjEW5A1vSEBWRZeGD7j2FePhB3ogn6Lse9IDm0HCf0yRiSdes+wVguKmts+O
	 BYe+k9rfny1t0rL/Q/N7Hsxcjt7RVG/vRMrSfUOgilP6lQ6flGmC/SEkMkKzdf4w2HVUJ
	 cDriiXGnmJt9ESHCL8rAgZLZuyJoKz1AMHpzxPecd/1Mq58iCJS1RVTPnUdgTIZ+6ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=bur.io;
	spf=pass smtp.mailfrom=bur.io;
	dkim=pass header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm3 header.b=QeX8015f;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=pbILUiz8;
	arc=none smtp.remote-ip=103.168.172.147
Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54999606A322
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 17:06:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54999606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm3 header.b=QeX8015f;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=pbILUiz8
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfout.phl.internal (Postfix) with ESMTP id 9316DEC010E
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 13:06:35 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Thu, 22 Oct 2026 13:06:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1792688795; x=
	1792775195; bh=FECDVPH3h7E4fJTHDHmRVxdaPr1jxY83MHGAe/n1COA=; b=Q
	eX8015fngwqj2vFZw2sv+40ToJR8jgvgG0fcMyXFp8RalX3MsCr6bXee0ZW+Wh2j
	HvFkED4EatGXAt99fC9JBBuN+GXcCyhVS1snnsYCkHmMYI9Yp/C3WB4KVIfymEgQ
	HmSIDUsDzX1YA+a8RmgvN/8r40TAjo0lY97TZlorUDJjQ967r3Mmj1BQvws1NGBh
	YaUlxXyrkrYkJWeCMbl4p2ULgO7a4nEuw+htne+/W0+UOMODirFMc8yw120I+AXj
	rX6bmz3UopRtSolxARxtQQXvTegs5vbttOzvc14hkaDcuqUIn9aRa5iH1xq4Lv2Z
	TmGYQIw2WTt9vLNLzMwQQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1792688795; x=1792775195; bh=FECDVPH3h7E4fJTHDHmRVxdaPr1j
	xY83MHGAe/n1COA=; b=pbILUiz84G+G646CFR3xcRO2LajZhP25ALSlmxXEaQrv
	UkmhivC60lK+3z/XNLEucQ1Lnh9wefe6dWPUn23ZtheJgJdqUVkKTy0SH6ZQjVA0
	A5wMJinZTA0QnQLY54iVsyO2I2xkgouhj6jxXSli8Ght4UlJEvtxpJu12EPXQ4Hm
	wzgzPXnQ8mWGy5APRhyC/Cbpmkzkrm/1r+HrxBnmFwUDzUu/ymq1nQiZB4N0tXZB
	WakQb1GG1RaagCu0BHCZKvF75bBwMNjaKwy5V3RIIfv2CFuCr0gDcfmu6JV4kMbI
	exT/w2AY3P5hpX0xWICVMpzTFhPXJ28HGMyaynmMtQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=bur.io a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792688795; d=bur.io;
	mf=PGJvcmlzQGJ1ci5pbz4=;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm3:rsa-sha256:RI+pJCSnKsExhBKJ7jECk/dqSYbL+AIXljvYLhUzNazRRW4
	SmGrLM1jyV2fSv3XHup6mtf62951GU621fnCY8wdQvf9EGn8XfVAfSC8SgAfFyhQ
	HKMWstjLKRcByt54VpDtfMZJZuEOTNhmq6M6OJGz+lKrVXNkUDYrmrrhEiK14ipk
	RXjDRJ/NK7NSbSJwsGETVslyDXg60RdQjKCwvysuVmbQTpM5ilI0h/tI9LnbCN4+
	RGekTAxkr/YTE9/3VDtGn8NDneAsuWcavQoi4SJzJXKe5aa2nOoU+wPXqpSlhtDV
	sqQgtp1mYQFFF9oGqSv20+mNNtLiydgv+75xNPw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=10;
	hn=content-transfer-encoding,date,feedback-id,from,in-reply-to,
	message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:uKng+bM88PMcT9+iBLVmjnsC3QBnQFCrcycmbXc+h/I=:SRRirr+N7G/HaVdNYB/2AI8G05hq4T9C9w7bbChc/Ug=;
X-ME-Sender: <xms:m0LaatqQVCfuacI0OR6wyoRB69_2QEvxv5VmMzytPjyyCNyVkHDoWw>
    <xme:m0LaaloosSYM2EIHmfxRktpM0U39nbdWD9089epe29a4t8Ly1hdAaDDq60aEiD8ui
    Kb2EgqZmh3pamHjf8d9mPQiEXR4vN4jVGUqozbKMxym79PMGzLsb4mr>
X-ME-Received: <xmr:m0Laan0A8BbTPFttdLJgEsIjGsOymNFQwRnh2Lz9j6tWkNWFa8GBpRiL>
X-ME-Proxy-Cause: dmFkZTEe4W4ijRj8LZWD4Lo9X8GUtUjJiOBEFgPoavKCOJyoNm0WKmUICZqjwAr1fZEtzN
    wX9psAuB6tGQcZKT04iwQ+nzS1nXqKBzO4k7TataXP7fQkA2HyVZ2udM8mwy84Ds+Oxk82
    /C5tnpFc/t9o1GhxCHWBjcvs0TX5V1ixUkXuiT5gcSJTdP1VU+IXQ7UmaSJRUsfJxTTgmk
    a0eZ4LANsWxq1NCnYhrjdh0JSaR2kq3OvXMAGUryItB1L+2jmIPVcVltxBrTsxaDNpZCxy
    iGE4xsxYB+SVoTBf5HYE6bbggKmUDOCKzyfNCMaar8wuusR9vJhsSaHMSh49K56q6PNmUt
    2OK30/Ccu8Fo0aGVTq1yCjR8dlDvuSUb8DjpL8qxPXn78N5gOvCmjqrqO7dgMQFscgSPAz
    x+rgGU1gKFi9PeBl7bQrVAcEZz2PrsbL9/fQr5lc926Xgu64oy+z0pwwe9mBGxQrNpva5F
    fsip9eKdN/9IZWSnOswKLKFOX3KqNFqW7k8FBLI/m3PK+HETwFG5Y5O8VfKPZ75kf/Owtt
    DgRsKdIf+xRP4+fFbG13kQ1jw5LrwD0O6kwkdUpnqXXN8fdp9aJFcePkulbLwOXfFaZlSY
    /AObicevy9Itq9bqqaLAYY4je3xLW/SNtWluZcE/Ctiap0azlTY7mts4jCSg
X-ME-Proxy: <xmx:m0LaakDMtmUMicuu9yEb14d1oIKHO63xLimb0CY2Dz2sczM55Gzc7w>
    <xmx:m0Laavf0HD91G4o4TSakpS988oFOkpcgTeeFGQedZFdtr0ZXMtJicg>
    <xmx:m0LaapgitoZ8RC-MpkeOMVODsH3bxe1QACGTeY2zPkQ1sx4X12sqKw>
    <xmx:m0Laanr9VY6FV0odb-dbIpSoqBpxlJtD8fDw2ygODfY1jCeoKTPyNQ>
    <xmx:m0Laanp1tb-PlbNozBPzAW73d02O-FHOxtno_VIq_NyhWPK7zJmFs0gJ>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 22 Oct 2026 13:06:35 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v2 4/7] btrfs: factor the find_free_extent() block group skip into a helper
Date: Thu, 22 Oct 2026 10:07:02 -0700
Message-ID: <708d0016ea13059c1123f12805a157c669e5fd49.1792688736.git.boris@bur.io>
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

find_free_extent() is already quite unwieldy so I believe a well defined
"usability check" is a helpful thing to pull out into a named static
function just to break things down into easier to grok components.

No functional change.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/extent-tree.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index afa9332ee2ec..67765797554c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4317,6 +4317,18 @@ static int can_allocate_chunk(struct btrfs_fs_info *fs_info,
 	}
 }
 
+static bool find_free_extent_skip_block_group(struct btrfs_block_group *block_group,
+					      struct find_free_extent_ctl *ffe_ctl)
+{
+	if (likely(!block_group->ro && !(block_group->flags & BTRFS_BLOCK_GROUP_REMAPPED)))
+		return false;
+	if (ffe_ctl->for_treelog)
+		btrfs_clear_treelog_bg(block_group);
+	if (ffe_ctl->for_data_reloc)
+		btrfs_clear_data_reloc_bg(block_group);
+	return true;
+}
+
 /*
  * Return >0 means caller needs to re-search for free extent
  * Return 0 means we have the needed free extent.
@@ -4674,15 +4686,8 @@ static noinline int find_free_extent(struct btrfs_root *root,
 		ffe_ctl->hinted = false;
 		ffe_ctl->search_start = block_group->start;
 check_block_group:
-		/* If the block group is read-only, we can skip it entirely. */
-		if (unlikely(block_group->ro ||
-			     (block_group->flags & BTRFS_BLOCK_GROUP_REMAPPED))) {
-			if (ffe_ctl->for_treelog)
-				btrfs_clear_treelog_bg(block_group);
-			if (ffe_ctl->for_data_reloc)
-				btrfs_clear_data_reloc_bg(block_group);
+		if (find_free_extent_skip_block_group(block_group, ffe_ctl))
 			continue;
-		}
 
 		btrfs_lock_block_group(block_group, ffe_ctl->delalloc);
 
-- 
2.56.0

