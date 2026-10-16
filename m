Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CF637E5D9
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 16:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792168576; cv=none; b=pgoGDI6zeHBZXnRruq+DIvlDtphHUoDcqEke/2iubHXVZjnPIrgL8oN/E1MaQuNwE/hXqTYiZ3M5ZI8Xsk0C3O1LZc5Bm0IsrFJ8NNj9zVkv7jx4CV0MJPvjgqe8qGSEM7fJLI09PfOwX2ZFxmqxDJZzVEuN0ra7O6AxG6BIgNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792168576; c=relaxed/simple;
	bh=5p7NgAZD6HdVh8JmAwQI23c4FPqwPqKyWSsvYNP0da0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=T7TMDoLwa/7La/b8gHaPpe/7QmUJj+eNcS/P0jHU4bfwN6e3gEVX5ezL+MT1F7M/0ECkU5zyQ+dmSQKhTJpBJU4YL2wdwc+iFLSnkHiUUigmM8CI64Fhp/t1+8XmhbQmFok8Mj9vl2xQX5T/wjcKsGgfm6T6Y5jVOwD2JfhTp0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gmFoho03; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gmFoho03"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39AC91F000C4
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 16:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792168574;
	bh=c4nLPWgYC9gylrXlCD5/zNpG/b02BuEf6rRtiX5xSVc=;
	h=From:To:Subject:Date;
	b=gmFoho03Tpt7d7ccSxBeIKJ20zePTOH/OyPZ4gKWWqaWRDBG8wiLSDAFKysa0ITg6
	 px6fh1gRExapGnEhYyHukLWh/LT3elXgG0AZIpM7STYeooMOb+cMMD7kLawBRJFkzL
	 ZS3EFZZJkmU01PAfXykEwcyo+9KxYKdfO7cs2s7xiO8R2brutwExdMFE0iaferlXnw
	 z3GJsAHeTKBx6f13gC15e+e9/Nfisohto5z+QR36gU3i8thcH/gP9A5MTxJ+NVWmA1
	 53smbnDzrKw2XBZDqGIVyHr63pyL4geLLYWVuBWdvMFPp0kepizJkJDS6zguDoNqZb
	 LKDxoRLRrPf7A==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: scrub: fix lost wakeup and hang when cancelling a scrub that is finishing
Date: Fri, 16 Oct 2026 17:36:11 +0100
Message-ID: <81444a955b6914c2de9fe6c7c097cf27ef734cfa.1792168555.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

When scrub finishes, it does a wakeup on the fs_info->scrub_pause_wait
wait queue and then sets dev->scrub_sctx to NULL. On the other hand the
scrub cancel code (btrfs_scrub_cancel_dev()) waits on that wait queue
for dev->scrub_sctx to be NULL. So this means if btrfs_scrub_cancel_dev()
is called right when scrub is finishing and sees the wakeup before the
NULL is assigned to dev->scrub_sctx by btrfs_scrub_dev(), it hangs.

Fix this by doing the wakeup in btrfs_scrub_dev() after setting
dev->scrub_sctx to NULL.

Fixes: a2de733c78fa ("btrfs: scrub")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/scrub.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 8c7404bb9636..05768e28fd95 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3171,7 +3171,6 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	memalloc_nofs_restore(nofs_flag);
 
 	atomic_dec(&fs_info->scrubs_running);
-	wake_up(&fs_info->scrub_pause_wait);
 
 	if (progress)
 		memcpy(progress, &sctx->stat, sizeof(*progress));
@@ -3184,6 +3183,13 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	dev->scrub_ctx = NULL;
 	mutex_unlock(&fs_info->scrub_lock);
 
+	/*
+	 * We have set dev->scrub_ctx to NULL, now do the wakeup as a concurrent
+	 * scrub cancel (btrfs_scrub_cancel_dev()) waits for dev->scrub_ctx to
+	 * be set to NULL.
+	 */
+	wake_up(&fs_info->scrub_pause_wait);
+
 	scrub_workers_put(fs_info);
 	scrub_put_ctx(sctx);
 
-- 
2.53.0

