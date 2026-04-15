Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB162FFDCB
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 18:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776278695; cv=none; b=N9WJAXQ8+SXjOp3mGD6hqPN7FE+L3XjBZ/OxAfP3BmcShATOsDeyL37bnloykR62VcJN0jH/DfZspZ21zZTNf04KNZYCPYimeb+u6mYBAuoQHydFlkDXEi4iT16uD/GYXnCiH0VGedhvBjjddGxXAeADqZrgw35KFVGhce3RJ0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776278695; c=relaxed/simple;
	bh=HsZJLB7ICLUELFFhoDc+dvboMPoagV7z3hupCmDML3Q=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fd+OLOxASvJD4YPxGYnrGxShN4qz8UccYT/IYt66cWO+tjedIi781NdRhGJIRwMd0TFi1tFXIPi5g6WHQzyeWTb87CpsKH9NPbmbFOGH0awg3g0LHD/EasTTu65p6PG3275p3KmmlfK6Sbp2BCxbxuoqCzwhi7ps9b5CK+x97YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TqztdBXz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TqztdBXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2228C2BCB4
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 18:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776278695;
	bh=HsZJLB7ICLUELFFhoDc+dvboMPoagV7z3hupCmDML3Q=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=TqztdBXzmAx7VSyAYEhNJl8yhcpLOmrqK1jsa9czT1VoK3rNQWyG8tjxKcq/BeiEe
	 o+E4kR1mTQ8kVppp8nD0oiJPdc4Jjqpq8VJas9tEV7AxMxxieX4oZEROq6GMkZvk1C
	 QF2ZCMQT/LhHUX9jgKT++zV35FLy7ULDlAXfbgocUd/zVK991lh1DZVdV40Ytn7y0v
	 qdC0Kxmkbklk9D0d4OXrsaVlaE6S66jhpQ8i+cFCQu14HuiGRoffG5eGrGovDtMlIL
	 Zzugz5CHaoOXVAPsWOjBcuSPGm8cM2+PvN4gMshdjDG/I5fCwPxgySjoc+j9MehAHs
	 YtGPEIbkknmtQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 00/10] btrfs: reduce memory consumption for block groups
Date: Wed, 15 Apr 2026 19:44:38 +0100
Message-ID: <cover.1776278490.git.fdmanana@suse.com>
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

Reduce the amount of memory used by block groups by using kmem caches
and reducing structure sizes, plus a few cleanups. Details in the
change logs.

V2: Add one extra patch that was missing, to further reduce the size
    of struct btrfs_free_space_ctl (patch 7/10).

Filipe Manana (10):
  btrfs: use a kmem_cache for block groups
  btrfs: reduce size of struct btrfs_block_group
  btrfs: use a kmem_cache for free space control structures
  btrfs: remove start field from struct btrfs_free_space_ctl
  btrfs: remove unit field from struct btrfs_free_space_ctl
  btrfs: reduce size of struct btrfs_free_space_ctl
  btrfs: remove op field from struct btrfs_free_space_ctl
  btrfs: remove block group argument from copy_free_space_cache()
  btrfs: remove unnecessary ctl argument from __btrfs_write_out_cache()
  btrfs: remove unnecessary ctl argument from write_cache_extent_entries()

 fs/btrfs/block-group.c            |  38 +++++++-
 fs/btrfs/block-group.h            |  36 ++++----
 fs/btrfs/free-space-cache.c       | 147 +++++++++++++++---------------
 fs/btrfs/free-space-cache.h       |  14 +--
 fs/btrfs/fs.h                     |   7 ++
 fs/btrfs/super.c                  |   3 +
 fs/btrfs/tests/btrfs-tests.c      |   1 +
 fs/btrfs/tests/free-space-tests.c |  24 ++---
 8 files changed, 152 insertions(+), 118 deletions(-)

-- 
2.47.2

