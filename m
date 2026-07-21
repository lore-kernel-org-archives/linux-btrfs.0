Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822403E121A
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Jul 2026 22:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673767; cv=none; b=qvRt5LSQKSQ7P3pRpGz/HiEjb1QyM0QjozZwzXglRjmiVknbt2r5OThIjZt0TeD5Rg4mD9YWJAhRz5JuCF6eqtqKC7CB/LCo3mW9bdfuGtHkiPWh0tQOd7bSHE4XX4RLfc2uVFXq03lh+xEVGVy0Hjc/KRi+O9k7FVxns5w/zTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673767; c=relaxed/simple;
	bh=lrhMGqu2WYrgXAd7fmgYQX9zzbpdDx8sHCsMiWKQZeI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=LPAEjHYMItwLaLKklP0idBCXQgixBcBLD0TGRYM7Wy08xp1FUqxy1FrftEPHmUBPJ3S6MiTozzOdTltT0srpB+l8XTnq+ijE4XEB+VDcrxvVeVbY3e0HIZLXy95RWdFbUOhioGa/iS6LpRD5zOzft48QfLDiPHsBFSaQTKj3TKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=rIq54xFJ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=eg7Q4dMu; arc=none smtp.client-ip=202.12.124.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="rIq54xFJ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="eg7Q4dMu"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 6E9037A00B2;
	Tue, 21 Jul 2026 18:42:44 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 21 Jul 2026 18:42:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1784673764; x=1784760164; bh=lJk2BX+4k6jgaeXREk/r3
	i8BdaY1pTD1AMZVYLkqlzk=; b=rIq54xFJe3RGhzwbhIWSO9HHUBg44jdbNh0QC
	mKMDBa4lqupY7ut/UGIb954DRyc+3Sn7hqBhIp5Xe3DaqLMOO9IWr40x5dn5la9z
	yn+OQmKpS1rZTkb17PyjXc8POA5C/6FgeU5GILc5brbGUlLtZt+Y7QYjJ4Srfzi4
	tZHF/DhrTCO14A9KpTbDmMLlXaG7hhw5BBr5WnVGI2I4R+Mmh+tOU2Dr5hhtHjvS
	cTLRGXtAarnJ6w47XAhZ8NMJwz+Ng31fbsHyeJ37fQLkB0/DUgM19J54vQrJJMkZ
	XTfDXFZCvbNuaBYAD/yqQmaAa1uucw5E0s9XBN8ZGTxiunNlw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1784673764; x=1784760164; bh=lJk2BX+4k6jgaeXREk/r3i8BdaY1pTD1AMZ
	VYLkqlzk=; b=eg7Q4dMuMjHcyY/5aND9DDb85AkEmEKQohr3RnDbG9uKgA02T8G
	F0ftCOW0GNLrftxKVtiEkf64TawRqnT9sd7RB6rnfl4ucScE8wiCb4ufCPjD4or3
	cH7ARlcknqz+gvrMpD9haXtr6Mb/3e75G2l3GHCS2SCnICXIbPDHpmchVHzc2LWy
	M6+Ptz9OnyyneC8ofS7oLLwyI1Zw2bilxOZLJezHYk4Rh0Y6XEQq2eSq61pJ5J5d
	99Mr5nJnEoOykN35pc6XBe1Pyk6TGsHu/NptexMHZ/aQZmDEh4ePU1uAIAUQEIVG
	a91HBpsUTbmWl8VGguW/3D59Ji6w2mZCU2A==
X-ME-Sender: <xms:5PVfavKJrG5tYl0GR9m5oeBssg3b9SKClO7l7aPu4FvU3xdxFbr1Lg>
    <xme:5PVfapLHEQN_WmRSboVXDeHy5JsQXYlUrlVxunGbQ-unBSpznhHklGunq0bIlKUnj
    jVPEfbgqwt86id4ulYSmfgcljrxBzQPw887l2faKPVJm6dUPi_CBxQ>
