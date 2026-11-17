Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794929066;
	b=RS6vVgh1Aps0kdUg2vN1r6hq372IM0j7YittUgHrBDcOFqf+cWOybPKgqtfXrBPfZfqV
	 QAyxgDlBxOhf0kZFd7maSVx1JX7Ri/IEl2b7h5J3bsIZAT2iYD6MgQamu6w+vYG5VC5Xl
	 jYLXSIComFXRuuvKWnhyT1RiBVPLYRtNlj3+RwkVTaa3HaMT2MOCzWtGEKloUMimAkZEI
	 5N2Tu+0cKChnlzLvLpe2wkTiGi9+tU61qW+fN2r8N6MkHI1VWVxuf6nRCbDg6FmsDDsKO
	 VL2FXxY3bBAM47Cb1gsmN0t1M5jqDdxWXQb2h1lNUoR5MOsTZBuIV6SUcP+mV8G1mwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794929066;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sdQmHzaa3ydsRR4SxPv+yY+/S7hzLgoxSsxUdK5eW44=;
	b=BQY7kAxTPE6lUyVa0F7zYW/2vRCantBcbx/r1sBH68gO/MdnOrwOxvTW8riq7EFAU5gE
	 5m341mSeHo5srHdjAk7Tc+Jx9pi4ESS/esVrR8nRi/FQGQrphuHdiMftsxgcpHjHBOzfr
	 PJt2IRuIVn6ds/WJcVBnSCqEjUthsJb1+nk1ehSw3lJMHSEaK24zwzO1mbJP0YN2XGQnI
	 HAwbcl8fOyjCM2UtE2O303u+STHIz2DnxsR5S5jvfYlBE6u+jxLFKEIAszVnwDin/UnDd
	 9weYMpuNQNjYf67tvvJUqvcaI4s9c1CBsgaZ8bb/Lgz9bJ8epCtSYH7B0jeHMu6x3Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PYXlpwkE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C19606A31C
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 15:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PYXlpwkE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882371F000CC
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 15:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794929066;
	bh=sdQmHzaa3ydsRR4SxPv+yY+/S7hzLgoxSsxUdK5eW44=;
	h=From:To:Subject:Date;
	b=PYXlpwkESbWr42kgNYpyX/Lxd0qXUbdYvJpB+Dpyn6tz7DuWY667Sj54nclfi+lRx
	 fduseLImuv8nRqzZwh2e9ajmQAiK8usAVo5rD+1mJWFKGTjWjdoIAUdCN1OHtSEkge
	 1XeH402ZqEs5l661/JGFdo93etGhwW0ONYpsXQMg8/vh1/fqkHwzcqsNq6O7rcmGsC
	 py3Ad8A2/r6Lbb3pZ1PaRDCZI6X/DEViTIk6k0VtaaRCVooNDOmpnFdoRLV96tJ8i6
	 yl5XV6cB/z4KDSEyNzSObqhY25bjKeg3GtbHZfosJ6CtZViYz5h642u1Hxu2qTcD0C
	 v650By0IXB1Vg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: avoid copying too much memory in the logical to ino ioctl
Date: Tue, 17 Nov 2026 15:24:22 +0000
Message-ID: <d20ac8e45fe2df6dbfde223e4a786f2b542756b8.1794928978.git.fdmanana@suse.com>
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

We always copy the entire data container into user space, no matter how
many inodes we found. If for example the buffer is 16M (the maximum
allowed in the v2 version of the ioctl) and we found only one inode, we
copy 16M back to user space instead of just the amount matching one inode.

Improve on this by copying only what we need.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ioctl.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a4de331c46a5..5635bc3891e1 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3343,8 +3343,15 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 	if (ret < 0)
 		return ret;
 
+	/*
+	 * Copy only what we found instead of the whole data container. If for
+	 * example 'size' is 16M and we found only 1 inode, it's wasteful to
+	 * copy 16M instead of sizeof(*inodes) + 1 * (3 * sizeof(u64)).
+	 * For each inode we find we add 3 elements to the inodes->val array:
+	 * inode number, offset and root ID.
+	 */
 	ret = copy_to_user((void __user *)(unsigned long)loi->inodes, inodes,
-			   size);
+			   sizeof(*inodes) + inodes->elem_cnt * (3 * sizeof(u64)));
 	if (ret)
 		ret = -EFAULT;
 
-- 
2.53.0

