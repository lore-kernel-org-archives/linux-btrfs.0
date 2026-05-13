Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3C01D798E;
	Wed, 13 May 2026 00:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778633028; cv=none; b=TZ0Zf433Yx+MMhX0HwKQb+w3Q8tSkwl/ORgaSlymAr1zVRfqjzvG+NiYl70wP4sVfvDB7LdWZMze7Fv6+VU9M0VfgHGNc4MphJ4DpP6mw1ftlaQ1SMQy1kVjElypDdDfI2E7WHALKvvWkGQjAto3rbS0ItCfJ1hqRBnA06oEOck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778633028; c=relaxed/simple;
	bh=gYJBdpHNZqV5l2/RY+ywnV0cbXBwP/Qx/MJhZPmsDbY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hOCLDkcqho1/sZlCrPinbHWb+OpCQbamQvWfzsS1jJyWrDok5Bn4EhQUDJ6undH8xpJoBpJ51hVAeKyUSDnyBGJ5HGHp8EfNDcaHqJvOPewzfipwzG9w5FTcRatKecBIOFnjW/kvWVpCRidFBSfsD6cARbjjPpzBDomN9iRsIL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=YTyhv4Aw; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=PqwcVa96; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="YTyhv4Aw";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="PqwcVa96"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id C6C7F14001D3;
	Tue, 12 May 2026 20:43:45 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Tue, 12 May 2026 20:43:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1778633025; x=
	1778719425; bh=y2EuBgAkToqE4AaAkuZ3+PVjl4qcNqmVoGDl9ppaPok=; b=Y
	Tyhv4AwodBO9hkh0pBKrOXq9SLUDaJPAMEucK686ucnwUB98LqGEvf68tRCt83D/
	vTTMktK087iKQ/bhLr0XQWsKeTELnnmw+U92In6mClWcFO+QMGfs/bElTCtHnOIK
	gAb0tsmqCcvJftrosoggICaTw9LeRsib5oQoAY6j9q/FAqoB5Fq+qY+YeX18/JmK
	H0/inGLcfKSipFBnLMXWOcnofQJrJTPe46XNj3g6FlG+KwvSmzstQ1gz0Fc7P6ER
	UqAanXTzmgLTeWAFhT14pnjq5sc5bvaioWavXqRMpnDZaNE9ELBHYGM1deTNEXE/
	4g4QzyOaFZa1gwntY9l2A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1778633025; x=1778719425; bh=y2EuBgAkToqE4AaAkuZ3+PVjl4qc
	NqmVoGDl9ppaPok=; b=PqwcVa964n8S62x+AMvyYTgZ5wYBus7rNyEQOoFaR96i
	RWpRr6B9nuKUwt4vLP0RVMFeeFcp396+++x2b54hZJf5271rxiDKoNXcddRpZ9mP
	eVX5z1ew//Eakgw1LzFO6ZqkBXmFaN5hrb0cpCfhbFNdNzF63fheSFoNimcz7bEN
	imVPAjEQNjYqsRmZzXIa1BDvrtlZMX7P88iYXzYNTs8cBqxlEaC0ZMUai2Msb2JY
	aoH4+N++8VVGXmSO/Bd1gK/3xmFWGwcvYr7va8PTTgTzEMxpOon/44PkpOHz0eNf
	aGXk1Ze0Hm5kjrGsszLF6SkJDS+/wyE+LoynRIyfOw==
X-ME-Sender: <xms:QckDasYQKnVg6vzIL8c-fEIiH9ac8KX_QQ9gMNC5k5NXmv-HhCvqzg>
    <xme:QckDavKLTcHfvQhSFEhxVMSdTF_XIIXsKspoH0BuZRxlrLzGaDKSIi5molBF4fm62
    tsYcLoCBVNiLw9hRzi0xNfWhlFYt8H2fZpVHbx3vs-VdOYxmi97BqY>
