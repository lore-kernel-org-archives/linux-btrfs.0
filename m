Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DBE231A07B
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Apr 2026 13:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776693254; cv=none; b=rIY0uN6/ORwg1ZDMe90xRDWtsVSAvsHAmws4F7/74JATzN+XF07AhB5qB3OYkooLUqjqnllq0UrDwpUxChUMzCKiZOfqVNJLrWabnJLbZ58BlUwS3e5Gl+u9dcYkFiheeHQgohE6MbjsnQmtNwXhKabDEL7SjiAUCLX72rTE0aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776693254; c=relaxed/simple;
	bh=XYRmpsrvDibZx5mdTk3unoAtH4tEIfAzsDari8wcUBw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Wri0wls/3FsEZGgKbQPIU+m/wfcUhBsBWBVGK8+Coo2KKCfp7bLz7+5holw4/YXRJ88vJu0DUxE7drcdcHudwtu3EX1b2DNyrVO9ilXABihKK+mIjaJxWxpQw1+z9L58/F4Mhgs+jBg+OEZ+sdsJ5k9dxDF2tRlu+6plaqQoQ0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U9/zgadf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U9/zgadf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B751CC2BCB6
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Apr 2026 13:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776693254;
	bh=XYRmpsrvDibZx5mdTk3unoAtH4tEIfAzsDari8wcUBw=;
	h=From:To:Subject:Date:From;
	b=U9/zgadfElvOvYei0zvaTREqiDK91b9YELhvUweGYRLgXQnHfefCiFjPISHLN7dMz
	 liWstqYzWuNYcSn9c6CwFmekwLgkD4InnEaR+neVWyO+zDMGxsZCvhyngcJNTTeztC
	 1MK/aNgTBqoLXh8ShoBMQ+GgEGsdT97WybfSgI6tIIB5YrQj9Q99UMqQ3hMuo+XQX0
	 E3A48csakt/vkI7T2CGbhKNtUzAG6mqzEoOnHehasGQBGSH4Y0EanYHnABN+jipRRP
	 aDUz4kLpJ5yHI2fERMubtEphlhABcCWeYiKxo0dKF43nLgQpYRw7XABrad4Jd0j7hh
	 xHs3FBCwXkfyQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: use the enums instead of int type in struct btrfs_block_group fields
Date: Mon, 20 Apr 2026 14:54:11 +0100
Message-ID: <085942c2ba1ec8fec438f49c6f8e2d6bb2011eb1.1776693204.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

The 'disk_cache_state' and 'cached' fields are defined with an int type
but all the values we assigned to them come from the enums
btrfs_disk_cache_state and btrfs_caching_type. So change the type in the
btrfs_block_group structure from int to these enums - in practice an enum
is an int, so this is more for readability and clarity.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/block-group.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
index 60a3b1c0a8ab..790c2d467af5 100644
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -171,10 +171,10 @@ struct btrfs_block_group {
 	unsigned long full_stripe_len;
 	unsigned long runtime_flags;
 
-	int disk_cache_state;
+	enum btrfs_disk_cache_state disk_cache_state;
 
 	/* Cache tracking stuff */
-	int cached;
+	enum btrfs_caching_type cached;
 	struct btrfs_caching_control *caching_ctl;
 
 	struct btrfs_space_info *space_info;
-- 
2.47.2

