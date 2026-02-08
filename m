Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2765C13B
	for <linux-btrfs@vger.kernel.org>; Sun,  8 Feb 2026 19:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770580378; cv=none; b=Dm0iRBZFdnPxyKATeEevxzniQk4p3+EXYs+d43cpOiaMuvDgNP+dogXHeY/ryn7Go2c3fqIXWDNzUaxuwQdZZy+ZVZodh6UgusTlW9TN8oFbAscmedzw/Jq2EDcBpVJ8WPPJY9LzlWoHJPLx1KasQuGOESoMrA7BJphaiI9WEcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770580378; c=relaxed/simple;
	bh=Sc4Qz1sIMR/hqeRPM2Cs21sXrJxGwTbj0QJXnG2q0As=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Rc1b5D5V9fOHNycxYU8mbTSj7yyrMI6BS8IyzttZ4EgZULGak02DroIl/m0S+LnazJ4XuOpKfRZtJvVT15TlR4u0KhwuqXoNFXaOMKo9XAC5erZ27Ydua5IBGbHjkVtLaEM36aPPoQxq8AXcAsUm/LsOd6RQoVra+fpK6SVV0fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vMGmnMGL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vMGmnMGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7A5C4CEF7
	for <linux-btrfs@vger.kernel.org>; Sun,  8 Feb 2026 19:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770580378;
	bh=Sc4Qz1sIMR/hqeRPM2Cs21sXrJxGwTbj0QJXnG2q0As=;
	h=From:To:Subject:Date:From;
	b=vMGmnMGLMTzMY1OXYKgkQN1EwDabl4gPcWE9UBHbV+odksw4nfy+fuV+7VYekyagl
	 WRKAZFglF/MlCDtrz3z88HbtcDym1Lt8ciBZB4qQ/Nu8OqLN1xWwoTa42SBAC2V8M+
	 FZOp91NoF6Rd0SQaEBemmFw6dpPYwZ9+uRfHljVZNDLKw1mnkItTyVmjee0X2ZvoYD
	 0LsZ5IsYPZPUwqfQMOFwOqezsJOsYtVFC3mSHERkBtC1qG3Tl94XNBDPk4Nbd6MwDb
	 V6DkT1ICWRaV98zuXFBDNosvn+MtuX12K4gMldim2MjHVg6MaSIJj0pMJM4vFRsvFr
	 I7pP0Zsw+quiQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix lost error return in btrfs_find_orphan_roots()
Date: Sun,  8 Feb 2026 19:52:55 +0000
Message-ID: <6400dc5103b5ddbe543961b4e865e311ab396790.1770580302.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

If the call to btrfs_get_fs_root() returns an error different from -ENOENT
we break out of the loop and then return 0, losing the error. Fix this
by returning the error instead of breaking from the loop.

Reported-by: Chris Mason <clm@meta.com>
Link: https://lore.kernel.org/linux-btrfs/20260208185321.1128472-1-clm@meta.com/
Fixes: 8670a25ecb2f ("btrfs: use single return variable in btrfs_find_orphan_roots()")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/root-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 37a4173c0a0b..d85a09ae1733 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -257,7 +257,7 @@ int btrfs_find_orphan_roots(struct btrfs_fs_info *fs_info)
 		root = btrfs_get_fs_root(fs_info, root_objectid, false);
 		ret = PTR_ERR_OR_ZERO(root);
 		if (ret && ret != -ENOENT) {
-			break;
+			return ret;
 		} else if (ret == -ENOENT) {
 			struct btrfs_trans_handle *trans;
 
-- 
2.47.2

