Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9688549620
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2026 00:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790641707; cv=none; b=vDV2DUiacVLg6KmU7RGSubn1NpJ48cRt74HGxpT9O5Ab3gdbDbwoA07B41VTsqiQj3y5Ept9QubfeHKVcDvxrZ8hye2W/vsD65N+ZbJYKspzvAGPxctImLJEH9/SclhwXwOyCILrtVx30GufcKdZrN7kOu2sfC2Wz69xizmdqVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790641707; c=relaxed/simple;
	bh=Ly664MnXtjOYs6lZD5CGZdKvcP3GA+qRUpso5gHSphs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aFnKRSGEZDmxq8EHqFG/M2D6QKvorbNDIpMqlrFkQlBEm7RFyUhGRSRDNnZO0eCuHM/pBBSn4VT4sozeRLjwdUkxv1VkqPV2fS0rpXWMf7OiiNt7qQ74BybQExjFDr7zo902Rk/8qO6LCOl9x4R6OlB7oLJeuKMKHcqGO0HfnXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=mIg0rkal; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=hpdaP8gx; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="mIg0rkal";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="hpdaP8gx"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id 8E535EC0174;
	Mon, 28 Sep 2026 20:28:25 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Mon, 28 Sep 2026 20:28:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1790641705; x=
	1790728105; bh=oHi5+htec0R5C7gMxRVS3JTqUJ6UXChqF+h3OAEBsK4=; b=m
	Ig0rkalYtNfd8uoRpItyEk5it3tFBv/6s2gd4udsMLPthsuyH2Nq3ekcvlSEGEz5
	v/U/+hGIUFQxBAndQjW3PZtS8RhQppTJp1cVbESf9Bx78kp0ekQucsQh9Of62YhO
	6Rw1Bn/jokkQr+IukzbOhcrtLAByEzLfbprmWWO1if8yQv8l73bzIKisAT5LLC2P
	p/rs6jSaLnZ8dKuBeYqtL1uPfftsftX3S1DkVyT9zm2WaJvjD02GCF/mkmC1yj4c
	WTqjE6aTJ9FeIf3TMsp89xObYIYA7EvHAngqwt2xcmM24ez4NJYzTCl3rruzHQH0
	5eKb2tXeDM1d3F3/t+Clw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1790641705; x=1790728105; bh=oHi5+htec0R5C7gMxRVS3JTqUJ6U
	XChqF+h3OAEBsK4=; b=hpdaP8gxdrYG/U5kOlAcWbAaEfDRz8S1ja5lknTYqdbu
	XNbttbV8scqAZDnmykK0SgEuPGiiBkWllTrrAyfg2aMusX+sVUvI5wuC3HuPVGxY
	+36QN90PEP1u2A3xePtCV1jCCla6rgOBLuPesklY4NMpBKJW8VMV8MeSgHl6CCyF
	Ua19NzpdSqku5/QjrNbflbvWp9FWCs+t2nfjEzP1WBFXp5aPyiVpAIbSnBC76Lwk
	HUOdYM9D2RYRLlotQ38e5jOCenCr0WmzHXqBZPWeD9qA6umrdY4x0K4vspz56Pkb
	BFpYJBzR9Rc1i/qQKMH/Vmevy7tq+LdnVpmHAZaa4Q==
X-ME-Sender: <xms:KQa7aq3TXkqHv6qiHcKJ03Fv1zPsiM19dbZAeye39EER-Rd0IZ0-cA>
    <xme:KQa7ajEund5lWSfrl6Jn90ptAO416UGOA4dNh7aopo2H3lKTpIA5B9FEyjLOEP3la
    raZecewa6ySSgQeKCj3btMn_qUiTKc0Z19uwG6U2miMiIOzV0ZlxuyD>
