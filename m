Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E45624A078
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2026 12:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781266443; cv=none; b=YT8C9QrMvyWkLNXoxheXtv8r+oRv2o6GFR1BF69+3QODdpD/i9viMCR2hbKawXZwO/CG2HoAZnKFH1ck2K/JlWWAWRPAJbETop4Wp3iELS5haCiQ/7VjKdZKC1ujzwA6ZQWVn1EaioT/9qodA/gZTaZJ0MQXBDy6LDM3oVU0oaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781266443; c=relaxed/simple;
	bh=gLhu8LMy+Ip43bLPnMgcyQjkAOHAyr+1Bpl+VrMSQNU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OnTw4PnRlqKRi07lgauk+41ZBQniUZ7hnwEuuvbg05DI7YBwD5cUPWEm7RmjbIf1rZuwj7CZ4AMkgNnX0/3AIyFULQK3gruH817+GNNYHr7vfkKoYhpAJzrln/UNI3lUk34Sgxx+AuahnIkNMrSEGul/esq1KClXd0I8/fn8TPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fb1ePWLT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fb1ePWLT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D27661F00A3D
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2026 12:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781266442;
	bh=pwtkuq34jFVAuIKQlcMAiGo/0P/bu7pc5GdaonumW4M=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Fb1ePWLTxeUQohV0mFQSg0pKEqvZ4b8F3MyBmFlFxK+F7x5oZ6pt4j/gjz38ddsxe
	 sQD6V+E8YKnpNL5Fha0EguS3Ky6XyHcOshxgSDH59S0wKdDt6u2aEF+mj+D5C3DX/Q
	 fB/bgC1GHh1Wd/Zog5R8RCNEKHV7oOPVf3VJyR7xC+bH9UubW3jgy+8QsbyZQsATDS
	 UGs9Dc0yrfXj9qHZibQ/n3PQC7kxKT8ar6buh0KzbPk+KXLtehRwyHdW2TLh61EiJp
	 KrIvc7be64TyFZUJlY+0ZfF00waxX2sxjJv5ybq9c6HkhqvzIjzVPITwMQWzL9m/Sm
	 wH0NT379jopGQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: fix reloc root cleanup in merge_reloc_roots()
Date: Fri, 12 Jun 2026 13:13:56 +0100
Message-ID: <50682caa6bbf69740c629a26ff6f19a72ce55e03.1781263239.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1781263239.git.fdmanana@suse.com>
References: <cover.1781263239.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

If the root we got has zero root refs in its root item, we are resetting
the root's ->reloc_root without using barriers like we do everywhere else.
Sashiko complained about this while reviewing another patch, and it's
correct (see the Link tag below).

Also, we should not clear BTRFS_ROOT_DEAD_RELOC_TREE from the root unless
the root points to the reloc root we have.

Fix this by using clear_reloc_root(), which issues the memory barrier
after setting the root's ->reloc_root to NULL and before clearing the bit
BTRFS_ROOT_DEAD_RELOC_TREE from the root.

Link: https://sashiko.dev/#/patchset/cf84f1a217c719e25b6b69e4298dd7afd36c9427.1781194426.git.fdmanana%40suse.com
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/relocation.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 74687c75f763..6b5a59cb21bb 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1950,11 +1950,10 @@ void merge_reloc_roots(struct reloc_control *rc)
 		} else {
 			if (!IS_ERR(root)) {
 				if (root->reloc_root == reloc_root) {
-					root->reloc_root = NULL;
+					clear_reloc_root(root);
+					/* Drop the ref for root->reloc_root. */
 					btrfs_put_root(reloc_root);
 				}
-				clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE,
-					  &root->state);
 				btrfs_put_root(root);
 			}
 
-- 
2.47.2

