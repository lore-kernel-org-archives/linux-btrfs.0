Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794339221;
	b=RxKSjNLWTJ6Po54LHDOyh1pvOn2zC0tokb4rnCvLuKe1334O3sdq/XOeyLOzF+NWe9te
	 wP00F/OI/965iRKejg0CjmWoFmJltyZgWSGBGglqXrLwWjB85qGkPnPhpnHqDiO90sV1F
	 IiwbQIV1sWgzSaEOWAEJJASQ9B5n23VtIbCZOj3VUo7d+euYw3WKo3aGc1DCRwgu7Gv7e
	 gf8WG4TsVWHrEkxBWOTj8c6pcWKZ1N6O2sZJxw8wiIaW+3U2PYFjD1cGk7AMEeMwpiGkB
	 kNSri1gQ24NLoSkp1/y/aLfQlOvh9qeI8ZQEmeqyQYI7+4R0CnxIZLuINPTy8OK/1ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794339221;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7i2LwsK7kZDjnXgSjmS+6llKO8GZ+I68+MW+Tli9xXI=;
	b=fka+yeOmcjCwKaEp1T2p5V/32BVvs+QdvFKqWA0aNujopozPEZWyVlTHArtOlOnUURYp
	 Ji8MipAR6P9TTBKHHrkl5Ggt8yrmLug4QlHp1GveROj5IZnmNZzqkgcQ/U9c+jabe5ucL
	 BHliEWh5zpNrN2ge63ruipGGdixcgw3PxKNhsQ35/Fbb6U89pMVggrvIJ9VjhMoLs12Fc
	 LOeaZn8EKVVHsb+aOZoxS98LeTmT+Vu9vO5zAdHC5xy7iQO7th+g85+rS3EBYb2TVrToS
	 xdM/AhX8iWpNjL3PZKHBGTfhIP2ykHkK0cyd/ijYGJRzrvNVRSmhryPsTsqnhXKDuIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BXHHgjHx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42605606A320
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 19:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BXHHgjHx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31261F0089F
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 19:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794339221;
	bh=7i2LwsK7kZDjnXgSjmS+6llKO8GZ+I68+MW+Tli9xXI=;
	h=From:To:Subject:Date;
	b=BXHHgjHxyUVmcUBcuqculInXMOf7ceTnba2ogrTbCEyfsTxtFH9FgHKdK5Nl3WHCW
	 G4JurXtPJU/xUy35ZiQ9uT75g5kGjtO6cEkKXrzgdmWWDSwCmMeMvbfKBSPCnA/eEB
	 rUDzSELPZmqy2qaMaUQzcRegbt1xupGGCHs/qX/nAeNvDSBpM1gi+jGhEUnfMz6p/Z
	 O/vLy4pqP6H8fEXxdn7AgXuc1Q61dPDdb0gow+K7fkxZRni4GCy6rAcx9DKbQJrwE1
	 MKlZ+OWx+0Q+CTmyvRV7vaabaj+fXxkW3FC50yLWAopIvLaQV/lZ2K62sowqZOzKVW
	 qaodfLrbxlSIA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix race between concurrent sync direct IO writes
Date: Tue, 10 Nov 2026 19:33:27 +0000
Message-ID: <9d7367f9498173442964c97ddeae9f1be248e48d.1794338999.git.fdmanana@suse.com>
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
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/direct-io.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index 66debd730e42..5c49d7249fec 100644
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
-- 
2.53.0

