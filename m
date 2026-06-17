Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE283939AE
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2026 10:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781693554; cv=none; b=Njb8TVQRiN+7uDFrAEddTXtWPbXw9b98wbXhtFBTnrLwPwlAlTRw9PMD9zIAH7JFhorjB2Vw53w284jUTKUcBWWYe2K1pi1DJk7C8wSDvv+LwPCUyC34gN6zpQ65y8KmblSTCEws4XRXBtj82DN4RLN3WQUMV1GJs/U9MNV2Ntg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781693554; c=relaxed/simple;
	bh=19hC7ajYNz3kThrV/ck8uQkHLCc+0/CextZ/jgr+3cs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=LSHayC5xSLeey/p81f3VQ82AzYJXy6S+xVk0ciEqT3sY+xOmlFANKANKkhxUIya/p8KdK37U6xeHT70Z1J07eXO7SIuRwEO+0VRIP+C5UFa+CjlR4LpCSaQt/wcvHDqFS+MWprZ1s+5VGrDlcRVEHYqvMqTQ0pX7M7vWcJffeqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=EW8aziKj; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=EW8aziKj; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="EW8aziKj";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="EW8aziKj"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A95E46BBD6
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2026 10:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781693544; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cAcFQne52LMMJq65dt4hIW3Sv4vkFS69QaJfN/ozZ7s=;
	b=EW8aziKjqOoYhpxdNLdmBRr/kBA5hfOkbTMyDUUlwbSxBEIL8DV8Q2P49Taau09a4yYLRN
	Sn5os+bFqkQx5jlNuV5peGORqUw925b4gYB4MscSnDvpHfyx01YVuGIOTfqXhPg0YTFnyl
	nXmYIGLCmX7C4oY23rDSNCYLIEieQLY=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781693544; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cAcFQne52LMMJq65dt4hIW3Sv4vkFS69QaJfN/ozZ7s=;
	b=EW8aziKjqOoYhpxdNLdmBRr/kBA5hfOkbTMyDUUlwbSxBEIL8DV8Q2P49Taau09a4yYLRN
	Sn5os+bFqkQx5jlNuV5peGORqUw925b4gYB4MscSnDvpHfyx01YVuGIOTfqXhPg0YTFnyl
	nXmYIGLCmX7C4oY23rDSNCYLIEieQLY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AC0D3779AB
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2026 10:52:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Ui+hFmd8MmrAPgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2026 10:52:23 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Revert "btrfs: add 32-bit compat ioctl for BTRFS_IOC_GET_SUBVOL_INFO"
Date: Wed, 17 Jun 2026 20:22:01 +0930
Message-ID: <83e52b702dcad16021067cc9b57a23f44ee4ed3b.1781693491.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Score: -2.80

This reverts commit 538e5bdbc8996d3f6ce65565dda7df58e6e97e04.

This patch is causing libbtrfsutils regression on 64bit systems, which
is the most common cases.

The involved selftests failures look like this, all related to
unprivileged ioctls:

 ======================================================================
 FAIL: test_subvolume_get_info_unprivileged (test_subvolume.TestSubvolume.test_subvolume_get_info_unprivileged)
 ----------------------------------------------------------------------
 Traceback (most recent call last):
   File "/home/adam/btrfs-progs/libbtrfsutil/python/tests/test_subvolume.py", line 336, in test_subvolume_get_info_unprivileged
     self._test_subvolume_info(subvol, snapshot)
     ~~~~~~~~~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^
   File "/home/adam/btrfs-progs/libbtrfsutil/python/tests/test_subvolume.py", line 196, in _test_subvolume_info
     self.assertEqual(info.id, 256)
     ~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^
 AssertionError: 140488005556880 != 256

 ======================================================================
 FAIL: test_subvolume_info_unprivileged (test_subvolume.TestSubvolume.test_subvolume_info_unprivileged)
 ----------------------------------------------------------------------
 Traceback (most recent call last):
   File "/home/adam/btrfs-progs/libbtrfsutil/python/tests/test_subvolume.py", line 318, in test_subvolume_info_unprivileged
     self._test_subvolume_info(subvol, snapshot)
     ~~~~~~~~~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^
   File "/home/adam/btrfs-progs/libbtrfsutil/python/tests/test_subvolume.py", line 196, in _test_subvolume_info
     self.assertEqual(info.id, 256)
     ~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^
 AssertionError: 140488005503648 != 256

 ======================================================================
 FAIL: test_subvolume_iterator_unprivileged (test_subvolume.TestSubvolume.test_subvolume_iterator_unprivileged)
 ----------------------------------------------------------------------
 Traceback (most recent call last):
   File "/home/adam/btrfs-progs/libbtrfsutil/python/tests/test_subvolume.py", line 835, in test_subvolume_iterator_unprivileged
     self._test_subvolume_iterator()
     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^^
   File "/home/adam/btrfs-progs/libbtrfsutil/python/tests/test_subvolume.py", line 700, in _test_subvolume_iterator
     self.assertEqual(subvol.id, 256)
     ~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^
 AssertionError: 0 != 256

