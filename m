Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9FE27C17C
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Apr 2025 14:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745418007; cv=none; b=B2jPL8H93Y8MUVRa2yhwGQVNSIbqbnkfT5wcM5OtDBKcTO1X19AfsPkthkV5a9U9QfMkmnYzsRTZEu6SHziPYBMpLbaqigw71o3mKgW9DyzPg/QsD124MVPH29hzcDAPa1eNlAtae5p94XJtMF0RsDZYV9fJ+TP/Tw7XIWQ9XF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745418007; c=relaxed/simple;
	bh=H3qm7MuOqBQSofAobB4VTDGfnoy8cn+XsaXiGfooDVs=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=Ki0hccdFet1H6zYx6LzbyW8PQJZi+SJXJreTipfhu6K6LfvVImXGFq4c9NhEa73D2otXTs62PWCKrhWmIm4mipHZ/fcGUWYifSA9pyP4Ng/e1wbSxl6MNP03K4njdurpbNZFYlAYVXcYKsw8oBSFMt15MRFle1Rn7wOb9P1PJ5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pk1Gj84U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pk1Gj84U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9A0C4CEE2
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Apr 2025 14:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745418006;
	bh=H3qm7MuOqBQSofAobB4VTDGfnoy8cn+XsaXiGfooDVs=;
	h=From:To:Subject:Date:From;
	b=pk1Gj84UENwtI63BdmR6U+Vtv2jrAbapPVyvs7ZEyPvatiZcU3VAPU+kmfAfr+S8R
	 PctMIYLZjPaxrAFe6baRsmYNGK1RuMHQK4D7WS/aMTAX+FTsSObnD8Yk/Wvhn8sans
	 qa2sPDC2s4WssSLzodTPYOWUM0JVBjJiASD+/luozLI8zW6/mEuyMmwRzLJkYemzSk
	 waxZFMIpKDNBmlxCnUm/jSjq9yVWK37YmIxn8i7EyqOGyv0+h7oK8vpdAT4PnNxEYm
	 4EJVuLPEgbyWAgjKrM1b8VsDpwOXECpCgzCrlpXh5GAS3Lek6jl+aM6cFGBFU6nP60
	 sCy2vdIf0kOoA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 00/22] btrfs: some io tree optimizations and cleanups
Date: Wed, 23 Apr 2025 15:19:40 +0100
Message-Id: <cover.1745401627.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

An assorted set of optimizations and cleanups related to io trees.
Details in the change logs.

Filipe Manana (22):
  btrfs: remove duplicate error check at btrfs_clear_extent_bit_changeset()
  btrfs: exit after state split error at btrfs_clear_extent_bit_changeset()
  btrfs: add missing error return to btrfs_clear_extent_bit_changeset()
  btrfs: use bools for local variables at btrfs_clear_extent_bit_changeset()
  btrfs: avoid extra tree search at btrfs_clear_extent_bit_changeset()
  btrfs: simplify last record detection at btrfs_clear_extent_bit_changeset()
  btrfs: remove duplicate error check at btrfs_convert_extent_bit()
  btrfs: exit after state split error at btrfs_convert_extent_bit()
  btrfs: exit after state insertion failure at btrfs_convert_extent_bit()
  btrfs: avoid unnecessary next node searches when clearing bits from extent range
  btrfs: avoid repeated extent state processing when converting extent bits
  btrfs: avoid researching tree when converting bits in an extent range
  btrfs: simplify last record detection at btrfs_convert_extent_bit()
  btrfs: exit after state insertion failure at set_extent_bit()
  btrfs: exit after state split error at set_extent_bit()
  btrfs: simplify last record detection at set_extent_bit()
  btrfs: avoid repeated extent state processing when setting extent bits
  btrfs: avoid researching tree when setting bits in an extent range
  btrfs: remove unnecessary NULL checks before freeing extent state
  btrfs: don't BUG_ON() when unpinning extents during transaction commit
  btrfs: remove variable to track trimmed bytes at btrfs_finish_extent_commit()
  btrfs: make extent unpinning more efficient when committing transaction

 fs/btrfs/extent-io-tree.c | 215 +++++++++++++++++++++++++-------------
 fs/btrfs/extent-io-tree.h |   3 +
 fs/btrfs/extent-tree.c    |  68 ++++++++----
 fs/btrfs/transaction.c    |   4 +-
 4 files changed, 195 insertions(+), 95 deletions(-)

-- 
2.47.2

