Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA2B30FF31
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 12:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784724111; cv=none; b=eZQJ74hxkWaroD5PIC7/ijELujXQ0s4l2cr+e+4uOl9A6BvNmhsM1KetFEzkfh78K7P5FPWaCxO5sMQTKjGixX3XwDbP7jYjJuhOQMeMmPRr8q1u6Yv0HeMCFdGSORxilT2hMVr/o0ZHxnHOwO48oMecxuGffNlxXj1lgs1muDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784724111; c=relaxed/simple;
	bh=5M9ehYgZWi54sdiWpoPqRXmBcunlTvAnx1vfsWaIXAg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=fmJ+2c5Wy+neIBFi8+m/d2W3Prfp/W4bII3XN/rAjm7hbRyeIVE9XpSH0WqTKO1/IkRdEVmCpqWH9vDcoe2aJqNBfzHjLMC76+qwUGbbSYeZfZVPKVEuIEM6UBrehSBv1qZ7couSErg1SEIyXGCJdx1WujT6/FHS/bIZ1m1MUVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H2YCDX/s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H2YCDX/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160E11F000E9
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 12:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784724106;
	bh=VqMU3LI0NLCemntUG6MDmfX+SJydo1jOJ3Gu2HqomWw=;
	h=From:To:Subject:Date;
	b=H2YCDX/sJ5N56yyM9stUoABq2RRqeiU1tCRovHfelntIyE8H5BV0XAKYXDK24t7XN
	 /7FEJ/tiOudAVeu8fI9sVbgNAP4seWeJicuPsJYKIQq6ElDlMDiW9Fi4kLCOIvqIpb
	 lRtVfWimiS7lu2HSWqLdMmkoz/4WbZjnToegPlT+bQOQxjvaN1zF9aN1862X7Vy+y+
	 dFeNeJ2Iv9rg+ZAU4qHJZjvwZutJdC0UrbQ3eDo32MGC/LVZ/Y9Viazw5vrNaUIeun
	 5wY4mGfgPO4XeJObDzvjiNCBOt34sTd++HIhD7ksDhTIOugH7p/YGNctxQw2aBtJQB
	 paL5dPCTs5WwA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/7] btrfs: some optimizations and cleanups for log syncing
Date: Wed, 22 Jul 2026 13:41:36 +0100
Message-ID: <cover.1784656641.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Some optimizations for log syncing, specially for non-sdd mounts, and
some cleanups. Details in the changelogs of each patch.

Filipe Manana (7):
  btrfs: stop sleeping for one jiffy in non-ssd mounts during log commit
  btrfs: remove log batch counter use for fsync
  btrfs: do an initial lockless committed log transaction check during log syncing
  btrfs: check for log writers count first in wait_for_writer()
  btrfs: move condition for log commit wait into wait_log_commit()
  btrfs: check for exit condition after waking in wait_log_commit()
  btrfs: use simple booleans for log_commit field in struct btrfs_root

 fs/btrfs/ctree.h             |  6 +--
 fs/btrfs/disk-io.c           |  3 --
 fs/btrfs/file.c              |  4 --
 fs/btrfs/transaction.c       |  8 +--
 fs/btrfs/tree-log.c          | 98 ++++++++++++++----------------------
 include/trace/events/btrfs.h |  4 +-
 6 files changed, 42 insertions(+), 81 deletions(-)

-- 
2.47.2