Adding 32bit compatibility should never cause regression on 64bit
systems.

Revert the offending commit to avoid regression.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ioctl.c | 107 ++++++-----------------------------------------
 1 file changed, 13 insertions(+), 94 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9d47d16394fc..360637e9edfc 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -83,30 +83,6 @@ struct btrfs_ioctl_received_subvol_args_32 {
 
 #define BTRFS_IOC_SET_RECEIVED_SUBVOL_32 _IOWR(BTRFS_IOCTL_MAGIC, 37, \
 				struct btrfs_ioctl_received_subvol_args_32)
-
-struct btrfs_ioctl_get_subvol_info_args_32 {
-	__u64 treeid;
-	char name[BTRFS_VOL_NAME_MAX + 1];
-	__u64 parent_id;
-	__u64 dirid;
-	__u64 generation;
-	__u64 flags;
-	__u8 uuid[BTRFS_UUID_SIZE];
-	__u8 parent_uuid[BTRFS_UUID_SIZE];
-	__u8 received_uuid[BTRFS_UUID_SIZE];
-	__u64 ctransid;
-	__u64 otransid;
-	__u64 stransid;
-	__u64 rtransid;
-	struct btrfs_ioctl_timespec_32 ctime;
-	struct btrfs_ioctl_timespec_32 otime;
-	struct btrfs_ioctl_timespec_32 stime;
-	struct btrfs_ioctl_timespec_32 rtime;
-	__u64 reserved[8];
-} __attribute__ ((__packed__));
-
-#define BTRFS_IOC_GET_SUBVOL_INFO_32 _IOR(BTRFS_IOCTL_MAGIC, 60, \
-				struct btrfs_ioctl_get_subvol_info_args_32)
 #endif
 
 #if defined(CONFIG_64BIT) && defined(CONFIG_COMPAT)
@@ -1948,9 +1924,9 @@ static int btrfs_ioctl_ino_lookup_user(struct file *file, void __user *argp)
 }
 
 /* Get the subvolume information in BTRFS_ROOT_ITEM and BTRFS_ROOT_BACKREF */
