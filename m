Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FEC332EB1
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 16:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773677666; cv=none; b=r6Mvkwdg6ii/pttgnVPntHPj/r6D2HarMXl6oyzrpBc/fOO5tXzzZVw0LdxPazt6wo2e1xI642vAW4NZCfZkoodDK6jD6aO5XA3BJUu9ZNcz5aUBOJWt+1CUgSsChs/ukPdKWFSFO4WfPA4gZ5jROr0O44gDCFwsafIXW9eeDqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773677666; c=relaxed/simple;
	bh=miD+LGNQAX1N6vAE+cLm1D71XJzUFti3ZhA43Riacjc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LrS2w+Hheq4+2dlcuzdQVr+hLE+RSN+y9zDPr3jW5o/uo1qXNmB0NRP7/7tXAJ2nESOCx2QJvQdAHeEwifLIO73/Lgt1OD89LcOM4ysbt/IctoiGjKjVqGktWuSBzxgxJ5mNruNAAYlfWybsM1BdVkQ+BMm3uvT9CGDFAPocfp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ajEwhmWS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ajEwhmWS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44819C19421
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 16:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773677666;
	bh=miD+LGNQAX1N6vAE+cLm1D71XJzUFti3ZhA43Riacjc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ajEwhmWSs7idGkCVoradNSeTs3nHbG/20zJaSt0G6F2vzEfkcmMdAoDmesUAm7+00
	 uw4bdFkoQ5xQ2+Ylh/9gCgZ9UmAVZFr8iF/CkZL56jXSVeZnoBDfLDVKHzioVs9oD7
	 T+F7J7yE7Rq4PrHsluBJ7jOgo41L9lTsXI6JMKYHrgE1Vn8+jLeSd0jLFN0Ng7zarB
	 wmv/aQ2E3kNnm/UJOzo/BQO9dctcJ/tHzOkERQg13uQy9k21yhGxgpJQDPW2vnDsdz
	 1/DpjwXf48XRQy9UJ5Q+cc0h+dLr1HYZiR+eDC5xiQQEB73/C2OrhoI671h1MbpD9o
	 nXvhnOAqCRWFg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 09/11] btrfs: free cached state outside critical section in wait_extent_bit()
Date: Mon, 16 Mar 2026 16:14:12 +0000
Message-ID: <2a5ab88b82b622067c88095f28136d17a802ef0a.1773676775.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1773676775.git.fdmanana@suse.com>
References: <cover.1773676775.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

There's no need to free the cached extent state record while holding the
io tree's spinlock, it's just making the critical section longer than it
needs to be. So just do it after unlocking the io tree.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent-io-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-io-tree.c b/fs/btrfs/extent-io-tree.c
index 0d9437e72bd4..29fcd08b9ca9 100644
--- a/fs/btrfs/extent-io-tree.c
+++ b/fs/btrfs/extent-io-tree.c
@@ -877,13 +877,13 @@ static void wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		}
 	}
 out:
+	spin_unlock(&tree->lock);
 	/* This state is no longer useful, clear it and free it up. */
 	if (cached_state && *cached_state) {
 		state = *cached_state;
 		*cached_state = NULL;
 		btrfs_free_extent_state(state);
 	}
-	spin_unlock(&tree->lock);
 }
 
 static void cache_state_if_flags(struct extent_state *state,
-- 
2.47.2

