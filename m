Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794340917;
	b=l24shkYCMMxYxISIKuTFpU4eW0swS7qCn/HOugdd8kO8iCZ/Mm6RGKfgdzqizaxhEqEY
	 0n1yZ1v97HDd5SetDxztFVNCNOpEcKRlzNijU65BRDrASh6k5qkVy58WURJlN0g6+Pk+A
	 UPLMpqqk0hfB05vPEoNKzrD5WH7QUz7eK0+KydK6YIx756Z4rAmfZnLWQ4n/e6R95udOt
	 lKc3g3vRnUZPi4prBiswYXEsC/jbI9x8Yxo/KX9RkE1HaF/RdBV30Eiw0WT2APLDRTM9g
	 T2YuCXP+peXtjaGT0vCTHtAtOvUQ0/NFqul1IRF5Y7qaudGk5l1kPuUwECam7Cvs9mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794340917;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=MsiYa5ZHHWyQi8gkC3IMWo32HGOJM6EAoSPW+PzA9oA=;
	b=nt8JcCF8Lh3O04uE/rhvqyrC1sMmKbgrqD77JJis99Te7RvgSQwwCvYv7SDold/4f2j6
	 B14cE+K4XkOxdrXOMaWL65WTGMyvGgmZCwcWg1RLw8SovQPrbVfUXp372FMRs8qdq+3id
	 u0IwtkPc2T1CZtX29E+BDs6NdsB8PPUDo1VRAGOA9I3GoTiB5NY5Ts6bUjlkx/9Bco1HM
	 d49Eh9tAlOMqj5ngd/iHCkc+pS3jpnIYKt8kWEJVG7oHHBuYxYGoiv1drCUcKMl39s84J
	 cJPj8PM5CTPDzAATB+ZghXx6+lLv0RadQU3mY6ULZluwJ0FFemlGXAVXPm2WzPK64+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OXGajnNN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F02606A339
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 20:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OXGajnNN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC461F008A5
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 20:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794340917;
	bh=MsiYa5ZHHWyQi8gkC3IMWo32HGOJM6EAoSPW+PzA9oA=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=OXGajnNNkY0SZOGXRv0DZ8mG+JKtfUd5yww+j5LodIayLpOUXvBf9AtDgTOWMjCgY
	 1ebnP59dUJJ2SQo3pcvN7ncwIxhOkKR/+fFhtYxE7eVgDmOzWBFMNqGI7Op+2O/HH5
	 Y/vuDU313Qaq28kehk6qSIfuvAgZ+tl09l33rVjg0f1QFtr5N5sxUT+2H7E4AQHe4b
	 9Ad2Uyu3/ZEglWutJiH0YW5e1mCURmcnoY1NaaPgjd9eg36WO+7PklqQt9N2QNlOlL
	 6SrY5jAKXIFz5Sw2qtU6G/lk32C1aPezXsOdwKjl/DCwna/trJfZBd+he5sqjvfbE3
	 72lj2GOF9UmRw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: fix race between concurrent sync direct IO writes
Date: Tue, 10 Nov 2026 20:01:53 +0000
Message-ID: <7c0a309c28d95b92a3fb3cbf14e4a80e428edd93.1794340795.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <9d7367f9498173442964c97ddeae9f1be248e48d.1794338999.git.fdmanana@suse.com>
References: <9d7367f9498173442964c97ddeae9f1be248e48d.1794338999.git.fdmanana@suse.com>
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

If we have a direct IO write within i_size, we lock the inode's vfs lock
in shared mode, which allows for concurrent direct IO writes within
different ranges of the file, which is an important optimization for many
applications such as databases.

However if we have a sync direct IO write within i_size, it locks the
inode in shared mode and then enters fsync through the call to the
iomap_dio_complete() function from iomap using the shared lock. This
means that if we have another concurrent direct IO write that locks the
inode in shared mode and the fsync is in fast mode (the inode flag
BTRFS_INODE_NEEDS_FULL_SYNC is not set), the fsync does not wait for
the ordered extent created by the concurrent direct IO write to complete
before logging its extent map. The fsync code relies on direct IO writes
to create ordered extents and wait for their IO to finish while holding
the inode's lock, while the fsync should hold the inode lock in exclusive
mode. This means that this race can end up persisting a log tree with
file extent items that point to extents that were not yet written when
the log is synced.

Fix this by always taking the inode lock in exclusive mode if we have a
sync write.

This issue was identified by Sashiko in the link below, which identifies
two different races between direct IO writes and fsync. The race fixed
here is the second case identified by Sashiko in the link below. The first
race is already being fixed in a separate patch from Josef.

Link: https://sashiko.dev/#/bug/linux-ee047626-2fa7-46d5-b543-861136993fc7
Fixes: 939b656bc8ab ("btrfs: fix corruption after buffer fault in during direct IO append write")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Address issue pointed by Sashiko.

 fs/btrfs/direct-io.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index 66debd730e42..dc37ae15b232 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -896,9 +896,14 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 	 * If the write DIO is within EOF, use a shared lock and also only if
 	 * security bits will likely not be dropped by file_remove_privs() called
 	 * from btrfs_write_check(). Either will need to be rechecked after the
-	 * lock was acquired.
+	 * lock was acquired. Also if this is a sync write we will need to fsync
+	 * and therefore we must lock in exclusive mode, otherwise we would race
+	 * with other concurrent DIO writes and the fsync would not wait for
+	 * their ordered extent to finish IO before logging the new extent maps.
 	 */
-	if (iocb->ki_pos + iov_iter_count(from) <= i_size_read(inode) && IS_NOSEC(inode))
+	if (iocb->ki_pos + iov_iter_count(from) <= i_size_read(inode) &&
+	    IS_NOSEC(inode) &&
+	    !iocb_is_dsync(iocb))
 		ilock_flags |= BTRFS_ILOCK_SHARED;
 
 relock:
@@ -920,6 +925,13 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 		goto relock;
 	}
 
+	/* Sync writes must use exclusive locking, see the comment above. */
+	if ((ilock_flags & BTRFS_ILOCK_SHARED) && iocb_is_dsync(iocb)) {
+		btrfs_inode_unlock(BTRFS_I(inode), ilock_flags);
+		ilock_flags &= ~BTRFS_ILOCK_SHARED;
+		goto relock;
+	}
+
 	ret = generic_write_checks(iocb, from);
 	if (ret <= 0) {
 		btrfs_inode_unlock(BTRFS_I(inode), ilock_flags);
-- 
2.53.0

