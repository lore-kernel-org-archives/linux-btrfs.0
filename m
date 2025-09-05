Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14DD313279
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Sep 2025 16:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757088660; cv=none; b=BoIjld0Xpm4weZsZsgQ7SRdUHLoX1uEo6QRURSlfxfCOa3QNmiOCpd5o4rukiMbPqJWYqRxPDd+bQw4wCmNo3ICyCdNZ6ky1ytAR6I97IrdpJHSKt+9+Oh04791pRQw/taNzjFLeEVbW3MohAX4X55H+24uJlTS2kdnWx8bOb7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757088660; c=relaxed/simple;
	bh=kBZo2HYQFKQbAAhAZvHEmx4YlLe9brfHWWNl8xJRMic=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/eg8EejdFbrKfTq5uR0qjnF8XD67T8YJnuwIB1srvdsbeBhklHLdzNti91m8YZhPjYpgD+SwMxPTqUS/fCgW6gkgM4jVTZmlZ3vQSYyWmSHEx966broZYUMJunpnrBBHdzOQRZDSZnM/9wuQ+fSi+SEicyDpU794KcC70f1xlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=istvhvrs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="istvhvrs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5883FC4CEF4
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Sep 2025 16:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757088659;
	bh=kBZo2HYQFKQbAAhAZvHEmx4YlLe9brfHWWNl8xJRMic=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=istvhvrsyhVZBuDJHoRj6xk+14GnWnceNLrEbXeUqEHNYWCS3Qs8Xp98ibMKg9qWe
	 SFFjLevr5K7Kk4IYZcQj8eZoZv2DmdrRB/vp7hXLOSizn1knBVfKP+oS/crIDiwqNi
	 p9yNF+HnciHrMhlXBIHnm/Y6zLGxliNQD86Xnx6gfFz+CKmUsbl+QY8NcVorzdW9uK
	 5wFraTVtaoI61IFlJwNEx6vHMrkTfDO0B3pEL56h+RNZQUbcIYPvebpauOJAC1ipNJ
	 mMiNwsPYq7uw40cEbqOVeSEbbQYAXG5JoVXwR4UGsVwu1STFmMQ+qQKPkcRLdQL/1+
	 QNX2RHS//omqg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 23/33] btrfs: avoid unnecessary path allocation at fixup_inode_link_count()
Date: Fri,  5 Sep 2025 17:10:11 +0100
Message-ID: <7e4c83d685e252cb18aba207a06af133b9123352.1757075118.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1757075118.git.fdmanana@suse.com>
References: <cover.1757075118.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

There's no need to allocate a path as our single caller already has a
path that we can use. So pass the caller's path and use it.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index b4e901da9e8b..5754333ae732 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1728,19 +1728,15 @@ static int count_inode_refs(struct btrfs_inode *inode, struct btrfs_path *path)
  * will free the inode.
  */
 static noinline int fixup_inode_link_count(struct walk_control *wc,
+					   struct btrfs_path *path,
 					   struct btrfs_inode *inode)
 {
 	struct btrfs_trans_handle *trans = wc->trans;
 	struct btrfs_root *root = inode->root;
-	struct btrfs_path *path;
 	int ret;
 	u64 nlink = 0;
 	const u64 ino = btrfs_ino(inode);
 
-	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
-
 	ret = count_inode_refs(inode, path);
 	if (ret < 0)
 		goto out;
@@ -1776,7 +1772,7 @@ static noinline int fixup_inode_link_count(struct walk_control *wc,
 	}
 
 out:
-	btrfs_free_path(path);
+	btrfs_release_path(path);
 	return ret;
 }
 
@@ -1821,7 +1817,7 @@ static noinline int fixup_inode_link_counts(struct walk_control *wc,
 			break;
 		}
 
-		ret = fixup_inode_link_count(wc, inode);
+		ret = fixup_inode_link_count(wc, path, inode);
 		iput(&inode->vfs_inode);
 		if (ret)
 			break;
-- 
2.47.2

