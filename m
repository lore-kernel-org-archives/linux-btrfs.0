Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF253B8BB5
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Feb 2026 14:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772116451; cv=none; b=f0PGRIUF51r0mJuRmRABMsdHBsBT9hyuhfUz+w/O1lQZq/pxoKDJfwvR+1W3Wt+Kkfdb6eav7tq7C7aHfIrp1ndl1crJdRtDZlLGyU7d4r8ax1HAbBqwTJ6FY2SGPuZ+bWsHpn5wLfYqQRKkOgyczNmRLqxoBdFVfrS0CZQq9/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772116451; c=relaxed/simple;
	bh=HmyzvG65nrH0nVXFJ0/g50Ouag4hINC5RjNaCS2AG4U=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mdAj2MdmOcXfzkrC0njAE6SlmbjwHADW40DHnoZ6YKvct2UthL076fQYMYG8iNw0EgfUp1Qe2tR4cR5JXVcmAs/tX/ekXy+rBG5ktnihedjAizuCiNYcHrfF3g1jm9YmzAW94FqTKJ3khidapn5DiiIgk7xhpQmWj07PVjrx4eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S3sM5fv8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S3sM5fv8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D383AC19422
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Feb 2026 14:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772116451;
	bh=HmyzvG65nrH0nVXFJ0/g50Ouag4hINC5RjNaCS2AG4U=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=S3sM5fv8rP/VrAD5G+lQ3UFbT2SYRboJxwh0hnidIgNBf008sXdMvz7ydMnWs4pPh
	 dywYO4R1DVPo+eSUb3YhXtMulXGUPYl4bBVnvpxbKNAN45tzpoMas2f7MUBFk1myrv
	 XZ4Y1Z4Z59phAIjoSgtBFry2Hnzn31OlHZ+vfqyE8LsHvankx3S0rcxKk5AHFiTdep
	 3VUzotASk5CMgBb8fWknJtyCeABRYhK0hdw0hg0S0Ks+o/3LIJPw2KqIdTwJLoGBMW
	 E09ISn7sXbVsrGCiacCo7P3lxNPhICnwzu+V+/2CB3zXdF2GN+z/6qDLtozJSI6lqJ
	 NwkBd+bnzkobQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/5] btrfs: stop checking for -EEXIST return value from btrfs_uuid_tree_add()
Date: Thu, 26 Feb 2026 14:34:00 +0000
Message-ID: <b6c668479a3a2e2a1406c8caf44014a3bf3e2510.1772105193.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1772105193.git.fdmanana@suse.com>
References: <cover.1772105193.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

We never return -EEXIST from btrfs_uuid_tree_add(), if the item already
exists we extend it, so it's pointless to check for such return value.

Furthermore, in create_pending_snapshot(), the logic is completely broken.
The goal was to not error out and abort the transaction in case of -EEXIST
but we left 'ret' with the -EEXIST value, so we end up setting
pending->error to -EEXIST and return that error up the call chain up to
btrfs_commit_transaction(), which will abort the transaction.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ioctl.c       | 2 +-
 fs/btrfs/transaction.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b8db877be61c..e5cff9c0616d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3974,7 +3974,7 @@ static long _btrfs_ioctl_set_received_subvol(struct file *file,
 		ret = btrfs_uuid_tree_add(trans, sa->uuid,
 					  BTRFS_UUID_KEY_RECEIVED_SUBVOL,
 					  btrfs_root_id(root));
-		if (unlikely(ret < 0 && ret != -EEXIST)) {
+		if (unlikely(ret < 0)) {
 			btrfs_abort_transaction(trans, ret);
 			btrfs_end_transaction(trans);
 			goto out;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 1a0daf2c68fb..c6a2328b6a22 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1918,7 +1918,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 		 */
 		if (ret == -EOVERFLOW)
 			ret = 0;
-		if (unlikely(ret && ret != -EEXIST)) {
+		if (unlikely(ret)) {
 			btrfs_abort_transaction(trans, ret);
 			goto fail;
 		}
-- 
2.47.2

