Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727392F069D
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 14:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776263896; cv=none; b=e5oIiI+Sd53tGseapc0+Py5Px2KXvaRHqg5aQQb8rDJuQrr0w3e6fWPsulOl43W8S9i3dpCPYdLq9glDy2BWAN8F8o9OQRBSWRVuRNhKmnO/pasKTf0CKMFpmGA16t8N73mktlW4oxj3kkD0h/uD2EbukJyfLueDBmZnv9e0mhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776263896; c=relaxed/simple;
	bh=TIqKsjJBYCkqe/ueG/IW+6O/UHejC3I30MUja71ZyuM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=jkRcInUrBccKfB457Ik+JsMjQTfx8bdlZ5x6mNyGP8CtM+aqchjeAey3QjPVa0HAXje4KRZiRDOPnRA7CRebMng6CmHFptHhdWSo1vtHUEq3zuIgYZTukwG21xoFo4gSc9a6WcdIpmVZmxx+1egJmvGjLuVid19CHiM8wp6YD1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qLAgQ8MF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qLAgQ8MF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4E9C19424
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 14:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776263896;
	bh=TIqKsjJBYCkqe/ueG/IW+6O/UHejC3I30MUja71ZyuM=;
	h=From:To:Subject:Date:From;
	b=qLAgQ8MFRGJF//hLPrBRNcQ/u7cqArQvE7YPSg7ROKJfxDOTflk6b1ZtwHIyltgaG
	 riA9in3sUs9U9DU9FARreSLyGPx5Z/V1LMSxReZphDTnJQfYIbRkiCV+dG+RPhFR6G
	 aGcdPR9Kr2/a1Gvbul/hcYOm/1T1Xp6gxzUHuKq/Th41XNjIQpl0XncZNKHB6svnWT
	 bWJwAew+kxpJzEQPqgmZ/gW3M5Q71oG1WV8dRZK8OjhN6pfhE0OFWEgbBocnlJSc18
	 snNFP+QlivdWuukj9SJ6hzomCIQMCZWrVr55Hwr+N3YkpLxsoxStdIcjVB19MyQoJM
	 W+N+T/Sc2aqtA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/9] btrfs: reduce memory consumption for block groups
Date: Wed, 15 Apr 2026 15:38:03 +0100
Message-ID: <cover.1776263553.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Reduce the amount of memory used by block groups by using kmem caches
and reducing structure sizes, plus a few cleanups. Details in the
change logs.

Filipe Manana (9):
  btrfs: use a kmem_cache for block groups
  btrfs: reduce size of struct btrfs_block_group
  btrfs: use a kmem_cache for free space control structures
  btrfs: remove start field from struct btrfs_free_space_ctl
  btrfs: remove unit field from struct btrfs_free_space_ctl
  btrfs: reduce size of struct btrfs_free_space_ctl
  btrfs: remove block group argument from copy_free_space_cache()
  btrfs: remove unnecessary ctl argument from __btrfs_write_out_cache()
  btrfs: remove unnecessary ctl argument from write_cache_extent_entries()

 fs/btrfs/block-group.c      |  38 +++++++++--
 fs/btrfs/block-group.h      |  36 ++++++-----
 fs/btrfs/free-space-cache.c | 123 +++++++++++++++++++-----------------
 fs/btrfs/free-space-cache.h |   6 +-
 fs/btrfs/super.c            |   3 +
 5 files changed, 121 insertions(+), 85 deletions(-)

-- 
2.47.2

