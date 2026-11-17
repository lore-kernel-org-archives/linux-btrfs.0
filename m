Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794930056;
	b=O2bkZ7vdVRMLhY26yrWFkwF5dZWp0RHZcr/V3htbW09jXLhLgNrLRw0FtMiAgiyrHzUc
	 ZboMNcuDnMXShlRZaTKlbsPiuyft4h2MYg3O1d1d2bhGPmdm3hGBRM0YghdtOnEH1Ogdy
	 EV6yFcsr69A3p7RsPWcvogVRcLp69E1TPXXJjSJkR3Tn/SiYeS3lmHbLkkdqaszQJJy6f
	 K+RqGQ8EqIuWykrK/31KTQxTLliBuM5H6dVQC63NXZSd/aDwhKDOMZigDbOex7HAgxNNY
	 W5yhg4LoH6fJhFRNzpe6C8BsGEmTAzpuUNQHXUQ8LMR2Tjou/cAQrYOYoA2h2NjPETw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794930056;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=7rwoh9oph/0t4aDDNUQeG3OjDHiaRY1YYQRvzNAkADU=;
	b=yQ16JUZqCkhcKM0M44vsmE4dvUMEqh7bqsgLVZerh1b+zvkylSLJvucOFd0Ch5GZBFYW
	 g8RJe8pFwyYV9BSPNMIpFkNy3viJQoJScsB/tRoLX8pNGPvW6wjhG5RgSsalILQiXxRNZ
	 mkhEJ+KMWvD52NoUKEamHi78MF5lMxun7qev1JodRuaxGh1aA8kCXzq4RDNz2x6cjpbCc
	 SpxqT4bW/JsHaYtQ+Ap1YzAsye/f8qO2YdEZSM8mZBPcjXjqjbfv/hLtkYpomuVN1P3Xv
	 Z4IUF00ilOR24UBc4oG4oVuaptUqacM8ewfdxy+X1GXqnIw0qtyuyioLWD9pwWMz1dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="D/N36jQi";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903BD606A31C
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 15:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D/N36jQi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F921F000C4
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 15:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794930056;
	bh=7rwoh9oph/0t4aDDNUQeG3OjDHiaRY1YYQRvzNAkADU=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=D/N36jQi9U0KcrbZy3IIWXB7tpBYh9npzFYaSW213Z3NTsAz8xMw8hs5rOMRjvjaK
	 WOPBx/5hIXgd3Q5C8cjfRoJK+hES75sjqdu/b+MncvO9QZqaHrqZcozR8zStlMFgEo
	 aYRj6dLak3Xh4SlxianTNWKh8OnE/QjnGcUoRzNY+1dEv70LSugWr1HspNqrn7uMGc
	 qCImyXZbtkjyHOwXN12IPBwes4ikv/elN/f02576ds3xam82Y8F2cq6IRv8NN3ERmo
	 C6F9l1/H0ss1kpaYpICWhBMODx6OwHdUkonbK/uIEQDYGdI+qeaPWZ9ksHLTi44oc1
	 2PuV0OXKt2e+g==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: avoid copying too much memory in the logical to ino ioctl
Date: Tue, 17 Nov 2026 15:40:53 +0000
Message-ID: <6340b0cbc797d7d9b3920aaac1e93dd85602b6e1.1794929971.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <d20ac8e45fe2df6dbfde223e4a786f2b542756b8.1794928978.git.fdmanana@suse.com>
References: <d20ac8e45fe2df6dbfde223e4a786f2b542756b8.1794928978.git.fdmanana@suse.com>
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

V2: Fix the byte count, it's actualy just elem_cnt * sizeof(u64), no need
    to multiply by 3, and with with case where buffer size is less than
    sizeof(*inodes).

 fs/btrfs/ioctl.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a4de331c46a5..4271f7a6d48a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3343,6 +3343,15 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 	if (ret < 0)
 		return ret;
 
+	/*
+	 * Copy only what we found instead of the whole data container. If for
+	 * example 'size' is 16M and we found only 1 inode, it's wasteful to
+	 * copy 16M instead of sizeof(*inodes) + 1 * sizeof(u64)).
+	 * For each inode we find we add 3 elements to the inodes->val array:
+	 * inode number, offset and root ID.
+	 */
+	if (size > sizeof(*inodes))
+		size = sizeof(*inodes) + inodes->elem_cnt * sizeof(u64);
 	ret = copy_to_user((void __user *)(unsigned long)loi->inodes, inodes,
 			   size);
 	if (ret)
-- 
2.53.0

