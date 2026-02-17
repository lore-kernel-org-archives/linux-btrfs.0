Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FD336F420
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Feb 2026 18:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771352850; cv=none; b=ug7TGSa7H0j1FVMEawIolMoux4qb4rlhwfre2Tpok6EW+vmF3Aa7T4LV1mZI9L6faX/U2cFl2Xa3/6Q/woKlbc1ZLJN983v2pWHP/gm3pXWP2q/xjo9GzNQEEO7rY8rLcsmYVTmaIe9ZMFb8wFvqrmrjVEoWTVKze6Y9Dx1g85o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771352850; c=relaxed/simple;
	bh=GXq2eCYYLqcaZ1ZNuDvjSzZYmym5a4v3eZS2EsxjHBI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=WQSQDV1U0fIN07L147kISJqz350X5OAbAKe9Dg6E51Uyy1OCZ+s4ZZC3ORC7jishdc9oGcasnAuxG24tEL5yjag+5hl4KTGbPyP0CNa46vUfAIgUm9NxM6UWKkcecw5SQ1BhMYpZ0/nh7rgG1gg3IWo323fb5b6uK0FGmbVkITc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jRKgTcEo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jRKgTcEo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A435C19425
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Feb 2026 18:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771352849;
	bh=GXq2eCYYLqcaZ1ZNuDvjSzZYmym5a4v3eZS2EsxjHBI=;
	h=From:To:Subject:Date:From;
	b=jRKgTcEoQ8J4fr1AMfyE/NHXWk7031ljpLb2Gl0Gux2k1wqquRmd9mdZI3xkWK+nC
	 8RW5qkpJiZ1LUMTutIjHH/SEUfdP0cfC12j94VIj5605rXM25qRjBvWfQoBhB35WLu
	 B67mkimVkvgbAetd4zwE8ANaZYayZjDUUXSMaqo1zkUoqd0VG5UtxLWTQj6Jc1n5bK
	 +lk9VZxV6BUvC7E2ntlU0W/svCO6rHC8IBvom8iarboREwrOEd63ipAG0XmlTRZ1LJ
	 daM7q5gTgE43PTIcUJRhSrZE3Wt9ZcZnKrQ9TwZfrZcx309ZZmwn2no8u0Yya7nO0H
	 g+DSMBpuPuesg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: fix log replay not persisting a 0 i_size
Date: Tue, 17 Feb 2026 18:27:24 +0000
Message-ID: <cover.1771350720.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Fix an issue where if we fsync a file that got its size truncated to 0, we
may end up not getting an i_size of 0 after log replay if new names for the
file were also logged. Details in the change log of the first patch.

Filipe Manana (2):
  btrfs: fix zero size inode with non-zero size after log replay
  btrfs: pass a btrfs inode to tree-log.c:fill_inode_item()

 fs/btrfs/tree-log.c | 140 +++++++++++++++++++++++++++-----------------
 1 file changed, 85 insertions(+), 55 deletions(-)

-- 
2.47.2

