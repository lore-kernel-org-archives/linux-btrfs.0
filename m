Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A2B37CD22
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 16:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785115; cv=none; b=K8sKb8jXNpgQIUJDB7IG6kp0nxKD+g5R0S+N6G7E7+w+aZL/WruA1GNUX2mAqOei7WpaQs0wFI9omYgFbUU+2mmglxSS3tViisiDJgt7csF74OiRKvk1/KpLFE+YCjkyhx7O2AtFFR2f+YgqGUXEIrLp6YbC4utE/H98PmQlWO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785115; c=relaxed/simple;
	bh=rqmjmgvT9TN08aInRnbnLLc2RGPeXmnBM232Jph5mBk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=REyI9IXt6dagkG31+JSOs5ofqWRpD/zfIAvum3u0kHTKWkwX0JibkQkA7zBVhSwcewZahvdXK4eYW3OBRS72egjdZrToLAJbgbfp+JDfGET8Ll40pI7yZUFWVzHXvXcttQwQi9NPbEZ21I7gxnLS9C8VvSOL3ByPpo1ZmlBi+PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YZE7/tTU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YZE7/tTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3518C1F00893
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 16:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790785109;
	bh=aXzSYLgTEj/Gmbf2dC1+cg0LKb93weX9Qfg4WqIFHIA=;
	h=From:To:Subject:Date;
	b=YZE7/tTUDsN9r5voJqCnLVfwSOv5/kPAFo7oij8Bqxpx7pTUjYRn5TzYXsczQ/xVe
	 TU6PUNdR1muPliX2pQmeYN8Rz+NRpX8BwPGZLFBJEsnnz7duW29SL5wVjL0oW4Fp/Z
	 KNxWuU+djT3+W+BhbIyp8AS+Dni7Cs21e1izSzl6ZuO6LQJOgLsK5iDkoX4B/JfaVz
	 V3yELFtMzGzdJ2W4a7FuAp7xcyHAKROnnDO7KkyDQfK2knED9gqSXOPqvQKIHsUpEf
	 f9ZWsUDOrwIMh+tt9UWJleO1nDM7Dk86a7uITG+/x5l0m95tEf5eVw1vGgPIGqupcx
	 cr5oC2GV8Uoww==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: remove unnecessary forward struct declarations in volumes.h
Date: Wed, 30 Sep 2026 17:18:27 +0100
Message-ID: <0be3914031faf9bf34dd86daf884e42f7352d848.1790785074.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

There is no need to forward declare the structures as their definitions
are brought in by the include of the linux/blkdev.h and fs.h files.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/volumes.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 337d7007d9e2..6eddda239221 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -24,9 +24,6 @@
 #include "extent-io-tree.h"
 #include "fs.h"
 
-struct block_device;
-struct bdev_handle;
-struct btrfs_fs_info;
 struct btrfs_block_group;
 struct btrfs_trans_handle;
 struct btrfs_transaction;
-- 
2.47.2