X-ME-Received: <xmr:QckDaqB9OUMWczfmNWpbsOXmKlSwDPOduhScsGNr4C52yJHcHW7jNn2wWiIof10tXjkxKbjZ3HqMa4M0bfCtpsLKKjY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduvdefvdejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekredtre
    dttdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdrihho
    qeenucggtffrrghtthgvrhhnpeeiueffuedvieeujefhheeigfekvedujeejjeffvedvhe
    dtudefiefhkeegueehleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpegsohhrihhssegsuhhrrdhiohdpnhgspghrtghpthhtohepfedpmhhoug
    gvpehsmhhtphhouhhtpdhrtghpthhtoheplhhinhhugidqsghtrhhfshesvhhgvghrrdhk
    vghrnhgvlhdrohhrghdprhgtphhtthhopehkvghrnhgvlhdqthgvrghmsehfsgdrtghomh
    dprhgtphhtthhopehfshhtvghsthhssehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:QckDakq-aeBgQRbUPruaCzfOc_JAlXzF-Sd1vr0HRUp-kjSQleCbHw>
    <xmx:QckDaliLB5T59zejD8TS_IAyqRSYb5Tj5RpiCEgYWgRj5uwHQoWm2g>
    <xmx:QckDahAltvbq1yLTNDeajbtPZJmBWBl4eHd8F9zZNwhiCVVqwz7GsA>
    <xmx:QckDaqE1hCnSebzUESmRHyEHbijuQXh1glzMk9sPqvB3XpTVwHTUww>
    <xmx:QckDav2ZD378k-1m6R1v9Jjbk_MkzS85XnivPF9rBYkYxmm_5Zh7clft>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 12 May 2026 20:43:45 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	fstests@vger.kernel.org
Subject: [PATCH 1/2] btrfs: inline enable_quota helper in test 301
Date: Tue, 12 May 2026 17:43:33 -0700
Message-ID: <3234af372b0f16511aa5856aa7a3a0ca28397fcb.1778632843.git.boris@bur.io>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1778632843.git.boris@bur.io>
References: <cover.1778632843.git.boris@bur.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The enable_quota helper in btrfs/301 takes a mode argument ('n', 's',
or anything else) to switch between "no quota", "simple quota", and
"full quota" enable.  Only the simple-quota path is ever exercised by
this test, so the dispatch is dead weight and the indirection just
obscures the actual btrfs command being run.

Inline the two call sites to call 'btrfs quota enable --simple'
directly and drop the helper.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 tests/btrfs/301 | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/tests/btrfs/301 b/tests/btrfs/301
index 1f72a97b..31243aab 100755
--- a/tests/btrfs/301
+++ b/tests/btrfs/301
@@ -169,16 +169,6 @@ do_enospc_falloc()
 	do_falloc $file $sz
 }
 
-enable_quota()
-{
-	local mode=$1
-
-	[ $mode == "n" ] && return
-	arg=$([ $mode == "s" ] && echo "--simple")
-
-	$BTRFS_UTIL_PROG quota enable $arg $SCRATCH_MNT
-}
-
 get_subvid()
 {
 	_btrfs_get_subvolid $SCRATCH_MNT subv
@@ -198,7 +188,7 @@ prepare()
 {
 	_scratch_mkfs >> $seqres.full
 	_scratch_mount
-	enable_quota "s"
+	$BTRFS_UTIL_PROG quota enable --simple $SCRATCH_MNT
 	$BTRFS_UTIL_PROG subvolume create $subv >> $seqres.full
 	local subvid=$(get_subvid)
 	set_subvol_limit $subvid $limit
@@ -421,7 +411,7 @@ enable_mature()
 	# Sync before enabling squotas to reliably *not* count the writes
 	# we did before enabling.
 	sync
-	enable_quota "s"
+	$BTRFS_UTIL_PROG quota enable --simple $SCRATCH_MNT
 	set_subvol_limit $subvid $limit
 	_scratch_cycle_mount
 	usage=$(get_subvol_usage $subvid)
-- 
2.54.0

