Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53C933290F
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 16:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773677658; cv=none; b=S604XeYv6vykLGnHBMxaLazABGT8M8lwD9ZZpm1sphl8GqAOhXVuCLKNKJujlZTnGQJ9DNQ1BIIEYQoP+jJMCUdge+L0VsAxBjXAnqbiTL4l1MpvT2lSgEEqgswOUOP7+KZ2J4xY2uv1BATitwNKgQ5G2eW3KBgxnOfXc331h54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773677658; c=relaxed/simple;
	bh=/17ze4Rwwy1EufOWebVM6M+7ip+x7lv+//xXeU1da8c=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Gl9/DYyT5ov+m7TdNn58hNaaaJ7fWNM0cAw0g8MjRv4b9r06dDWdLXM+jfg8h/clJU5F4Gl4ItdGPU0o8SgMaOyuHFJk/a9504iKBaP+mwopluz4zMEQLgh3zhunYJO3cSb05x1DHVy2L1ZCUuxriRqUd4Sp/gPBz2jTxdTA1yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MB1S87Tg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MB1S87Tg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326BBC2BC87
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 16:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773677658;
	bh=/17ze4Rwwy1EufOWebVM6M+7ip+x7lv+//xXeU1da8c=;
	h=From:To:Subject:Date:From;
	b=MB1S87Tgp0EPHQ30lF5b1PqDK3vaP41sO1w8noJqcn4fCgBQe/GUzGuTXHJ9KrGnw
	 AXEn+biqYwdDSWZol2xOqrYwp0Im70vgWZHxzUqSmtwQTjH+Ha6qTHqb/nQkr6yfts
	 vUbpJlak+kDvfh4+g31rJsN7Jt4+LRhSvavb0MXCzJYfrlR8AlRbf4Rxe+8cv/ioF0
	 CDkJbgoXKwrtNcHUr+1X4/upafIxakXb8rKsLwSruI2+Uxo0dPViNjaFHBDHQYQHul
	 chs+wgNWjE7tpA7mtrMpvNv3qUclRSUWv24YXhzMChZvLMTozSCGBvMvANEpmZ+QQY
	 J5DzvqfTmcgrA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 00/11] btrfs: some optimizations and cleanups for io trees
Date: Mon, 16 Mar 2026 16:14:03 +0000
Message-ID: <cover.1773676775.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

An assorted set of optimizations and cleanups for io trees. The last patch
contains some benchmark results after applying the whole patchset.

Filipe Manana (11):
  btrfs: optimize clearing all bits from the last extent record in an io tree
  btrfs: turn extent_io_tree_panic() into a macro for better error reporting
  btrfs: tag as unlikely branches that call extent_io_tree_panic()
  btrfs: make add_extent_changeset() only return errors or success
  btrfs: use extent_io_tree_panic() instead of BUG_ON()
  btrfs: change last argument of add_extent_changeset() to boolean
  btrfs: remove wake parameter from clear_state_bit()
  btrfs: avoid unnecessary wake ups on io trees when there are no waiters
  btrfs: free cached state outside critical section in wait_extent_bit()
  btrfs: panic instead of warn when splitting extent state not in the tree
  btrfs: optimize clearing all bits from first extent record in an io tree

 fs/btrfs/extent-io-tree.c | 179 ++++++++++++++++++++++++++++----------
 1 file changed, 135 insertions(+), 44 deletions(-)

-- 
2.47.2

