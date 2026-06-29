Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028804071DE;
	Mon, 29 Jun 2026 13:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782738620; cv=none; b=LTLG5/jUhjVjG96hqV/rObb/15Exp1YBWEv2aOPDoFIduX5ec4FcLN2bicpXPeaA1A/pbK82dZ6IkfAZWn3L3XsWMeeB0rSgSTBaaLSNn657GJ+IOw6aSUSFTrzGzeNvaVJs7NfeHoTonnpOhO8Piv1Vkxe6jR54WYKy6iP++C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782738620; c=relaxed/simple;
	bh=eCmODVVhx/s6OyTHtx6Usjc3WwRYAA1pV026SwpvVoY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Y3IDh8qK2ban74Y7y2HrFoLDbJn1CLDbmhg4F4u+PTLik//O4SBY4WdTK5qgKxIzOSFUZI/uCBfwJmCL0LwaTrgt9c2migpQf2aGCAVGCbX/dlQMj5kwwSUKW9bJnZ7phxGzpn4tvpIkOy9JUEK9qNQTdPkx/ixCXSTO1B/N2N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WshzvsMa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WshzvsMa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F190E1F000E9;
	Mon, 29 Jun 2026 13:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782738618;
	bh=T4kuEeGHnDUKEY4hD3IHrS67fMnaGT8woej4N+L2wU8=;
	h=From:Date:Subject:To:Cc;
	b=WshzvsMapEBWfjRhA2gNFCWjjnxJ0bAVduyWKnJfEd3HLrieom5BVei+t9eSOJrGE
	 7TdPi7FSzU8dEH86MVeNGSjlosTwj/SpcaGp0FcS4ZmgMlUhMxYhkCVZZaVanmLITL
	 lOk2IE6ttckgz+qcHHwdFj0am+wEFvdCS0gLPG5POcrJHJOACy9HWB9txnSGWuyAcM
	 iZgn9ifae729edUCpRLsfZ5Ko8O3icXGNvSpO63Kw02tLORl45cjJL6ijtOw58TOiZ
	 mK1rxQJO+atqZbo9M/PAjfWf6Q2Ij5YvYaFEB67Cio22wGSDWidWL5rGmJSOD/zQQi
	 q+JPADfDnHTSA==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 29 Jun 2026 09:10:09 -0400
Subject: [PATCH] btrfs: don't let shrinker touch extent_maps that are being
 logged
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260629-btrfs-skip-logging-v1-1-4e3a28c1acaf@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MTQqAIBBA4avErBtQC6WuEi36GW0oLJyIILp70
 vJbvPeAUGISaIsHEl0svMcMXRYwLUMMhDxng1HGKmsaHM/kBWXlA7c9BI4BK6q0U3pubO0gh0c
 iz/c/7fr3/QDyQaGFZAAAAA==
X-Change-ID: 20260629-btrfs-skip-logging-3e31701d9647
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
 Filipe Manana <fdmanana@suse.com>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2337; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=eCmODVVhx/s6OyTHtx6Usjc3WwRYAA1pV026SwpvVoY=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBqQm61vk7SKOPQZlqbhPGKriB9W6L+D46N629Nx
 Ex2pOpKpLiJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCakJutQAKCRAADmhBGVaC
 FQahD/sEon/km5N5jiAYqyXOOlpwqSyIsHSXMu5AgW0Vtu1nGL37bsnJViNJVcWay4Jo7nzczlK
 dTOd3wDs15Htl+V4lwXy2vKIRtxFOV+WkqJ63xPHBrlqMxSCIhD01SBMSkIklduhu1dg6C9VltY
 9SDcV4QwkP46oIEcUB8oYDG9sSlcMm6ScdUVp5odzuwFTgZctfjoXbi6Ft4wQBnBVGFsjwad8He
 WAlsJ+moktzyfURMxsOPcqBiswr5XWwdr7QQ0YjX9jjoZuS69RczRxg1m5vR3qBfJ1GYVtTRVFk
 ARrfmpsi0RwoRpJ37WOXA8aOqMvWW7ix6YXO/Wd/Q7b2961uaB0T3YtBAmN1HdxEfl/V4/svFBP
 kmyrnxF17MFXMpsHCV82zmONI/R1kya1HE3ipfcSXX6g6WgEk7Kd09P5XmsVKABP7CllLfq7sgl
 waqRqdYMa0JRFQG2GchQf6EUGVCUTv6HtVgY5g8RUxAhWfWwjfoUC6FhddaEI89ycycm1qlsl0Z
 VAeAJVyp2c78Bqzi69OoIDkH0zs4vTAfDV5mJ5lKQqZZVYfCcX3F4SZ4OzLQ6GF1Q1GIRt1p2+D
 rdpVLKoN0m0Uug7SILFSPU0qbWPVS9dlzadpYKIkvAOklrJY+37tKdVaxVXKpuM4ic99W3ZBZKg
 //Why+GKWm88dAg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

The extent map shrinker can free an extent map that is still owned by an
in-flight fsync and still linked on the inode's modified_extents list,
corrupting that list and eventually causing an RCU stall.

btrfs_scan_inode() currently skips EXTENT_FLAG_PINNED maps, then calls
btrfs_remove_extent_mapping() followed by btrfs_free_extent_map():

	if (em->flags & EXTENT_FLAG_PINNED)
		goto next;
	...
	btrfs_remove_extent_mapping(inode, em);
	btrfs_free_extent_map(em);

But btrfs_remove_extent_mapping() deliberately does NOT unlink a map that
has EXTENT_FLAG_LOGGING set:

	if (!(em->flags & EXTENT_FLAG_LOGGING))
		list_del_init(&em->list);
	remove_em(inode, em);

This sets up a UAF situation where a later fsync() can trip over the
now-freed extent_map still on the modified_extents() list.

Fix it by having the shrinker skip maps that are being logged, the same
way it skips pinned maps. Such a map is owned by the in-flight fsync and
will become reclaimable again once logging clears the flag.

Fixes: 956a17d9d050 ("btrfs: add a shrinker for extent maps")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
We've started hitting a number of these problems in our fleet. It
seems to mostly happen on ARM64 architecture, but there have been some
WARN_ONs that popped on x86_64 too.
---
 fs/btrfs/extent_map.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index fce9c5cc0122..128f7800e101 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -1166,7 +1166,13 @@ static long btrfs_scan_inode(struct btrfs_inode *inode, struct btrfs_em_shrink_c
 		em = rb_entry(node, struct extent_map, rb_node);
 		ctx->scanned++;
 
-		if (em->flags & EXTENT_FLAG_PINNED)
+		/*
+		 * Skip extent maps that are pinned or are being logged. The
+		 * i_mmap_lock should prevent this from seeing LOGGING on extent_maps
+		 * directly associated with inode, but em may be associated with
+		 * other, dependent inodes and their locks are not held.
+		 */
+		if (em->flags & (EXTENT_FLAG_PINNED | EXTENT_FLAG_LOGGING))
 			goto next;
 
 		/*

---
base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
change-id: 20260629-btrfs-skip-logging-3e31701d9647

Best regards,
-- 
Jeff Layton <jlayton@kernel.org>

