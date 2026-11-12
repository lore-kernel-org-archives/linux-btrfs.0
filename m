Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794514006;
	b=HUq1/qgXGshi5e+wTmG2Xu98lxCB0UiW8oJLwecWhQc+9NVbSNtzSBScQSowFh5WIofG
	 EIM0gC24rSuavE0kNFrBBTjRO+oinzkfIwNBfo4e2kmW3B9VCv9ug1/fAMMX+9BJhhu5h
	 89DrUNk6bWiW2CLIC5DVSaH4rRiBU+BKrUgbWogPkSBKZBTwIn3uiHXEucdchDaYoEJCO
	 qOtzgzaVpUA9HvdfLezTI07kk0gy1HdvB0XoTBO9tIQ+zpdArA/pw+oA7aNOluWKRitqR
	 kdzAyCZTqqLaCidraqvXx+7cXn3cST4vZr71thiWkk7WBrrfqvYf146qo4dVXjkCEtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794514006;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AwMqk+wVYfD8ZAh2ZN275j8BDp8LNbUEXkEo7EjsqUc=;
	b=MU6JQ8QN4dHqEwLTUOicA2koiWEVps2guTLuy2ogOb3wuLDldTyBwB4BcLxi4quBewHb
	 DL1H/tMq1Nh3z5iljtMKP+Xhlgb/pMtjC2dkVKYQUfYCPPtT68P8BA+VYOfMS8BH7wWd9
	 Chz2ldf/JibP1+Ufh9GqA6KxQxBkkk0XGRDxQ+hCZXQgqlDYdZzFowttVep26/xxcneDe
	 fPl0oE9bj2owPsUwGMGzQZRQFS2lHZGHzHZ/Z9zN8PkMbJchHbkepMAu72WkwCISMY5QN
	 2ND0G1wYJbG88nx3gBwvAOmbeK+PTHu8zW8JKTcNcxnV2BEJZTdrJbF18rsIVFP4X4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CT50Bzsg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56488606A31C
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 20:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CT50Bzsg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D7C1F000C4
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 20:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794514006;
	bh=AwMqk+wVYfD8ZAh2ZN275j8BDp8LNbUEXkEo7EjsqUc=;
	h=From:To:Subject:Date;
	b=CT50BzsgatzoCOmUeMDKJ9xPsQY0HAVyHS186QEJRyLxEhib+AGWG7U7X2rAGs+BY
	 1isFlABgQnOOJg3k9Dwq0IuVZwh/h9If0cBRezvsazq6QoC82KG4kd2nurK9i6WoxJ
	 zb1Or0nijk4+/mspvCCY1SmGxSsoBNTfFEZjgdy2BaNLGXldDOr95Sw1WOATDuFvOU
	 gphr9yORMPXsXOgWSet8Ghsi4eJtzcM2Qjig2EEvH5JpFfA8JGHXfAnWKyHxvafTlV
	 U92JP8pdO1Z1/yQ7ODSj66/AAaBg60UJobt+Hi8s2Cifg+OqGAENjvmBOaPzjyr9Jz
	 vxbAzlFpby4bg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix off-by-one max tree level bound when replaying log trees
Date: Thu, 12 Nov 2026 20:06:42 +0000
Message-ID: <b8a17190faf5846c5d843cef9c0887a050eaf98f.1794513725.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
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

From: Filipe Manana <fdmanana@suse.com>

In walk_up_log_tree() we are bounding the loop iteration to 7 levels
instead of 8. This is a bug since the maximum number of levels for a
tree is 8 and they go from 0 (leaf level) to 7, so the loop condition
should be:

   i < BTRFS_MAX_LEVEL (which 8)

and not

   i < BTRFS_MAX_LEVEL - 1 (7)

This means that in case if we ever get a log tree with 8 levels, which
theoretically should be impossible specially because they are very
short lived, we would miss replaying large parts of the log tree.

Link: https://sashiko.dev/#/bug/linux-8d5b7229-3920-47fa-ad36-3a7ddd02f0e7
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 85ef3c26e0e4..399414ae67c8 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3067,7 +3067,7 @@ static noinline int walk_up_log_tree(struct btrfs_path *path, int *level,
 	int slot;
 	int ret;
 
-	for (i = *level; i < BTRFS_MAX_LEVEL - 1 && path->nodes[i]; i++) {
+	for (i = *level; i < BTRFS_MAX_LEVEL && path->nodes[i]; i++) {
 		slot = path->slots[i];
 		if (slot + 1 < btrfs_header_nritems(path->nodes[i])) {
 			path->slots[i]++;
-- 
2.53.0

