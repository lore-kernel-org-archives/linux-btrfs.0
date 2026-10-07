Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C944A0933
	for <linux-btrfs@vger.kernel.org>; Wed,  7 Oct 2026 15:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791386458; cv=none; b=oYfxET3+2xh/dyBIdG1yWAYktaptIXSe3S1Mme7rkPmzLliBdjfdEwwy1dUn12wsuDW/UdYRJLs5tKMmnVBh3jeKaLRWWw1NvRnuq+NaA/ii0Wg5B/EksBBzV21ISQ5GtLzBLT62ieMKZSLengA+ElUJpRzabp2mM/FBms5cpLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791386458; c=relaxed/simple;
	bh=id4q0RRdagpryCkIWaVeB0rUCnCFCNX5WAVifgnWu+E=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=qzlfMRtQCwLLUr1u690xd2IabVdPkhfTNOWp88f/SGvQyfA/zsCepb1qFGN9G4Dar6Q8f0Q5ysSaWmVkRtUQPmV57Gjy+aBi+OOt+aidMdPEbQPOx7iS3jIUsfMd0+gtK7QOOmNfjRUhJ7B0sYfPNz2a6W4Dobe/a5aKvg3+sIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dwQWJm9V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dwQWJm9V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC7A1F000FF
	for <linux-btrfs@vger.kernel.org>; Wed,  7 Oct 2026 15:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791386455;
	bh=5CbKK15w13aYaMkDGSOARsaruxxb4ipmgKk3ZbLW9/w=;
	h=From:To:Subject:Date;
	b=dwQWJm9VhRLae4Zwjj08/QO0wKNhc2rv43oqN+piv026NMUc54U8WbKlpCQRHDklQ
	 UsBHtGLTMiRbgJhBaIDeYLMHtA99xdwGwfm9TZbZaPKpA0aOJcLBjcXH0ABDwgWWVg
	 byLLP28iE7GEsV4QbemxxnoJHgbpj2qA4Xr9vG+7g2q1sQdmaRG68D+hAXVnzvGfmn
	 aJqlaQEW6ukmAG97SIMEX7A2ju7oEKE5NMuA7ZX3vrZz98rwafL7gZYip++0+Rmbgc
	 LeNmHy3Hms5ok10NVnGZbMZepFbJOTfsF4N3TQpNoWj9EfkLFWizNkGf1C4ykA7z2e
	 e280qsqnvI2nQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: defrag: fix check to see if next extent can be defragged too
Date: Wed,  7 Oct 2026 16:20:53 +0100
Message-ID: <28749bc33ebb6dbb85b0acd298fbff300fc5d731.1791386424.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

We want to check if the next extent is at maximum capacity but we are
passing the current extent map to get_extent_max_capacity() and not
the next extent map. For example if the current extent is compressed (its
maximum capacity is 128K) and the next extent is uncompressed (its
maximum capacity is 128M), then we can bail out and not defrag the next
extent too - when for example the next extent as a size of 128K, is
uncompressed, and the extent threshold is >= 256K.

Fixes: 979b25c300db ("btrfs: defrag: don't defrag extents which are already at max capacity")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/defrag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
index 75c87aee5de9..7010d714cfe1 100644
--- a/fs/btrfs/defrag.c
+++ b/fs/btrfs/defrag.c
@@ -811,7 +811,7 @@ static bool defrag_check_next_extent(struct inode *inode, struct extent_map *em,
 	 * If the next extent is at its max capacity, defragging current extent
 	 * makes no sense, as the total number of extents won't change.
 	 */
-	if (next->len >= get_extent_max_capacity(fs_info, em))
+	if (next->len >= get_extent_max_capacity(fs_info, next))
 		goto out;
 	/* Skip older extent */
 	if (next->generation < newer_than)
-- 
2.53.0

