Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C054D30DD2F
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Apr 2026 13:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776693240; cv=none; b=mC7L543gLYyvWCEnYA4/EP0YL1BoQbuELcT/c9f0z7hXOujlMqKh4VUuSVsW4Tc1O9lWV38bfJxnE7Ipv+BDvNsFUAgmT+ctfEHKd1VfPjqcTJxfYRlblCy3To9AVkQ9nrZZNfIXaqFHjfIKQiRYo21cCBzNO0lsevBi+u6N0WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776693240; c=relaxed/simple;
	bh=pHXShU9t8idlMBP52CR/P6CEKTjR2IPAzx/ICF4cpQ4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=gLys8FCnMWpjt5oYCms65wvkT0/+/8aaJYGO+eLpDBbJy0oLx9X6v/d2xELQ4dAyGjkDg5unkxcZk7By0KjWCRGgAipxa+TV9Rv7mwdLRidPOOH0fk0sGXTsgsBL37BKMaNpWjNPKJuZjcwnUCm1lxmytZDvtD4TjRRXpzQKLe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JFf/6I5H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JFf/6I5H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D7BC2BCB7
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Apr 2026 13:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776693240;
	bh=pHXShU9t8idlMBP52CR/P6CEKTjR2IPAzx/ICF4cpQ4=;
	h=From:To:Subject:Date:From;
	b=JFf/6I5Hr254SoDmGiJfp0hxmK1JxPGkQ9rIGZ8fG28yPNFmkdPrSOBnMQLrZ7yrX
	 433gs1OJMuLk56W2EOv3kFrAbcypmoXmViebPvR7cxJxSayOmViI5+u5/WWoplmPb7
	 jt58QeMMV/V2rlTx8z8KZNjmdX5FV4Gr243NN/OZq7B320vK+eHskCyyoh3VKHing4
	 Z9TNhZH8mpC8NVRd9uT9goJL7dKZRK6XmCrE0dMEvAsSpz7jcgEo03zVs3G5H7Yy8Q
	 5QDexpE74ngkTpWJUGxJAyedQQZqCE9SzLB4sQ+DGqh6GddTHfi2otWOZbvEEXbQ0m
	 PBTTlo/Ql65zQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: use min_size variable to setup block rsv in btrfs_replace_file_extents()
Date: Mon, 20 Apr 2026 14:53:56 +0100
Message-ID: <efc156002e21e5453d58c2c0856f605575f27642.1776693213.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

There's no need to calculate again the size for the temporary block
reserve in btrfs_replace_file_extents() - we have already calculated it
and stored it in the 'min_size' variable.

So use the variable to make it more clear and also make the variable const
since it's not supposed to change during the whole function.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f007f1f2fd84..7aab4a98caaa 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2395,7 +2395,7 @@ int btrfs_replace_file_extents(struct btrfs_inode *inode,
 	struct btrfs_drop_extents_args drop_args = { 0 };
 	struct btrfs_root *root = inode->root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
-	u64 min_size = btrfs_calc_insert_metadata_size(fs_info, 1);
+	const u64 min_size = btrfs_calc_insert_metadata_size(fs_info, 1);
 	u64 ino_size = round_up(inode->vfs_inode.i_size, fs_info->sectorsize);
 	struct btrfs_trans_handle *trans = NULL;
 	struct btrfs_block_rsv rsv;
@@ -2408,7 +2408,7 @@ int btrfs_replace_file_extents(struct btrfs_inode *inode,
 		return -EINVAL;
 
 	btrfs_init_metadata_block_rsv(fs_info, &rsv, BTRFS_BLOCK_RSV_TEMP);
-	rsv.size = btrfs_calc_insert_metadata_size(fs_info, 1);
+	rsv.size = min_size;
 	rsv.failfast = true;
 
 	/*
-- 
2.47.2

