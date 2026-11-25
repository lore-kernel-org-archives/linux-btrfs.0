Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.157
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795642471;
	b=n2F70LQnl5TuGlid9MS/eBDnvrRyGzFmnhird1vJr9Hq+BpCKJTupvWITKZfan8xZHhw
	 UAiXxEVxDKD1UIWFSRKGU7zTkazJAzoxiMVcmY6Lpy9gYXzlOmN7CESM9+a7vWraW/Yr0
	 se1BqscDl0iCTGwaLzdsm5o2J2W/NsjI8soiDXW/XtzcwVNR6evEXvcKvK8AJR7WQemh5
	 aA2S2gQIE2Mc0uWY03KwfnolOVJ/R9JC2sddydwz48Btm1VwNaG6syOYSyCgjJMNFCVAE
	 8lNXzHFPM5gjPgng/oT9jc7TsqES4lOIZZDDY7X5ti6tCuPIAnBaVA1fi0/Z9eG6icg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795642471;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=h2DKVysBU1ilVpAZ73KX/xWclaZ2a6CYyTzi8BOmvs4=;
	b=my0KzGBSuwCLAacD0l194XI7Wdo9IzDxJ2h8vOPlT5ag920KvHy/FM3fnfIN6NRMKbBh
	 PmkSuTqrCuNMbyVgY8fpB0TbI4URXFq/sVNzWa/zEBNGWtNexxqfSqOfvtk5W6Rnu8uJe
	 tzpyxJFJ/AXugiXzePmdgA6bQ06ewkrkf0uPP7R8q/7e1inWeGJrTHD/hpVKuE4f07mMO
	 W52awBeNLWDA1V2j1wlF3lNWn9CzxMh77wqBMCUZVebDIiPfFl4+ah960X8zuYgg1vrYe
	 KyVPlZCbA9xozUBH6Ld9qLJj4rswdvSdpPGe1ZmCwku/j3xb5iEnCs2LrtwVAt8ZnsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=bur.io;
	spf=pass smtp.mailfrom=bur.io;
	dkim=pass header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=QbhloMT7;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=ukBCHhSK;
	arc=none smtp.remote-ip=103.168.172.157
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD41606A31E
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 21:34:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CDD41606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=QbhloMT7;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=ukBCHhSK
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id DA2471400368
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 16:34:29 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Wed, 25 Nov 2026 16:34:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm1; t=1795642469; x=1795728869; bh=h2DKVysBU1ilVpAZ73KX/
	xWclaZ2a6CYyTzi8BOmvs4=; b=QbhloMT7lfeCw1RRwD+ESk6dtQ8FNSTFS9Y+q
	jIB/6zRGcbdE7L6QCMCqNFCcXJa91YIJ9bRi5XuaTHFPVoFRgx5R8qJrfLhsa+8H
	Qkhz0/6kHVi6WPolhGVu1rVu5u5w+Nbn8oISz9EQDZxG68ekBQYmsZQkhLBUNQmf
	nrW0IHsZ9hGY9mU3xKVMsSHsSjchmlAKddOM4jEVaMW6xVr1bQnW2WrHsheMSuIh
	a0x4qTBDN0bMKQzR1fNyj/gzlNRinzsY81LToD82FH/vmJYcHOp+qKiSZaLSuiKL
	yW/kM5+YORClDve4y5QuGKitobK6QSA0+89GRnz9nIdvFcBWw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1795642469; x=1795728869; bh=h2DKVysBU1ilVpAZ73KX/xWclaZ2a6CYyTz
	i8BOmvs4=; b=ukBCHhSK9NAzcuFJGk+CeX2Q7vZPiqzWDENm53J3sb/NJ/JBnJh
	1LqEbOGOw1qsZfssotwa78X5XkksfqGRo+6G7UHnwMVHyjdrXK+ReBf4i+9WyrD4
	vjyS1xv9YUxbrn3cAdj9QEShT/ZBWocAbkvb5HUXAgrzyE0FXuyf6jx7rbXUH9jY
	pPvlFW7P2XIyFNDZgJnGkleXtqKLvGwWyYgPSM+GIfj/x/A6qeCNO5BYyPh7QZFA
	oOTJN7iqNps5mZLs/6er0NmxRknl4sBhr9giXsSOlvFlJtnn7x580fr+2M3BInP4
	PyhWnrt/8sqO0LR74DuyW+oxK+05ILbb3wg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=bur.io a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795642469; d=bur.io;
	mf=PGJvcmlzQGJ1ci5pbz4=;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm1:rsa-sha256:G3ST0jMsBVFYjYWUR7sT3VRzU37S8r3s7EOx3emQjbRHNBO
	5RSsXIwkzqBhqOfKko4Zi5vsl5MwFInHeD0o5RHgTR8xq3IkfJBttHhFdo5a0IOk
	9CkZMWPE2RqT7nnN24iJTrIVPeX5CSes+rJ1W9dcKQWCF/83RjmcTHrOrwyu96WZ
	rqZ/+xqcmAt3z6I2a9DR0zTZH/oEyhsWYmmL+ktMCya1nnupbHsD0zWGX952ZWu5
	67MfxyxPnOx+KzvBsWB7OrrXxStA2xa4tpgU/DaISrGpY9p/q2U6tt8PO1nqbv7n
	AJYato/wyP6uAWoClToNWtfokAm5Tr37uc7+HkA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=8;
	hn=content-transfer-encoding,date,feedback-id,from,message-id,
	mime-version,subject,to;
