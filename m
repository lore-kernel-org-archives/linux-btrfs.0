Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4824FC8E0
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 15:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783262; cv=none; b=sEJ7jXSGmntGkfchCI7fSQSSgkNeHhYCqRotmbD57zXQImE5dm2hwCWAEii5NtmycqagUVdRguAyivERCfgZAbN2XdZzMx7kVc0hvJ78bOfzppw6+Ku4N1LCzWD5m0gqPbaaoTwBQuDpnGqTOLNnkM7BpakQb5W+rA8fjvrFpk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783262; c=relaxed/simple;
	bh=Y3dI8AWH8NjoslKdPF/reaV1JKlinJuIlQ07XhdgwAQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Ldu+SmYK3AHzfiLnIyowSQHvbAtXTj3iWAqQ741Pp2AkmAQ/5qjerA9Gv88AvW9IRiu04ddKd2mA1ZfcnTJ2pHXbhI0ZMtLO8QECVuWZMVUMezPp0RbMxGuAfx6qtSPiYoojbqwb2DVJ+1ZaH9KvQKTpc10HUAgs1lf+Iwz5t6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X1mPI2HY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X1mPI2HY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30251F000FF
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 15:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790783259;
	bh=4jW5NO9G2pnvRtdENhJhttIh8WSI+OxaQ3UceFpLUvA=;
	h=From:To:Subject:Date;
	b=X1mPI2HYzMxu5NDU8FYVAzbS1BMd/NERlZver9FfVQIhPcFtUIFo3rfj3AvodYaWi
	 XRBlU9Mv+750umbkAxTz087KjBLmENo4a/pG3Pm2k9Zw3eaAr9ZlMHkTJa/C5RpWbl
	 grhjvnXLulpE+YQnvWybBRW8e/svqP0vaNzrca1CYS0BEXrTiKt3VjLCGQ7IMhOOkn
	 OMc9RbdU/wUl3Y8Yp9F9mPOnbdfj71Mcqhpgr8WWwPLW4aCAQ0Mb4LfXjteOe8a1Mf
	 XPoFRb08zJTzzyVTrGjoYKgj4HJPZnfdMRcCrvJxKWMDuTTLaiyTAccOOcWT0j29sh
	 dMSSpUQu5T9SQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs: remove unused arguments and code in block-rsv.c
Date: Wed, 30 Sep 2026 16:47:33 +0100
Message-ID: <cover.1790783086.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Remove unnecessary code and arguments from a few functions in block-rsv.c.

Filipe Manana (3):
  btrfs: remove fs_info argument from btrfs_block_rsv_add()
  btrfs: remove fs_info argument from btrfs_block_rsv_refill()
  btrfs: remove pointless qgroup assignment in block_rsv_release_bytes()

 fs/btrfs/block-group.c   |  5 ++---
 fs/btrfs/block-rsv.c     | 12 +++---------
 fs/btrfs/block-rsv.h     |  6 ++----
 fs/btrfs/delayed-inode.c |  3 +--
 fs/btrfs/inode.c         |  4 ++--
 fs/btrfs/props.c         |  3 +--
 fs/btrfs/relocation.c    | 13 +++++--------
 fs/btrfs/root-tree.c     |  3 +--
 fs/btrfs/transaction.c   |  3 +--
 9 files changed, 18 insertions(+), 34 deletions(-)

-- 
2.47.2

