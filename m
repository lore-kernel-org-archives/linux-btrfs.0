Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3394963D5
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2026 16:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769013061; cv=none; b=So1xQGqxjlJi4H60InZ/682rCWPbSeCJ2TGQHdnJTPNLJqa6o/wyy5/bjZR+XfAF8QRyUqayOoCjtxqLTuTuZDv7d+jXhGJbR0qps0/LmUiPzMgdGQNU8Mzs8x5hDVgvoNeJaQ07WS54xOfF1CdR24d/vWMUmEDZ7V+tV612/pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769013061; c=relaxed/simple;
	bh=nMOl2T0KpAO5544eEo+6Ur6v6RMtVI5rPfV6t8dCNhU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OP7MveWMPY39ARoU70lZKPg8LmIdtHPwScROtDJ9zor12pyVeo5SwiJKOyB8VrX17t+9SwDKOlnbwZKdaBsaK0sV8xvLgRKudDQ4hiasQZAOQSBfjD+l5/p1Vh7EOU0t+ixBOygY0bPz4e6g1Yll89pVLthS4RyN3W2AjJQdYw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o3LGZhMu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o3LGZhMu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F50C116D0
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2026 16:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769013059;
	bh=nMOl2T0KpAO5544eEo+6Ur6v6RMtVI5rPfV6t8dCNhU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=o3LGZhMuUql/3fd3dujv0nCdoOk8OoOtHaw9mvMzgUCSTcqQZbJvXjOYpbFjFnwF7
	 xFXTBp7J2GUbj0Ks4py5hnaFHgL/e/0s5he2HghFh/AMru1Q5uHu0hJWbxqR7jcjzU
	 cxavuK7gP9EbU5B9O+4EWDW3PWzju8cjxL08Fbl6kgk9MuNZxD+eApmyEm905HJ3vK
	 CIxNzMP78I+F011twjx/dZ/fQg9y6qNKEvrKI4ZrlQ16wN1+AM+TRltjMoBG41XISn
	 CVenmpTviHUSpkq2ICMNbiecoKYHpsX2GRbvLKO8oqaZcp+YNU3DdfuJKUcONHGhWl
	 2FOryQiN2rBug==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 12/19] btrfs: remove out label in btrfs_csum_file_blocks()
Date: Wed, 21 Jan 2026 16:30:38 +0000
Message-ID: <536e51884d418e33532cba83f42375e600cf1a32.1769012877.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1769012876.git.fdmanana@suse.com>
References: <cover.1769012876.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

There is no point in having the label since all it does is return the
value in the 'ret' variable. Instead make every goto return directly
and remove the label.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/file-item.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 568f0e0ebdf6..7bd715442f3e 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -1134,7 +1134,7 @@ int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
 	}
 	ret = PTR_ERR(item);
 	if (ret != -EFBIG && ret != -ENOENT)
-		goto out;
+		return ret;
 
 	if (ret == -EFBIG) {
 		u32 item_size;
@@ -1150,7 +1150,7 @@ int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
 		/* We didn't find a csum item, insert one. */
 		ret = find_next_csum_offset(root, path, &next_offset);
 		if (ret < 0)
-			goto out;
+			return ret;
 		found_next = 1;
 		goto insert;
 	}
@@ -1178,7 +1178,7 @@ int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
 				csum_size, 1);
 	path->search_for_extension = false;
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	if (ret > 0) {
 		if (path->slots[0] == 0)
@@ -1234,14 +1234,14 @@ int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
 			    btrfs_header_nritems(path->nodes[0])) {
 				ret = find_next_csum_offset(root, path, &next_offset);
 				if (ret < 0)
-					goto out;
+					return ret;
 				found_next = 1;
 				goto insert;
 			}
 
 			ret = find_next_csum_offset(root, path, &next_offset);
 			if (ret < 0)
-				goto out;
+				return ret;
 
 			tmp = (next_offset - bytenr) >> fs_info->sectorsize_bits;
 			if (tmp <= INT_MAX)
@@ -1282,7 +1282,7 @@ int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
 	ret = btrfs_insert_empty_item(trans, root, path, &file_key,
 				      ins_size);
 	if (ret < 0)
-		goto out;
+		return ret;
 	leaf = path->nodes[0];
 csum:
 	item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_csum_item);
@@ -1307,8 +1307,8 @@ int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
 		cond_resched();
 		goto again;
 	}
-out:
-	return ret;
+
+	return 0;
 }
 
 void btrfs_extent_item_to_extent_map(struct btrfs_inode *inode,
-- 
2.47.2

