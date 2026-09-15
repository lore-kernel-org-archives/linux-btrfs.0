Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C6F3DCD9B
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2026 17:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789495100; cv=none; b=fLscwSM/6+9wZcRQY3Cm93I8dEL6By/8a0jV9qmikxP2oQlcUb4FJiH2/Hn6rTJAvd4ng80ZtbSJ2re0u6rUHiPIymFPLi/+PjcyiZBjZ0t8fuMbWhJpEXQb9EFL+oG62TZAxhvnKENNP6lwqraA1E1iStp9Mg/kHCit2d+mUAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789495100; c=relaxed/simple;
	bh=ZaTwwu4c8oH3YdI7HVBrF4qisUZsDOH2KddW6fjJXZo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=VeWe3+kzmBDEKPsNBpGesxkeSszsqeSh1IqJyjmEWsjXw0Vbsd9oRsE3exnndoAtCNAQN7KEJjZsV5qrtENEUJpIFGIynMtpfWodnuEKW4Ts+IBL+vT1bCjFIJU154YaVExX1jFDKNGZe3PnvPVIAL9elgDw3A1YEGb2QLI9Sh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=mbnB7384; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=RiMekfWy; arc=none smtp.client-ip=202.12.124.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="mbnB7384";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="RiMekfWy"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 4504C7A01C7;
	Tue, 15 Sep 2026 13:58:17 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 15 Sep 2026 13:58:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm2; t=1789495097; x=1789581497; bh=OUiQZcRoMI21kXo3AXyBr
	L7jsL3eHndqwCd9dDhiTFY=; b=mbnB7384jikanuBTevI9HYqnTt4FGNauOw6NK
	FLwPiEZhOlxQHM1CaUaAWMiqESvte9qvaZCGj5xnKTjQPoSB+JdGvDUOGy6U/j49
	RWGm8s2c/kAz5Htv44Zwk2vr5fQFkdDqjv+o0WyHnHcsh1mDGzz0g61gECUdk4hL
	XWsCS5AoJdKCc8aE8tUpCbyT5gYzeijvV/lx473OO9ESO5QaCjRNh2Gix6fPzy+B
	F+6a5MjE4dS5/aM2gNkLZrCS9GFSkATBCQEFMHiHgfMwrioxBbTSn4zVeJfdpOTi
	xJwPis3UKcnyypOdR+csdEywQAhGl1kX8yu+3LWu1AbMlArbg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789495097; x=1789581497; bh=OUiQZcRoMI21kXo3AXyBrL7jsL3eHndqwCd
	9dDhiTFY=; b=RiMekfWy5cm7nO6x/ONtoBtrraVOza4UVhGwmsXHIvsrMVD0fJ/
	C7UTT2kLO/7r+MqVUrUfwwFxNDnn2H8LGZfRplj4Vm1L+W9Mt/A3mYQrQWIB32EM
	KnvPsgK2Ei6lDcACDvkSY4GlwIMmcJKN1jdAfP+eMggCqM/C8R1uZjNLzxRugOo/
	4Tx64eG+WcZYSbIvUobMrOOgQAxxIOVDdz0dZBic6InIutadsMLBwFw2Vpn1sRsc
	NPiB13Wwp8kYv178CRzJ+AwJpRCAtCfMbCY8l9pGsmBQyXnxBSknibb+dKIdNlS4
	F17ezOMXFDFnA0Cr79PgGIo4KV8MgfPmvAg==
X-ME-Sender: <xms:OIepai_gyGsvPSykK_L6UvRrdf_HqyC-pl28Uyc9cZvN6tXEWQtXtA>
    <xme:OIepaotN2aOrjNQRZ18dr-PRiCQWcqImTokxk4DveWxYxkSeXX7IYUTsGSt3ELGot
    IHVhhkmiFECfJGhtmAXGb0HMhYZEHtWjy5ox27n5TP_flH4o_iSgEc>
