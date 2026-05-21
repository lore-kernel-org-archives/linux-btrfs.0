Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02ACC348C55
	for <linux-btrfs@vger.kernel.org>; Thu, 21 May 2026 07:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779349895; cv=none; b=fvFDzoB9aBOwqJ4boJL37TGjYv5n5DNKz5AUqnU80zLHjELf0OVocJnvKJFA/moV+c04PXbTyuy4E1fLBjqkPxeRoU7Z1BDmm+CFab6NN72q5/PrrWfQFXaRsfnGTuDZMi6UC6fZ5BIhNBbKHoP7laYVLwI+XTQdI3Nllwg8HeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779349895; c=relaxed/simple;
	bh=/EZ86jP9n2KvRGXFplMEg0RE4WZbfteYbg+zSLlRd9g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PTi14fMw8Xu2ikP/+qXpmq6p5de696k495nsoUgNrgBj3QfQq+LP6A3Ia1Vkk4hN3xRxlKQWaexNUlZHq4vPMcc1jvFjK6p3ZuEs/cPVhcwf3VcINagqjXaGMIHZVfVSXJUBUAF7PoJVQvhq++ZIC6werlHpxS5Rzjtzl7NvI6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com; spf=pass smtp.mailfrom=amutable.com; dkim=pass (2048-bit key) header.d=amutable-com.20251104.gappssmtp.com header.i=@amutable-com.20251104.gappssmtp.com header.b=wg8GYj68; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20251104.gappssmtp.com header.i=@amutable-com.20251104.gappssmtp.com header.b="wg8GYj68"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-48e8132c6d0so37820575e9.1
        for <linux-btrfs@vger.kernel.org>; Thu, 21 May 2026 00:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20251104.gappssmtp.com; s=20251104; t=1779349892; x=1779954692; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3aI5YzARhLsUA4MyC+qMzawRsnYJRP6u3t4Wfim/QNY=;
        b=wg8GYj68HBFvvGVMhlcC6gmQt9Yae/2+L/EIdJfE5sUk88YGpXkK6+BQkbLmwSaURy
         3sC29JJJhuVAAIG4pMmzU+1nI87J+Ax/jmBCthnF0X26vAArRvprfiJSdlymPghLiLOV
         dQlRby0rSSYNs8ULrb/lEzxOrlQm6d1J+CRC/LWnm+kKUEhT31+H3gC7hl/mIunftLUF
         U650f028a5pZVALrUsTwU22jsP92nRSINVNfd3T3VJwuh3t7ihBcEBM9Z5/Eng3NPn7R
         3sx7/qoorVn6+ADgGFBF9Eez89wkBIN+CQbegX0Qnp41sbjhcqVC6AMIPtynKJ/5r1fp
         2utg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779349892; x=1779954692;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3aI5YzARhLsUA4MyC+qMzawRsnYJRP6u3t4Wfim/QNY=;
        b=CemZSb5RdYubtyZEbIJGbzPeZJr63jN4hwz0W0Z9yobF7YYbXAGrelpbwKKMr1KFCF
         0ORuQquFMMn+5vbQtmNm+2+CxaUDZ6bd2NA4CWlVCHqMLg2WskzuEBJuVpCADsIGHpgk
         i3I65//LqmHOdhJcgM/OWQZWl9bZHBvXMtVO12mHrnMUi9V0ZlMlNC+XDqHtqPbhW3q4
         fQ1XwfMz/RhsmYDV4bUQbzu0RrG8/CgnpVryTaF3jMHFqbdRtcYoDpAA/Br7p0ROM5TQ
         E2lA+U6xpnRqbiRNeBI7qmpXqId8O00kxkOFLUSiWcAlDyxGL4vpfU8UKZgpit9zMak1
         QapA==
X-Gm-Message-State: AOJu0YxeabcxAQK0EP1EK5a075n9t3t8B5RFKmSHQLrEK3emVVOVj5Me
	kfhs8gxtzpJsEdH5XxzMT1OgsF71gu5SoaOhCFyVPJJ8ytxLOnDhdnMU+w/qtKXJ2STEAnbomSr
	Ah4GTUN+w
X-Gm-Gg: Acq92OEJDF68MAOvK7lGGdS1UO/nn362ysJyEEATG6ZyKYXKZCbhLZiord4qA4RoTFo
	AmiIqx51qSKmc/GTiF2J8nhYklMasaJoNzEgelqIwk1mpjI98DD/1WSMc5D/NtBah9dqcKw3UVC
	ChGg8iwBqJaDTaXRb8cTMviY8qirNLtyO1i9Xg5XtsFx05Yt/iNK6CZQuaRHShw9NGrj/5R7yYu
	uwVXUqJoZQ4cGTNBfp8yHsgJCo1Df1N0jjcocPKs+l6RN/umhKfUIX0kBQhe4XLymSukv6FRHpX
	+qX87qNWwQB2tOYyfCrJ9wHR2Y6zNPRIlNRitXseVSF2+m6a/ewols82eYjPQVI4F2pqbsQ/OBi
	HVu/9sliP6CEV9L5I0Md1SssT981M7AUm4RTH2sPXjntG9lT34JBYGdGsQPsGho3jqYLdsan8Bw
	OBBzSKS4csUp2r9i5RK0dYTIV9DlJIIhVVgmMAhezgGKRUj2qhWo8FlpJcVv8ph/y1r+ghS7t30
	dXeiLAFtjnbnadRtW53Gxgk8lO9hlhN8E/sxvb4no8H2Zk7jm/8VO6z