X-ME-Received: <xmr:5PVfalUbwBLapugj-7x-MEZIycVL6-eGJxJkFb3euyCHB7fs5ezVY97BIuPD-OMkYslMytLDnQ4Up9em2F1VL8OC9X4>
X-ME-Proxy-Cause: dmFkZTF15Tt0CswFJoIIG7CAqaT4GjnPeEdHQPEqtKOWDt89ErXRJMvyqiHkCP2C+aZJDN
    vcO07MrFNtRhcgl3ZWnZ41ydLeREos4j5iNGPslHOYlt73HhQnYaWHSC0gu2UStYox3oTf
    EUW6WYjNBdcrZN17UHfMw6jZWcFyZOhVdn8tZ16qUvLWTkIkglfnAcpGQFIB4WOTWx1Ks/
    bcy9FSBYLXMExK3p8D4pvxbIey3qd51z2asJ7+paDgrcyUwrrjpLqo6G7dYcCGjN4tI6fP
    OrfBq7XLkyHks0mFkC29hz/chNWIPET3LYibk8S6GjfGPaw92eXozN2C4vsHVXkw0cIGZa
    mDZTqSgCx1y/6AXGAQmftCLQQLx2LJSQI+ZX0UjWvsosUnYbsXx1cmeY19JVvWMQY/I0PO
    ipmaAoULoXE0Ln5aMxpxr/DaE+qh5uuo/rv9EVNWRbrkrnz/BVcZ1QFmibt9+PLb6Ek5tF
    F6JA1CRfptF8x0z9gRl8IzB1iUbXc2yIta3Puf40UJQ9PyGMMHH9r6znzpC+VhA/9VgiQS
    xSUrV7X2E84DV74qiIF7SG7FIJT7MgF1qUSxs6N0ftGgGyg8ryJa5p7X2QizwIl2/MRigV
    O6lV8qpEjGvBpmbekm9QF2HIHKJgNxEN1T4A/gni1jG7U4q590TLl7a8E+YQ
X-ME-Proxy: <xmx:5PVfajhKkKSo_P6PKYS3g2supd2r3RKOJh-mtxmvVwAkUP-J-5szLQ>
    <xmx:5PVfao9nhJlJ9m_guj_Ike1Z9qvXn1Cyq2T4_NBjDOhMibgiqHYD2Q>
    <xmx:5PVfalB91mnOfF1ZiOw0M7ZDXtATBFDb5SC0cJPZH68KkIPwpV2rYg>
    <xmx:5PVfatLtPYZ92Ut2_jKqOqu1tNM-p-CsEE3yy3xMTIwdEzVYt-NkGw>
    <xmx:5PVfalujSIosIOUAIq-scEsmNMLb61NkRyptAeIA4YGlprX1hWlpMIzQ>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 21 Jul 2026 18:42:43 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v2 0/4] allocate extent_buffer GFP_NOFAIL with unlocked retry
Date: Tue, 21 Jul 2026 15:42:11 -0700
Message-ID: <cover.1784673567.git.boris@bur.io>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From sampled fleet data measuring lock holders that go into direct
reclaim with a waiter present when they eventually unlock, we have
observed ~15% of those are btrfs extent_buffer allocations in
btrfs_search_slot() done while holding btree locks. This is the single
largest category. Additionally, a large source of hung_task timeouts is
both btree waiters and direct reclaiming btree allocations, which
further motivates the desire to drive down this source of stalls and
contention.

The aim of this series is to allow us to allocate the extent_buffer,
btrfs_folio_state, and the extent_buffer folios with GFP_NOWAIT then
fallback with EAGAIN to outside the critical section to retry with
GFP_NOFS | GFP_NOFAIL without any locks held.

This is analogous to how we must drop locks to read an extent_buffer and
then EAGAIN.

The series does not manage to completely eliminate allocations from this
lock holding path, as we also allocate inside xarray functions for the
extent_buffer xarray and the btree_inode mapping xarray, the latter of
which is done via filemap_add_folio() with no reserve type API. Luckily,
those particular allocations are small cached slab allocations and have
nearly no contribution to the production reclaim fueled contention.

Changelog:
v2: 
- rebase
- dropped the inhibit array allocation patch


Boris Burkov (4):
  btrfs: factor init_extent_buffer from __alloc_extent_buffer
  btrfs: add struct btrfs_eb_prealloc
  btrfs: enable unlocked NOFAIL retry for eb allocations
  btrfs: use GFP_NOWAIT for tree block readahead

 fs/btrfs/ctree.c       |  36 ++++++-
 fs/btrfs/disk-io.c     |   6 +-
 fs/btrfs/disk-io.h     |   2 +
 fs/btrfs/extent-tree.c |   6 +-
 fs/btrfs/extent_io.c   | 213 ++++++++++++++++++++++++++++-------------
 fs/btrfs/extent_io.h   |  23 +++++
 fs/btrfs/subpage.c     |   7 +-
 fs/btrfs/subpage.h     |   3 +-
 fs/btrfs/tree-log.c    |   3 +-
 9 files changed, 220 insertions(+), 79 deletions(-)

-- 
2.55.0

