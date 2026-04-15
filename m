Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C5B386428
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 21:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776289468; cv=none; b=SQDB781aGrnU6uPrid6rR36nKH45Kww4NFEX1Xt6MKSevIRT3PNXryLx3+EiZoJ83vNosMI3KnIm6oBV9TYjMGmMn/xjGSlsxlHwPz393ijdFvLcURoSjmusWboHPxrrisZbMeCfIMwUpIpW3yXBtQtmExEH+hCv5j0vVvcNeEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776289468; c=relaxed/simple;
	bh=1po+nHJgSKjcrjvY6Fy2ES3Hinp5mthx20Z8J27pzZI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TmINKb3p6n8ZcDbERw9/PyGSz9XUra+t5onVX+Y1LypQSiiZYQo6WbhNFBUVyMBZ3/Vv/Md2yTtIVE+8BDfMPVN8gDi2ICdoSUMYSpeOBU2CMBskQ/9X2PgQOSgQ/Byx7KP3q7mSJitIBkiiFJY1/W4G6aEEfJL7t/VsUUv75/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=iLz5P51h; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=iLz5P51h; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="iLz5P51h";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="iLz5P51h"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BD5385BD31;
	Wed, 15 Apr 2026 21:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1776289463; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=0ZCJ/tXwtnDZNEANummOLlY1IdqznT68oBKDJW0lEYA=;
	b=iLz5P51hI9T9AewZhBuvHXLBG0uRBJ+kdYuq4J8uGw9gXRHHAjZEc6kYDAg5cdHe0UGqIw
	ZhPbx0nqOHd8jyEYUGtQuXPnHDXHxpSafQhCnplb3NiveX8arPMOb1+utqdyx7VRhM5BJC
	ISkp7uTtNcKDSEXQFXq96uBegyzJPZ8=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=iLz5P51h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1776289463; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=0ZCJ/tXwtnDZNEANummOLlY1IdqznT68oBKDJW0lEYA=;
	b=iLz5P51hI9T9AewZhBuvHXLBG0uRBJ+kdYuq4J8uGw9gXRHHAjZEc6kYDAg5cdHe0UGqIw
	ZhPbx0nqOHd8jyEYUGtQuXPnHDXHxpSafQhCnplb3NiveX8arPMOb1+utqdyx7VRhM5BJC
	ISkp7uTtNcKDSEXQFXq96uBegyzJPZ8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B572B4BC10;
	Wed, 15 Apr 2026 21:44:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yyBILLcG4GlARAAAD6G6ig
	(envelope-from <dsterba@suse.com>); Wed, 15 Apr 2026 21:44:23 +0000
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH v2] btrfs: convert ioctl handlers to AUTO_KFREE
Date: Wed, 15 Apr 2026 23:44:14 +0200
Message-ID: <20260415214414.15115-1-dsterba@suse.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Queue-Id: BD5385BD31
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

Many ioctl handlers are suitable for the AUTO_KFREE conversions as the
data are temporary and short lived. The conversions are trivial or the
collateral changes are straightforward.

A kfree() preceding mnt_drop_write_file() is slightly more efficient but
in the reverse order (i.e. the automatic kfree) does not cause any
significant change as the write drop does only a few simple operations.

Note: __free() handles also error pointers, so this is safe for the
memdup_user() errors too.

Signed-off-by: David Sterba <dsterba@suse.com>

---
v2:

- mention handling of error pointers
- keep 'return ret' where necessary

 fs/btrfs/ioctl.c | 285 +++++++++++++++++------------------------------
 1 file changed, 102 insertions(+), 183 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index adbc6d2caafb..751db2ae8408 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -708,7 +708,7 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 {
 	struct btrfs_fs_info *fs_info = inode_to_fs_info(dir);
 	struct inode *inode;
-	struct btrfs_pending_snapshot *pending_snapshot;
+	struct btrfs_pending_snapshot AUTO_KFREE(pending_snapshot);
 	unsigned int trans_num_items;
 	struct btrfs_trans_handle *trans;
 	struct btrfs_block_rsv *block_rsv;
@@ -817,7 +817,6 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 		free_anon_bdev(pending_snapshot->anon_dev);
 	kfree(pending_snapshot->root_item);
 	btrfs_free_path(pending_snapshot->path);
-	kfree(pending_snapshot);
 
 	return ret;
 }
@@ -962,7 +961,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 	u64 new_size;
 	u64 old_size;
 	u64 devid = 1;
-	struct btrfs_ioctl_vol_args *vol_args;
+	struct btrfs_ioctl_vol_args AUTO_KFREE(vol_args);
 	struct btrfs_device *device = NULL;
 	char *sizestr;
 	char *devstr = NULL;
