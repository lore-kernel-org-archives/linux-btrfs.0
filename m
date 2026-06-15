Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7C034A794
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 16:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781541960; cv=none; b=pi6LBmPGYOfN5Yuxe/qVd9R6DQAmvIvgG9m0NGH1hTiM/Xy2rb0MMPx0aQixgOP7cuaZxue75WiF8yM0Toraan6B8+jy4za9wQgkE3Nbrtj6lfrGK/0X3NlzbDnYoyf5DCZoJXU9bTpprztrAwnY3a2QSXBizXzyNCKS/HuUoVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781541960; c=relaxed/simple;
	bh=SVy6yU2w9VFc+8Jb2Ss+DxO5qcMdTIlr2bTOELv/6YY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=jzAvk0Fq7eNknpJ79vHyKTVNraINzbI63zSdRGc9tHicOxViLAOxFAzqJn8rgZ9RyKKR7cm2JOzmIlX91dyVrhc7JY+fAHBAcI4mKoRBoHngo8Ywh5jrZiE1UkOmKaHroq24ADQ8uCuukdN1gb3r5n+3/XgF5mMRRVL8kQfMcSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SMdgHNH/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SMdgHNH/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51DB1F000E9
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 16:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781541959;
	bh=WHqdN+A/7UciqRk6vJtcVNNkb6cDWBRctdjizGp3GRM=;
	h=From:To:Subject:Date;
	b=SMdgHNH/Ya5uK4UarpfYNBB5Igqo3hkdQHJStsrX7in7jiKoRsTBjqbC3hB6fjDha
	 Eceuzp2N24DmJU507rsa21AaX2S/pESiSabODbrnmTmxyz3RmZ/eLeYeSmsJKOt2fg
	 DQ62t6KNnSuly/hOSbKrNOoaRBF1PGBHM1GDJQH8eZi8TTDdZZP093sDuFGTELYbPe
	 D8eTFtD8gINnAwA/GRniCukdMhHXZgNbCB4v72+W7q2RDeXJ0jlVb7MONcr9NkXDTJ
	 ICbIGEoLklkH75DuGNHM8dIQTImBkpZtdK7qABhepiopfvyW5QLsIAtqaUwSkQe17c
	 RC5LnqbICQ8Sw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: send: fix is_current_inode_path() to avoid path resets for common prefixes
Date: Mon, 15 Jun 2026 17:45:56 +0100
Message-ID: <4402ee2dd45308bdcfade989e0fb5a917cfc3f6a.1781541942.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
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

Fix this by detecting exact matches - when strncmp() return 0, verify that
the character following length characters is either the string terminator
or the path separator (/).

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/send.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index a3c8f2d889bb..7880d64f7797 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -626,8 +626,18 @@ static inline bool is_current_inode_path(const struct send_ctx *sctx,
 					 const struct fs_path *path)
 {
 	const struct fs_path *cur = &sctx->cur_inode_path;
+	const int cur_len = fs_path_len(cur);
 
-	return (strncmp(path->start, cur->start, fs_path_len(cur)) == 0);
+	if (strncmp(path->start, cur->start, cur_len) != 0)
+		return false;
+
+	/* Path may be a prefix of the current inode's path, check for that. */
+	if (path->start[cur_len] == '\0')
+		return true;
+	if (path->start[cur_len] == '/')
+		return true;
+
+	return false;
 }
 
 static struct btrfs_path *alloc_path_for_send(void)
-- 
2.47.2

