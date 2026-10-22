Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.156
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792688790;
	b=HdNU5CpN461cZbyOTY+tJ92/GVuAIDbtsdUwHp0J0QdYExQjBFfrUJiLwDiGHRK71neG
	 8YLelz5+teRULWYZF8E7h+7fsMw2X3hGQey8TdcNT0WZyIhG6dXQZEMZ1ofX7NYU8H+I3
	 UasYyplU2Ub6AF84VT4sw+ps0WuaOMFhGNm34A5AWMzMsIrC+xlBqEx1vjTEVgi8NAdPL
	 n7au00XFy5ts8QmJaVWee1lpvYSWCgLzB0jh+LimzjLqjvMgda34iUj7JA4oLBabtOwUQ
	 XlY+fcWECCkBt4dIbv9fNEDKf1nChIONWbdw8TeHWwePn/z0Qe8ZiQytYB+2+LPR92w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792688790;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=K0Z4UGMuUn2GAjkA7p3CckHX8WoyQTDx/1uJAZq04rM=;
	b=b2saBTLaG+gZCygsEU1bXYFd6dmO73zt4FaKEqWGDZ/iXs6ZuqATWLMQwD2zGSRykGDi
	 oysULufoATK7DtLCSUZQqQhx45FAFMrXdrDJc+CMLoYuvJKseID9YOiK6vYzuB5dda/7Z
	 3nhkR1JtGGnz0RSnvYB7afsA4PuEyrZBhoMeoN4Usq8qWpxEanzDLiFiqndHFHdBaFK7H
	 RwRAjY0C20WSiCZwBiz3OvpcuH++I3pebZA9GDAWOuxCMpz+23YdaqmiepH88R8Ua2fdO
	 HtJRUg2bWJPXIs1pAMbsQBHs72zoCRyosQGuB3IwSJxlsAKx9EI17Tg1gi0UJo8qlrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=bur.io;
	spf=pass smtp.mailfrom=bur.io;
	dkim=pass header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm3 header.b=gY3IncOh;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=suAJTjG+;
	arc=none smtp.remote-ip=103.168.172.156
Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19214606A319
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 17:06:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 19214606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm3 header.b=gY3IncOh;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=suAJTjG+
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 3857C14000FB
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 13:06:29 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Thu, 22 Oct 2026 13:06:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1792688789; x=1792775189; bh=K0Z4UGMuUn2GAjkA7p3Cc
	kHX8WoyQTDx/1uJAZq04rM=; b=gY3IncOhY8RlMlRdv6Pyb+hgh8Poq/0tw/W3o
	rRk6TCyGlCh9/MkYLsAXCeYswUQEK64znEEkLfDxWPACJChr40uwuaOzb9N3FnAl
	KWHH+tI2cGoOtbvlISX3GYeI8E01Oe5b4yxFQR71yvRsBjdmOrIYoGifQIrXBsz/
	QOdGKSLkYuj04+l0fh11tn7UeJ2w+95gRqg4p7hCs5mNqdh89YBDpeWCCVqhr9sa
	HuPiGS0W19GoY/GKp7pJeJ0Yi6VO4TZX/yE/5syW0LLYvRi8wcld/+eGMGkv4DnH
	B2q089PPq6t2vb/oMt0Di1l6S8Rt4wLa86kQ3LyEDRfRuUbmw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1792688789; x=1792775189; bh=K0Z4UGMuUn2GAjkA7p3CckHX8WoyQTDx/1u
	JAZq04rM=; b=suAJTjG+n3p3Dmnsyjr+gVZolT7YM4o98sa0Pew79mIR5QhomdH
	kACFCmlXLnWLPbLZh4Dzp6OA5cFvupNlgLDFSB0SC72UUAuD48O+zLGR+kbWy+wR
	HZHY2v4iCpmFuR/o3DPuSY/UP6fHjudcrtwOfRNbSZAwxipXvLD4mjivA5XjA4WX
	BuHL7O2NhctaubjBaVuOx3DBkOSx7yhaVYF6WJVIgiJMVxwcsLKOkN4U11R1OJ5K
	UFFaCsPD5+GrxclXOfm/zHrqq7blrQdSdTSW5ZBJjX9XovaghLATbbTNtuMDNGAo
	LG44XbongB7eAE1y8mEXDtZJQuXtlMCc6Bw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=bur.io a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792688789; d=bur.io;
	mf=PGJvcmlzQGJ1ci5pbz4=;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm3:rsa-sha256:WBREWCBJOQ3js2sK3cG8UTK0sv5AJa3mLIRt0vcpryl1ecc
	Els8Yg/kTVq+kr2ZVkxt5wSkF0MYoTn6+HBnJgHUm1QoZCL9sIJKby2oSxMbzHo5
	+Yj3g0hQTSSMLjC/mgcT8ef5oHwG/L9tfwRwwYYAdKSKWed4R9C4buGF8c5ilby+
	czaIMgOjK7fJ5uB58/FbgaXSTAFxcNrnXmQPYeYWiWR42GRcErDXx6n/mXAsX6l/
	I+LOScgQVBpntlEfu1FDjtHLnpyRoH7aJuoD7g/CsEBSxkMovVNLyrnwgDpQ7xsI
	pzM3cKwn3Ag9DPOz69ja+OAyiHEi/MaaWY2ssmw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=8;
	hn=content-transfer-encoding,date,feedback-id,from,message-id,
	mime-version,subject,to;