@@ -988,13 +987,13 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 	}
 	ret = btrfs_check_ioctl_vol_args_path(vol_args);
 	if (ret < 0)
-		goto out_free;
+		goto out_drop;
 
 	sizestr = vol_args->name;
 	cancel = (strcmp("cancel", sizestr) == 0);
 	ret = exclop_start_or_cancel_reloc(fs_info, BTRFS_EXCLOP_RESIZE, cancel);
 	if (ret)
-		goto out_free;
+		goto out_drop;
 	/* Exclusive operation is now claimed */
 
 	devstr = strchr(sizestr, ':');
@@ -1101,8 +1100,6 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 			old_size, new_size);
 out_finish:
 	btrfs_exclop_finish(fs_info);
-out_free:
-	kfree(vol_args);
 out_drop:
 	mnt_drop_write_file(file);
 	return ret;
@@ -1180,7 +1177,7 @@ static noinline int __btrfs_ioctl_snap_create(struct file *file,
 static noinline int btrfs_ioctl_snap_create(struct file *file,
 					    void __user *arg, bool subvol)
 {
-	struct btrfs_ioctl_vol_args *vol_args;
+	struct btrfs_ioctl_vol_args AUTO_KFREE(vol_args);
 	int ret;
 
 	if (!S_ISDIR(file_inode(file)->i_mode))
@@ -1191,24 +1188,20 @@ static noinline int btrfs_ioctl_snap_create(struct file *file,
 		return PTR_ERR(vol_args);
 	ret = btrfs_check_ioctl_vol_args_path(vol_args);
 	if (ret < 0)
-		goto out;
+		return ret;
 
-	ret = __btrfs_ioctl_snap_create(file, file_mnt_idmap(file),
-					vol_args->name, vol_args->fd, subvol,
-					false, NULL);
-
-out:
-	kfree(vol_args);
-	return ret;
+	return __btrfs_ioctl_snap_create(file, file_mnt_idmap(file),
+					 vol_args->name, vol_args->fd, subvol,
+					 false, NULL);
 }
 
 static noinline int btrfs_ioctl_snap_create_v2(struct file *file,
 					       void __user *arg, bool subvol)
 {
-	struct btrfs_ioctl_vol_args_v2 *vol_args;
+	struct btrfs_ioctl_vol_args_v2 AUTO_KFREE(vol_args);
+	struct btrfs_qgroup_inherit AUTO_KFREE(inherit);
 	int ret;
 	bool readonly = false;
-	struct btrfs_qgroup_inherit *inherit = NULL;
 
 	if (!S_ISDIR(file_inode(file)->i_mode))
 		return -ENOTDIR;
@@ -1218,44 +1211,32 @@ static noinline int btrfs_ioctl_snap_create_v2(struct file *file,
 		return PTR_ERR(vol_args);
 	ret = btrfs_check_ioctl_vol_args2_subvol_name(vol_args);
 	if (ret < 0)
-		goto free_args;
+		return ret;
 
-	if (vol_args->flags & ~BTRFS_SUBVOL_CREATE_ARGS_MASK) {
-		ret = -EOPNOTSUPP;
-		goto free_args;
-	}
+	if (vol_args->flags & ~BTRFS_SUBVOL_CREATE_ARGS_MASK)
+		return -EOPNOTSUPP;
 
 	if (vol_args->flags & BTRFS_SUBVOL_RDONLY)
 		readonly = true;
 	if (vol_args->flags & BTRFS_SUBVOL_QGROUP_INHERIT) {
 		struct btrfs_fs_info *fs_info = inode_to_fs_info(file_inode(file));
 
-		if (vol_args->size < sizeof(*inherit) ||
-		    vol_args->size > PAGE_SIZE) {
-			ret = -EINVAL;
-			goto free_args;
-		}
+		if (vol_args->size < sizeof(*inherit) || vol_args->size > PAGE_SIZE)
+			return -EINVAL;
+
 		inherit = memdup_user(vol_args->qgroup_inherit, vol_args->size);
 		if (IS_ERR(inherit)) {
-			ret = PTR_ERR(inherit);
-			goto free_args;
+			return PTR_ERR(inherit);
 		}
 
 		ret = btrfs_qgroup_check_inherit(fs_info, inherit, vol_args->size);
 		if (ret < 0)
-			goto free_inherit;
+			return ret;
 	}
 
-	ret = __btrfs_ioctl_snap_create(file, file_mnt_idmap(file),
-					vol_args->name, vol_args->fd, subvol,
-					readonly, inherit);
-	if (ret)
-		goto free_inherit;
-free_inherit:
-	kfree(inherit);
-free_args:
-	kfree(vol_args);
-	return ret;
+	return __btrfs_ioctl_snap_create(file, file_mnt_idmap(file),
+					 vol_args->name, vol_args->fd, subvol,
+					 readonly, inherit);
 }
 
 static noinline int btrfs_ioctl_subvol_getflags(struct btrfs_inode *inode,
@@ -1866,7 +1847,7 @@ static int btrfs_search_path_in_tree_user(struct mnt_idmap *idmap,
 static noinline int btrfs_ioctl_ino_lookup(struct btrfs_root *root,
 					   void __user *argp)
 {
-	struct btrfs_ioctl_ino_lookup_args *args;
+	struct btrfs_ioctl_ino_lookup_args AUTO_KFREE(args);
 	int ret = 0;
 
 	args = memdup_user(argp, sizeof(*args));
@@ -1896,9 +1877,8 @@ static noinline int btrfs_ioctl_ino_lookup(struct btrfs_root *root,
 
 out:
 	if (ret == 0 && copy_to_user(argp, args, sizeof(*args)))
-		ret = -EFAULT;
+		return -EFAULT;
 
-	kfree(args);
 	return ret;
 }
 
@@ -1916,7 +1896,7 @@ static noinline int btrfs_ioctl_ino_lookup(struct btrfs_root *root,
  */
 static int btrfs_ioctl_ino_lookup_user(struct file *file, void __user *argp)
 {
-	struct btrfs_ioctl_ino_lookup_user_args *args;
+	struct btrfs_ioctl_ino_lookup_user_args AUTO_KFREE(args);
 	struct inode *inode;
 	int ret;
 
@@ -1932,7 +1912,6 @@ static int btrfs_ioctl_ino_lookup_user(struct file *file, void __user *argp)
 		 * The subvolume does not exist under fd with which this is
 		 * called
 		 */
-		kfree(args);
 		return -EACCES;
 	}
 
@@ -1941,14 +1920,13 @@ static int btrfs_ioctl_ino_lookup_user(struct file *file, void __user *argp)
 	if (ret == 0 && copy_to_user(argp, args, sizeof(*args)))
 		ret = -EFAULT;
 
-	kfree(args);
 	return ret;
 }
 
 /* Get the subvolume information in BTRFS_ROOT_ITEM and BTRFS_ROOT_BACKREF */
 static int btrfs_ioctl_get_subvol_info(struct inode *inode, void __user *argp)
 {
-	struct btrfs_ioctl_get_subvol_info_args *subvol_info;
+	struct btrfs_ioctl_get_subvol_info_args AUTO_KFREE(subvol_info);
 	struct btrfs_fs_info *fs_info;
 	struct btrfs_root *root;
 	struct btrfs_path *path;
@@ -2058,7 +2036,6 @@ static int btrfs_ioctl_get_subvol_info(struct inode *inode, void __user *argp)
 	btrfs_put_root(root);
 out_free:
 	btrfs_free_path(path);
-	kfree(subvol_info);
 	return ret;
 }
 
@@ -2069,7 +2046,7 @@ static int btrfs_ioctl_get_subvol_info(struct inode *inode, void __user *argp)
 static int btrfs_ioctl_get_subvol_rootref(struct btrfs_root *root,
 					  void __user *argp)
 {
-	struct btrfs_ioctl_get_subvol_rootref_args *rootrefs;
+	struct btrfs_ioctl_get_subvol_rootref_args AUTO_KFREE(rootrefs);
 	struct btrfs_root_ref *rref;
 	struct btrfs_path *path;
 	struct btrfs_key key;
@@ -2152,8 +2129,6 @@ static int btrfs_ioctl_get_subvol_rootref(struct btrfs_root *root,
 			ret = -EFAULT;
 	}
 
-	kfree(rootrefs);
-
 	return ret;
 }
 
@@ -2168,8 +2143,8 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 	struct inode *inode;
 	struct btrfs_root *root = BTRFS_I(dir)->root;
 	struct btrfs_root *dest = NULL;
-	struct btrfs_ioctl_vol_args *vol_args = NULL;
-	struct btrfs_ioctl_vol_args_v2 *vol_args2 = NULL;
+	struct btrfs_ioctl_vol_args AUTO_KFREE(vol_args);
+	struct btrfs_ioctl_vol_args_v2 AUTO_KFREE(vol_args2);
 	struct mnt_idmap *idmap = file_mnt_idmap(file);
 	char *subvol_name, *subvol_name_ptr = NULL;
 	int ret = 0;
@@ -2187,10 +2162,8 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 		if (IS_ERR(vol_args2))
 			return PTR_ERR(vol_args2);
 
-		if (vol_args2->flags & ~BTRFS_SUBVOL_DELETE_ARGS_MASK) {
-			ret = -EOPNOTSUPP;
-			goto out;
-		}
+		if (vol_args2->flags & ~BTRFS_SUBVOL_DELETE_ARGS_MASK)
+			return -EOPNOTSUPP;
 
 		/*
 		 * If SPEC_BY_ID is not set, we are looking for the subvolume by
@@ -2199,23 +2172,21 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 		if (!(vol_args2->flags & BTRFS_SUBVOL_SPEC_BY_ID)) {
 			ret = btrfs_check_ioctl_vol_args2_subvol_name(vol_args2);
 			if (ret < 0)
-				goto out;
+				return ret;
 			subvol_name = vol_args2->name;
 
 			ret = mnt_want_write_file(file);
 			if (ret)
-				goto out;
+				return ret;
 		} else {
 			struct inode *old_dir;
 
-			if (vol_args2->subvolid < BTRFS_FIRST_FREE_OBJECTID) {
-				ret = -EINVAL;
-				goto out;
-			}
+			if (vol_args2->subvolid < BTRFS_FIRST_FREE_OBJECTID)
+				return -EINVAL;
 
 			ret = mnt_want_write_file(file);
 			if (ret)
-				goto out;
+				return ret;
 
 			dentry = btrfs_get_dentry(fs_info->sb,
 					BTRFS_FIRST_FREE_OBJECTID,
@@ -2285,13 +2256,13 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 
 		ret = btrfs_check_ioctl_vol_args_path(vol_args);
 		if (ret < 0)
-			goto out;
+			return ret;
 
 		subvol_name = vol_args->name;
 
 		ret = mnt_want_write_file(file);
 		if (ret)
-			goto out;
+			return ret;
 	}
 
 	if (strchr(subvol_name, '/') ||
@@ -2372,9 +2343,6 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 		dput(parent);
 out_drop_write:
 	mnt_drop_write_file(file);
-out:
-	kfree(vol_args2);
-	kfree(vol_args);
 	return ret;
 }
 
@@ -2462,7 +2430,7 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
 
 static long btrfs_ioctl_add_dev(struct btrfs_fs_info *fs_info, void __user *arg)
 {
-	struct btrfs_ioctl_vol_args *vol_args;
+	struct btrfs_ioctl_vol_args AUTO_KFREE(vol_args);
 	bool restore_op = false;
 	int ret;
 
@@ -2502,15 +2470,13 @@ static long btrfs_ioctl_add_dev(struct btrfs_fs_info *fs_info, void __user *arg)
 
 	ret = btrfs_check_ioctl_vol_args_path(vol_args);
 	if (ret < 0)
-		goto out_free;
+		goto out;
 
 	ret = btrfs_init_new_device(fs_info, vol_args->name);
 
 	if (!ret)
 		btrfs_info(fs_info, "disk added %s", vol_args->name);
 
-out_free:
-	kfree(vol_args);
 out:
 	if (restore_op)
 		btrfs_exclop_balance(fs_info, BTRFS_EXCLOP_BALANCE_PAUSED);
@@ -2524,7 +2490,7 @@ static long btrfs_ioctl_rm_dev_v2(struct file *file, void __user *arg)
 	BTRFS_DEV_LOOKUP_ARGS(args);
 	struct inode *inode = file_inode(file);
 	struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
-	struct btrfs_ioctl_vol_args_v2 *vol_args;
+	struct btrfs_ioctl_vol_args_v2 AUTO_KFREE(vol_args);
 	struct file *bdev_file = NULL;
 	int ret;
 	bool cancel = false;
@@ -2583,7 +2549,6 @@ static long btrfs_ioctl_rm_dev_v2(struct file *file, void __user *arg)
 		bdev_fput(bdev_file);
 out:
 	btrfs_put_dev_args_from_path(&args);
-	kfree(vol_args);
 	return ret;
 }
 
@@ -2592,7 +2557,7 @@ static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
 	BTRFS_DEV_LOOKUP_ARGS(args);
 	struct inode *inode = file_inode(file);
 	struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
-	struct btrfs_ioctl_vol_args *vol_args;
+	struct btrfs_ioctl_vol_args AUTO_KFREE(vol_args);
 	struct file *bdev_file = NULL;
 	int ret;
 	bool cancel = false;
@@ -2606,7 +2571,7 @@ static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
 
 	ret = btrfs_check_ioctl_vol_args_path(vol_args);
 	if (ret < 0)
-		goto out_free;
+		return ret;
 
 	if (!strcmp("cancel", vol_args->name)) {
 		cancel = true;
@@ -2634,19 +2599,16 @@ static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
 		bdev_fput(bdev_file);
 out:
 	btrfs_put_dev_args_from_path(&args);
-out_free:
-	kfree(vol_args);
 	return ret;
 }
 
 static long btrfs_ioctl_fs_info(const struct btrfs_fs_info *fs_info,
 				void __user *arg)
 {
-	struct btrfs_ioctl_fs_info_args *fi_args;
+	struct btrfs_ioctl_fs_info_args AUTO_KFREE(fi_args);
 	struct btrfs_device *device;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	u64 flags_in;
-	int ret = 0;
 
 	fi_args = memdup_user(arg, sizeof(*fi_args));
 	if (IS_ERR(fi_args))
@@ -2687,17 +2649,16 @@ static long btrfs_ioctl_fs_info(const struct btrfs_fs_info *fs_info,
 	}
 
 	if (copy_to_user(arg, fi_args, sizeof(*fi_args)))
-		ret = -EFAULT;
+		return -EFAULT;
 
-	kfree(fi_args);
-	return ret;
+	return 0;
 }
 
 static long btrfs_ioctl_dev_info(const struct btrfs_fs_info *fs_info,
 				 void __user *arg)
 {
 	BTRFS_DEV_LOOKUP_ARGS(args);
-	struct btrfs_ioctl_dev_info_args *di_args;
+	struct btrfs_ioctl_dev_info_args AUTO_KFREE(di_args);
 	struct btrfs_device *dev;
 	int ret = 0;
 
@@ -2731,7 +2692,6 @@ static long btrfs_ioctl_dev_info(const struct btrfs_fs_info *fs_info,
 	if (ret == 0 && copy_to_user(arg, di_args, sizeof(*di_args)))
 		ret = -EFAULT;
 
-	kfree(di_args);
 	return ret;
 }
 
@@ -3012,7 +2972,7 @@ static noinline long btrfs_ioctl_wait_sync(struct btrfs_fs_info *fs_info,
 static long btrfs_ioctl_scrub(struct file *file, void __user *arg)
 {
 	struct btrfs_fs_info *fs_info = inode_to_fs_info(file_inode(file));
-	struct btrfs_ioctl_scrub_args *sa;
+	struct btrfs_ioctl_scrub_args AUTO_KFREE(sa);
 	int ret;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -3027,15 +2987,13 @@ static long btrfs_ioctl_scrub(struct file *file, void __user *arg)
 	if (IS_ERR(sa))
 		return PTR_ERR(sa);
 
-	if (sa->flags & ~BTRFS_SCRUB_SUPPORTED_FLAGS) {
-		ret = -EOPNOTSUPP;
-		goto out;
-	}
+	if (sa->flags & ~BTRFS_SCRUB_SUPPORTED_FLAGS)
+		return -EOPNOTSUPP;
 
 	if (!(sa->flags & BTRFS_SCRUB_READONLY)) {
 		ret = mnt_want_write_file(file);
 		if (ret)
-			goto out;
+			return ret;
 	}
 
 	ret = btrfs_scrub_dev(fs_info, sa->devid, sa->start, sa->end,
@@ -3059,8 +3017,7 @@ static long btrfs_ioctl_scrub(struct file *file, void __user *arg)
 
 	if (!(sa->flags & BTRFS_SCRUB_READONLY))
 		mnt_drop_write_file(file);
-out:
-	kfree(sa);
+
 	return ret;
 }
 
@@ -3075,7 +3032,7 @@ static long btrfs_ioctl_scrub_cancel(struct btrfs_fs_info *fs_info)
 static long btrfs_ioctl_scrub_progress(struct btrfs_fs_info *fs_info,
 				       void __user *arg)
 {
-	struct btrfs_ioctl_scrub_args *sa;
+	struct btrfs_ioctl_scrub_args AUTO_KFREE(sa);
 	int ret;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -3088,40 +3045,36 @@ static long btrfs_ioctl_scrub_progress(struct btrfs_fs_info *fs_info,
 	ret = btrfs_scrub_progress(fs_info, sa->devid, &sa->progress);
 
 	if (ret == 0 && copy_to_user(arg, sa, sizeof(*sa)))
-		ret = -EFAULT;
+		return -EFAULT;
 
-	kfree(sa);
 	return ret;
 }
 
 static long btrfs_ioctl_get_dev_stats(struct btrfs_fs_info *fs_info,
 				      void __user *arg)
 {
-	struct btrfs_ioctl_get_dev_stats *sa;
+	struct btrfs_ioctl_get_dev_stats AUTO_KFREE(sa);
 	int ret;
 
 	sa = memdup_user(arg, sizeof(*sa));
 	if (IS_ERR(sa))
 		return PTR_ERR(sa);
 
-	if ((sa->flags & BTRFS_DEV_STATS_RESET) && !capable(CAP_SYS_ADMIN)) {
-		kfree(sa);
+	if ((sa->flags & BTRFS_DEV_STATS_RESET) && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	}
 
 	ret = btrfs_get_dev_stats(fs_info, sa);
 
 	if (ret == 0 && copy_to_user(arg, sa, sizeof(*sa)))
-		ret = -EFAULT;
+		return -EFAULT;
 
-	kfree(sa);
 	return ret;
 }
 
 static long btrfs_ioctl_dev_replace(struct btrfs_fs_info *fs_info,
 				    void __user *arg)
 {
-	struct btrfs_ioctl_dev_replace_args *p;
+	struct btrfs_ioctl_dev_replace_args AUTO_KFREE(p);
 	int ret;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -3138,10 +3091,8 @@ static long btrfs_ioctl_dev_replace(struct btrfs_fs_info *fs_info,
 
 	switch (p->cmd) {
 	case BTRFS_IOCTL_DEV_REPLACE_CMD_START:
-		if (sb_rdonly(fs_info->sb)) {
-			ret = -EROFS;
-			goto out;
-		}
+		if (sb_rdonly(fs_info->sb))
+			return -EROFS;
 		if (!btrfs_exclop_start(fs_info, BTRFS_EXCLOP_DEV_REPLACE)) {
 			ret = BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
 		} else {
@@ -3163,9 +3114,8 @@ static long btrfs_ioctl_dev_replace(struct btrfs_fs_info *fs_info,
 	}
 
 	if ((ret == 0 || ret == -ECANCELED) && copy_to_user(arg, p, sizeof(*p)))
-		ret = -EFAULT;
-out:
-	kfree(p);
+		return -EFAULT;
+
 	return ret;
 }
 
@@ -3175,7 +3125,7 @@ static long btrfs_ioctl_ino_to_path(struct btrfs_root *root, void __user *arg)
 	int i;
 	u64 rel_ptr;
 	int size;
-	struct btrfs_ioctl_ino_path_args *ipa = NULL;
+	struct btrfs_ioctl_ino_path_args AUTO_KFREE(ipa);
 	struct inode_fs_paths *ipath __free(inode_fs_paths) = NULL;
 	struct btrfs_path *path;
 
@@ -3224,7 +3174,6 @@ static long btrfs_ioctl_ino_to_path(struct btrfs_root *root, void __user *arg)
 
 out:
 	btrfs_free_path(path);
-	kfree(ipa);
 
 	return ret;
 }
@@ -3234,8 +3183,8 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 {
 	int ret = 0;
 	int size;
-	struct btrfs_ioctl_logical_ino_args *loi;
-	struct btrfs_data_container *inodes = NULL;
+	struct btrfs_ioctl_logical_ino_args AUTO_KFREE(loi);
+	struct btrfs_data_container AUTO_KVFREE(inodes);
 	bool ignore_offset;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -3250,41 +3199,32 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 		size = min_t(u32, loi->size, SZ_64K);
 	} else {
 		/* All reserved bits must be 0 for now */
-		if (memchr_inv(loi->reserved, 0, sizeof(loi->reserved))) {
-			ret = -EINVAL;
-			goto out_loi;
-		}
+		if (memchr_inv(loi->reserved, 0, sizeof(loi->reserved)))
+			return -EINVAL;
+
 		/* Only accept flags we have defined so far */
-		if (loi->flags & ~(BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET)) {
-			ret = -EINVAL;
-			goto out_loi;
-		}
+		if (loi->flags & ~(BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET))
+			return -EINVAL;
+
 		ignore_offset = loi->flags & BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET;
 		size = min_t(u32, loi->size, SZ_16M);
 	}
 
 	inodes = init_data_container(size);
-	if (IS_ERR(inodes)) {
-		ret = PTR_ERR(inodes);
-		goto out_loi;
-	}
+	if (IS_ERR(inodes))
+		return PTR_ERR(inodes);
 
 	ret = iterate_inodes_from_logical(loi->logical, fs_info, inodes, ignore_offset);
 	if (ret == -EINVAL)
-		ret = -ENOENT;
+		return -ENOENT;
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	ret = copy_to_user((void __user *)(unsigned long)loi->inodes, inodes,
 			   size);
 	if (ret)
 		ret = -EFAULT;
 
-out:
-	kvfree(inodes);
-out_loi:
-	kfree(loi);
-
 	return ret;
 }
 
@@ -3381,7 +3321,7 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
 {
 	struct btrfs_root *root = BTRFS_I(file_inode(file))->root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
-	struct btrfs_ioctl_balance_args *bargs;
+	struct btrfs_ioctl_balance_args AUTO_KFREE(bargs);
 	struct btrfs_balance_control *bctl;
 	bool need_unlock = true;
 	int ret;
@@ -3466,7 +3406,6 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
 		btrfs_exclop_finish(fs_info);
 out:
 	mnt_drop_write_file(file);
-	kfree(bargs);
 	return ret;
 }
 
@@ -3519,7 +3458,7 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
 {
 	struct inode *inode = file_inode(file);
 	struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
-	struct btrfs_ioctl_quota_ctl_args *sa;
+	struct btrfs_ioctl_quota_ctl_args AUTO_KFREE(sa);
 	int ret;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -3578,7 +3517,6 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
 		break;
 	}
 
-	kfree(sa);
 drop_write:
 	mnt_drop_write_file(file);
 	return ret;
@@ -3589,8 +3527,8 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
 	struct inode *inode = file_inode(file);
 	struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct btrfs_ioctl_qgroup_assign_args *sa;
-	struct btrfs_qgroup_list *prealloc = NULL;
+	struct btrfs_ioctl_qgroup_assign_args AUTO_KFREE(sa);
+	struct btrfs_qgroup_list AUTO_KFREE(prealloc);
 	struct btrfs_trans_handle *trans;
 	int ret;
 	int err;
@@ -3615,7 +3553,7 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
 		prealloc = kzalloc_obj(*prealloc);
 		if (!prealloc) {
 			ret = -ENOMEM;
-			goto out;
+			goto drop_write;
 		}
 	}
 
@@ -3623,7 +3561,7 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
 	trans = btrfs_start_transaction(root, 2);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
-		goto out;
+		goto drop_write;
 	}
 
 	/*
@@ -3649,9 +3587,6 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
 	if (err && !ret)
 		ret = err;
 
-out:
-	kfree(prealloc);
-	kfree(sa);
 drop_write:
 	mnt_drop_write_file(file);
 	return ret;
@@ -3661,7 +3596,7 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
 {
 	struct inode *inode = file_inode(file);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct btrfs_ioctl_qgroup_create_args *sa;
+	struct btrfs_ioctl_qgroup_create_args AUTO_KFREE(sa);
 	struct btrfs_trans_handle *trans;
 	int ret;
 	int err;
@@ -3684,12 +3619,12 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
 
 	if (!sa->qgroupid) {
 		ret = -EINVAL;
-		goto out;
+		goto drop_write;
 	}
 
 	if (sa->create && btrfs_is_fstree(sa->qgroupid)) {
 		ret = -EINVAL;
-		goto out;
+		goto drop_write;
 	}
 
 	/*
@@ -3699,7 +3634,7 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
 	trans = btrfs_start_transaction(root, 2);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
-		goto out;
+		goto drop_write;
 	}
 
 	if (sa->create) {
@@ -3712,8 +3647,6 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
 	if (err && !ret)
 		ret = err;
 
-out:
-	kfree(sa);
 drop_write:
 	mnt_drop_write_file(file);
 	return ret;
@@ -3723,7 +3656,7 @@ static long btrfs_ioctl_qgroup_limit(struct file *file, void __user *arg)
 {
 	struct inode *inode = file_inode(file);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct btrfs_ioctl_qgroup_limit_args *sa;
+	struct btrfs_ioctl_qgroup_limit_args AUTO_KFREE(sa);
 	struct btrfs_trans_handle *trans;
 	int ret;
 	int err;
@@ -3749,7 +3682,7 @@ static long btrfs_ioctl_qgroup_limit(struct file *file, void __user *arg)
 	trans = btrfs_start_transaction(root, 1);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
-		goto out;
+		goto drop_write;
 	}
 
 	qgroupid = sa->qgroupid;
@@ -3764,8 +3697,6 @@ static long btrfs_ioctl_qgroup_limit(struct file *file, void __user *arg)
 	if (err && !ret)
 		ret = err;
 
-out:
-	kfree(sa);
 drop_write:
 	mnt_drop_write_file(file);
 	return ret;
@@ -3775,7 +3706,7 @@ static long btrfs_ioctl_quota_rescan(struct file *file, void __user *arg)
 {
 	struct inode *inode = file_inode(file);
 	struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
-	struct btrfs_ioctl_quota_rescan_args *qsa;
+	struct btrfs_ioctl_quota_rescan_args AUTO_KFREE(qsa);
 	int ret;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -3796,13 +3727,11 @@ static long btrfs_ioctl_quota_rescan(struct file *file, void __user *arg)
 
 	if (qsa->flags) {
 		ret = -EINVAL;
-		goto out;
+		goto drop_write;
 	}
 
 	ret = btrfs_qgroup_rescan(fs_info);
 
-out:
-	kfree(qsa);
 drop_write:
 	mnt_drop_write_file(file);
 	return ret;
@@ -3947,8 +3876,8 @@ static long _btrfs_ioctl_set_received_subvol(struct file *file,
 static long btrfs_ioctl_set_received_subvol_32(struct file *file,
 						void __user *arg)
 {
-	struct btrfs_ioctl_received_subvol_args_32 *args32 = NULL;
-	struct btrfs_ioctl_received_subvol_args *args64 = NULL;
+	struct btrfs_ioctl_received_subvol_args_32 AUTO_KFREE(args32);
+	struct btrfs_ioctl_received_subvol_args AUTO_KFREE(args64);
 	int ret = 0;
 
 	args32 = memdup_user(arg, sizeof(*args32));
@@ -3956,10 +3885,8 @@ static long btrfs_ioctl_set_received_subvol_32(struct file *file,
 		return PTR_ERR(args32);
 
 	args64 = kmalloc_obj(*args64);
-	if (!args64) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!args64)
+		return -ENOMEM;
 
 	memcpy(args64->uuid, args32->uuid, BTRFS_UUID_SIZE);
 	args64->stransid = args32->stransid;
@@ -3972,7 +3899,7 @@ static long btrfs_ioctl_set_received_subvol_32(struct file *file,
 
 	ret = _btrfs_ioctl_set_received_subvol(file, file_mnt_idmap(file), args64);
 	if (ret)
-		goto out;
+		return ret;
 
 	memcpy(args32->uuid, args64->uuid, BTRFS_UUID_SIZE);
 	args32->stransid = args64->stransid;
@@ -3985,19 +3912,16 @@ static long btrfs_ioctl_set_received_subvol_32(struct file *file,
 
 	ret = copy_to_user(arg, args32, sizeof(*args32));
 	if (ret)
-		ret = -EFAULT;
+		return -EFAULT;
 
-out:
-	kfree(args32);
-	kfree(args64);
-	return ret;
+	return 0;
 }
 #endif
 
 static long btrfs_ioctl_set_received_subvol(struct file *file,
 					    void __user *arg)
 {
-	struct btrfs_ioctl_received_subvol_args *sa = NULL;
+	struct btrfs_ioctl_received_subvol_args AUTO_KFREE(sa);
 	int ret = 0;
 
 	sa = memdup_user(arg, sizeof(*sa));
@@ -4005,17 +3929,14 @@ static long btrfs_ioctl_set_received_subvol(struct file *file,
 		return PTR_ERR(sa);
 
 	ret = _btrfs_ioctl_set_received_subvol(file, file_mnt_idmap(file), sa);
-
 	if (ret)
-		goto out;
+		return ret;
 
 	ret = copy_to_user(arg, sa, sizeof(*sa));
 	if (ret)
-		ret = -EFAULT;
+		return -EFAULT;
 
-out:
-	kfree(sa);
-	return ret;
+	return 0;
 }
 
 static int btrfs_ioctl_get_fslabel(struct btrfs_fs_info *fs_info,
@@ -4255,7 +4176,7 @@ static int btrfs_ioctl_set_features(struct file *file, void __user *arg)
 
 static int _btrfs_ioctl_send(struct btrfs_root *root, void __user *argp, bool compat)
 {
-	struct btrfs_ioctl_send_args *arg;
+	struct btrfs_ioctl_send_args AUTO_KFREE(arg);
 	int ret;
 
 	if (compat) {
@@ -4284,9 +4205,7 @@ static int _btrfs_ioctl_send(struct btrfs_root *root, void __user *argp, bool co
 		if (IS_ERR(arg))
 			return PTR_ERR(arg);
 	}
-	ret = btrfs_ioctl_send(root, arg);
-	kfree(arg);
-	return ret;
+	return btrfs_ioctl_send(root, arg);
 }
 
 static int btrfs_ioctl_encoded_read(struct file *file, void __user *argp,
-- 
2.51.0

