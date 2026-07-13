Received: from va-2-27.ptr.blmpb.com (va-2-27.ptr.blmpb.com [209.127.231.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A73A3CFF6C
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Jul 2026 08:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783932648; cv=none; b=cBVsQdsOKtgI8tDy/8SY/6DlxA76gJ1OTvKl0FDrxxHqwuInavBzkQM+mI6bA9uIW2fn1KNAWRH5+eA5U4ImBfXDWzCk2F/NQx+v4UxLIYir7Zwy0PXGCBeaPtQfU1VCPH0dBqLzcuEt0me+H0ruaT1buws1rITV6r7JwesGeW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783932648; c=relaxed/simple;
	bh=svhxXE2W+PDmVk/0k3YIRv95civZlAIfNIG8gxb6ulo=;
	h=Message-Id:Mime-Version:To:Date:Subject:Content-Type:Cc:
	 References:In-Reply-To:From; b=uVzbbh/r4Q9GiEf55gqQFROXTBeOuKYbu1bZJ478cZQk+nMZ3lzONZ4TPciW902GUGFUAgBQ1rPJssvJcOCqODQVZB9bLpJ83/Wbmt959fxfIl+v2sxsIZjn2uDEYid/+rnJhQfNYMzPPgh99iv48dda9pkSN7rg1H9FT+yEIXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=U26EGHwQ; arc=none smtp.client-ip=209.127.231.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="U26EGHwQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1783932636;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=AYsQEPzYaRN/FFE64KxjNRGSF7x38GZqbU/9ill4uMg=;
 b=U26EGHwQv8olYx/3NcBq7PeAwVO9P1ST35UuSc5T4XmScLkW9HMx0UlesGkpCL/ZoAc4x3
 WpGMeJeCSEXxiZgLCofd2Ukl2/sK6OE9EVqlc6A/y6He9htI2Fd9c5JXqTja9Cse0Zo/0u
 KFfvwsihAcxszmphP1hZ3vEDja5imNbgaDZIUBmBkNCDvYP+OMY0z9HW8ts8vjgH/jyqgr
 hDWXcd39NPRwvC/+vVh/sthUFrZ41mOvAL/u+3aM0WateG5tZFebRZWn5EwW3+tfx9JJ2l
 pZADRqrGn/1O6Oiweno69b5tf9NGaZBGElygQ9wyd5x9WYsuNY5azf1/W1eLkQ==
Message-Id: <20260713085010.1123273-2-zhudongjiang@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
To: <linux-btrfs@vger.kernel.org>
Date: Mon, 13 Jul 2026 16:50:08 +0800
Received: from pdzhu.teiron-inc.cn ([183.34.174.151]) by smtp.feishu.cn with ESMTPS; Mon, 13 Jul 2026 16:50:32 +0800
Subject: [PATCH v2 1/3] btrfs: move the full read-only helper to fs.h
X-Mailer: git-send-email 2.39.5
X-Lms-Return-Path: <lba+26a54a6da+b2b7be+vger.kernel.org+zhudongjiang@fnnas.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Cc: <dsterba@suse.com>, <wqu@suse.com>
References: <20260713085010.1123273-1-zhudongjiang@fnnas.com>
In-Reply-To: <20260713085010.1123273-1-zhudongjiang@fnnas.com>
From: "Dongjiang Zhu" <zhudongjiang@fnnas.com>
X-Original-From: Dongjiang Zhu <zhudongjiang@fnnas.com>

The global block reserve code needs to determine whether a filesystem is
fully read-only. Move fs_is_full_ro() from disk-io.c to fs.h and rename it
to btrfs_is_full_ro() so that it can be shared.

No functional change.

Signed-off-by: Dongjiang Zhu <zhudongjiang@fnnas.com>
---
 fs/btrfs/disk-io.c | 11 +----------
 fs/btrfs/fs.h      |  9 +++++++++
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 52593423bdc3..acff40469589 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3287,15 +3287,6 @@ int btrfs_check_features(struct btrfs_fs_info *fs_info, bool is_rw_mount)
 	return 0;
 }
 
-static bool fs_is_full_ro(const struct btrfs_fs_info *fs_info)
-{
-	if (!sb_rdonly(fs_info->sb))
-		return false;
-	if (unlikely(fs_info->mount_opt & BTRFS_MOUNT_FULL_RO_MASK))
-		return true;
-	return false;
-}
-
 /*
  * Try to wait for any metadata readahead, and invalidate all btree folios.
  *
@@ -3460,7 +3451,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 		WRITE_ONCE(fs_info->fs_error, -EUCLEAN);
 
 	/* If the fs has any rescue options, no transaction is allowed. */
-	if (fs_is_full_ro(fs_info))
+	if (btrfs_is_full_ro(fs_info))
 		WRITE_ONCE(fs_info->fs_error, -EROFS);
 
 	/* Set up fs_info before parsing mount options */
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index cffb9197a1ab..d3f74453b356 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -1159,6 +1159,15 @@ void __btrfs_clear_fs_compat_ro(struct btrfs_fs_info *fs_info, u64 flag,
 #define btrfs_test_opt(fs_info, opt)	((fs_info)->mount_opt & \
 					 BTRFS_MOUNT_##opt)
 
+static inline bool btrfs_is_full_ro(const struct btrfs_fs_info *fs_info)
+{
+	if (!sb_rdonly(fs_info->sb))
+		return false;
+	if (unlikely(fs_info->mount_opt & BTRFS_MOUNT_FULL_RO_MASK))
+		return true;
+	return false;
+}
+
 static inline bool btrfs_fs_closing(const struct btrfs_fs_info *fs_info)
 {
 	return unlikely(test_bit(BTRFS_FS_CLOSING_START, &fs_info->flags));
-- 
2.39.5
