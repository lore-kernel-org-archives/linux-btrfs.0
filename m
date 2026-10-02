Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1E47DA66
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Oct 2026 18:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790967352; cv=none; b=Ttu2+sVL2dMjZkzuAoID2p3HOieRdhXIXMHZdD4ApI8pEIAvySiRQledqp85D6WwqyirfbcE6K+I5HLGKZYfNLLUSYSwSvx+Gz75WKIKpT2dxkXEYCbICd+FVdZC1QwmFlBVq3KJnhiTtceHaR9gfbtPLCB1mZZUBMvlBlbjdUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790967352; c=relaxed/simple;
	bh=BPsDV7Tpp+UfvrsJyJRGzq5F7qxU9cydhFuCWJbFmpo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=eEeq5hM5ik4/zfnZegvKK0w2qrkdvvgT7qu4aPgRjwSS2b5yZWLSSzWiV6xZEUyWOc/NWkFZPjjKmJ9Gm9WkMEuCXUdzEn6i8KkClmK1WvBl22KqMQGsmDoydHy5cP4xl0Z1SlifazjEPX3yrA6QZfphrACdNP5QElAkfim8kXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a/OZu+bu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a/OZu+bu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A171F00899
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Oct 2026 18:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790967351;
	bh=kqZYyhRIAdw9kGUYPnGsirlD3X0IJrGFp0aDF3cD1g8=;
	h=From:To:Subject:Date;
	b=a/OZu+bujJeaXD8wfp5z6pTuXvjwSDNxOdqD+NA6UQby1Ib1Y5V85YoQbWg+g1Ywy
	 BpWZSR7dSgc+o04A6TVBu67/OsHii3P/aBYL/kPLFxokiJe8U3jol/D7U6CnzoezBJ
	 V1GYEp3+4aXRyK/1csvTuSucDqxvCt0ChGsHIq8B5Z+YF7+ftCBGbwlLZL1Ibf1gby
	 KZfNqcIYfHBiRkFhkAc1GMZUwEpo2q2yWUF2tEZGiWRPvx/mLMFYXu3Va+GodJvHyj
	 0EV3dDprpyu6ce3Rcb2CD2wqaJ8wY++JxG7pM7Ic+8wrOeekPq+52aNyBh+yZbTzno
	 VsKKU19GwblXg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/6] btrfs: some qgroup fixes and cleanups
Date: Fri,  2 Oct 2026 19:55:40 +0100
Message-ID: <cover.1790967259.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Fix a few a bugs related to qgroups and some cleanups.

Filipe Manana (6):
  btrfs: qgroup: fix swapped blocks existence check when tracing after COW
  btrfs: qgroup: abort transaction on failure to add qgroup relation
  btrfs: qgroup: fix leak of qgroups in rb tree after failure to enable quotas
  btrfs: qgroup: merge error labels in btrfs_quota_enable()
  btrfs: abort transaction on qgroup failures in create_pending_snapshot()
  btrfs: qgroup: fix off-by-one max level check in qgroup_trace_new_subtree_blocks()

 fs/btrfs/qgroup.c      | 55 ++++++++++++++++++++++++------------------
 fs/btrfs/transaction.c | 15 +++++++++---
 2 files changed, 42 insertions(+), 28 deletions(-)

-- 
2.47.2

