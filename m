Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1DE02868B5
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 19:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782415221; cv=none; b=MhwpxH51vzCC4HgSOdiwUG0JyZcCt1h31IcwLW3KreCjnJmd8fstTM3kEO+TtlNnbxz6CnFJN9W/MJhGBV1TQ5ZVibC8USp71OEeRCIxwEwx148kLghsz8aF9GZhjNNUsnSRaE5kppXnJC4IqGQF+4CKP5u9lxMUWqGasDyWksk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782415221; c=relaxed/simple;
	bh=2XyKSk2DJaJZc3sUdOcCSLuz6RPoiWz+bsIO/qnfV00=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=g4aMM7BBtTggYpN3NnNdfgucxfZnzVy4A9wh3umJE5C7v8OFET+k4b58oAPKBvnOuHnYzE/+CtO3yPEbhpSu5ESSA6wG/sUPe/JU/gMaR6BYQ1l08lUdL7hT4TlaEp+vBXaTLsdaDrwrpuqoXtcYLhZm9xhKSojDtHVbdBydaFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nQJXGukC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nQJXGukC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA57F1F000E9
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 19:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782415220;
	bh=/JhqH096ycvfVS7pUAofU1NNuHLbjTp3M9uyHOs8KyA=;
	h=From:To:Subject:Date;
	b=nQJXGukCswTFQpI097M8g9oEnvZy6C1xXZjVlxMjTno+hX38S4tlP0CXUjiIKvcBz
	 aVVn5CNXl4bf0VDaRR61GL/s8LB/AZG2CWu8NiNW+mcYublrpdBG/Qjmif5evnA5Ri
	 EsHWd6SAVKEC6WFgrXyHC1g9vqnFO6X3FU4ID1BgNKgtPDF1wYW6eZwQa+bL6jzSq6
	 uiz6QH9JwZmUi2444EwE+u8dqudXtRk/NTmupJEQO9oY1CmQh6iMnGRyJQvjVn6zev
	 tmsTOvIVqUumtaA4HH3REUGloTv1LYYXzf1fnzXbmdOZpMWNbqZQtxeTtKOZr4D7xA
	 vYwIY5I9gcnyw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/6] btrfs: defrag/autodefrag fixes and cleanups
Date: Thu, 25 Jun 2026 20:20:10 +0100
Message-ID: <cover.1782321584.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

There are a couple bugs related to defrag and autodefrag, one of them
reported by syzbot and the other can often be triggered by fsstress with
the mount option "-o autodefrag" (or fstests on random tests that use
fsstress with multiple processes). Details in the change logs.

Filipe Manana (6):
  btrfs: defrag: fix deadlock between defrag and delalloc space reservation
  btrfs: fix pending delayed iputs when using autodefrag
  btrfs: defrag: use a single list for each loop in defrag_one_range()
  btrfs: defrag: use auto kfree in defrag_one_range() for folios array
  btrfs: defrag: use simple list_del() in defrag_collect_targets()
  btrfs: defrag: remove pointless list_del_init() in defrag_one_cluster()

 fs/btrfs/defrag.c  | 61 ++++++++++++++++++++++++++--------------------
 fs/btrfs/disk-io.c | 15 ++++++++++++
 2 files changed, 49 insertions(+), 27 deletions(-)

-- 
2.47.2

