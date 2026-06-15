Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EDC409128
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 17:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781543701; cv=none; b=eADveI/JNq+BmwG/UstSh9koXiinkc6SUQhK0SFvC86XypRr8GC4DXJPvdHrgxHtf2f2mhJGCNFxUyzR0ExatNkgY86rNhVXsPqDIKhsrUBnV8TE62BIVKFEJ4oGomK9pH1kbjBfZqA+8H2y9GfVGQACBksa+W0SLsoGAnCElK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781543701; c=relaxed/simple;
	bh=8S4ool7H/8gFIPgPcx+T1mIv7Yp7YLEM/ZxPe5VAvgY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3C7qVtrDnUVQYZjhrW+DH7ec4gG1c1387VrMMsY+mwP1QX9XYcWte0BpKA7C2bGxnQcL/xBgt2i5XCDDx0JTgRcaBUqHfB+zcCSZFusU0weAB6cOds28mO3Wz+fquIw+UBJCrz7Hs2WQofP82qFkwkaQawTD7oqmdSNU7WAVzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dWEvt06F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dWEvt06F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EAC81F000E9
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 17:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781543700;
	bh=qxOUu2U/MFhKwAo98kTW4G+DuSCS7YBPaKSOE8SWJ0g=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=dWEvt06FXR8YHtDbSXMlfhw7MasYl5Eqr+FrG4pxEOX88EwmGnt5xSXrusLZn1lyb
	 9pFi2e3RLw7dKAgxQm3KQfuTkzrjYoqRSLi0VKxXwwdMhxxLULAg2Wec66s/+HSGUk
	 WQ5AeWfiWK5pH4cigSxqhlBj7CSVE0ESXPwyI1UnilecPIR3QwVA7j9Uv6PE1RTbmt
	 6xWvlKvONpemqJsD7IqJlNfL3S5q1HMizylB6KKZ7tF1BeUgHeJKf9v3nzamGbXT0x
	 4HN1ScQVVNlIXxrYMAZjLiyvkFA1IHLYkdVwnwb1G/YsMQRwanjCoiity8Jgp+dHBl
	 JdU3XaAkappTQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: send: fix is_current_inode_path() to avoid path resets for common prefixes
Date: Mon, 15 Jun 2026 18:14:57 +0100
Message-ID: <ef59cdc332942f989bda1448b95007c6c2d55f82.1781543363.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <4402ee2dd45308bdcfade989e0fb5a917cfc3f6a.1781541942.git.fdmanana@suse.com>
References: <4402ee2dd45308bdcfade989e0fb5a917cfc3f6a.1781541942.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

In case the current inode's path is a prefix of the given path, the helper
is_current_inode_path() will return true, which causes the single caller
to reset the current inode's path. While this is not a functional issue,
it makes the caller recompute the current inode's path later. It could
also become a problem in the future in case get new callers for
is_current_inode_path() in more sensitive contexts.

Example: the current inode path is "/foo/bar" and the path we compare
against is "/foo/bar_xyz".

Fix this by returning true only if we have exact matches.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Simplify and avoid false positives in case of something like
    "/foo/bar" vs "foo/bar/xyz".

 fs/btrfs/send.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index a3c8f2d889bb..d664e470fd77 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -627,7 +627,14 @@ static inline bool is_current_inode_path(const struct send_ctx *sctx,
 {
 	const struct fs_path *cur = &sctx->cur_inode_path;
 
-	return (strncmp(path->start, cur->start, fs_path_len(cur)) == 0);
+	/*
+	 * Path may be a prefix of the current inode's path, so return false if
+	 * the lengths are different.
+	 */
+	if (fs_path_len(path) != fs_path_len(cur))
+		return false;
+
+	return (strcmp(path->start, cur->start) == 0);
 }
 
 static struct btrfs_path *alloc_path_for_send(void)
-- 
2.47.2

