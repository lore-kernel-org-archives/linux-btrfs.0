Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591275;
	b=yddcjAW7vTpv3bwryl9XlTivDwsnnrr9WnApV5l378wNJry5UojE42okhwd+TOJUwJBX
	 Kyvluu2ekFecNx49eVwSerPEfT4t4eTPLT9xLYSn9RECEF+aSlM19+NupODiDxpOpDhB3
	 NiMG7dJAIef1Gz0+5KsrpaSMLelsCsSxJC5RwJUp+jBveUeVLFi7VQb+eokxbLTy85Gkj
	 ikPHYInuUxhVuxvZ69d9ZvwypGfxcUbw6M382VAu8QGyGoqu4c7DDndOrE9r6y+Gp3EDu
	 RT72i4JeJqY3SK6fGQfPu00V23AZyNsNT7b2ng5q2RcAHvl3jK6LpIrLX9Xy65sAQsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591275;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O/iL6ZXeLWOVCyh7QkSiUk02/818ZJMdVpOHGLOZ/ro=;
	b=CSxfyapkQK2Q69nhAgQz4X0Geff3uxQhemfgChL5Y6WS2r3cl6BMoNsbNjxyOzXFuawg
	 +hjWCjC9CAVM+UihWfaDpE+Bl0chS/Xbun8PwaBbNIlm8HTxszrgS+ZlyKUKAX3q5p2kh
	 wNkS1bMAwPO5h02E6xmt0Vy6aaSsQEJS/vF/xpqXmkxnesqMatq4MiQsANT8o6bMa3I3j
	 eqvcuzJC5zLpEgE7AT7imDGMfxmEI6jhrrvFJBA36l3TawGhoVzsOqcjIgrwfqzk6N9Jd
	 wVtsG0yYVzzI1oTg9d9obSGacmHV447oH/YjHY5cwP9i1pCXhXHIpdlm9Xq6X6J0pbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XwQNNjp0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD1C6076FB4
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 17:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XwQNNjp0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C4E1F000C5
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 17:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794591274;
	bh=O/iL6ZXeLWOVCyh7QkSiUk02/818ZJMdVpOHGLOZ/ro=;
	h=From:To:Subject:Date;
	b=XwQNNjp06f5JFAGHbH5zZa407UjxK+qArP2vfao225VeUAVamIvGF4bnHBSbfAgZS
	 2W/kxvQ+/KAid/evV51H5xZzuOKW3sTYl66ixOtma/vqdl1s7rmcHgYvjTGFdJbETW
	 beOq5IlqRxbXQgP6CWO4IkqlhrdOSjolMu3yfBtv7doYbsMviuo7Qt2ufI8xf2GpP4
	 2abdKF/wrP2kDv8pFklTfbcEt0ap3kjY+gdfEHccxL4ULUqq+dlsxj9g6rxlyGt6Hb
	 Sr/TmK5JSxRmPQ97G9dhauVy4syCmfDRfrGsz3pZnYUQl63iEn5BqKO8OkaX7W2/kM
	 OvaHhSux7FceQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix missing device freeze allow on btrfs_rm_device() failure
Date: Fri, 13 Nov 2026 17:34:32 +0000
Message-ID: <31108cde017b75b3f06f1839f3d1f42aa74efad9.1794591257.git.fdmanana@suse.com>
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

If we fail to remove the device stat item we return without allowing back
the device to be frozen, as we previously called bdev_deny_freeze().
Fix this by adding the missing dev_allow_freeze() call before returning
after an error from btrfs_remove_dev_stat_item().

Fixes: ae5067f1533e ("btrfs: deny freezing a device while it is being removed")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/volumes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f128115a3a3b..590d9bd4130c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2441,6 +2441,8 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info,
 	if (unlikely(ret)) {
 		btrfs_abort_transaction(trans, ret);
 		btrfs_end_transaction(trans);
+		if (device->bdev)
+			bdev_allow_freeze(device->bdev);
 		return ret;
 	}
 	clear_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state);
-- 
2.53.0

