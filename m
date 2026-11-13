Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591656;
	b=dannSWUwB/8xjoQXaijgmQNhqT3NC1SAtfuLu+sbVKrDKkJICCY81stLvaoiq7bbib7z
	 a9px2XSirEyT3AMje9bAYJKZ6ufCbhSR2AcoHhwD6NOfwDy3O0DE5We8OGOTR3om0f7gr
	 SkFSZH+Q9gRhRoo4TOpU/i1TcgY7QqkSa8RkuqWIvbkN7j8P3GorlbeS8L9kPiGFENV42
	 S7JYvN+oxoL0B3ig/FVTddU3+5FG8nXXLEaoecMU+xVmXOTjaYoLGKldqENk4NrYh3/dn
	 LrSnqaUY52TGyxPwe2Qs9bxF9QbbrbvKQYaU7gBoegByMXgl0VGkuZZIf7mVJRUhn4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591656;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8pISivxQLJ0sBkifptuQcSb/XSvPcBMc+MCfnleNulY=;
	b=FGA9o/etea4wgDG9ysXZuBYwWP38K+i0N1VVCJLPt8xQhBx1nnJoWHIs3kA1tK+ZIhwL
	 bebnDtd4vmNjgxUr7JoHPmiCyp4WzsS68CTfAASPIwNPsixfehJnYL+hk7UkKkuxP6OOP
	 54oMFphQkThZtgntKow99Oz3kzD6XDLmOMoCdC2ZLSmHqaZ8nlA/mLxA0p2Tsb58/5RXL
	 f5e+seT8gGMXHK48q0vDElE8yvdA5ZeP8aL0p8+EZzGNSThk3clwI2dtktZWN+sy2wai2
	 V+zAuBw9WedxdHkI1zaTPx3p0C8eLgRltEpfv7aqw06J6hJJ0jgpIB/ZDtGbpIZX3CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qn5wor16;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DBC560703C4
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 17:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qn5wor16
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5051F000C4
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 17:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794591656;
	bh=8pISivxQLJ0sBkifptuQcSb/XSvPcBMc+MCfnleNulY=;
	h=From:To:Subject:Date;
	b=Qn5wor16Tpbyi+Gyp/f9ie8k02S//Yxck1qOdRweV9yi2C49U/bPNlwkgkR1bpoNd
	 4H1dB18EQ3pqmkBX3k5DvBo9V6ONRWgqdanAP2qGIgprNn5Xldy1AGb4ojw5oLLIH8
	 pysvRqQmA9IkfAqkMs4HaaeTiY5Fq7EcrJ4MiMVSgJjgrMqyySwOwP0z+MZcZTbQ4m
	 ZAy6D277h5kt7UyURaqQP/FDLqazeqT4FW7dbkML5IihuW2J/vnafOKcakiB4k5T0J
	 MrtRspGRKV0Caz4Kfc/7qNdRzEKnkY9v3II6l9lx6CWRBnuEZjMWVQohgPsH7IWWHU
	 ZZLVmttgIVJ4A==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix blocking allocation for nowait encoded reads of inline extents
Date: Fri, 13 Nov 2026 17:40:53 +0000
Message-ID: <68de579e49460c18b37fb3468b63c9c33a6e8ada.1794591635.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

If we are doing a nowait encoded read of an inline extent, we are doing
a GFP_NOFS allocation for the temporary buffer, which can block. We are
also returning -ENOMEM on failure, which is wrong for a nowait context.

Fix this by using GFP_NOWAIT when we are in a nowait context and by
returning -EAGAIN insteaf of -ENOMEM if the allocation fails.

Fixes: 973a432637ed ("btrfs: don't sleep in btrfs_encoded_read() if IOCB_NOWAIT is set")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 62ff1e568a5c..e68c9871ee1e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9480,9 +9480,9 @@ static ssize_t btrfs_encoded_read_inline(
 		ptr += iocb->ki_pos - extent_start;
 	}
 
-	tmp = kmalloc(count, GFP_NOFS);
+	tmp = kmalloc(count, nowait ? GFP_NOWAIT : GFP_NOFS);
 	if (!tmp)
-		return -ENOMEM;
+		return nowait ? -EAGAIN : -ENOMEM;
 
 	read_extent_buffer(leaf, tmp, ptr, count);
 	btrfs_release_path(path);
-- 
2.53.0

