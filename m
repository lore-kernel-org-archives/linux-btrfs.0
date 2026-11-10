Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794305882;
	b=vExIv7U6GytLcNQvbddLm4cvINWch6FDvF8AVzRMs2EqHI8lum3mU2YP+MEeiVT9h270
	 L07ZeiNFoBtrEEG6ss45vwNpcX/1zjgYVeWefRIeEBfHkV3Blt4IkxJcdN0+GeV3+aCNw
	 KVEmC02MONhlUc4GLR32NDTDm3/bEAJV/CJNGLVwL9Q5K+wCPNOMYACZnFSaJ5vn6zzHa
	 7UFipi61T6NiMrS/6CNYNeVVY28o/gtLPK61NLn/Xme/HYJgy+8PQjz3sBOdISadg1Cry
	 GXxCsLsgQTUSs4jeV2DBDjNQBiw7CVytcJvBHGZSmuwUvW5vnTvPrxIZEtksBC1I7Eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794305882;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R3voUBN1d8PsCc/wUWFNiuYf3fx1GrtBdHhdjid5A4A=;
	b=YNmhmfNNSzUR59BMJneQ3cntXp7L/liRdC+B7SE1AoeBQJ6EostkEjARavFXJPMOJmYq
	 69jbs9ruF2f4yRroa+jb54SIWva5lxOgrF0ZUVWe9tbGMnYdKJiFkuqrCkOl2pwsCrdT0
	 gIJgORnCTiiZY4YqcRda+Os9tqFBJ1N0DJmabisfwFo7m54OR5tnb+PDKG9e58Y0onhXD
	 mmKjp4c2EeB1qzM2UTW2NyW7xtZWyzWXiEiNbYiAvpMDw9ho6zGlnHLcC3h9uY25jR/Uk
	 qrbCRtxhjSSxfikvi4mJG1veI2vEUQclGsXetBG0i1FLU0UuI4c14ITt+NYg7C1xzXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UlnuVWnZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45541606A321
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 10:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UlnuVWnZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541501F0089F
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 10:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794305881;
	bh=R3voUBN1d8PsCc/wUWFNiuYf3fx1GrtBdHhdjid5A4A=;
	h=From:To:Subject:Date;
	b=UlnuVWnZTESNUvsLyhrpEZI4P7toBd0s7GlLneydV59SDbdKrhLE+04ANA81wnS1h
	 9s0tIv7AgXnzFbwTy064qPMpiHILeQpbxiI74AyZSn0ihiClyJDhVRE/gmeSXcNTGA
	 aDKsdmKd/EfqB0KuF7d4vuwyX/xtt6D6Pvx60fmWGPUoy98gJKNLgnEAeSxeschHOe
	 EnQJnKOGSeMGFY2cwzJqTxGAidQchGUNB8/BoDcxK23XpHYH5X3VMaCHojIEOGHI1u
	 D0LLOdb/WLfQaVJ3cWX6iPvr1ulafpne2qb3OlCnLMuu3vgFbioY4t50RXppedT5++
	 P9NLdJQvzqizg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix return value to report partial success for direct IO writes
Date: Tue, 10 Nov 2026 10:17:57 +0000
Message-ID: <c40fb9e159c3ddc020c5d48db85a517caf63bc30.1794246932.git.fdmanana@suse.com>
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
 fs/btrfs/direct-io.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index ed3914257d39..da50abbf315a 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -1061,7 +1061,17 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 	invalidate_mapping_pages(file->f_mapping, pos >> PAGE_SHIFT,
 				 endbyte >> PAGE_SHIFT);
 out:
-	return ret < 0 ? ret : written;
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