X-ME-Received: <xmr:OIepalrcnTn6zFDZj-lNh73jD7FcOpqdm8UIK9ZO8eobXGYXIv4me-U>
X-ME-Proxy-Cause: dmFkZTGKP0t2jhn//YTdOLUHfx5QGT0V5X4Ky3wJCHB3HguDSZ1KrLrwx/T6lfmPmsO0UF
    cnPiHiP+2gqG+XNHOj07XGJe2zTOspHSM606VGyuR6FCiaCJxTbtOQqcY8jP4DB8d2Xk0U
    syuqht1nBVOdLxXIX+gQwXbWk1tEj4fsuhY/GkuBiEyZcGXpOn9OYz5uIGdWNwzVuv6Xb8
    EkHttxO8UMsIg+W/Nv4KeZM9O4mKMWqRPsalL2mjKL2yMTeFwiu6THSVCbYsDVy0BnZBIc
    suPb0M0I07UAdYXCTHCuSyZ5MRc/pG5Xst4g5+n206HwtYojl8wf8oV+LVKUWO3P8tAMSg
    R2LjHOKA2KXflwyMPRoxf3tzqfW1tPN4FdguMGwV0qQhYu9jFc930WR5t5FWHvbbbZpc25
    ONc1jr952WiYM+OnF0zT7ILmN/QaeXu/a9GosHQi9+yM7Vzy9f4WpAcmEmc6fJ/om24Rgh
    7lcMLG83BPf2rJJflkUSloIJCX/c9uWRfxdsWZwZuUe6Gnw9A2jiawvWml+dKe46KSaH36
    dsxNtKEbiFfszaXgvNRFxznEWahx2gt57DkmaYpx+sYakIu5HpqPoYq/rplmkdmIX6rJof
    c5FibpRs9p+hPHb7PBLLZ5Xl2YhMutrn23MaZEukoS2Zk3xy+khto0o3NI+Q
X-ME-Proxy: <xmx:OIepaln3AbMeztumSQSdiKR0v2gBicq6oqsgq-GQ2WxEGLmMmpUdBw>
    <xmx:OIepapzE4hkjBVh6D038-2C3-QH_5hv6yIQhltrMg-G9CHFLECr82Q>
    <xmx:OIepatnJmecCJLB8Cp0GYhesCO_FKkQ543OXJYP31HJU7TTUXzy0tg>
    <xmx:OIepaieadOWu-NQR27UQSqfyV6wLXLyE4fTY1PtlIp9ndV2z70rsSw>
    <xmx:OYepao8y3Fs2eIPGHCP41JLR-iVL8WqAR4YlCJpunmEsVIlLNH_vGHyT>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Sep 2026 13:58:16 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v3 0/3] reduce reflink src inode lock contention
Date: Tue, 15 Sep 2026 10:58:30 -0700
Message-ID: <cover.1789494885.git.boris@bur.io>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We currently take the src and dst inode i_rwsem exclusive for the
entirety of a reflink which includes writing back all of both files and
walking all the src extents and duplicating them to dst. This results in
contention on those locks which I think can be reduced.

The basic strategy is:
1. try to do obvious easy src writeback outside the lock.
2. downgrade the src lock to shared where it is safe.

Changelog:
v3:
- use btrfs_wait_ordered_range() instead of the misguided custom walk.
- add a helper to unify range computations.
v2:
- introduce unlocked wb pre-flush instead of a downgrade of src inode lock
  for the whole reflink.
- add the "has writers" pessimization.
- still downgrade after done with wb.

Boris Burkov (3):
  btrfs: pre-flush reflink source before taking inode locks
  btrfs: skip unlocked reflink source flush if the inode has writers
  btrfs: downgrade the reflink source inode lock for tree walking

 fs/btrfs/btrfs_inode.h |  6 +++++
 fs/btrfs/direct-io.c   |  7 ++++++
 fs/btrfs/reflink.c     | 51 +++++++++++++++++++++++++++++++++++++-----
 3 files changed, 58 insertions(+), 6 deletions(-)

-- 
2.55.0

