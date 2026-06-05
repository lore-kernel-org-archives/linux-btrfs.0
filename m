Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6DE30EF88
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jun 2026 16:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780677674; cv=none; b=h/zBM4RLDIf9cB6JYPYYPHA8pRf2f/9zBbIrDBFVAV/0gDCUmzySoJbI1aChX2zcLuFUOBGZT769gvChyKabFbfAp0L0fMAxOrkG0c9i37AQFQWyzCS1/TlZsDNUOGyv6cWs4SnFELpVReLAq/k/ovEOSfCJiivVMfMp6bIP/Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780677674; c=relaxed/simple;
	bh=zz50Tt/hh3rrx9dpbb4OLoj3pi2HWh6k5TgADMrIDC4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=s0POjyEB7Hy1r/pfVOP/WUy459XD/jelvzcdlERYI0FIBhDTCDBVzAcqBHrAIxO8OBkqatX2JbY64G8O2h+Ult6Wlz53oFYVdy1NEjiapNJVFGR1FbiqWMCGUcbVQxZ5KxCZuXq96GLUK7hqE8rEI2NtSoAHOUJ6ckBmQ9DwadU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XsAwsCue; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XsAwsCue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 964381F00893
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jun 2026 16:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780677671;
	bh=/BzCCA6cfDXF9+l4R80QGbnJMe8EDhiXYP79NpO5ACU=;
	h=From:To:Subject:Date;
	b=XsAwsCuexO0qa2M14dBHt3de+g4XXjCMgXTuN3OzGML6dKZ2n2yHgwlLWEmAG8RRq
	 Wwzm5GQ1VXMwLP/ZpuiWmu0WT/jNV1IRg/dVQqIlppwMr5eLzwEKjTTMDdH/wZl6Wy
	 35QchOyEts25Ql2p7NJGPqru3cn0A54oxZH0uOnMfvI0E2/6kx9KBw7d3AnU3J3WMT
	 FJGpoxZ3vyHazWkHdQ2KH+mes2hwM/0jvatcj5z7j7AqOvZb8aYsdC8C4Ga7rWrrwp
	 AZLtprHUD3WXNirdS8m6dqn+gI4zAvRZyPgSThtWJh3Ge8K75X8acDMUyUNFy+KfM5
	 pZpOqXiZrdSmQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: move WARN_ON on unexpected error in __add_tree_block()
Date: Fri,  5 Jun 2026 17:41:08 +0100
Message-ID: <3c637e06f9a7c3e83b430c4b30620118356cd3f5.1780677634.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

There's no point in having the WARN_ON(1) inside the if statement for the
unexpected error. Move it into the if statement's condition, which brings
a couple benefits:

1) It marks the branch as unlikely, hinting the compiler to generate
   better code;

2) The WARN_ON() produces a stack trace after the dumped leaf and error
   message which can hide that more important information in case we get
   a truncated dmesg/syslog.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/relocation.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 9771975dae99..6b462920306c 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3236,13 +3236,12 @@ static int __add_tree_block(struct reloc_control *rc,
 			goto again;
 		}
 	}
-	if (ret) {
+	if (WARN_ON(ret)) {
 		ASSERT(ret == 1);
 		btrfs_print_leaf(path->nodes[0]);
 		btrfs_err(fs_info,
 	     "tree block extent item (%llu) is not found in extent tree",
 		     bytenr);
-		WARN_ON(1);
 		return -EINVAL;
 	}
 
-- 
2.47.2

