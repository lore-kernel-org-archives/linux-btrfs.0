Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E2F576EA6
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2026 16:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790096138; cv=none; b=oqQPeYYo1kVuZ5x2E09s9J0TOrXjhzkOf52rEla/749jK+oxgY4mCEqt2Jc6lJ1CIJ1Q8ssXYxGek02qRoypAJ+y/saozPXf9As44xOwH2sHFI98x+Tgr0ldRsFGa/u3hqaU93pRCCWQvAwmKBQs4LWS3fItXlCITXMgmHXavJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790096138; c=relaxed/simple;
	bh=HgxDRM5Q+/DlHTIw3PMiAvEyZQ57xjjUH99EnhxbN50=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=mB37P//9I/jNIYomAM+FqHpWEmZllfsAS9h/JCqNwxa9bR0VDf3wrhmBFwZsqzg2ZKHWP9ls01tprynXxqEObtFsc3JRrGLw3rXMcaPdFU/kqdrFcm8pj6SCW2DgHyti+Ufc3PFg7yANgicmp0eMlObS0xA3cMyEuRe5WWMyb84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=LKty8Ljp; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=u+kbDtns; arc=none smtp.client-ip=202.12.124.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="LKty8Ljp";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="u+kbDtns"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id C00C27A00E2;
	Tue, 22 Sep 2026 12:55:34 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Tue, 22 Sep 2026 12:55:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm2; t=1790096134; x=1790182534; bh=WPZmhV9BOd5kMjTqQ4Ayx
	M94CmF0Yxytsv6Z2qzPxxo=; b=LKty8LjpC68in+EME1IkrjWbfcccDdKVuDjMJ
	0UwXA+Mbo0Dapi2F5K0jJ1fLAMLHNLeZENoAUP+QuoTQ+tB+Z5h2kDktU3PzDp/6
	o3UkiED4BNNRpl/vPEFFqyvNocrJ/sISGAAOJjc1PBGd8KCDc+HNLq+z6e3LJxFP
	RwEtrb2jmwcKRPQOzrMo2rMAG5HXdA+zqh6zjGhjm8r1f/GGFODBDcuFLwGzTkBf
	uy0yf5Fz5YOlPV8PmxVM0PlbRwOKMgkWbD6zrkNOwFm4cLq0ul3Wzbu4LeI/8Qyg
	jH8AJ02RNuNN+FK3AyVKzFUZyYc1pb61l+b6zM/zVNJScyQ9Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1790096134; x=1790182534; bh=WPZmhV9BOd5kMjTqQ4AyxM94CmF0Yxytsv6
	Z2qzPxxo=; b=u+kbDtnsRv52buZjG2uRFhniQo/uPo2XDdRlrycNYkyjxzYS5rW
	nnnpGZsv7Me+eMbQPEqhT4DHRxpEBolB8VxwuzIPTe4T3FRuv9N1YTb0r5cCtKBy
	01ltkyRl6hEIZpWrzX9uAkC6qHP7Orz5KaEqQDZIBsCnegdtdIz9/yCDxElcZXwU
	0OPSTNLHU/WJzJgVWpY68OM07tvkSUX8hp8EhkMzxzC43sSWu4zotmBTFxsN7N1D
	q0ldERAVAY3Q3YHfKu/KBHBAQ3FGW1YcSNZ6+xoOkfCoQTuUtf52LvMcEjOYF1e5
	llkOljOCe5EknbX+mVZ/mAiAmZFn0Jk32bg==
X-ME-Sender: <xms:BrOyagCUx3YEwErC_6bmd88r6y71NMGJAe1FObuVKXuXQlRew6xBWA>
    <xme:BrOyaoijhSqINCsvMZtuM_kU-9lt2udIw_Od4ISFhWrmSUQhDEvSvHTujglHdcqfp
    oLQDM4Y-0errsdyOGXtJgJPzgsm2UyaBS-PRMF6PxuMGmYyGTE2ajGJjQ>
X-ME-Received: <xmr:BrOyahPHexG4q4sbdUBUylbUrds2NH-WOKAezeu0EDqVI93zqMuW-TM>
X-ME-Proxy-Cause: dmFkZTFGNpBpqjHxWjNrYMiLsCixy+fHULw+CHKHBgCuMNabKvUSXpXoCDBQOgl9SxF+d9
    b0u4MBGzIY+BcZl/ulCHKQuKp/nieRp0GR1x3zlFEswm7kdJ3CWoQcmqGoypDQjKmuBOt1
    ZL8davkGeargT1ZFdDaVQ1nWF3RMIW4N2vJFhCfnDyLpEKqE2vDkeTxs5rBo+BBwvdkUFZ
    efajh6BAyQLafqtctUM+K9ZpLJWh2fZ4U53qnSh0lnBHPGZhIj3N0d1waDndoTOX6r3Yec
    PB2Iex8Om2c36RkmW07g6PEVsCaK7bw0krU4RkopCKHaJxRYVqrFikEfRWKdtcdvhjkCoq
    7kUAsu3uvFT4ESF62B2ssUrh3FEJvalUBdKF3nVaL0JD1RmIgsAmQLkmL1q5ogpLMA37K4
    uuoWZdnt3HKjLw4Jo7kv3xBIky9L6cTumip/yzpBoiwHgmkeJ4nSXCa1Yott6bVNlI7vpB
    iUSuuhayAlVvRKe94uZ2ECXkTlA9aK+3W2xZkL5cWUvgTLobWKMJwrJaY8OA6OGusi364V
    oLIJt79e88jS6dVmU0ILgpgBCIgA1hoYk4c2JMlumJrN8Mwv9RwfXsFBzvvEoOQ8RI03Mq
    +F27gl8gqSk34YKHIpI2WhcxiNdA1Hb/kqCa525mGuO/x4jxXSzAEmIC0UjQ
X-ME-Proxy: <xmx:BrOyah4e7c1j_yxFgV6-8pL9dKqi6MZvt0PeJmBv9iNcOIXJSXDmPg>
    <xmx:BrOyan1Ec2jduvaV_y0vyCvW4VB7eiW74rWXHga3_WVG9i3yebhpjw>
    <xmx:BrOyaqZicC8u7GOxcxKqq3ZBiadVJgTPgCi8qPTjG93zlx5h9reifA>
    <xmx:BrOyanDXF-y5c8HQB0oijDSazvTiPAR72p2akO4YUMaVxl4vbYVW9Q>
    <xmx:BrOyaiDZzu-1GbnIH9R2KhB38PLTQfPtZc03JXTKU5olyWV1oaPGkgA->
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 22 Sep 2026 12:55:34 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH 0/2] btrfs: ENOSPC fixes for unused block groups
Date: Tue, 22 Sep 2026 09:55:36 -0700
Message-ID: <cover.1790095812.git.boris@bur.io>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A few fixes for system chunk allocation ENOSPCs caused by a sudden influx of a
large number of unused block groups in a filesystem with no free dev extents.

In practice, I saw this on a fully allocated fs with 30TB of space, a 4MiB
system chunk (single metadata mode) and ~10k unused data BGs.

- The first patch tries to avoid the condition by allocating earlier for the
  system chunk.

- The second patch eagerly commits a single deletion when the system chunk is
  at risk.

More details in the patches themselves.

Boris Burkov (2):
  btrfs: allocate additional SYSTEM space earlier
  btrfs: commit after deleting an unused block group if system space is
    low

 fs/btrfs/block-group.c | 43 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 40 insertions(+), 3 deletions(-)

-- 
2.55.0

