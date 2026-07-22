Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FF4388891
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 15:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784733895; cv=none; b=fXidfVmAklpQaanFuyoEbUjIGYdDH/oobkFqqYEmaaXnWlO68CXcRgOMMCXACqMVFwNb7HpXG3Qv+S6qRrOFX2Ns0S4sVwgn4WJh0JpMoMYOFxds+L2wbG+njUxPFF6rkOzuSqIxIzPihzxOd3exSwGqtdi5o2zwuR+MoKUJLtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784733895; c=relaxed/simple;
	bh=QhgOmE1aK69Y9N0BqWt0dHI/NqIFmdZY2WedkWFXr18=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PrbozZoO58oIabekDxkYoq/QElF3YQF67TEaGR6XVAdemKQevMd4KoA0YD4Zz/beJoM6ji/5KNR3Ba7/9ALh/kgXM8HzcmDvjS6lNTL/A6jkyHddXYT99mPSU0444GqdyQcsGCNt+JZab3Vy8B8zckSV2x+bD+FefXnRVUhg1uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WE02nEvy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WE02nEvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992911F000E9
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 15:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784733886;
	bh=34jIwt5LObOdUxyafjPTTjZGrBE0iESAklDbnbXCpak=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=WE02nEvyGiTGNvesgxNFgeAaC0zsJL15rvm4MSC1V61qOsziPakY4bINGXWDVEZW0
	 /DjKcjFaj4WoPSBPUl23cKaB5XR4fqELfDYGUMnl9hkzqAXUWMPHGjWoVJBr9kG3dE
	 L0DZQ2zPXsem/Bgle/VlAF2NFIxM4BlOpgsFX+XAZ5ndHpk425G7CKyDjYSjbLK4up
	 z3W2Zs63v+IsMgqXn/Gmt2MK8nU+jv1xXPXesS3pb+1Mk/1iM0MsGH/AJF/5K71x4N
	 FgUZUYB/s3cJsnWeNJZPrF1g1YOta28acBaEJzE3VojO3x0Z7fwl3IkLCWGn8GHko7
	 cHC/vS4Qo8jYQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/5] btrfs: some optimizations and cleanups for log syncing
Date: Wed, 22 Jul 2026 16:24:37 +0100
Message-ID: <cover.1784733395.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1784656641.git.fdmanana@suse.com>
References: <cover.1784656641.git.fdmanana@suse.com>
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

V2: Removed two patches which sashiko found problematic, the benefits of
    fixing them up versus the complexity required to fix them is not worth
    it. Updated last patch to add the data_race() annotation in the trace
    events.

Filipe Manana (5):
  btrfs: stop sleeping for one jiffy in non-ssd mounts during log commit
  btrfs: remove log batch counter use for fsync
  btrfs: move condition for log commit wait into wait_log_commit()
  btrfs: check for exit condition after waking in wait_log_commit()
  btrfs: use simple booleans for log_commit field in struct btrfs_root

 fs/btrfs/ctree.h             |  6 +--
 fs/btrfs/disk-io.c           |  3 --
 fs/btrfs/file.c              |  4 --
 fs/btrfs/transaction.c       |  8 +---
 fs/btrfs/tree-log.c          | 85 ++++++++++++------------------------
 include/trace/events/btrfs.h |  4 +-
 6 files changed, 32 insertions(+), 78 deletions(-)

-- 
2.47.2