-static int _btrfs_ioctl_get_subvol_info(struct inode *inode,
-					struct btrfs_ioctl_get_subvol_info_args *subvol_info)
+static int btrfs_ioctl_get_subvol_info(struct inode *inode, void __user *argp)
 {
+	struct btrfs_ioctl_get_subvol_info_args AUTO_KFREE(subvol_info);
 	struct btrfs_fs_info *fs_info;
 	struct btrfs_root *root;
 	struct btrfs_path *path;
@@ -1966,6 +1942,12 @@ static int _btrfs_ioctl_get_subvol_info(struct inode *inode,
 	if (!path)
 		return -ENOMEM;
 
+	subvol_info = kzalloc_obj(*subvol_info);
+	if (!subvol_info) {
+		btrfs_free_path(path);
+		return -ENOMEM;
+	}
+
 	fs_info = BTRFS_I(inode)->root->fs_info;
 
 	/* Get root_item of inode's subvolume */
@@ -2044,6 +2026,11 @@ static int _btrfs_ioctl_get_subvol_info(struct inode *inode,
 		}
 	}
 
+	btrfs_free_path(path);
+	path = NULL;
+	if (copy_to_user(argp, subvol_info, sizeof(*subvol_info)))
+		ret = -EFAULT;
+
 out:
 	btrfs_put_root(root);
 out_free:
@@ -2051,70 +2038,6 @@ static int _btrfs_ioctl_get_subvol_info(struct inode *inode,
 	return ret;
 }
 
-#ifdef CONFIG_64BIT
-static int btrfs_ioctl_get_subvol_info_32(struct inode *inode, void __user *argp)
-{
-	struct btrfs_ioctl_get_subvol_info_args AUTO_KFREE(subvol_info);
-	struct btrfs_ioctl_get_subvol_info_args_32 AUTO_KFREE(subvol_info_32);
-	int ret;
-
-	subvol_info = kzalloc_obj(*subvol_info);
-	if (!subvol_info)
-		return -ENOMEM;
-
-	subvol_info_32 = kzalloc_obj(*subvol_info_32);
-	if (!subvol_info_32)
-		return -ENOMEM;
-
-	ret = _btrfs_ioctl_get_subvol_info(inode, subvol_info);
-	if (ret)
-		return ret;
-
-	subvol_info_32->treeid = subvol_info->treeid;
-	memcpy(subvol_info_32->name, subvol_info->name, sizeof(subvol_info_32->name));
-	subvol_info_32->parent_id = subvol_info->parent_id;
-	subvol_info_32->dirid = subvol_info->dirid;
-	subvol_info_32->generation = subvol_info->generation;
-	subvol_info_32->flags = subvol_info->flags;
-	memcpy(subvol_info_32->uuid, subvol_info->uuid, BTRFS_UUID_SIZE);
-	memcpy(subvol_info_32->parent_uuid, subvol_info->parent_uuid, BTRFS_UUID_SIZE);
-	memcpy(subvol_info_32->received_uuid, subvol_info->received_uuid, BTRFS_UUID_SIZE);
-	subvol_info_32->ctransid = subvol_info->ctransid;
-	subvol_info_32->otransid = subvol_info->otransid;
-	subvol_info_32->stransid = subvol_info->stransid;
-	subvol_info_32->rtransid = subvol_info->rtransid;
-	subvol_info_32->ctime.sec = subvol_info->ctime.sec;
-	subvol_info_32->ctime.nsec = subvol_info->ctime.nsec;
-	subvol_info_32->otime.sec = subvol_info->otime.sec;
-	subvol_info_32->otime.nsec = subvol_info->otime.nsec;
-	subvol_info_32->stime.sec = subvol_info->stime.sec;
-	subvol_info_32->stime.nsec = subvol_info->stime.nsec;
-	subvol_info_32->rtime.sec = subvol_info->rtime.sec;
-	subvol_info_32->rtime.nsec = subvol_info->rtime.nsec;
-
-	if (copy_to_user(argp, subvol_info_32, sizeof(*subvol_info_32)))
-		ret = -EFAULT;
-
-	return ret;
-}
-#endif
-
-static int btrfs_ioctl_get_subvol_info(struct inode *inode, void __user *argp)
-{
-	struct btrfs_ioctl_get_subvol_info_args AUTO_KFREE(subvol_info);
-	int ret;
-
-	subvol_info = kzalloc_obj(*subvol_info);
-	if (!subvol_info)
-		return -ENOMEM;
-
-	ret = _btrfs_ioctl_get_subvol_info(inode, subvol_info);
-	if (!ret && copy_to_user(argp, subvol_info, sizeof(*subvol_info)))
-		ret = -EFAULT;
-
-	return ret;
-}
-
 /*
  * Return ROOT_REF information of the subvolume containing this inode
  * except the subvolume name.
@@ -5610,10 +5533,6 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_set_features(file, argp);
 	case BTRFS_IOC_GET_SUBVOL_INFO:
 		return btrfs_ioctl_get_subvol_info(inode, argp);
-#ifdef CONFIG_64BIT
-	case BTRFS_IOC_GET_SUBVOL_INFO_32:
-		return btrfs_ioctl_get_subvol_info_32(inode, argp);
-#endif
 	case BTRFS_IOC_GET_SUBVOL_ROOTREF:
 		return btrfs_ioctl_get_subvol_rootref(root, argp);
 	case BTRFS_IOC_INO_LOOKUP_USER:
-- 
2.54.0

