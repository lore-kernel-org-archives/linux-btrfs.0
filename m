Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3366F2F2
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Feb 2026 21:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770845375; cv=none; b=pTvQD63tE8VyBPXX1RO+4GCQQkSUK8DQSNy3fPEkdmWv6rkgmEW8/zM68ZONLz5gngAvYlht7rxnISpK+iWsu2UNHoE956sTv7FasGtbiGn8E6Rp2bayu/vXOGTKiEsguTZ+oyrT0lOkzzxP66bK6atMeGFiCDuF/8Nx6459Exc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770845375; c=relaxed/simple;
	bh=ZabSuwIlzlra80ZcV1v54VF5AvQsftnGsvbJWp5xWiQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Vl+5KFarHlYdXdkOe3K4Zy4kD+v7VReq8zVNGRAI1qJyf0PxxfbYI35VYCo3w3rvf80COdl0WVHM/wawKp4j5fG+NyeqVGPVCDYjVkKQKfOGUfegSlIkKGofsxotIJFLyP/4+NO7YK6e6xhENmHfuCwlh45jNZQLDUC/OmUMHXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=PLXmw697; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=BQBo7jV8; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="PLXmw697";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="BQBo7jV8"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id E5662140016D;
	Wed, 11 Feb 2026 16:29:32 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Wed, 11 Feb 2026 16:29:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm1; t=1770845372; x=1770931772; bh=cZzUI6BQUuaxDBaMf4ey1
	bRGG48fS34YKqDTwQxoo+A=; b=PLXmw697D2aRIRNulMrqZLA3tyi28lg2WL1/9
	9ynlF3Pq+n8TISmhxBv7+tq5i781P9mlfS0CNiSgkmnYHX0SiHuZKHNirPPlZdzC
	H75b8mUWqzGb8gx0yr2B63p3tgsJGTPmU5pToLrhlY6A82zw/iEDLz3NZslib/lO
	/7ZoUpWgalZjs/fYsr5Lj+CtS5m+wj6TioDwvgXSeGIBPF7Mr+YjVeWKIbBYsSw+
	9o1jnB42po81KMIuxQQBSWU5wGOqVls8NtAVlM0jiaal/7TyL8HgShWgGxILf5ya
	ZPDoPAcMYMqKLvQSV9Za/m96yeAt8DPSDyUPv45yzb7KBMgrw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1770845372; x=1770931772; bh=cZzUI6BQUuaxDBaMf4ey1bRGG48fS34YKqD
	TwQxoo+A=; b=BQBo7jV8BvSaF2eDg3QQzvVAUnCj7vMCowb955K7/SP44KGvyBt
	a/7NDPnpPHRq0L7GN4sBGo/dVinD8AEToVh/xajMes5IhjhU/RQhP6bFcjnivEXI
	xd+pzQ0kGQYPIQkbVaFj+t0P4LQKdxfWrs0cDTGd52ZbhyCyFWNv9nli5iVco3iA
	HQ5VipTdnNHLRio3wI2u4o8TWUMUaRXOKV3x9MiYG6v4KJwsOcy44mKuwaxfn8NN
	3fLiJWEiacmdbZjRinemA2V8zJv+1XB2HVUJ10HcKJUrGVN9lV6xrjDaGNCTU9ic
	vSmRr58XOPnHOSl0LBfiIHwXBTGRZOyyv/A==
X-ME-Sender: <xms:vPSMabHwJG45Jmm_AuKiSwdnFkwQOSJIN90N-0ADHU_HS57sD430Pg>
    <xme:vPSMaeUguU8zX6W912J2SuGljgi9IVcp7n-TcYdJR8Mmie85ZOmEVxsROeb4ZnFfM
    vkLpMxiTtiE-lGgSjNCYAu3bKkwkyjU7Anhwr3kgHZjA3_qq8aMVg>
X-ME-Received: <xmr:vPSMaay1xWL5pVS4DsUj75k_FCkAf6iPQpkJisxwxH-Va5QfpRSB9mxSViyys5A5FRexUejMxGvQS1_Ww-vGtUr--As>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvtdefieefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtredttd
    enucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdrihhoqeen
    ucggtffrrghtthgvrhhnpeeiledtfffhhfdvtdefgedvieetleeijeejiedthfefgeekhe
    evheekjeelkeegkeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghorhhishessghurhdrih
    hopdhnsggprhgtphhtthhopedvpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehl
    ihhnuhigqdgsthhrfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepkh
    gvrhhnvghlqdhtvggrmhesfhgsrdgtohhm
X-ME-Proxy: <xmx:vPSMaUMr0XkKOJGFBmd8bA-PgUsl4SBHutUBPJwsux8xacPzsIcgtA>
    <xmx:vPSMaT4beLD-Ba16lIvib5IgAkzhr_ZMFfTmrA6nZmsWIlse4F7obw>
    <xmx:vPSMadM4XYoKrlzsU1ExWubkcKnHSEmG87grJhfXlr3OHEQuTGyoEQ>
    <xmx:vPSMaZl21-KE8hTWhz3poe22MheZUyQtzoMnPiZhKhWKNMlxP8wxiQ>
    <xmx:vPSMaYraIpQxq-ZXsZAuwnP_3rs_6l36ukNeoiTVDOsnVqMd-5fwzK1p>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Feb 2026 16:29:32 -0500 (EST)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH] btrfs: fix rfer_cmpr check in squota_check_parent_usage()
Date: Wed, 11 Feb 2026 13:28:42 -0800
Message-ID: <b47c68886c6e5174a2281e45c93f486a2aa73752.1770845275.git.boris@bur.io>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We compared rfer_cmpr against excl_cmpr_sum instead of rfer_cmpr_sum
which is confusing.

I expect that
rfer_cmpr == excl_cmpr in squota, but it is much better to be consistent
in case of any surprises or bugs.

Reported-by: Chris Mason <clm@meta.com>
Link: https://lore.kernel.org/linux-btrfs/cover.1764796022.git.boris@bur.io/T/#mccb231643ffd290b44a010d4419474d280be5537
Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/qgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 38adadb936dc..19edd25ff5d1 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -370,7 +370,7 @@ static bool squota_check_parent_usage(struct btrfs_fs_info *fs_info, struct btrf
 		nr_members++;
 	}
 	mismatch = (parent->excl != excl_sum || parent->rfer != rfer_sum ||
-		    parent->excl_cmpr != excl_cmpr_sum || parent->rfer_cmpr != excl_cmpr_sum);
+		    parent->excl_cmpr != excl_cmpr_sum || parent->rfer_cmpr != rfer_cmpr_sum);
 
 	WARN(mismatch,
 	     "parent squota qgroup %hu/%llu has mismatched usage from its %d members. "
-- 
2.52.0

