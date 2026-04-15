Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1623CB2F0
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 14:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776263904; cv=none; b=Enlgwrsj8lYW1upJLS1hHr2beA2KpJZZf7oGEWbtDuZJt/bMwVuVQq1niCItPPI9Qndo1enOHDcHttyddmD6WM8Vs1S+wTo2Hiankm5hgISk+p72UlIeZQQL101sQnz+vwlBqblajzwSBDcQoJ4anGDKzdfaoDPPVJ+VThMH1ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776263904; c=relaxed/simple;
	bh=L35xvC3d1D4DY/+hHpLltYPOFUbHYJe/kDqB2B8mtTE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rx+DpESb9w/h0HfxXDhY5rPW2xcIjBNN6frA0sjBdaK5vsHgFsN1yTb/OoKTF1v1l2pTk3huj92F2Lxk2POe5hIfm46RhV+9gQ0BtDRKM3si+mLJxwZSB5CFA5wYkOGLACeFTZy0z+XDWelx0TsWrodzVe6QDqGt7nQC+pH6m+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AEo47sPB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AEo47sPB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84ABC19424
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 14:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776263904;
	bh=L35xvC3d1D4DY/+hHpLltYPOFUbHYJe/kDqB2B8mtTE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=AEo47sPBh5W7fUqCAkPQXmBZTbRIY2rygsXF9lDH/FUFhdCrQLtswGzV8+czxAXXm
	 UN3HiMhobEWWoORwqNZfhwUWf7c55ekQHLr0mNgNtv/HB4WJuFIpFdhXjJJTv63WpR
	 kpZMa+Mux4Mxx8iHc9jeMSpie/7MphNzSX2Zc6NXzmQruFVsy8vmdmfFzcxbWRlPZl
	 C4SgKrN6x+AcaHhJkq0ZUlWKb1D31zX3zTmv2wL+yhGP+00ajBAltQv7COk0NACLC3
	 EN79S4BMFvi+GxYlRgVgGlwaGlyOoH5UDG644sQ1xEzenWhzoUbeIirzXTXkZVBtFc
	 RkiRFoWrqydSA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 9/9] btrfs: remove unnecessary ctl argument from write_cache_extent_entries()
Date: Wed, 15 Apr 2026 15:38:12 +0100
Message-ID: <1645afa46f0e85b22bd4967d393d012781f344d4.1776263553.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1776263553.git.fdmanana@suse.com>
References: <cover.1776263553.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

There is no need to pass the free space control structure as an argument
because we can grab it from the given block group.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/free-space-cache.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index bc39551ec6d5..181af26b7209 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1068,12 +1068,12 @@ int load_free_space_cache(struct btrfs_block_group *block_group)
 
 static noinline_for_stack
 int write_cache_extent_entries(struct btrfs_io_ctl *io_ctl,
-			      struct btrfs_free_space_ctl *ctl,
 			      struct btrfs_block_group *block_group,
 			      int *entries, int *bitmaps,
 			      struct list_head *bitmap_list)
 {
 	int ret;
+	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct btrfs_free_cluster *cluster = NULL;
 	struct btrfs_free_cluster *cluster_locked = NULL;
 	struct rb_node *node = rb_first(&ctl->free_space_offset);
@@ -1416,8 +1416,7 @@ static int __btrfs_write_out_cache(struct inode *inode,
 	mutex_lock(&ctl->cache_writeout_mutex);
 	/* Write out the extent entries in the free space cache */
 	spin_lock(&ctl->tree_lock);
-	ret = write_cache_extent_entries(io_ctl, ctl,
-					 block_group, &entries, &bitmaps,
+	ret = write_cache_extent_entries(io_ctl, block_group, &entries, &bitmaps,
 					 &bitmap_list);
 	if (ret)
 		goto out_nospc_locked;
-- 
2.47.2

