Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E5F30EF9B;
	Mon, 29 Jun 2026 14:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782742884; cv=none; b=kl5iUZL0dkVRbj48wMy6Wk7fNtI1Tlqy1i258ZKk/+VGHFc1tPB/tXorOMJG+nE+Ca7qaqKKnQQu41aRvsReqon0nzkCStlOR9sb4LlVTi92Ve6Yl1+JpC+ne/e23LU0tOGobvTJ3oDcebekGZjzX+x8hLCdxLQDRM28dfs8ppo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782742884; c=relaxed/simple;
	bh=oh+xQddIdm+QKIPFM7G7RajY+Oa+4sFl2hVmQnxeeB4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oNrrgX1DROfWfyrcDYcmwRMEk49MHemVEvBoTdVCi1BXc6YuHIBnAPneQkeXlUknpW2nd0WH/9KivFXFmfvKc1bukS4aiY0XDcviqiCovSVZphAqvDrnOnip7yOO1xnHqxs0Q3+UGFMpeO4JDBmjBziqvhkHI0w80ET8m9EkE+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mssola.com; spf=fail smtp.mailfrom=mssola.com; dkim=pass (2048-bit key) header.d=mssola.com header.i=@mssola.com header.b=SLaShbdm; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mssola.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mssola.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mssola.com header.i=@mssola.com header.b="SLaShbdm"
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4gppNr6v81z9tmc;
	Mon, 29 Jun 2026 16:21:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mssola.com; s=MBO0001;
	t=1782742877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hRgBd2JaIP5i4MomaRwPNw7ZK4hh5t++skMu1ohxI6c=;
	b=SLaShbdm1j2+xf/iyU+yPcl75nVnxYdoXsHu1iAN1q4pUw8P9QWw7RJVXwtyY2V5jh9NTO
	jYuGJpaRc3+oE6LUlbEmEo2EiiHs0LDJ4Rth4dKbBCD5fSKsIkwJKMEiV3bbko36OEnKJA
	mHfeELmt7kqyV5nzjUA51rFIQTC5Hu7MffW1lMvit6pk34j/IOo3gUNfBiR5W/WJo04WBG
	5R8NgC1R4zEfHV2/JthRYvbnKQAQBHHNa8yvO2pGqkFlCHoaasdj7nqAP5iD11nLwmnNrg
	nmvtpi9SyBQ3a/zZMvZGTqnUEUalpqVuhRHdpL+3Xr15QikGVA6vxbheGG76oQ==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=softfail (outgoing_mbo_mout: 2001:67c:2050:b231:465::202 is neither permitted nor denied by domain of mssola@mssola.com) smtp.mailfrom=mssola@mssola.com
From: =?UTF-8?q?Miquel=20Sabat=C3=A9=20Sol=C3=A0?= <mssola@mssola.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Miquel=20Sabat=C3=A9=20Sol=C3=A0?= <mssola@mssola.com>
Subject: [PATCH] btrfs: don't pass tree_id in btrfs_search_path_in_tree()
Date: Mon, 29 Jun 2026 16:20:56 +0200
Message-ID: <20260629142056.309300-1-mssola@mssola.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4gppNr6v81z9tmc

The 'tree_id' parameter in btrfs_search_path_in_tree() was only being
used in order to fetch the root tree to be considered for the
search. For this same reason this function was also requiring a 'struct
btrfs_fs_info' parameter. This commit replaces these two parameters with
a single 'struct btrfs_root' one, which identifies from which root tree
the search should happen.

This function only has one caller, the inode lookup ioctl, which knows
how to provide the root tree for each case. In fact, if args->treeid ==
0, then we don't even have to allocate a new root tree object, and we
can reuse the one provided by the ioctl system call, thus avoiding an
extra allocation.

Signed-off-by: Miquel Sabaté Solà <mssola@mssola.com>
---
 fs/btrfs/ioctl.c | 54 ++++++++++++++++++++++--------------------------
 1 file changed, 25 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 1ed16ff4007b..00897a66187c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1664,13 +1664,11 @@ static noinline int btrfs_ioctl_tree_search_v2(struct btrfs_root *root,
 }
 
 /*
- * Search INODE_REFs to identify path name of 'dirid' directory
- * in a 'tree_id' tree. and sets path name to 'name'.
+ * Search for an INODE_REF in a 'root' tree which identifies the path name of
+ * 'dirid'. When found, it sets 'name' with the path name.
  */
