Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C74715624B
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2026 19:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773776830; cv=none; b=PywwZPs37VkzTX6yMcqn42VZLh3OnEz53PTysBK+ZJYVpozTtQVjpmQpwPAxMFjM580aBGFnEVrWjJp0CLNgnbt/wmHyN+n6cPcN01re3trwWKy8rirQNHYARWyJEOEDVXJo7trCyvCcrAKj3MPFokm3KAhpf+Pren3whjn4KMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773776830; c=relaxed/simple;
	bh=C1PRD0GVD/Z5nHa/yNbrwxiINqvm46TxagVPUe4+Z7M=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=jGpw8eyO19obXR0XtNxxd/q5EWj7rWA7Jox4XzGz+ENk9zY+6soHvuYkBzvSKGIAvztJ+DOtWwQ7o7YU+ZBn65CnnOj5kmYdX4ActCKYnmaS4QNWMosg1LlN7SiA0d/zYVpiknnLZtt07/jZ4/Q88Fh8VGivu6AfOv4pH/THoPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M2y+3W/c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M2y+3W/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE51C4CEF7
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2026 19:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773776829;
	bh=C1PRD0GVD/Z5nHa/yNbrwxiINqvm46TxagVPUe4+Z7M=;
	h=From:To:Subject:Date:From;
	b=M2y+3W/cEhYqn+C9Pix2dlzWDb6+spAIxe9PkU5nYDlJ0Rskj9xpvxA6VMRncWM3r
	 BkwiTJo5o670ecURSUwT/UKC7JMyYxNbqgOhYg/7D15/KTPAwmv9IGnxkFxTDgiSbD
	 RJIdGkF6nEgnXBB9dZVqwt9LL9U6pefbF5HtVBreiFqEnPXlYg0hWFIGTf7eu7hXHb
	 f/3z4cEPNHhxtFtvafMh3N/PtIG2wmdEXl7lifo+UJXut6xJyVy+errVnyjbzwKYNj
	 BzAeCTwTMCNtgaH4gv92rsU8YbHg7tK7sySovgYRgBWZcX4z+4OAKH3Tv936LWCZ2w
	 Wix3gIHz1V+5Q==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/4] btrfs: qgroup API cleanups
Date: Tue, 17 Mar 2026 19:46:59 +0000
Message-ID: <cover.1773776354.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Remove some unnecessary qgroup functions and exports and make the API
simpler.

Filipe Manana (4):
  btrfs: removed unused qgroup functions for pertrans reservation and freeing
  btrfs: collapse __btrfs_qgroup_free_meta() into btrfs_qgroup_free_meta_prealloc()
  btrfs: collapse __btrfs_qgroup_reserve_meta() into btrfs_qgroup_reserve_meta_prealloc()
  btrfs: unexport btrfs_qgroup_reserve_meta()

 fs/btrfs/delayed-inode.c |  3 +--
 fs/btrfs/qgroup.c        | 27 ++++++++++++++------------
 fs/btrfs/qgroup.h        | 42 +++-------------------------------------
 3 files changed, 19 insertions(+), 53 deletions(-)

-- 
2.47.2

