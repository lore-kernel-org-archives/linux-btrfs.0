Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33438 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbbGVVqx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jul 2015 17:46:53 -0400
Received: by wicmv11 with SMTP id mv11so98706311wic.0
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2015 14:46:51 -0700 (PDT)
Received: from [192.168.178.26] (155-219-103-86.dynamic.dsl.tng.de. [86.103.219.155])
        by smtp.googlemail.com with ESMTPSA id gw7sm23980887wib.15.2015.07.22.14.46.50
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Wed, 22 Jul 2015 14:46:51 -0700 (PDT)
Message-ID: <55B00F4A.5040508@gmail.com>
Date: Wed, 22 Jul 2015 23:46:50 +0200
From: Thomas Rohwer <trohwer85@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs send ioctl does not support 32 bit user space with 64 bit kernel
 in Linux 4.1.3 ; patch included
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I am using as kernel Linux 4.1.3 (64bit) and btrfs-prog version 4.0 (32 bit user space).
I wanted to use send/receive with btrfs for the first time today and I got the following error:

humbur:~# btrfs send /snap > /dev/null
At subvol /snap
ERROR: send ioctl failed with -25: Inappropriate ioctl for device
ERROR: failed to read stream from kernel. Bad file descriptor


Investigating the source, I noticed that probably the problem is the member clone_sources in the structure

struct btrfs_ioctl_send_args {
   __s64 send_fd;      /* in */
   __u64 clone_sources_count;  /* in */
   __u64 __user *clone_sources;  /* in */
   __u64 parent_root;    /* in */
   __u64 flags;      /* in */
   __u64 reserved[4];    /* in */
};

in include/uapi/linux/btrfs.h and the missing adaption code in fs/btrfs/ioctl.c. The member clone_sources is only 32 bit wide in case of 32 bit user space.
For the ioctl RECEIVED_SUBVOL somebody already added code for the in this case also necessary translation. I took this as a template and
wrote a patch (see below). The patch compiles and with the new kernel I seem to get valid data with send (I have to read it back yet,
but I get about the expected amount and structure).

This is a proof of concept patch; for example the compiler currently warns for
  (args64->clone_sources = (__u64*)args32->clone_sources;
and I would have to investigate how to properly convert the pointer. Further there are probably some issues with the formating of the source code.
I also have not tested the 32bit/32bit 64bit/64bit userspace/kernel combinations.
If there is interest, I can resubmit an improved patch. Please CC me in replies, since I have not subscribed to the list.


Sincerely,

Thomas Rohwer





Signed-off-by: Thomas Rohwer <trohwer85@gmail.com>

 From e4156c38105200fa83913b6a94f07a41631c5f75 Mon Sep 17 00:00:00 2001
From: Thomas <tr@humbur.fritz.box>
Date: Wed, 22 Jul 2015 22:03:15 +0200
Subject: [PATCH] add 32 bit adaption code for send ioctl

---
  fs/btrfs/ioctl.c | 73 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  fs/btrfs/send.c  | 11 +--------
  fs/btrfs/send.h  |  2 +-
  3 files changed, 75 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 1c22c65..8b969c0 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -83,6 +83,19 @@ struct btrfs_ioctl_received_subvol_args_32 {

  #define BTRFS_IOC_SET_RECEIVED_SUBVOL_32 _IOWR(BTRFS_IOCTL_MAGIC, 37, \
  				struct btrfs_ioctl_received_subvol_args_32)
+
+struct btrfs_ioctl_send_args_32 {
+	__s64 send_fd;                  /* in */
+	__u64 clone_sources_count;      /* in */
+	__u32 clone_sources;            /* in */
+	__u64 parent_root;              /* in */
+	__u64 flags;                    /* in */
+	__u64 reserved[4];              /* in */
+} __attribute__ ((__packed__));
+
+#define BTRFS_IOC_SEND_32 _IOW(BTRFS_IOCTL_MAGIC, 38, \
+				struct btrfs_ioctl_send_args_32)
+
  #endif


@@ -4965,6 +4978,43 @@ out:
  	kfree(args64);
  	return ret;
  }
