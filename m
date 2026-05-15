Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0052F7F1D
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778864449; cv=none; b=XBwrNIp7XQsD+QkjdzMjCfJnbPlUWF4yQQwUUAnUXGuxWMZ5bIxNizhZI/Zsu7yvXf2WbNZAGYYXI66IxKE40c6+Rx0OLCxGijoCbJAruobxxaRgoJGNZU+Gbq+lazNu/8nhVm9w9GkvBekfhO9mFadWE94sKqpKeO90KUI1k0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778864449; c=relaxed/simple;
	bh=qg+/nP9sCRb9XS44zvt/6PH8e+b+TQQyUF1IK0SB7bI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eMghhNJfUTOi3yX8o3kwQN0IWTZxqQ24XuR6iCSDK8XGmFykgEUpgnBNb07ixJ5sTJyBGL6yMNHmYtw8T0PyRHXq21A5+k2wdNMMo78Y+F/PiM3IH4z1H+qn4ywIAm7RN+BkkoSjd5n7aP2aY6/Rzc1ceILhewqrB1o5lgw8oCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VOQzrPVp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VOQzrPVp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 178A9C2BCB0
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778864449;
	bh=qg+/nP9sCRb9XS44zvt/6PH8e+b+TQQyUF1IK0SB7bI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=VOQzrPVpZYT19DD/pvFuPj1eNrl8wwqJsJae9CCwrj99Y+WlcV/o1/GZrPvrn8F9b
	 g3LZTo2XvyGWtbLz5IMllfL/O6wo6EQFneh5UD1104xgoeExvLD5nVtN9GZznFMr8G
	 BGlF0WC35W/ln+ZZuLjUl2ejhz54CbH0a1PcBh34P89PavsQyKCZ4r9wGaZ7mRcrAa
	 9V8ItzLjVhIQ+F2I963+avlzBbnF2B2DZrtyx02egFei++o4lyg+LPskNUi+ZOdvuM
	 IvhgI9Al5kNzwbU3a95QVVUYYZhFjySLa+DOzO0kzn7pg0KjcFqpwUUkEMbxZNmr1X
	 chSftR3lMQf8A==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 21/28] btrfs: use simple assertions where enough during inode logging and replay
Date: Fri, 15 May 2026 18:00:18 +0100
Message-ID: <9febb56498a2c1c545b2ab5627d52d49584a4c1a.1778776707.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1778776706.git.fdmanana@suse.com>
References: <cover.1778776706.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

In overwrite_item():

  There's no point in printing the root's ID if the assertion fails, since
  it can only be BTRFS_TREE_LOG_OBJECTID if it fails.

In log_new_delayed_dentries():

  There's no point in using a verbose assertion to print the value of
  ctx->logging_new_delayed_dentries because it's a boolean, so if the
  assertion fails we know its value is true (1).

So convert them to simpler assertion to make the code less verbose.
It also slightly reduces the object size, at least on x86_64 using
Debian's gcc 14.2.0-19 (if CONFIG_BTRFS_ASSERT is enabled in the kernel
config, which is the case for SUSE distributions for example).

Before:

  $ size fs/btrfs/btrfs.ko
     text	   data	    bss	    dec	    hex	filename
  2028244	 197176	  15624	2241044	 223214	fs/btrfs/btrfs.ko

After:

  $ size fs/btrfs/btrfs.ko
     text	   data	    bss	    dec	    hex	filename
  2028228	 197176	  15624	2241028	 223204	fs/btrfs/btrfs.ko

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index dab1452dc4d1..6be98f8a3b43 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -491,7 +491,7 @@ static int overwrite_item(struct walk_control *wc)
 	 * the leaf before writing into the log tree. See the comments at
 	 * copy_items() for more details.
 	 */
-	ASSERT(btrfs_root_id(root) != BTRFS_TREE_LOG_OBJECTID, "root_id=%llu", btrfs_root_id(root));
+	ASSERT(btrfs_root_id(root) != BTRFS_TREE_LOG_OBJECTID);
 
 	item_size = btrfs_item_size(wc->log_leaf, wc->log_slot);
 	src_ptr = btrfs_item_ptr_offset(wc->log_leaf, wc->log_slot);
@@ -6844,8 +6844,7 @@ static int log_new_delayed_dentries(struct btrfs_trans_handle *trans,
 	 */
 	lockdep_assert_not_held(&inode->log_mutex);
 
-	ASSERT(!ctx->logging_new_delayed_dentries,
-	       "ctx->logging_new_delayed_dentries=%d", ctx->logging_new_delayed_dentries);
+	ASSERT(!ctx->logging_new_delayed_dentries);
 	ctx->logging_new_delayed_dentries = true;
 
 	list_for_each_entry(item, delayed_ins_list, log_list) {
-- 
2.47.2

