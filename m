Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77A1376475;
	Tue, 11 Aug 2026 18:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786472111; cv=none; b=ZztcMZZD1bAGF+u4fkcTUUsJaLJmOC35PyLCq2Jl3MPeZupRX2YTbUxr/snQpYppbIm7mC3eTT4vZPOpGhABHJtfjwpPcl/JD5v3sPHoo1QoK8VHkGGcmghdVRnhg5gQgRpT+rOHCdIgmwwS6iaG0XmdHYm5uG3Oo9ZAkHwC8aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786472111; c=relaxed/simple;
	bh=KhWdPBELIeMvAxFJiDxL/iLcUriQg6T+juXokUgGOIc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=k/hCfn8zQ5d4hjIlAFLdR4wglSDIT8pS8JT5jN+wrMdS6Ot+95onreLgC6aENz4LMcGSFUE8/2lyUEATdT0CpG7i2L1eOQiQ9SoL1ZYJKXb3jorp5//PBNkF/MhyfjIXArOnT6O/bXH0bN6whv9a+13T1QZM8dtgGpO9dTSbt94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XFaH1ctx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XFaH1ctx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3741F00A3D;
	Tue, 11 Aug 2026 18:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786472109;
	bh=4qG9pt9qpja3I+dp/q+sfoAW6y+kjZng9ZLdIg42aFU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XFaH1ctx+HWWXJR3teB4U21dwpMJ2z40YoZZJfsfEumK4TP8AdaNsPeiKGPzw0Fb4
	 TbSYsBhhBdi0hmmBvX6MEjEb7n7dR3qO6dp4CbyyRgfSxaWUXdjZkOzRxiVGLLDYbI
	 zZX0+t73Cuol/sKR20NVKS8P87XSKd6Dm5Y5E+LPBfbAHnLOWYkovVTc2yxQQ8MQld
	 uGuN2iomqpJiIJhH7wKjBbkwCAQ8DrDCbg2stc4ddR0pjSk5EvyR/EtU3044c2lbyP
	 PpGOECbmnde5c+Y2wi0ZeLQmr75YXxaLW3swPCZC7DYoNUrYHfcfLyLmwHoCAGMTRf
	 F3VrAD6XogTjQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Tue, 11 Aug 2026 14:14:54 -0400
Subject: [PATCH v3 1/6] btrfs: use an on-stack path in
 btrfs_insert_orphan_item()
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260811-btrfs-enomem-v3-1-46a993fc3fe5@kernel.org>
References: <20260811-btrfs-enomem-v3-0-46a993fc3fe5@kernel.org>
In-Reply-To: <20260811-btrfs-enomem-v3-0-46a993fc3fe5@kernel.org>
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kernel-team@fb.com, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1361; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=KhWdPBELIeMvAxFJiDxL/iLcUriQg6T+juXokUgGOIc=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBqe2aq5VzvXCnHbz0BS+a+L/N0LekrR/Dn4JcL6
 W48kzHi7QWJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCantmqgAKCRAADmhBGVaC
 FQPyEACiEHA27+fVbcWI15K/oN6uUud1kO0Gg72G9folHw9yAapLhCRmlNuJyb65hvdwMBTfUJF
 qou66MIlRY6nETnDXA6e20NvaGIwKgM5TTEF/HNVaCq6C8L2aQ/BvzVMwGD/T83+gtb2Cnk8GFt
 jB6dZ0JfrtH2Ju+PkrWXpQ7TXas/ztwUgShOoa9kEVb0FdIfZxCbCEdON9WoRyDAFM/hLmY+aOo
 4RzypREDvWdb+EjBZwNvie4nUEKzx83uDBMEq2/8KXXNurIvDSD6ywW5hJdJAlWIQnPzKQE6xaI
 3qh1w+1i9c/BhMR/jDP7I08WoC0O457Puvb+ZCNMnJs46l/V79yO+usv4KfFSdwuqkdimnyniXA
 m4SDAcmtHf4vA96FuT+Zi9/wlL2XYcgYJg1hZnEGaPl4ePbdWRMxGO2VzABsFIfGM4JuPJo/E5V
 2BKB71Lot458yhCU0rrp3q0hNnCalWBiOJFro632iu9R4lJhLi0k627twbRLv+zQ+j4ZUVlM+cQ
 vKqR/5swd6I9zP4u0VvaOgZAb2qalEZ6h2VutV9RH9g2D1dgQ+H6y0hc8K1WVdIKHeRvRK08zhZ
 dOSyBDFWt3f0K8ZkItnjTt+CHq/Dggh863FAjCxlJvE5d+iZBkQEr+PjJmTkT+mPl+HagrJQBgy
 49YA0Wvcl3sK1wQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

btrfs_insert_orphan_item() allocated a btrfs_path with btrfs_alloc_path()
which returns -ENOMEM on failure. It is called from btrfs_orphan_add(),
so a path allocation failure there turns a recoverable error into a
transaction abort.

btrfs_path is only ~112 bytes, so allocate it on the stack instead.

Assisted-by: LLM
Suggested-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/btrfs/orphan.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/orphan.c b/fs/btrfs/orphan.c
index 9f3ad124104f..72e1adec39d8 100644
--- a/fs/btrfs/orphan.c
+++ b/fs/btrfs/orphan.c
@@ -9,18 +9,17 @@
 int btrfs_insert_orphan_item(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root, u64 offset)
 {
-	BTRFS_PATH_AUTO_FREE(path);
+	struct btrfs_path path = { 0 };
 	struct btrfs_key key;
+	int ret;
 
 	key.objectid = BTRFS_ORPHAN_OBJECTID;
 	key.type = BTRFS_ORPHAN_ITEM_KEY;
 	key.offset = offset;
 
-	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
-
-	return btrfs_insert_empty_item(trans, root, path, &key, 0);
+	ret = btrfs_insert_empty_item(trans, root, &path, &key, 0);
+	btrfs_release_path(&path);
+	return ret;
 }
 
 int btrfs_del_orphan_item(struct btrfs_trans_handle *trans,

-- 
2.55.0