X-Received: by 2002:a05:600c:489a:b0:48e:8741:fd53 with SMTP id 5b1f17b1804b1-4903605e47bmr13767225e9.15.1779349891741;
        Thu, 21 May 2026 00:51:31 -0700 (PDT)
Received: from particle-07b4-08e3 (2a02-1810-950a-eb00-a90e-161c-9ea3-63c9.ip6.access.telenet.be. [2a02:1810:950a:eb00:a90e:161c:9ea3:63c9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4903c9a5108sm7085365e9.6.2026.05.21.00.51.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 00:51:30 -0700 (PDT)
From: Daan De Meyer <daan@amutable.com>
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Daan De Meyer <daan@amutable.com>
Subject: [PATCH] btrfs: add 32-bit compat ioctl for BTRFS_IOC_GET_SUBVOL_INFO
Date: Thu, 21 May 2026 07:51:13 +0000
Message-ID: <20260521075113.1079519-1-daan@amutable.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 64-bit kernels with 32-bit userspace, struct btrfs_ioctl_timespec is
laid out as 16 bytes (8B sec + 4B nsec + 4B trailing padding) instead of
the 12 bytes a 32-bit userspace expects, because the surrounding struct
is not packed. As a result, struct btrfs_ioctl_get_subvol_info_args has
a different size and layout in 32-bit userspace than in the 64-bit
kernel, and BTRFS_IOC_GET_SUBVOL_INFO returns garbage to 32-bit callers.

Mirror what was done for BTRFS_IOC_SET_RECEIVED_SUBVOL: add a packed
btrfs_ioctl_get_subvol_info_args_32 with btrfs_ioctl_timespec_32 fields,
define BTRFS_IOC_GET_SUBVOL_INFO_32 with that struct as the size
argument, factor the existing handler into a shared _btrfs_ioctl_get_
subvol_info() helper, and add btrfs_ioctl_get_subvol_info_32() which
fills the kernel struct and translates field-by-field into the 32-bit
struct before copy_to_user().

Signed-off-by: Daan De Meyer <daan@amutable.com>
---
 fs/btrfs/ioctl.c | 112 +++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 99 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a39460bf68a7..31be2590f1b2 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -82,6 +82,30 @@ struct btrfs_ioctl_received_subvol_args_32 {
 
 #define BTRFS_IOC_SET_RECEIVED_SUBVOL_32 _IOWR(BTRFS_IOCTL_MAGIC, 37, \
 				struct btrfs_ioctl_received_subvol_args_32)
+
+struct btrfs_ioctl_get_subvol_info_args_32 {
+	__u64 treeid;
+	char name[BTRFS_VOL_NAME_MAX + 1];
+	__u64 parent_id;
+	__u64 dirid;
+	__u64 generation;
+	__u64 flags;
+	__u8 uuid[BTRFS_UUID_SIZE];
+	__u8 parent_uuid[BTRFS_UUID_SIZE];
+	__u8 received_uuid[BTRFS_UUID_SIZE];
+	__u64 ctransid;
+	__u64 otransid;
+	__u64 stransid;
+	__u64 rtransid;
+	struct btrfs_ioctl_timespec_32 ctime;
+	struct btrfs_ioctl_timespec_32 otime;
+	struct btrfs_ioctl_timespec_32 stime;
+	struct btrfs_ioctl_timespec_32 rtime;
+	__u64 reserved[8];
+} __attribute__ ((__packed__));
+
+#define BTRFS_IOC_GET_SUBVOL_INFO_32 _IOR(BTRFS_IOCTL_MAGIC, 60, \
+				struct btrfs_ioctl_get_subvol_info_args_32)
 #endif
 
 #if defined(CONFIG_64BIT) && defined(CONFIG_COMPAT)
@@ -1945,9 +1969,9 @@ static int btrfs_ioctl_ino_lookup_user(struct file *file, void __user *argp)
 }
 
 /* Get the subvolume information in BTRFS_ROOT_ITEM and BTRFS_ROOT_BACKREF */
