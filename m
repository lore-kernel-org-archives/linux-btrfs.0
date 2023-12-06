Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419971A29C;
	Wed,  6 Dec 2023 10:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kGpIWuyS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D521AC433CD;
	Wed,  6 Dec 2023 10:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701858286;
	bh=7awaOdln7WxQcIXK8E6KA2bDasWPoO0iZw6EQYviMIw=;
	h=From:To:Cc:Subject:Date:From;
	b=kGpIWuySOvkORiL75WOJGCulSzMX5yLEeMP5hCbS/zVbrWGXAOe5lJGMw9AvCON+r
	 7RCvA0gJXl93GsUZKrySPr8NQdHRxLiKy3xsFA+YGx9bTxQl1Rm01Y79diOwITOfGw
	 p8HJbqRJHYVxkO0TSjVYy9Mz3gXcPN8I9IwWy5bZgsS7VF99y2HBe2m/qy9KGyuetA
	 2xRfyNDAlaz16aHycEMuShH08fSQl1LJHMwpSvuZr1sS1nsrlB+Mo+ZXstJIV3LV0S
	 3OWuddAETNgZ1YiTA3ETGsj5V1Y1oUi44HDgT8PFdDXJv0u+sJx3JF0alpDfa1KwuZ
	 eldrVo7cj+sDA==
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] btrfs/303: add git commit ID to _fixed_by_kernel_commit
Date: Wed,  6 Dec 2023 10:24:44 +0000
Message-Id: <a61891b7afa408c39921c2357d00812292068c9e.1701858258.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

The kernel patch for this test was merged into 6.7-rc4, so replace the
"xxxxxxxxxxxx" stub with the commit id.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/303 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/btrfs/303 b/tests/btrfs/303
index b9d6c61d..521d49d0 100755
--- a/tests/btrfs/303
+++ b/tests/btrfs/303
@@ -15,7 +15,7 @@ _begin_fstest auto quick snapshot subvol qgroup
 _supported_fs btrfs
 _require_scratch
 
-_fixed_by_kernel_commit xxxxxxxxxxxx \
+_fixed_by_kernel_commit 8049ba5d0a28 \
 	"btrfs: do not abort transaction if there is already an existing qgroup"
 
 _scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
-- 
2.40.1

