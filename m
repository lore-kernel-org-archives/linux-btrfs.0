Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF2736D9FE;
	Tue, 11 Aug 2026 18:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786472117; cv=none; b=AA/+llYLL7Xx7BdTZ3DDx4YVffU1L3pTAA+3sTS1B5uRm8mIS/tz0ZE8bM2jFYz769mx4xy5CRSFNoP6muPQF6DRPdKFfC2nOesba1kSEIPBrslJbodr9AwopGth8Yjpqgvx/CCgHaoT/VpcVKUuSQmvB/Ug63AB0WUyd1iVOso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786472117; c=relaxed/simple;
	bh=i8QCxSVOV0LcFs+6/Mjy+uu1WcgS6N7H0r4iR2hOgvk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=h4/htJN4Ah6oq/heXnmnw54bs4XwiurozXHFpTAEw2N7G4I4D9rnEeUlJL+3VamJBq9axj+OuC9+JI7bf3sc71TBD1NGnL83LNHby+yt8xIsLStKOFyxXMWzGUdY3zvmTDxN8s7R1OcHfm2oKjJ+iRlE4UTAui8SSlYXyxWnzts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FGhjd9yi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FGhjd9yi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9F31F00A3D;
	Tue, 11 Aug 2026 18:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786472112;
	bh=0KxVljklGd97b9rZMT8e3dxgS3KH3MdjoX7XMkwh6Ws=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FGhjd9yipJAsE8MOIVP3Fr/Y/r3xaRD18wkeAJTOKzMtDVwiyvPpihEyfjitJ9iQc
	 IjpYNcEpF/9eqxO/lRmsaUgQtDDeeTq3B7p0LkUXX0zLgXhJtF46zyK8oaAZXFxNrX
	 tPusbteXZk6RL2/G0zkpMtruVwmaCKtUv9Zq5HGxO4lB9XhL11kZMR82Q1Rm16PmJ5
	 5kB+JCOXE4dGED+X6/Wf1rSg2Oo+oFCUQP35p5IH/AOqoCZZPm4SBhgUhaaaCVncC1
	 8UpCg7+kttVy4Hrgdm50aQ+fKyPf68MEp6f5kO3vKGVkQwDY7LkwOqfdSGF8icIYw7
	 etdXG/6N+mInA==
From: Jeff Layton <jlayton@kernel.org>
Date: Tue, 11 Aug 2026 14:14:58 -0400
Subject: [PATCH v3 5/6] btrfs: handle ENOMEM from btrfs_insert_dir_item()
 without aborting
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260811-btrfs-enomem-v3-5-46a993fc3fe5@kernel.org>
References: <20260811-btrfs-enomem-v3-0-46a993fc3fe5@kernel.org>
In-Reply-To: <20260811-btrfs-enomem-v3-0-46a993fc3fe5@kernel.org>
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kernel-team@fb.com, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2667; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=i8QCxSVOV0LcFs+6/Mjy+uu1WcgS6N7H0r4iR2hOgvk=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBqe2arMWMeCVirASuceWVZYx/Ga8+ycl7V71gix
 cqbv9EQlOyJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCantmqwAKCRAADmhBGVaC
 FSsAD/9EMnv2Pf2XjvvyBgU8P6Kmd6x/0sOKXWolE6REbF6AmlOc8FS3xbpUn0uIOXh8KqBnr4S
 zzBl6/ZcuFWV0tyJhqCl88F6AfRvOC2fCr0Yl+P+RvbhjXdREXwmNtPYg12EFEOIpnzaG4MFE8x
 EwgdRRJEEpg0BW3ZN65Y6BrUpqDesqcj3yyk+q72m6lTgDHOKpEONcMufQ6A+nWKpyS7FRWbmCM
 4Jqlnk3wVo4s4eG2WhFi2sFBoxHdCnmdHwJvG+v5olVTTtm5c0f5qRaGwe3sQs/Hw016BpD3Kpa
 WmW94LaUVnQL8Fj+hm/sgAGk1WYCvQe90pgA9ILGpTV2AgRo/evH5b0XI/Weak22jLt9KbHCeiZ
 axqb1+MMmD+ZwrRI+dDaZ7yUxrkQ9BJNSLDE/k/DKHMCnsP5ILfT7qXL4B9vB3EwhHO5MTICW2E
 ss+kOo8MHyRNSmC0LK/RAMCMU/YSpZVS7fQzwWhv/2Bj6CJrDmJLnxdgQCPjNvulNUkjDhtmgQi
 J6slD32+ZSdjDwBNNDYNO1TyiGZ80fe3bIlgkw6bpfZX+Q6Ci7OGSJG+/e4LB3sBvuT5oxKOSVH
 Lp8HogG2LznHxcieDalC9VqkZ2DVAVGpR4SmXxhKkQWgVDa2bBU5ImEVTRH5+OJVykb6GH3RXN2
 abtzhAcxNvJn1KA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

Now that btrfs_insert_dir_item() returns -ENOMEM before modifying the
btree (thanks to delayed dir index pre-allocation), callers can handle
ENOMEM gracefully instead of aborting the transaction.

- btrfs_add_link(): add -ENOMEM to the recoverable errors alongside
  -EEXIST and -EOVERFLOW.
- btrfs_create_new_inode(): on -ENOMEM from btrfs_add_link(), orphan the
  newly-created inode instead of aborting. The inode item was already
  written with nlink 1, and discard_new_inode() marks it bad so eviction
  won't delete it. So clear_nlink() alone is not enough: persist nlink 0
  via btrfs_update_inode(), otherwise orphan cleanup would see nlink > 0,
  drop the orphan item, and leak the inode. Fall back to aborting only if
  that update also fails.

This turns a filesystem-killing abort into a graceful -ENOMEM return for
create(), mkdir(), mknod(), symlink(), and link() under memory pressure.

Assisted-by: LLM
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/btrfs/inode.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3a2dca093c7d..5b79910d72f5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6863,7 +6863,27 @@ int btrfs_create_new_inode(struct btrfs_trans_handle *trans,
 	} else {
 		ret = btrfs_add_link(trans, BTRFS_I(dir), BTRFS_I(inode), name,
 				     false, BTRFS_I(inode)->dir_index);
-		if (unlikely(ret)) {
+		if (ret == -ENOMEM) {
+			/*
+			 * Orphan the new inode instead of aborting. The inode
+			 * item was already written with nlink 1, and discard's
+			 * eviction won't delete a bad inode, so nlink 0 must be
+			 * persisted here or orphan cleanup would see nlink > 0,
+			 * drop the orphan item, and leak the inode.
+			 */
+			clear_nlink(inode);
+			/* btrfs_orphan_add() aborts the transaction on failure. */
+			ret = btrfs_orphan_add(trans, BTRFS_I(inode));
+			if (ret)
+				goto discard;
+			ret = btrfs_update_inode(trans, BTRFS_I(inode));
+			if (ret) {
+				btrfs_abort_transaction(trans, ret);
+				goto discard;
+			}
+			ret = -ENOMEM;
+			goto discard;
+		} else if (unlikely(ret)) {
 			btrfs_abort_transaction(trans, ret);
 			goto discard;
 		}
@@ -6925,7 +6945,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_insert_dir_item(trans, name, parent_inode, &key,
 				    btrfs_inode_type(inode), index, NULL);
-	if (ret == -EEXIST || ret == -EOVERFLOW)
+	if (ret == -EEXIST || ret == -EOVERFLOW || ret == -ENOMEM)
 		goto fail_dir_item;
 	else if (unlikely(ret)) {
 		btrfs_abort_transaction(trans, ret);

-- 
2.55.0

