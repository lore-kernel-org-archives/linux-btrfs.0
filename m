Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F501D5CDE
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2026 00:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772151110; cv=none; b=QWnhR5V7GPh8rLDs9rVIDU/B34RTRRl8Efhyedcn3P4AWl0QwHd5M7se1fWDypGP8G5DudaW1x8xem/Wh2/Ti+b4zMTWpRIM/yb53trL9jUfD2q2/g3skEiNCKVfD0/EnEsXzwhX3f1zQ4zlR0iWGvNrH7h8WvLZ6eC6WKljl/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772151110; c=relaxed/simple;
	bh=4cKQeREyFfII2ZGW2+sECbawfYzZVdDQOgfB3nQ1puI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kyz9J20jHd//wQLXGn+LWizgSv7j0/dcvPyZjGzI3eRlSae6Dp+Ekjme86ENb5GmUdLm9MYhNsxl6/0A3i/Laofj8NTO+ge8rL/7Os7k/Sn4YIH3BvVOugfyb1zIZTTGeEKfR+7XtMObU6YT5qhOa7h9Mr8UL+dx019hhhcxUAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BIDRJYcU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BIDRJYcU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3D8C116C6
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2026 00:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772151110;
	bh=4cKQeREyFfII2ZGW2+sECbawfYzZVdDQOgfB3nQ1puI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=BIDRJYcUf8zXbjx+btQA5cNEB82gYRxDGPGWS5V5W6HaC5tBHL3yPd+5d5jIhP1qK
	 rGEWZD1JS7dJk8XovFwl+uVHxF4sOBaocXOQfQoseA72k0bxL4svoAxqM+vDFi5lQl
	 L10NQK1GO+HJJLD1aazuyeL2blUtZ5B+o4Nxg4nFNl6+10KSpWb+WojOh6mzkdqB+o
	 nuQADf7e7683Diw7UmCdrJSBv35Ff7mzwCzx42Rxh5DnECLR4NgXGis4tvCC55mpzL
	 5jWy/Aar27XTSAOaYJatN1cVHFCQT9S7SEGG8EsYWH3y2hzGX9JEzmZoLgpY4cxHVQ
	 DEFtgy44QH5pQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs: remove unnecessary transaction abort in the received subvol ioctl
Date: Fri, 27 Feb 2026 00:11:43 +0000
Message-ID: <4d778585f3aac94525d60bfa5dbb9eb5f6177315.1772150850.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1772150849.git.fdmanana@suse.com>
References: <cover.1772150849.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

If we fail to remove an item from the uuid tree, we don't need to abort
the transaction since we have not done any change before. So remove that
transaction abort.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ioctl.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 8799eb82c4c3..3f63769c89b0 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3905,7 +3905,6 @@ static long _btrfs_ioctl_set_received_subvol(struct file *file,
 					  BTRFS_UUID_KEY_RECEIVED_SUBVOL,
 					  btrfs_root_id(root));
 		if (unlikely(ret && ret != -ENOENT)) {
-		        btrfs_abort_transaction(trans, ret);
 		        btrfs_end_transaction(trans);
 		        goto out;
 		}
-- 
2.47.2

