Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D8E2E542C
	for <linux-btrfs@vger.kernel.org>; Tue, 12 May 2026 19:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778614521; cv=none; b=fHtkzGEzHEMvL/UjKFSmyTHM8ikUm2pn+6547DQa1o5Ot27YDkHNYyQbyamtDsiObFOxUIzHHfVduftJBytB4NcCE2FSmrtfGnTxmMKDsRAtfOac4/+BBvrjO5y3p7h53epQ5Krs1AobyGvmhSqtTy6vFb3Ek4P04XC1d2cHN1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778614521; c=relaxed/simple;
	bh=6K3lnzz27IncV/mtQtJ8bPED1Doi+TXfkyePetST9xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pq15dmn9sQoX+O+8oZyq4TSfsoeYGtLKzRQpy4SBY7ldAOzmxk4XmIWRL8hUGQdO1iuiCz/7qMzvrsHbqM6lSev0boC1SHXij1Zxwm954oa+RNsbDmz8QeaxuZMeLh0KG2cBFoTcxwW2dRRndaM4qdyw59lvua4nli3CWBhCNKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=PhJdgdZS; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=gBnlBdJf; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="PhJdgdZS";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="gBnlBdJf"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 417E214001AA;
	Tue, 12 May 2026 15:35:19 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Tue, 12 May 2026 15:35:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1778614519; x=
	1778700919; bh=TD7aaEsespuRyxqkD7/OaWRXsTQiWtQohc/nCW0f5gw=; b=P
	hJdgdZSMC99AC95CcUJ7TRRYt1vjKIAIrhAIOa+Nroq8ANJ61WoMq05tpi1U7/L+
	s2/vCsRer8R8JVcsPMibp2iJXBJ6/wcfG+uaGWXu9hHyb+g1P0b5icl+3QI8BMEg
	HSW3oFhiTPIv202Q7FZs+XOe+3dchOSQMm1yw2+w9S3wd40MXzxsMPd4iZ3SVBMr
	n+mGB3wqtyekQ8hDwYYmcB13gon6GVv8m5HFOrIV28V5WoEI0i+dD9Q+A+7Dba5A
	zhbk89FbxgucpX0LsXH+hOkDCFiZlMWrP5vPK9EnXZEumlko7wv+1mTZ47m9SUzL
	tWHzNhlaTx0OhO7oxB4hg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1778614519; x=1778700919; bh=T
	D7aaEsespuRyxqkD7/OaWRXsTQiWtQohc/nCW0f5gw=; b=gBnlBdJfqjbIdFAAf
	c5Cs/9pxEZDgKybcFGTelAlY7fIX7qXbcDYMG2598K/V3IElAeWfU+dOCO8P62Tc
	Z4YsqXryNGLYdQpe8h62l9Vi3/E7NDdJdQi5wrH86YyBhr8TLNKn+pZsUWTTDv4o
	0rtEjSxVkytRH8VPUsf3WYR1v6E78JYtEkBCpV0JIgk9x5POtf6Ipzsiiq9zcHkF
	CrUyrc0rvVRAT1C4PVL8OWIPAGrmpYCDYsftTKLRyXEHxWqV4OisEMJ+GqgfHok/
	4ib4FwJ1rB0UUTnGkIkdva6t0ulT1c0illoNYVbmDAEUeVlAmI4pyRGracGHrSFU
	FCDPQ==
X-ME-Sender: <xms:94ADalImUzuk59FCQgJCG0cLlOv1q5Td9quT1_12yqKuC28hc4-LlQ>
    <xme:94ADaon0PhjkBWUsPzDWZuI4-lfGYIG1reWHlGne78RwLrTg9bIVYso8y_2rzWHen
    swWR-t_HZaSlKJnoBlzGK88S8R98KowmiIy__Uo5URIcf-55tte7F1i>
X-ME-Received: <xmr:94ADarE8S1OrJfz432MqRa-i3bCoIdxZs15jebsj4rHC5aIZm2gMJWW-tNzngTlgzpbNuK7ZzJGz7sM3Qd5pkQNum04>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduvddvieehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepgeduteffveeileetueejheevveeugfdttddvgfeije
    fhjeetjeduffehkeelkeehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopeefpdhmoh
    guvgepshhmthhpohhuthdprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvghgvrhdr
    khgvrhhnvghlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghlqdhtvggrmhesfhgsrdgtoh
    hmpdhrtghpthhtohepmhgrrhgtsehmvghrlhhinhhsrdhorhhg
X-ME-Proxy: <xmx:94ADagFhhmnF0c7YjQRE2WXmsawfC9YNxdbQUU7YGr_oTaMmd5Ql4A>
    <xmx:94ADagOvq14IMm7S64SG1OgRA2r8-6GbKsmqqKgB_QRtSkylNLEUcg>
    <xmx:94ADanG3q4nAqOcGA-FILLvHFUMxQ6uVEV_DSDd0Ua3W7hIIFw2m9g>
    <xmx:94ADavOq62yv5YyQUsmGKyeYWFiHJWq2OFcGDneweg4mlkk4PsGEuw>
    <xmx:94ADavJo5zeKc9rLE3PoB3lapbpPfSxMD9yNX3U34Zwx2-z0sLZ7-AXg>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 12 May 2026 15:35:18 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Cc: marc@merlins.org
Subject: [PATCH 4/4] btrfs: swallow btrfs_record_squota_delta() enoent
Date: Tue, 12 May 2026 12:34:56 -0700
Message-ID: <2d814d975b4bb96a8310d9c941c5457e10db388a.1778613519.git.boris@bur.io>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1778613519.git.boris@bur.io>
References: <cover.1778613519.git.boris@bur.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I thought that it was likely I could harden squota deletion to the point
that it was impossible to end up with an extent accounted to a qgroup
outliving its qgroup. Several recent bugs have made me re-consider that
position.

Ultimately, this is a tradeoff between short term stability and long
term strictness, but I think given that there could be another layer of
bugs behind the 2-3 I just fixed, I would feel much more confident in
people using squotas if the risk was "your values can get a bit out of
whack which you can fix by deleting stuff or
disabling/re-enabling/repairing" vs "it will abort your filesystem".

As the final nail in the coffin, the Meta production kernel was lacking
earlier fixes from me and Qu regarding subvol qgroup lifetime, so this
is what we have been testing at scale, so I think at least for now
upstream should have the same extra layer of protection.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/qgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index a93d49015fc7..f9e5005028dc 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -4959,7 +4959,7 @@ int btrfs_record_squota_delta(struct btrfs_fs_info *fs_info,
 	spin_lock(&fs_info->qgroup_lock);
 	qgroup = find_qgroup_rb(fs_info, root);
 	if (!qgroup) {
-		ret = -ENOENT;
+		ret = 0;
 		goto out;
 	}
 
-- 
2.54.0