+
+static long btrfs_ioctl_send_32(struct file *file,
+						void __user *arg)
+{
+	struct btrfs_ioctl_send_args_32 *args32 = NULL;
+	struct btrfs_ioctl_send_args *args64 = NULL;
+	int ret = 0;
+
+	args32 = memdup_user(arg, sizeof(*args32));
+	if (IS_ERR(args32)) {
+		ret = PTR_ERR(args32);
+		args32 = NULL;
+		goto out;
+	}
+
+	args64 = kmalloc(sizeof(*args64), GFP_NOFS);
+	if (!args64) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	args64->send_fd = args32->send_fd;
+	args64->clone_sources_count = args32->clone_sources_count;
+	args64->clone_sources = (__u64*)args32->clone_sources;
+	args64->parent_root = args32->parent_root;
+	args64->flags = args32->flags;
+
+	ret = _btrfs_ioctl_send(file, args64);
+	
+	// only in arguments, so no copy back to args32
+
+out:
+	kfree(args32);
+	kfree(args64);
+	return ret;
+}
+
  #endif

  static long btrfs_ioctl_set_received_subvol(struct file *file,
@@ -4994,6 +5044,27 @@ out:
  	return ret;
  }

+static long btrfs_ioctl_send(struct file *file,
+					    void __user *arg)
+{
+	struct btrfs_ioctl_send_args *sa = NULL;
+	int ret = 0;
+
+	sa = memdup_user(arg, sizeof(*sa));
+	if (IS_ERR(sa)) {
+		ret = PTR_ERR(sa);
+		sa = NULL;
+		goto out;
+	}
+
+	ret = _btrfs_ioctl_send(file, sa);
+
+out:
+	kfree(sa);
+	return ret;
+}
+
+
  static int btrfs_ioctl_get_fslabel(struct file *file, void __user *arg)
  {
  	struct btrfs_root *root = BTRFS_I(file_inode(file))->root;
@@ -5320,6 +5391,8 @@ long btrfs_ioctl(struct file *file, unsigned int
  #ifdef CONFIG_64BIT
  	case BTRFS_IOC_SET_RECEIVED_SUBVOL_32:
  		return btrfs_ioctl_set_received_subvol_32(file, argp);
+	case BTRFS_IOC_SEND_32:
+		return btrfs_ioctl_send_32(file, argp);
  #endif
  	case BTRFS_IOC_SEND:
  		return btrfs_ioctl_send(file, argp);
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index a1216f9..6838078 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -5663,13 +5663,12 @@ static void btrfs_root_dec_send_in_progress(struct btrfs_root* root)
  	spin_unlock(&root->root_item_lock);
  }

-long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
+long _btrfs_ioctl_send(struct file *mnt_file, struct btrfs_ioctl_send_args *arg)
  {
  	int ret = 0;
  	struct btrfs_root *send_root;
  	struct btrfs_root *clone_root;
  	struct btrfs_fs_info *fs_info;
-	struct btrfs_ioctl_send_args *arg = NULL;
  	struct btrfs_key key;
  	struct send_ctx *sctx = NULL;
  	u32 i;
@@ -5707,13 +5706,6 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
  		goto out;
  	}

-	arg = memdup_user(arg_, sizeof(*arg));
-	if (IS_ERR(arg)) {
-		ret = PTR_ERR(arg);
-		arg = NULL;
-		goto out;
-	}
-
  	if (!access_ok(VERIFY_READ, arg->clone_sources,
  			sizeof(*arg->clone_sources) *
  			arg->clone_sources_count)) {
@@ -5942,7 +5934,6 @@ out:
  	if (sctx && !IS_ERR_OR_NULL(sctx->parent_root))
  		btrfs_root_dec_send_in_progress(sctx->parent_root);

-	kfree(arg);
  	vfree(clone_sources_tmp);

  	if (sctx) {
diff --git a/fs/btrfs/send.h b/fs/btrfs/send.h
index 48d425a..fb43556 100644
--- a/fs/btrfs/send.h
+++ b/fs/btrfs/send.h
@@ -130,5 +130,5 @@ enum {
  #define BTRFS_SEND_A_MAX (__BTRFS_SEND_A_MAX - 1)

  #ifdef __KERNEL__
-long btrfs_ioctl_send(struct file *mnt_file, void __user *arg);
+long _btrfs_ioctl_send(struct file *mnt_file, struct btrfs_ioctl_send_args *arg);
  #endif
-- 
2.1.4


