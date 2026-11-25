Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795628407;
	b=GF7p+ol2vEFDSt8as0X/wst5eu7bgA/498MaV9spPXaqJQFnAHHjqXxxeNkV6SxwFopY
	 Z0F5Uny9nYAyrzdshmUIWXKualJLV5TFnqhxSJAsD2YLZ1esTrxyJ/4IrZn/MirdFmeF3
	 cDIwd1e7S7jjkjvHxB405jPlf4CkfBeI4szV3avOET3HkjYI85Ov9IvmvyP3QmL5D93DG
	 eLi3GdViIbXCqSrFkf5EX+ONS+bKboFKcX2KLTFiaWWJ/rc+PWUPDbd9fnPXcGjPe2J4p
	 k7+mffyvVENQsrtqY4jRDHn/bdEs4/26DxlYMhlpRFAA8+Df85UplOcohihcdC/t1tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795628407;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dVfO6GQGDbT6KsEQM6VZ9AgbedY8t17D+aBWJoestrM=;
	b=Skd89ov97IbUxdCP8HYnTUqH+410xxJ5w8/DASmL2lotgOsI6t3kK28a4xUqB75F3/+6
	 Fq/VqDOrtLtdpFABbc89FkaStxn7IXZOBadsTEhhrguP6P8LHpQgYEn9+SlBkhBECGL2m
	 UzchIHLO5lSy00E15x0hG/L45dulryRNl6jpc4W0GIU3tPnoIIuu4J6zMdTaAD2PO7ftg
	 DjKG6BVmiY+S3g8Zj4cJlx/uo+HBSftQE9GWFyj3HUe9xWtuF67q2O8qnYwAehHSsFeUS
	 xOGB43hgIOcfa4sHCL3sr28mTWcVtYAhhwnDNba6cvzUj4sVZpz2UMU80jOnWuvx1pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lwEbAvoC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC32606A31E
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 17:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lwEbAvoC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C971F000D1
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 17:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795628407;
	bh=dVfO6GQGDbT6KsEQM6VZ9AgbedY8t17D+aBWJoestrM=;
	h=From:To:Subject:Date;
	b=lwEbAvoCo8LEGTw8EHStEkPS29cnohvtvoN7/mCoIi4+0Thd65CPOnrhcqLJHC7sp
	 4YMN7D/5jDPanvEmYgD1JWoGrA4K1V0RbABTlgb2T7+H2jaTZo+sG6QEM5PRvP7x0x
	 iPJXLx+WFxzdfDNdqQs8iaP+fyg4Of9ALiZiqIzf98R1avwYcJL+eMy2dOAIOX16NB
	 nKfJE0RFrdmvFbOO3pU4oW47migvZMKQ5c6SQQ11/JzOrdEKM1fA2m0juceZCuUCWi
	 qFnhfnTJU0O9CIamkG1PMA7hCyzTnkIpzGFgmfKHZ79DvaBlTULWyw6PlrIVRV7Dmt
	 Ez1YIJ+Fn2XaA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: return -EIO when attempting to start/join transaction after shutdown
Date: Wed, 25 Nov 2026 17:39:27 +0000
Message-ID: <46986ec836a3f93b77ab9d6f664733cf12640e37.1795615479.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

After shutting down the filesystem, if we attempt to start/join a
transaction, we will return -EROFS since we don't have any code in
transaction.c to explicitly check for the shutdown state, all we do is
check if fs_info->fs_error is not zero, and if it's not, return -EROFS.

Everywhere else in the code base we return -EIO if btrfs_is_shutdown()
returns true. Probably applications don't care about -EIO versus -EROFS
but this can trigger very sporadic failures in test generic/623 which
does this:

   xfs_io -x -c "mmap 0 4k" \
             -c "mwrite 0 4k" \
             -c shutdown \
             -c fsync \
             -c "mwrite 0 4k" $file

and expects the fsync to fail with -EIO, which normally does since by
the time the fsync is called there's usually delalloc from the mmap write
and when fsync flushes delalloc, it gets -EIO which comes from
cow_file_range(), where we return -EIO when btrfs_is_shutdown() returns
true and it gets propagated up the call chain to the fsync code.

However if delalloc happened to be flushed before fsync is called, due to
memory pressure, then when fsync flushes delalloc it does not get any
error since there is no more delalloc, but then when it attempts to start
a transaction it gets -EROFS and returns it to user space. This makes
generic/623 fail since it explicitly expects -EIO.

So change the transaction code to return -EIO instead of -EROFS when the
filesystem was shutdown. This avoids the very sporaric failures of
generic/623 and makes the return value consistent.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/transaction.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 1ea8dc522d2e..df3a3c78e681 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -306,7 +306,7 @@ static noinline int join_transaction(struct btrfs_fs_info *fs_info,
 	/* The file system has been taken offline. No new transactions. */
 	if (unlikely(BTRFS_FS_ERROR(fs_info))) {
 		spin_unlock(&fs_info->trans_lock);
-		return -EROFS;
+		return btrfs_is_shutdown(fs_info) ? -EIO : -EROFS;
 	}
 
 	cur_trans = fs_info->running_transaction;
@@ -361,7 +361,7 @@ static noinline int join_transaction(struct btrfs_fs_info *fs_info,
 		btrfs_lockdep_release(fs_info, btrfs_trans_num_extwriters);
 		btrfs_lockdep_release(fs_info, btrfs_trans_num_writers);
 		kfree(cur_trans);
-		return -EROFS;
+		return btrfs_is_shutdown(fs_info) ? -EIO : -EROFS;
 	}
 
 	cur_trans->fs_info = fs_info;
@@ -654,7 +654,7 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
 	ASSERT(has_single_bit_set(type));
 
 	if (unlikely(BTRFS_FS_ERROR(fs_info)))
-		return ERR_PTR(-EROFS);
+		return ERR_PTR(btrfs_is_shutdown(fs_info) ? -EIO : -EROFS);
 
 	if (current->journal_info) {
 		WARN_ON(type & TRANS_EXTWRITERS_MASK);
@@ -1156,7 +1156,7 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 		if (TRANS_ABORTED(trans))
 			ret = trans->aborted;
 		else
-			ret = -EROFS;
+			ret = btrfs_is_shutdown(info) ? -EIO : -EROFS;
 	}
 
 	kmem_cache_free(btrfs_trans_handle_cachep, trans);
@@ -2371,7 +2371,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 		 */
 		if (unlikely(BTRFS_FS_ERROR(fs_info))) {
 			spin_unlock(&fs_info->trans_lock);
-			ret = -EROFS;
+			ret = btrfs_is_shutdown(fs_info) ? -EIO : -EROFS;
 			goto lockdep_release;
 		}
 	}
-- 
2.53.0

