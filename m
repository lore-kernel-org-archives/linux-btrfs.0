Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794332915;
	b=QMxwtCSs6LIEjzwAnxOQYoCQL1zSdvSol32uE+rPx1eS3XYgAyoVDKgfSK2UQvxtbJBk
	 XwHth4Xppw7KU1hUGDeFXcdyJ2GkPUg3x2/bNOveYQY59TtXgt3jShmcp6KJmOYDLMkXV
	 BBAnEHaiaHs4I7Jn48/lQ7BBoKoePpctANGKxJknFwawJwsQmP5Q0J7E53aFc+GRtSTkZ
	 83ABRuRWKla7Ha+eMeSnRMiNuwNYBp6E/n6t275qLawZWifZcq3BEF3yKBQh/VwFg9Ggp
	 gLDmWYQPKmRC4bMnkTxj2D+P9MJ+xcB2FD+cOsvbctHY3815kZ9m0JQXea2YmNsiAYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794332915;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=YwgxZY5f+/iFDU9D+iJMsauiI8SAcgrPCtizeAgN4Ao=;
	b=xZuhm3Pu9YN7nuomhvhLlQdwBWxUkOSZ4EVX5u1bkb8DiJildn8c5A96969uyc4mZw1Q
	 CwFPiQdy3MDIxLNF0Z/STvSH3zQTpeBpbbwZcpfxDU9YqMOTkThPMXwi9ewr1dL+Z8XnX
	 u9Fk8q75miuaK2Z0viS2XjpuQFqftyjS31hwI04wuP75Y+TqtHOMY+ttGFBD+MqOF0X5u
	 uI8PgnS3tMvuhAr5NIk+a7KU/5rCOgbfLbCqHgdpHSuCao2nhcwzw1XM3dJEvn6tOFGou
	 4V/lOkusrF4Y1CMJnvxo3VH18iL+w46rRMAaWbOXz+ZoEbAjNe7/yaBv3fy0h2BEOpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="i9Yb/VQ4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BAF606A31C
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 17:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i9Yb/VQ4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5BEA1F0089F
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 17:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794332915;
	bh=YwgxZY5f+/iFDU9D+iJMsauiI8SAcgrPCtizeAgN4Ao=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=i9Yb/VQ4zJNIYjOSpml8vMzoVD4+qS/7bbWjtMPz2x2/IXw2yzQTBuW6/ps4D2X3q
	 dOPm0D2JTdua4EZi6WHAYKip76S8bpvvZ41lW2ReNTYBSyMTnFP+YH3zMWP1A+wXCz
	 ljqg3qxrxyD9ywBDxhhV6sLf6t+wmu3IjB1oT3duLFvzGE4OL7X2k/epEhcCU78G4/
	 +Q9SPvvk9OChN9+Nye39bxj0IayNfkEhrcnmAVUtlVVPyA5YGkgsq6HwBYZPOqZaA8
	 /VHHuMR6iX0ulk1JMgCkusLJVJF9tYLH42Jcsn5LwGYKovbQGKd/B7eUB9bxlS/YKv
	 at+DS/RLMQr0g==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: fix return value to report partial success for direct IO writes
Date: Tue, 10 Nov 2026 17:48:17 +0000
Message-ID: <8da77d7db1e50bd725179dd123d5518b9a7d29b2.1794329417.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <c40fb9e159c3ddc020c5d48db85a517caf63bc30.1794246932.git.fdmanana@suse.com>
References: <c40fb9e159c3ddc020c5d48db85a517caf63bc30.1794246932.git.fdmanana@suse.com>
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

When a direct IO write in btrfs_direct_write() is only partially
successful, the remaining data may trigger a page fault retry or a
fallback to buffered I/O. If this subsequent operation encounters an
error (for example -ENOSPC, -EFAULT, or -EAGAIN if we are in a NOWAIT
context), the  current error handling logic drops the count of already
successfully written bytes and returns the negative error code to
user space:

    return ret < 0 ? ret : written;

This goes against the write(2) semantics, which dictate that if some data
was successfully written before an error occurs, the system call should
return the number of bytes written.

By returning the error code instead of the short write count, user space
applications are misled into believing the entire write operation failed
and that no data was persisted to disk. For append-only workloads that
blindly retry the entire buffer upon receiving an error, this results in
a silent data duplication and corruption, as the initial partially
successful direct IO write is repeated.

Fix this by always returning the number of written bytes if we wrote
anything, otherwise return an error.

Fixes: 51bd9563b678 ("btrfs: fix deadlock due to page faults during direct IO reads and writes")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Addressed a couple issues pointed by Sashiko.

 fs/btrfs/direct-io.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index ed3914257d39..66debd730e42 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -1048,20 +1048,36 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 	/*
 	 * Ensure all data is persisted. We want the next direct IO read to be
 	 * able to read what was just written.
+	 * On success btrfs_buffered_write() incremented iocb->ki_pos already.
 	 */
 	endbyte = pos + written_buffered - 1;
 	ret = btrfs_fdatawrite_range(BTRFS_I(inode), pos, endbyte);
-	if (ret)
+	if (ret) {
+		iocb->ki_pos = pos;
 		goto out;
+	}
 	ret = filemap_fdatawait_range(inode->i_mapping, pos, endbyte);
-	if (ret)
+	if (ret) {
+		iocb->ki_pos = pos;
 		goto out;
+	}
 	written += written_buffered;
-	iocb->ki_pos = pos + written_buffered;
 	invalidate_mapping_pages(file->f_mapping, pos >> PAGE_SHIFT,
 				 endbyte >> PAGE_SHIFT);
 out:
-	return ret < 0 ? ret : written;
+	if (ret == -EIOCBQUEUED)
+		return ret;
+	/*
+	 * Always report partial writes if we wrote something, otherwise it
+	 * could lead to silent corruption for some applications: for example
+	 * if an application does writes to a file opened with append only mode,
+	 * in case we succeed doing a part of the write and then fallback to
+	 * buffered IO and that fails (or return -EAGAIN because we are in a
+	 * NOWAIT context), we mislead the application into trying to write the
+	 * whole buffer again, resulting in duplicating part of the data and
+	 * therefore a corruption at the application level.
+	 */
+	return written > 0 ? written : ret;
 }
 
 static int check_direct_read(struct btrfs_fs_info *fs_info,
-- 
2.53.0