-static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
-				u64 tree_id, u64 dirid, char *name)
+static noinline int btrfs_search_path_in_tree(struct btrfs_root *root, u64 dirid, char *name)
 {
-	struct btrfs_root *root;
 	struct btrfs_key key;
 	char *ptr;
 	int ret = -1;
@@ -1682,7 +1680,7 @@ static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
 	BTRFS_PATH_AUTO_FREE(path);
 
 	if (dirid == BTRFS_FIRST_FREE_OBJECTID) {
-		name[0]='\0';
+		name[0] = '\0';
 		return 0;
 	}
 
@@ -1692,13 +1690,6 @@ static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
 
 	ptr = &name[BTRFS_INO_LOOKUP_PATH_MAX - 1];
 
-	root = btrfs_get_fs_root(info, tree_id, true);
-	if (IS_ERR(root)) {
-		ret = PTR_ERR(root);
-		root = NULL;
-		goto out;
-	}
-
 	key.objectid = dirid;
 	key.type = BTRFS_INODE_REF_KEY;
 	key.offset = (u64)-1;
@@ -1706,11 +1697,9 @@ static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
 	while (1) {
 		ret = btrfs_search_backwards(root, &key, path);
 		if (ret < 0)
-			goto out;
-		else if (ret > 0) {
-			ret = -ENOENT;
-			goto out;
-		}
+			return ret;
+		else if (ret > 0)
+			return -ENOENT;
 
 		l = path->nodes[0];
 		slot = path->slots[0];
@@ -1719,10 +1708,8 @@ static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
 		len = btrfs_inode_ref_name_len(l, iref);
 		ptr -= len + 1;
 		total_len += len + 1;
-		if (ptr < name) {
-			ret = -ENAMETOOLONG;
-			goto out;
-		}
+		if (ptr < name)
+			return -ENAMETOOLONG;
 
 		*(ptr + len) = '/';
 		read_extent_buffer(l, ptr, (unsigned long)(iref + 1), len);
@@ -1737,10 +1724,8 @@ static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
 	}
 	memmove(name, ptr, total_len);
 	name[total_len] = '\0';
-	ret = 0;
-out:
-	btrfs_put_root(root);
-	return ret;
+
+	return 0;
 }
 
 static int btrfs_search_path_in_tree_user(struct mnt_idmap *idmap,
@@ -1884,6 +1869,7 @@ static int btrfs_search_path_in_tree_user(struct mnt_idmap *idmap,
 static noinline int btrfs_ioctl_ino_lookup(struct btrfs_root *root,
 					   void __user *argp)
 {
+	bool new_root = false;
 	struct btrfs_ioctl_ino_lookup_args AUTO_KFREE(args);
 	int ret = 0;
 
@@ -1897,6 +1883,8 @@ static noinline int btrfs_ioctl_ino_lookup(struct btrfs_root *root,
 	 */
 	if (args->treeid == 0)
 		args->treeid = btrfs_root_id(root);
+	else
+		new_root = true;
 
 	if (args->objectid == BTRFS_FIRST_FREE_OBJECTID) {
 		args->name[0] = 0;
@@ -1908,13 +1896,21 @@ static noinline int btrfs_ioctl_ino_lookup(struct btrfs_root *root,
 		goto out;
 	}
 
-	ret = btrfs_search_path_in_tree(root->fs_info,
-					args->treeid, args->objectid,
-					args->name);
+	if (new_root) {
+		root = btrfs_get_fs_root(root->fs_info, args->treeid, true);
+		if (IS_ERR(root)) {
+			ret = PTR_ERR(root);
+			new_root = false;
+			goto out;
+		}
+	}
+	ret = btrfs_search_path_in_tree(root, args->objectid, args->name);
 
 out:
 	if (ret == 0 && copy_to_user(argp, args, sizeof(*args)))
 		return -EFAULT;
+	if (new_root)
+		btrfs_put_root(root);
 
 	return ret;
 }
-- 
2.54.0