-static int btrfs_ioctl_get_subvol_info(struct inode *inode, void __user *argp)
+static int _btrfs_ioctl_get_subvol_info(struct inode *inode,
+					struct btrfs_ioctl_get_subvol_info_args *subvol_info)
 {
-	struct btrfs_ioctl_get_subvol_info_args *subvol_info;
 	struct btrfs_fs_info *fs_info;
 	struct btrfs_root *root;
 	struct btrfs_path *path;
@@ -1964,12 +1988,6 @@ static int btrfs_ioctl_get_subvol_info(struct inode *inode, void __user *argp)
 	if (!path)
 		return -ENOMEM;
 
-	subvol_info = kzalloc_obj(*subvol_info);
-	if (!subvol_info) {
-		btrfs_free_path(path);
-		return -ENOMEM;
-	}
-
 	fs_info = BTRFS_I(inode)->root->fs_info;
 
 	/* Get root_item of inode's subvolume */
@@ -2048,15 +2066,79 @@ static int btrfs_ioctl_get_subvol_info(struct inode *inode, void __user *argp)
 		}
 	}
 
-	btrfs_free_path(path);
-	path = NULL;
-	if (copy_to_user(argp, subvol_info, sizeof(*subvol_info)))
-		ret = -EFAULT;
-
 out:
 	btrfs_put_root(root);
 out_free:
 	btrfs_free_path(path);
+	return ret;
+}
+
+#ifdef CONFIG_64BIT
+static int btrfs_ioctl_get_subvol_info_32(struct inode *inode, void __user *argp)
+{
+	struct btrfs_ioctl_get_subvol_info_args *subvol_info = NULL;
+	struct btrfs_ioctl_get_subvol_info_args_32 *subvol_info_32 = NULL;
+	int ret;
+
+	subvol_info = kzalloc_obj(*subvol_info);
+	if (!subvol_info)
+		return -ENOMEM;
+
+	subvol_info_32 = kzalloc_obj(*subvol_info_32);
+	if (!subvol_info_32) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = _btrfs_ioctl_get_subvol_info(inode, subvol_info);
+	if (ret)
+		goto out;
+
+	subvol_info_32->treeid = subvol_info->treeid;
+	memcpy(subvol_info_32->name, subvol_info->name, sizeof(subvol_info_32->name));
+	subvol_info_32->parent_id = subvol_info->parent_id;
+	subvol_info_32->dirid = subvol_info->dirid;
+	subvol_info_32->generation = subvol_info->generation;
+	subvol_info_32->flags = subvol_info->flags;
+	memcpy(subvol_info_32->uuid, subvol_info->uuid, BTRFS_UUID_SIZE);
+	memcpy(subvol_info_32->parent_uuid, subvol_info->parent_uuid, BTRFS_UUID_SIZE);
+	memcpy(subvol_info_32->received_uuid, subvol_info->received_uuid, BTRFS_UUID_SIZE);
+	subvol_info_32->ctransid = subvol_info->ctransid;
+	subvol_info_32->otransid = subvol_info->otransid;
+	subvol_info_32->stransid = subvol_info->stransid;
+	subvol_info_32->rtransid = subvol_info->rtransid;
+	subvol_info_32->ctime.sec = subvol_info->ctime.sec;
+	subvol_info_32->ctime.nsec = subvol_info->ctime.nsec;
+	subvol_info_32->otime.sec = subvol_info->otime.sec;
+	subvol_info_32->otime.nsec = subvol_info->otime.nsec;
+	subvol_info_32->stime.sec = subvol_info->stime.sec;
+	subvol_info_32->stime.nsec = subvol_info->stime.nsec;
+	subvol_info_32->rtime.sec = subvol_info->rtime.sec;
+	subvol_info_32->rtime.nsec = subvol_info->rtime.nsec;
+
+	if (copy_to_user(argp, subvol_info_32, sizeof(*subvol_info_32)))
+		ret = -EFAULT;
+
+out:
+	kfree(subvol_info_32);
+	kfree(subvol_info);
+	return ret;
+}
+#endif
+
+static int btrfs_ioctl_get_subvol_info(struct inode *inode, void __user *argp)
+{
+	struct btrfs_ioctl_get_subvol_info_args *subvol_info;
+	int ret;
+
+	subvol_info = kzalloc_obj(*subvol_info);
+	if (!subvol_info)
+		return -ENOMEM;
+
+	ret = _btrfs_ioctl_get_subvol_info(inode, subvol_info);
+	if (!ret && copy_to_user(argp, subvol_info, sizeof(*subvol_info)))
+		ret = -EFAULT;
+
 	kfree(subvol_info);
 	return ret;
 }
@@ -5273,6 +5355,10 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_set_features(file, argp);
 	case BTRFS_IOC_GET_SUBVOL_INFO:
 		return btrfs_ioctl_get_subvol_info(inode, argp);
+#ifdef CONFIG_64BIT
+	case BTRFS_IOC_GET_SUBVOL_INFO_32:
+		return btrfs_ioctl_get_subvol_info_32(inode, argp);
+#endif
 	case BTRFS_IOC_GET_SUBVOL_ROOTREF:
 		return btrfs_ioctl_get_subvol_rootref(root, argp);
 	case BTRFS_IOC_INO_LOOKUP_USER:
-- 
2.54.0

