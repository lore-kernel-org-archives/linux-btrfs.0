Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33BC318BBAE
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2025 12:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758199344; cv=none; b=Ij9AE2fPGL5yLaUpfjGQdijwTMRnPjZ6FWmzJ+XXFxzmmUZJTJRgAk78uf8QdRyFAi8DSjmTBCT3ZZgDfh+KI9otRsR6XlMh+E7eFFyW4WnD19JR1J+M+hCpxYFso0uWEGj2ReOZpy1FCpMth7N9yZbdYynn7TbgIbrpZkuy4nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758199344; c=relaxed/simple;
	bh=XByUASUNktAxd/LpCdBuJpyehi9Cvy92l9AnaySwaZg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=LdYMl/zHNSUmGE+asDdA//LOIECe8nDgKM3siH8nnVXai0Llb1ShSA11q8+ndsn/rCHVM8wUAzsHLzT7DbXN2MlBM4IJR+iY/tFJkIiKrLdcgJNqgLYBp/nQnMmaiWtAEpbGZaYz7SrljEUZ515FUZrSnn7+YCPm9bGxeoz0/ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b5fuM87I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b5fuM87I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39AA4C4CEE7
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2025 12:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758199343;
	bh=XByUASUNktAxd/LpCdBuJpyehi9Cvy92l9AnaySwaZg=;
	h=From:To:Subject:Date:From;
	b=b5fuM87IteQJajZCZgZwbxY0kqAegJ9w++ewL4X+LAts7TNAFr5TKowVljNzMfA4k
	 6U18UwlAlt+7mzJYvDLtvEjf1XUndeUZTz7DxtZyhLb2/+STjpz7PdZBBpwBOiw6aW
	 fa/TIBbKMhoUZYhrodLb6rSYwJR+meUkHksG0HZLAkfQJDTfkHWE6jE53ZWDwWtLty
	 oSHz1E8euDcktTINoLfk6Q1Ffo7hnFMoycnxtepte3SrWIlQvkWSG5BNEL7VZlRgzC
	 ksu6bH4RnHwA1hSXwamiEjSSwh69apesZBwXhMfOojw9dGTYoFOACoocvUv8PdKE5e
	 rvUEK3K13OQEA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: a couple cleanups in replay_one_extent()
Date: Thu, 18 Sep 2025 13:42:17 +0100
Message-ID: <cover.1758198953.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Trivial changes, details in the changelogs.

Filipe Manana (2):
  btrfs: fix comment about nbytes increase at replay_one_extent()
  btrfs: simplify inline extent end calculation at replay_one_extent()

 fs/btrfs/tree-log.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

-- 
2.47.2

