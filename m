Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484894DD6FC
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778864439; cv=none; b=LsixU2qIJ9NG4nrShswqilRq6Tj2AmIXrHM26TPLzzb2DRO9uowheT5tNPUlc0810GmCWelJiFi2+69UxE4rEpChdGLf+PDIke3r5UyU8Ig1ywMkjzyrk/jcQHpTqGoQqPJu8lWKSiCn/VxxET6usiUKxW5hCF8AG+q2eI4/0GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778864439; c=relaxed/simple;
	bh=lUNunBVyBORWIhrlC3HbvwLpH1Mt2Ewat+j3b30SHk8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q5z+Qt7wIw4arjUO7uV7xVXB/Frr1v3WzCKd4YIADzgpGMizaTaKPAjS7Xkz+/ty+cS317/HNDxKBKN8+DllLJFmvqHG5dbtoYP6z/hJAuHv619ZIcwZaB60fiAN9X119bewMwxyNrvczz47nqCB3n0WOxau/1tEnv7jG+oFiEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dooJ8hJ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dooJ8hJ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C52C2BCB0
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778864439;
	bh=lUNunBVyBORWIhrlC3HbvwLpH1Mt2Ewat+j3b30SHk8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=dooJ8hJ2/0r0cU4XIln7SoLmSJcC5zTVlO1Pnmf3V2X1vRsNXL3Frs7U6/6ZRh612
	 h8s9jpVffIYBhYRLroaqrCDPw8dJ6hsGui8JBvIfXnQj4OnKG5LUMbeDOo1XrIXfwQ
	 ObzrTteA2Q2DT687fsdnYJM+FT510xXbCX1cHeWylQfKtOv/+Xz2L5CPATErna5y3I
	 a1xkwmTrahdxFwwpCUJrriMIkZGhfSwAxQPKwH53OX+5SkEK+pov0Qln8DPR7QW+PW
	 cbLla5qaAIenEBMEsMaYjDvRdWFh1RRL+6DLI2BCAZc7FNv//HUx+JoPD/MxRUINyt
	 VUhD0BiCLiXvw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 10/28] btrfs: stop checking for greater then zero return values in btrfs_sync_file()
Date: Fri, 15 May 2026 18:00:07 +0100
Message-ID: <a6a748457b00c6f11fae26f7207370c21d92b5d5.1778776707.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1778776706.git.fdmanana@suse.com>
References: <cover.1778776706.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

The value of 'ret' can never be greater than zero when we reach the end of
btrfs_sync_file() but we have this ternary operator converting any such
value into -EIO. This logic exists since the first fsync implementation,
added in 2007 by commit 8fd17795b226 ("Btrfs: early fsync support"), when
all that fsync did was simply to commit a transaction, but even a call to
btrfs_commit_transaction() could never return a value greater than zero.

So stop checking for a greater than zero value and assert that 'ret' is
never greater than zero, to catch any eventual regression during future
development.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 43792d5a792c..42914c9785e5 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1810,10 +1810,11 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	free_extent_buffer(ctx.scratch_eb);
 	ASSERT(list_empty(&ctx.list));
 	ASSERT(list_empty(&ctx.conflict_inodes));
+	ASSERT(ret <= 0, "ret=%d", ret);
 	err = file_check_and_advance_wb_err(file);
 	if (!ret)
 		ret = err;
-	return ret > 0 ? -EIO : ret;
+	return ret;
 
 out_release_extents:
 	btrfs_release_log_ctx_extents(&ctx);
-- 
2.47.2

