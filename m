Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53DCB4949F2
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2026 16:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769013051; cv=none; b=dlJglLa7cMbyEU9Q+WEsyk/Xo6s+EPLFu0Js2U4zz9Uvfvkc3nn1mGD755EzngX9GXP0a1lMjSqKdJu/kx/Nw6Po4P7xWRRbMQB3T9ijCNPxNmch0ZlyLDXWnTgp8veuv+C+XwQMRzGqzF4/grWQQgRvM8cRQkLjZYu/xDhmBzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769013051; c=relaxed/simple;
	bh=SgKPzFjPfZQSimMCdhS9gRSKnAvAM5uC59/bzBlx0Sw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tp3TJHIKhPMc2scRcVlwz18TCjjLFgZzKkglEMYSTlJ/TETUrg0tii3kb9vQF+K28jahhRNoRFUygwE2C7Im/ap1JJk14vHcvaFDrjaKR6RXIKvZ3Pj+PqfE2/QtsOKtdGSl+679lHkH+G8HfShyDUrPDXpuMxOB6g+6oU1wMf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eIXWZ6D/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eIXWZ6D/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672B2C19421
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2026 16:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769013050;
	bh=SgKPzFjPfZQSimMCdhS9gRSKnAvAM5uC59/bzBlx0Sw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=eIXWZ6D/U44KlHTJ5U8A0WzQQjPvu5nucV7A0ioseTEPVj7ifqVJIC5rpV7C2MnFp
	 i/z8fb7Ce0VnRYd0rvznoojBRlohFGeiPBXOA7s1XOGKskxCad9Mpu6d1sZn7Rfquf
	 nJLhVZkCDEAfaWRqKxvntYeOhS6nanlymQJbF2YVrMxZqJM6s9FNSEmY6zjwOnuOdK
	 9ZyTtB8cU11rNonPUxQeMKPZoG39+q4RVKJqYZj070/Hz5wJnTGfbZxljLemphSbo+
	 KFBCfHFKaFPB7geKT5W7sc/vMgfTtDCiBmHMquwHNNfGaMcPIclYVD+QcDO0IyxS03
	 I7rHOrVlvlPCg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 02/19] btrfs: remove pointless out labels from ioctl.c
Date: Wed, 21 Jan 2026 16:30:28 +0000
Message-ID: <32f540695aec994e34451d26a58c43a82732571c.1769012877.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1769012876.git.fdmanana@suse.com>
References: <cover.1769012876.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Some functions (__btrfs_ioctl_snap_create(), btrfs_ioctl_subvol_setflags()
and copy_to_sk()) have an 'out' label that does nothing but return, making
it pointless. Simplify this by removing the label and returning instead of
gotos plus setting up the 'ret' variable.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ioctl.c | 44 +++++++++++++++++---------------------------
 1 file changed, 17 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d9e7dd317670..f1b56be6f8f4 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1176,7 +1176,7 @@ static noinline int __btrfs_ioctl_snap_create(struct file *file,
 				bool readonly,
 				struct btrfs_qgroup_inherit *inherit)
 {
-	int ret = 0;
+	int ret;
 	struct qstr qname = QSTR_INIT(name, strlen(name));
 
 	if (!S_ISDIR(file_inode(file)->i_mode))
@@ -1184,7 +1184,7 @@ static noinline int __btrfs_ioctl_snap_create(struct file *file,
 
 	ret = mnt_want_write_file(file);
 	if (ret)
-		goto out;
+		return ret;
 
 	if (strchr(name, '/')) {
 		ret = -EINVAL;
@@ -1236,7 +1236,6 @@ static noinline int __btrfs_ioctl_snap_create(struct file *file,
 	}
 out_drop_write:
 	mnt_drop_write_file(file);
-out:
 	return ret;
 }
 
@@ -1352,14 +1351,14 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
 	struct btrfs_trans_handle *trans;
 	u64 root_flags;
 	u64 flags;
-	int ret = 0;
+	int ret;
 
 	if (!inode_owner_or_capable(file_mnt_idmap(file), inode))
 		return -EPERM;
 
 	ret = mnt_want_write_file(file);
 	if (ret)
-		goto out;
+		return ret;
 
 	if (btrfs_ino(BTRFS_I(inode)) != BTRFS_FIRST_FREE_OBJECTID) {
 		ret = -EINVAL;
@@ -1428,7 +1427,6 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
 	up_write(&fs_info->subvol_sem);
 out_drop_write:
 	mnt_drop_write_file(file);
-out:
 	return ret;
 }
 
@@ -1494,10 +1492,8 @@ static noinline int copy_to_sk(struct btrfs_path *path,
 			continue;
 
 		if (sizeof(sh) + item_len > *buf_size) {
-			if (*num_found) {
-				ret = 1;
-				goto out;
-			}
+			if (*num_found)
+				return 1;
 
 			/*
 			 * return one empty item back for v1, which does not
@@ -1509,10 +1505,8 @@ static noinline int copy_to_sk(struct btrfs_path *path,
 			ret = -EOVERFLOW;
 		}
 
-		if (sizeof(sh) + item_len + *sk_offset > *buf_size) {
-			ret = 1;
-			goto out;
-		}
+		if (sizeof(sh) + item_len + *sk_offset > *buf_size)
+			return 1;
 
 		sh.objectid = key->objectid;
 		sh.type = key->type;
@@ -1526,10 +1520,8 @@ static noinline int copy_to_sk(struct btrfs_path *path,
 		 * problem. Otherwise we'll fault and then copy the buffer in
 		 * properly this next time through
 		 */
-		if (copy_to_user_nofault(ubuf + *sk_offset, &sh, sizeof(sh))) {
-			ret = 0;
-			goto out;
-		}
+		if (copy_to_user_nofault(ubuf + *sk_offset, &sh, sizeof(sh)))
+			return 0;
 
 		*sk_offset += sizeof(sh);
 
@@ -1541,22 +1533,20 @@ static noinline int copy_to_sk(struct btrfs_path *path,
 			 */
 			if (read_extent_buffer_to_user_nofault(leaf, up,
 						item_off, item_len)) {
-				ret = 0;
 				*sk_offset -= sizeof(sh);
-				goto out;
+				return 0;
 			}
 
 			*sk_offset += item_len;
 		}
 		(*num_found)++;
 
-		if (ret) /* -EOVERFLOW from above */
-			goto out;
+		/* -EOVERFLOW from above. */
+		if (ret)
+			return ret;
 
-		if (*num_found >= sk->nr_items) {
-			ret = 1;
-			goto out;
-		}
+		if (*num_found >= sk->nr_items)
+			return 1;
 	}
 advance_key:
 	ret = 0;
@@ -1576,7 +1566,7 @@ static noinline int copy_to_sk(struct btrfs_path *path,
 		key->objectid++;
 	} else
 		ret = 1;
-out:
+
 	/*
 	 *  0: all items from this leaf copied, continue with next
 	 *  1: * more items can be copied, but unused buffer is too small
-- 
2.47.2

