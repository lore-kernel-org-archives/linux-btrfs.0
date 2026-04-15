Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C774D2C11DF
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 18:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776278703; cv=none; b=RPIGgkGgta45kstPYH4O1wBL8jUS40mA3kz0NYqbCKWvKoBiKcpDLYsLs7HpbW8Bedv7dpxlTbc0gnfVxSMeRW1dvCkajqH0z8uyqcJU/mfkDw9sWDcMC7fIXM5qRrioMR88niu2m3Z3hJfy/IEECJzmH+t2Wq0HYgKprW9X7Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776278703; c=relaxed/simple;
	bh=rlRN+RZnUa+eV5aQIB8Q2SXDLklbd/O8u6oxBVQpYJ0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vE5+r6TynEB1e/2yGx8ze6PQZOdTODQsDN8CRc7MxmfSZihEeKpsQQM/+mq/6W2G83qsK9E295D/yqdODPJLYC1Hfbyk08UidaHJ+Fqsv4XtoepTAZKza6am2Ub5eNgckOckJd7JdrOLAJILbSHVrGRZUsCn79PobthRZCZqDFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QnNQezn6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QnNQezn6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE49DC2BCB6
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 18:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776278703;
	bh=rlRN+RZnUa+eV5aQIB8Q2SXDLklbd/O8u6oxBVQpYJ0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=QnNQezn6mp37tQec9ub/9xILxSmY8fXF5PsQsNHYTMXV4sncZo4lMoY8XJyygHawH
	 HvpX5sQUG8uN2D9enm7gDu4RKR66NMlipA1jFCsVSV25lBVmgYxRx/azfTuhWFrC24
	 Pl4zYbqjJjdDgSxXOHvSnfuZYZy2zZxuy3QV7Dmef/GNI/m+vkXoM364pLTAJ9QviQ
	 ylUwRR3QFBEVEgfKs9aA09byvQ+dJNEWJC/qePWHkToDjRRWbMYJ3qZVmAwAlJNNeN
	 OaxRX1ROuoLUeQt1h/IT8+RUhNP26l4555ozl2stdbE5BdNrM/TRPUoTxSAHktdMbO
	 H41rZjvgA7RYQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 09/10] btrfs: remove unnecessary ctl argument from __btrfs_write_out_cache()
Date: Wed, 15 Apr 2026 19:44:47 +0100
Message-ID: <06f81916ec34d7825cd09a010d12e1884c9ca085.1776278490.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1776278490.git.fdmanana@suse.com>
References: <cover.1776278490.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

We can get the free space control structure from the given block group,
so there is no need to pass it as an argument.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/free-space-cache.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 5ede85cf6c69..76d4b7eea746 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1367,10 +1367,10 @@ int btrfs_wait_cache_io(struct btrfs_trans_handle *trans,
  * or an errno if it was not.
  */
 static int __btrfs_write_out_cache(struct inode *inode,
-				   struct btrfs_free_space_ctl *ctl,
 				   struct btrfs_block_group *block_group,
 				   struct btrfs_trans_handle *trans)
 {
+	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct btrfs_io_ctl *io_ctl = &block_group->io_ctl;
 	struct extent_state *cached_state = NULL;
 	LIST_HEAD(bitmap_list);
@@ -1516,7 +1516,6 @@ int btrfs_write_out_cache(struct btrfs_trans_handle *trans,
 			  struct btrfs_path *path)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
-	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct inode *inode;
 	int ret = 0;
 
@@ -1531,7 +1530,7 @@ int btrfs_write_out_cache(struct btrfs_trans_handle *trans,
 	if (IS_ERR(inode))
 		return 0;
 
-	ret = __btrfs_write_out_cache(inode, ctl, block_group, trans);
+	ret = __btrfs_write_out_cache(inode, block_group, trans);
 	if (ret) {
 		btrfs_debug(fs_info,
 	  "failed to write free space cache for block group %llu error %d",
-- 
2.47.2