Message-Instance: m=1; h=sha256:ivQbD1CiYN1dgE54XJrHzpZDiu3EZHN6nd4lSfA6NZM=:4MHt1PeivYUglLB9IwuvXgcpY5/Jppm87Zg5ddpVhcA=;
X-ME-Sender: <xms:lULaarydtok641cOXqlYH5AsNFKqbu9XSoXtkCRZf2SFUOG6ykURMw>
    <xme:lULaapSwW_5ZvQp8XDPNpv_7sMZifY5TNMyIBeR3YCcooH3GITdbaemNEaSDnoqkz
    8dXY4OecJVx4uvpcFt2l8yFDR0MU2LcegiPk4kcc0Lx0QsdIxHXxNg>
X-ME-Received: <xmr:lULaai8daAJTORidDxWEcGzsfPdA4uSwsxkqdiBmEMZZlJknN5prq1aq>
X-ME-Proxy-Cause: dmFkZTFbLoFc0eTl42LVrAVQ2D+1z6muXI3KVu3hDm3fBW37s867FHMlbQJGKpo16jA7tf
    u13JB73X23SdgacNPyhIo0LHKYd1ZRjBbga4Qz++vEhHyN22NqlQ7N7j3xcY79vVwyV5R7
    rmEPGB2mRg4Wkuyk62X5J3aBNKTbzFt7rBwkGCOyisd6oYn7HoJN1R3j78QvwdcGkHUdqL
    I6iyVdwdt1UnqAH8uv3ruLVOouL7qs3Z7mfEIu795TL1fqTjp4XeJ4F0XpsjPezVT2XLHP
    r8ij4oxnJEsQX3plNPXGHa0wXRO9RkaglscPKnX8lyLSo5djVj9HXDPUW9sv/Q1DHd5Anh
    cCSCo2bMkyZPPXbiBfwbRqeVAXVnuWrUiLx0a8yheZ0BrIbrqyCFa6Ep0QbfdjVGnCrOa7
    vNxQKGd+xfOPoG+8dn8lvwzKHoyweWPji6KkhHVTjP49Tvwm0Ed0n0MVL6fYzt0yAJmFvP
    8tMZ+9OJWn6VV6/sFMijL1EXEL9UosNAoAOvqj+6IR1QewXlxxK7l4WbYOStSzWqIaSQ40
    ig5ETJYQ/sBg+QfddqgMhLxHA0hY1jaYRMVWzTTii7gkCa36txBw9uJ3KvDEMlnYMhe4vK
    bTNrathlzvq02zdCx8fzN9sVRQIaljFM2D71cZL4Hwm1DdrtJExEi8h4/dew
X-ME-Proxy: <xmx:lULaagrwumEz1GRf7rJgUbMKt96HPmepwx9rPaq-rHHPB0n70fLr4Q>
    <xmx:lULaavmtP28URA-y98pIk_yfXGn4GJsX43x3qmyIgzzn_tz78CxH0g>
    <xmx:lULaanK0joE9nPcM2mM4Ad8HCTWOzC9rBMJEXoSLOtHhIfPv_d-O3A>
    <xmx:lULaakzzjXChQRQ2wTqDUe_bTZN0Qo4IMPrssiU1bpM4WLNdREf7Pg>
    <xmx:lULaatzXFtmgESeEkopB8KQ_AEN8AiJIdcCIVsgTpH-lT9UBpcF6eGlQ>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 22 Oct 2026 13:06:28 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v2 0/7] btrfs: allocator perf improvements
Date: Thu, 22 Oct 2026 10:06:58 -0700
Message-ID: <cover.1792688736.git.boris@bur.io>
X-Mailer: git-send-email 2.56.0
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

Working on the bugs to do with large fs-es and unused block groups

https://lore.kernel.org/linux-btrfs/20260916230447.GA1706558@zen.localdomain/T/#t
and
https://lore.kernel.org/linux-btrfs/cover.1790641111.git.boris@bur.io/T/#t

revealed some low hanging fruit in allocation performance for very large
mostly full fs-es. The gist is to try to skip unnecessary operations per block
group which adds up with 10s of thousands of obviously skippable block
groups. Running 20k fallocates in a loop on a sparse file fs improved from
~40s to ~7s.

Changelog:
v2:
- removed data_rwsem and delalloc_bytes from block_group and find_free_extent()


Boris Burkov (7):
  btrfs: skip unhelpful size class relaxing allocation loops
  btrfs: don't take block group references in find_free_extent()
  btrfs: remove redundant checks in find_free_extent() hint path
  btrfs: factor the find_free_extent() block group skip into a helper
  btrfs: find_free_extent checks full block groups unlocked
  btrfs: find_free_extent checks size class unlocked
  btrfs: remove block_group data_rwsem and delalloc_bytes

 fs/btrfs/block-group.c |  12 +--
 fs/btrfs/block-group.h |  13 +---
 fs/btrfs/direct-io.c   |   4 +-
 fs/btrfs/extent-tree.c | 166 +++++++++++++++++------------------------
 fs/btrfs/extent-tree.h |   9 ++-
 fs/btrfs/inode.c       |  36 +++------
 fs/btrfs/relocation.c  |  16 ++--
 fs/btrfs/space-info.c  |   5 +-
 8 files changed, 100 insertions(+), 161 deletions(-)

-- 
2.56.0