Message-Instance: m=1; h=sha256:fbLU8Ebg5R8wuEDfRc5UfTNHELIz2QDiLMuPMURmx1Q=:Mhgftxkc0pWvTPbNg9DonpgmhH5Hjih5ww4E1UAqBjM=;
X-ME-Sender: <xms:ZVQHa0Gldlkjiu6pchjMzN3gU_hsxYFh9LWydL6QdmL7CncdMPcjzQ>
    <xme:ZVQHazVifD6nFeYQ41sfByZFmfy8e5iwEYcmLvZf3VkY2XAjEWZYAWBpomcwxOAxd
    esNT_TqlDzei32hAHAK_eB8WNelIaBpk36WaX4XYHl1nxqS-sb0xWwp>
X-ME-Received: <xmr:ZVQHa7xkVg6O53rSr4eWoP6pUzf9BBF0WRgpr3zK4-66y8kcDviq7h1R>
X-ME-Proxy-Cause: dmFkZTFmh897UYxtCTMBLIJEkp7jF1qo733+rRj424OlnFni+YTcawxja7Jz0LVUQp9u42
    M5afu1jowsA4kQWXr2k8Z3eHbPSyHkpZCIyj3cNNULv10aDNWX7hi9tqH94QYPQK9y25eV
    J3SbSGUPm8TwGl5GLMG4krudBtUkETFCnD8cFUhm+eYZOZfTmG+IiCzqjZt8VCXf6nDcfU
    aWRkxTWd428r3WQvV4/K/70UGMVp/8gQ+305WH7gHaPgaNJUs/XCeLyhiW0UR2PCIFGZ63
    65f/YdOp/DAyfLGzdjlgpxiwUhN5iZV1dtIWHFHQtDLyzfSafrS6PdCqDW2S9epztVnmQH
    8Xyp7HyORGlt1gXrTQqngHr8/bOhC1UrvyIcPLokD1XoAYKI1Tgtmj1L1AOHME1heoRkQe
    f5yx4OgICRHxhl2Yi/QoI9lNxzAvL3ES9A/t8t2XY6US2TyWznWzWEA9riu9RBEFB3ovWW
    PF+B2tjtw6J9qbJq8W4PrYETGyt17rAylMU8+BslmmOiQlGNpEiKwhuq/9M2dnrnVtotdZ
    NYeS//brtec2Y5KGMdyg2I7/+Ymb48/8X+zK0UErQduYC9o1Zj9GNUA3Z/SpP1Ag9mfvii
    reb+CsAJP04ucwS4e02nCQ6RDCaI3ObxgDPYAP4ImL+OLq57hmcVv1hWN8yw
X-ME-Proxy: <xmx:ZVQHaxMVdMZUQgIs98RqiTvkCpbkXC1o34KU-LP2kZ9eNj-LPxUxFA>
    <xmx:ZVQHa86Ippvs6cAhmI_g7QxQkDgyG_45wavCBCDCYOTYtiIOD0vA9w>
    <xmx:ZVQHayM_UURM2kagos1OslgLH62oHBDD4S4XQocT03R6hrSyHcN0-A>
    <xmx:ZVQHa6kGKn8Jq4JPw7piZA8DLFkV_zcOWXrwhei_NIiHBv-ER452pw>
    <xmx:ZVQHayGR_UAu5WI-p87-50UFUf6_6bNZDqcWE8pnKukOUSEed5-CJB_z>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Nov 2026 16:34:29 -0500 (EST)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH 0/4] btrfs: scrub: support low bwlimits
Date: Wed, 25 Nov 2026 13:34:01 -0800
Message-ID: <cover.1795642270.git.boris@bur.io>
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

Scrub currently bottoms out at 512KiB/s bwlimit, and below that the logic
doesn't make much sense. But if we support it naively, we ruin high speed
scrubbing and add unacceptably long uninterruptible sleeps.

Therefore, to support arbitrarily slow scrubs, we must also spruce up some of
the sleeping / pausing / cancelling logic.

Boris Burkov (4):
  btrfs: scrub: release the commit root paths before pausing
  btrfs: scrub: cancellable pause during throttle sleep
  btrfs: scrub: handle bwlimit below 512KiB
  btrfs: scrub: size read bios to the bwlimit 10ms burst

 fs/btrfs/scrub.c | 192 +++++++++++++++++++++++++++++------------------
 fs/btrfs/sysfs.c |   2 +
 2 files changed, 121 insertions(+), 73 deletions(-)

-- 
2.56.0

