Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8439208D0
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2026 00:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790641696; cv=none; b=U/FzIbWI4O6bwg9oG0KJVcK09lo0YoYtQsyK+AskBFlecBRBNq4Iwag/9nuC2/PjTj4pXeBIqAIWMN3q05t9yPLgjqkBOICc7FsgEhZDxosHEksvCIcVx9WQgUYSbdqlmQvLHfn/k6lrxM+86eBveLypgUf4qr8YP3nMRN7ELLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790641696; c=relaxed/simple;
	bh=j8XP2E3VMFztqpHb5FzoSCz92hRp2ZQMZAuvQCKYM6U=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=k6Dnvn1qlIqbsyEweDxwUdhe4VP1lmr0i0xnZwQMoPw2vVYcemzT0EnugisWmZhdcA6WHARAweqwgczMrjpHZ4udMrcLUS+wCAlEoqmt4SnwvVMbVKFNNJa+B/WqCfCZr0Ok7FdOK3t9xFidMpxgg37Mk9WO9McZohj8E1ffs54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=WhqxTM2r; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=iOTT6+xE; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="WhqxTM2r";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="iOTT6+xE"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id EDAF01400083;
	Mon, 28 Sep 2026 20:28:13 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Mon, 28 Sep 2026 20:28:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm2; t=1790641693; x=1790728093; bh=tjebcKQEJydX4Qtpd+/9x
	b9Pc04WNAKST1CssWP51BM=; b=WhqxTM2rKIG3y6BlbkZQ82nIyL3gz+Ff/JauG
	Ng6HZ2QIF4xPuNVnJeRtU1kUiKQKpoFNIXbK8PL50r+geG2NWVTyFdgN7SXbmuxM
	s1RKWCDStaJISqLv4Ua9UcBWZs5QY2esFD9pFknkj7N/DNyFQtniD4dhMC0Yp2RB
	QF3hKv7ROp95hRfM/7ZetKBfzFsZZngshSXtLnhwvvXl1CfsakwFgvfAhjf7pAvB
	Hv/UKK9frO6Ufge3NzFzuBYEOVJH4vV+DULsb85+ivID/U9slqv2ueI71+HQMeKq
	Fr8xHLHJfN8YZvcvk9S8ZcMDmWxoUSynf9PeoCxxKGwpF4ZGg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1790641693; x=1790728093; bh=tjebcKQEJydX4Qtpd+/9xb9Pc04WNAKST1C
	ssWP51BM=; b=iOTT6+xEjJngzd0AvHwVgZigGkxtgXfH6PbWlaFPBnnITCpZwCw
	kKj2kpF4pPJQWzx/kwmQa6IYzGnlbkbDlYc3Lty65UWMIwPGMPUEYmgD8Asu8Jdj
	BQF8Q4pDfW8/5w4JWP2j6p8aOGBZOtYAcFmOqB4CK0Y0RCzbpL0ZmtpSNpSkyRkN
	AwQFkF0A/IuK+Oo21tsnTxDwzxr/TWi0K5gJlIwXxemyDjudwa67ls1RUVitBg3O
	kIBDt1OdzXvpSgirTrlKdXQP57NlSi5yzsWgqn814PHLxudVvCW90KsRPQCM+OPf
	imGLNeevXZz2Wfh3D7D5iILS8xKwfwObmkA==
X-ME-Sender: <xms:HQa7asn0QM2oItrfpTSWk_bMB0G3rAnjqERZFs3UjtJQfYmk1t8ddA>
    <xme:HQa7ah1vdJBhLXGl_xVEeq_uH2Mixp7Nov8POUi9KWJeo77SQ91DPj9NWQCp4KVRY
    lrcjkgNJ8WnVPi6XzNn90022LJemSYVP_WEaf9q0q75CMyYeBcLLb8>
X-ME-Received: <xmr:HQa7aoRTbOZXyGnnsOpWqUwhBRZJbPGAV7rWuvhaYdhaWwjvF8i_PZ8>
X-ME-Proxy-Cause: dmFkZTF+YiuEnJHGL81G6hNofAoza6DI+3BsrbWzqroBhPJt7vFXKHY9f79SgTPOAlc1zp
    IaTPdgH1FS43stozkrj42si1hJAnnW5sezXMOEvO59hTrPDqzI1JeTgcN188SgSXD6nUAY
    +wa0h1Zg2vw8zNOreEunZ8p5QgINq9Z3ieT6J4dYhbtSM2VbbsLrigtI4kFRfinDBmUe4x
    TXYFd8WNRHV5MiNWhr1n9+ihKMwKU9+WdprhUrDttAPfb7FAc8xGSOb84eJeMirVIyAlVC
    ClqToGCeEbOsLnAgNTF7vFWPx8pk7Bea1F9wSJqbY5v1R3VhMg6j1aQ51nCrVBo6idFtIy
    w4sRhynern+/S2J0WFWkLYItLdnyRIdfBaKobdWtezibVSX7YJ9rnCSVKGqQSSIH2tUUa6
    68Ov6jO4Td7QEi40uw/DEiiInJL7jLa+eyFOR0F28AH0kWR4Z4sW/ABJw7Ko1ujrWJLoDC
    z5mYk+cA9C32wOiIpQn3NGAvCmr2/laiYSW8ttYETtfkMkzo3ykEtmMna5inb7KZAp8tt0
    akWMg4sEJR8s9Fgxrqs0npMi4nVlHV//f5NKu3/0FaK37qecoxzL1KZM0zPKP6nG3opQzt
    j+1PEIG9t5AgnFEjkxvMrSzu6qq5p6upL/J+sxTpaINEgYjLPDgG6INcSU4w
X-ME-Proxy: <xmx:HQa7ajtwsgwILLGZjZVYALKnkDIqHbw-ZHSHo59L-cR-H_KVkQCCqA>
    <xmx:HQa7atZI-UK6P3oCrZDTQNb64qn2nYLOMLeJlSABSb-kifzuyl-2dA>
    <xmx:HQa7aosydNIPDuXFHN7e6SNrY5M19wuDHgMVwS0tYKuBbwq2t5qUbA>
    <xmx:HQa7avEZm_6o218GKG-gzfBImjwPFBKMu7PBYyCdhWf-nPrn6Rrw9A>
    <xmx:HQa7aqk2Qtg4W7VMbVN1A5Gw0EInBN98WX98hFsaxpxA_hxeJhbdLx8H>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 20:28:13 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH 0/6] btrfs: allocator perf improvements
Date: Mon, 28 Sep 2026 17:28:01 -0700
Message-ID: <cover.1790641462.git.boris@bur.io>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
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

Boris Burkov (6):
  btrfs: skip unhelpful size class relaxing allocation loops
  btrfs: don't take block group references in find_free_extent()
  btrfs: remove redundant checks in find_free_extent() hint path
  btrfs: factor the find_free_extent() block group skip into a helper
  btrfs: find_free_extent checks full block groups unlocked
  btrfs: find_free_extent checks size class unlocked

 fs/btrfs/extent-tree.c | 88 +++++++++++++++++++++++++++++-------------
 fs/btrfs/extent-tree.h |  3 ++
 2 files changed, 65 insertions(+), 26 deletions(-)

-- 
2.55.0

