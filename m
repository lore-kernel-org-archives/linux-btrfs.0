Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4222534C83D
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Feb 2026 13:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770123756; cv=none; b=F2UHMds2JImArFyBKabAT8HkGWs1ZStN+mAdB+Ik7vx0lXygYRhw26tpgdTuOVW77T/bdFf1kComlXq2rQ8Zd/us6KTAbXoPFwQcY8vypBsf0zJyPgcmfhso7npCtnADP5t7FlfzEsAl8kYEetxyUw0TTfTtvLCUZoR58DHdJ6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770123756; c=relaxed/simple;
	bh=H0zkurIksZz2m4/JIc/Dij4WF2zuHgMZrjfGKpJpuns=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ken52oksXEm4dC4Hl8SWvZtY28+wn9NzJmF5DW8SvGN9FgyZUQ6iMHXrXrZpHE5BEJkYO4DoDb4xcxwrAqtXuZvTPj6ZcUKftm82jTGzu0QsBHIbXI6LvrF/gjmLD5YWy0kPI7mRco8Pat7ug/keq11hs7ErCnKuwjwT6BcBsJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aUP0qg3U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aUP0qg3U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5961DC116D0
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Feb 2026 13:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770123755;
	bh=H0zkurIksZz2m4/JIc/Dij4WF2zuHgMZrjfGKpJpuns=;
	h=From:To:Subject:Date:From;
	b=aUP0qg3UwqCNlCHwVf89hMnSyvq/myVP8fJ+y5gnFPzx2wU5Fyb90LxhrdKkab23U
	 5BaPuRPAM4tYRLANjQLMLVhPAmeNYJRZV9C/pRUd/PZ4zjHY7AAaTfndTq+1MDJIA9
	 UOoaHMs0lVEXQvlwRVqzWhqCoW63fAfcZy9OzQGi5M3akOZuxIbwCWZYMuylL2sMxT
	 oRIiPTDcJ4kj10Mbdo3wxv6kbfJzLfWZCReJRSeQwHf28U/AKS9Af0TlI0JoT9s5Pl
	 f4PTJKZ+6PzBSHUWtzKYcVZRKKD7pec/TZfRZoKaLx39f/2w/dPRVyXDZwnRiGub79
	 t/Qt1Y5Fspm/Q==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs: a few space reservation fixes and comment update
Date: Tue,  3 Feb 2026 13:02:30 +0000
Message-ID: <cover.1770123544.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

A couple fixes for metadata space reservation and update a comment.
Details in the changelogs.

Filipe Manana (3):
  btrfs: be less agressive with metadata overcommit when we can do full flushing
  btrfs: don't allow log trees to consume global reserve or overcommit metadata
  btrfs: update comment for BTRFS_RESERVE_NO_FLUSH

 fs/btrfs/block-rsv.c  | 25 +++++++++++++++++++++++++
 fs/btrfs/space-info.c |  7 ++++---
 fs/btrfs/space-info.h | 19 ++++++++++++++++++-
 3 files changed, 47 insertions(+), 4 deletions(-)

-- 
2.47.2

