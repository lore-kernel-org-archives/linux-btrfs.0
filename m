Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9006F48FF7D
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 16:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789576688; cv=none; b=AXTqKGL968Xv8oRaMaV7Ou/DuF1d5QXDSO2AXDxAKum/WSXB9vSttlTG4jLExrM/KhCJZLAXQ4gCbFXYCAGhkbaHkehiGgTfZBXlf8J8pAHFjttEKxNaPOX/YmLB+QbVKsa8bxhCPTh0fyYhgHdBUqkDHwsFpWblSq+Z/eHJHSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789576688; c=relaxed/simple;
	bh=HYuytOrDsvCkND80ZaYMpDoPT609DTVkYopVVqhgRLo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=B0BHU8jiVd5hFic8GPa7zvY1RwAYRfftgLbqqsrOIA0yxSrHdQTy4J0JP2qiZfwNCt9ebb04v6a5bvVuW6I5QnN+omxTAQ7IJmpxd2f/yddKde01KMPZz0Z2OA1i8EKh1mY+eOnoxKrAcGjtSD7xl997l5XZ7ILP2/QMi9+hg0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BDcNrp5Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BDcNrp5Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB7681F000FF
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 16:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789576687;
	bh=/2hCCKw3JUKt4znklCD4236SatYuUtcze+cK+GTEUxY=;
	h=From:To:Subject:Date;
	b=BDcNrp5QMpcM6EeFHXvA7unNRawHYX1k7RsWNLiY2MpcntYPX8fYTdz9y+hAbWzEm
	 zQZfAqbIg9Ime2pAX+/OF+RTCPWq0xeZgaIldR5x6q+JdYsZChNw7ianklF4hgLivJ
	 8PJduvXWkk74wV8klFXMZcmEL/eDKfbbCVDXxdFr4WrhUx3G+r5r17+e0bn3jAO6/x
	 EgleUnyguzAUj7Dq824jR4tOXxDKnTNOoYNgKWqxnSvS0SGDUbI7aZtnw2uxVjNtDD
	 FxQqBX2zNUic8XrzxbxhkwyXJVG9uYFRb46Lcn21egz2/OQEiCbLqnQQyBsOjmUseg
	 PgH/a89SA06Kw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: remove duplicate error message when writing super blocks
Date: Wed, 16 Sep 2026 17:38:04 +0100
Message-ID: <9621b3d58ea4af3cece1e00894d0241233fdd59b.1789576649.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

If the total error count is greater the maximum allowed number of errors,
we print exactly the same error message twice. Remove one of the messages.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/disk-io.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 161a7b9bb27a..a8535e309b57 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4228,8 +4228,6 @@ int write_all_supers(struct btrfs_trans_handle *trans)
 			total_errors++;
 	}
 	if (unlikely(total_errors > max_errors)) {
-		btrfs_err(fs_info, "%d errors while writing supers",
-			  total_errors);
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 
 		/* FUA is masked off if unsupported and can't be the reason */
-- 
2.47.2