X-ME-Received: <xmr:KQa7agin4UcOu9k7CnEpnTZ88LUb6ISSFJA4MoeyD8kSeLC2RQ9HDsU>
X-ME-Proxy-Cause: dmFkZTExuF93JGdXfiGgW7nhIqu51hI8C5kNPxAejyYwywaiQdYYJWeJi45RH2Q3gCPa55
    VjA+ay/YFd/3pyl8KBeEfpt9QEJvrAosJUDjL4V6R+2haUET5XnHu73J4Q5b45C4HB/iIz
    RNT2T1+2L2LIxqlgyrrQlkjjODfNAxhX0/mc/NasjTh10Z3dHNiS/LO8GoXPoTpyRa+/jQ
    eSwiMTT1t6iRITMpyX7CIBaOxBehrbpLtNmxtIblZXMQrQUB1/pzyoZXtqtaUj7R82UdMI
    6d9FjH8VfZhN/8J8o+38loyKAtAaePXcnHUstIw4xJhFl+boltZk+r8HvaJoa84gUlwKn9
    F4Q0eAS3loE7suAUnOG91ZbvHTOOxutBuXmrQHj0Gh1dqjDvt9c8de88bfZU83z3UsJOOW
    yUq5SnuKQ4SreBxoHUZ4ythvWeNSaE3cvYO+a+0bjwv5DPPp+b+HyJSXOYHcgz3RIahnG5
    sXNLlYu+Ukv+BpE9N8JKinLZFpM5ZNAIlNA7CNB4ePFgF6r55OI9pG0pGOVaZiYWqZxTla
    d9/RIKGiQqbB6jckw+Odei1OEeSNZeEpX6jIpnkBDx8/KEUh87tsP1I3pkNR7Fn0w9N8Dq
    P/EU1nvwoOHfdi7Z4C8M4bK+YManIHU3xKrWK2lgt4ex+JW7fmmeC+1s8CrQ
X-ME-Proxy: <xmx:KQa7am-XX2r0tU7Cs14ddP20D7qMWRwMQNjDqlN6ZpsLWRSQaPOcwg>
    <xmx:KQa7avqx2_JJyMwiGZMw8PVrB1ijTK4pRLc91VYq204vLobAYZ8sig>
    <xmx:KQa7at9OgUUrFwbASDh6q7VtxskeNpo9ZYkG_GjZPfmr4a2mYBR_2A>
    <xmx:KQa7arWhE7hh7ZcyrGPjEUF7qU6SUNMaV7aQD6cyq4rDNTEkZ27QkA>
    <xmx:KQa7ao1YJ5uGEtrOegIcVM3Wss74jRoxGL-N4TcB5pV1LlurMzwgZNAN>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 20:28:25 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH 6/6] btrfs: find_free_extent checks size class unlocked
Date: Mon, 28 Sep 2026 17:28:07 -0700
Message-ID: <9ebabdc4d62fc8824c675396ca7436bb333ee9c6.1790641462.git.boris@bur.io>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1790641462.git.boris@bur.io>
References: <cover.1790641462.git.boris@bur.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Similar to the free space check, it doesn't hurt to skip a block group
for having the wrong size class even if it maybe was just about to
get reset to no size class. Furthermore, setting the size class already
admits that races are possible and that there is no guarantee of
perfection of matching size classes, just that we only set it once per
bg per reset.

This can also help quickly iterate past thousands of wrong size class
bgs in a large fs without taking bg locks on each pass.

Measured on a 30T single-device filesystem on a tmpfs-backed loop device:
  20k sequential 1G fallocates:                            6.7s -> 7.0s
  sync of 20k new 64K files after 20k full 1G bgs:         3.7s -> 3.8s
  sync of 20k new 64K files after 20k 1000M fallocates:   13.2s -> 4.8s

Assisted-by: LLM
Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/extent-tree.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d96de10348c1..10beb78a5ba3 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4338,6 +4338,9 @@ static bool find_free_extent_skip_block_group(struct btrfs_block_group *block_gr
 			ffe_ctl->total_free_space = max(ffe_ctl->total_free_space,
 							free_space);
 			skip = true;
+		} else if (!find_free_extent_check_size_class(ffe_ctl, block_group)) {
+			ffe_ctl->size_class_skipped = true;
+			skip = true;
 		}
 	}
 	if (!skip)
-- 
2.55.0

