Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795112906;
	b=WeYwepvBbt6ZnQeDjyibt18C+w76WDOeQCPhG2S0ekCrvrEtx0ELUl4GDdDGPJbsI4Sd
	 YT83Dc2OAq2JZ0yUeOI/FaYMCXd5eai0IY+DNDhPzqh7ThKxhcXkpAPcB259fLg1tgHQd
	 ob32tvxVdtSQEInS44yQqV8mMgt40M/e0h9IkpM/xVn0kk+Von4XGqnkvi5Mqg0vHO9eA
	 A65O/v8CLCuTa2XnodlkI4H/gTuOOfiT3VJmmwtP3UtN7usbffSkits6C9Ujzzm0Oqqd0
	 TVKPhZKvJmi6CiwjfogZHHFxvC+aduAqg4pXVy1nfc4swHTneRivEwdpmQsnVOY9sHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795112906;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=uqLpLxv8bLQr4W44BYPxgaZOxuBRMe12kLOb1QeOYhk=;
	b=MfYQ50wxJYC4RakkVHVnGHCYLofGOBUBlFrF/1XyXm0yF/84LxqIx0s9eT9MPpLhZZSz
	 UNNwLJbMNYw/iN3+ZKYSHCjDa/lL9In6OSNapAR6xQ1zhxltviFzxkfNS2Qg3U23fXajx
	 Yofu9CJ8zXl7TR7+DI4+6OSlRUoHG/i+8gnMMYwY/tj3QaXA2mMkTuAfwzp4Re2mHFST/
	 E8gSsdIwAOfm3jRpQEDIOf6p3Ti1YG1LlwxLyoaa9FJoPfQrVlSnhGvd4lrQcFP+ih0y/
	 PlKLPOBXme+QaWqs6N7hsFqP0kG9QfJu9wQ1wQr/SRm4BPR8lDfpBiZjoPWkNM226bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bjhIh6XZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C78B606A32C
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 18:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bjhIh6XZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A681F000C6
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 18:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795112906;
	bh=uqLpLxv8bLQr4W44BYPxgaZOxuBRMe12kLOb1QeOYhk=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=bjhIh6XZ2ndAVHpgOMg9iK/8wnL4u9SUL+zpH8cnwMIydxeqRPX2kdEikfX8VOY5n
	 0k+NdLi00BGYuRsG1dY5H7rDVV5QvLNgAe5btOFNCEHJsoA6h07hW4mLpTIViH8NlB
	 S4RxOXR8sfydHncHekTUtqaKh4mEm7yukGAC4xwJOnHpksLUMOGgMrwGxssO3MEnDs
	 L4L0GRq0NguyPS7QZFN3tHQumQQ/c7AE2IbTRaF/c3ni+204R/PJdJQWLovaHz2Tvq
	 CzXkIAZlNn07os5r2FyHWYyd/McHFNfkcGJTa9W34sbWrpKmLzpaMwqYTnBj5lvFDB
	 SCqhAUGp4b+kw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: fix incorrect memory copying in BTRFS_IOC_GET_SUPPORTED_FEATURES
Date: Thu, 19 Nov 2026 18:28:20 +0000
Message-ID: <6680855bc8cae04685712762f9e971f0ea2fa19b.1795112801.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1795112801.git.fdmanana@suse.com>
References: <cover.1795112801.git.fdmanana@suse.com>
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

In btrfs_control_ioctl() we always assume the argument from user space
matches a 4096 bytes buffer, for a struct btrfs_ioctl_vol_args. That was
true until commit c5868f8362f5 ("btrfs: add GET_SUPPORTED_FEATURES to the
control device ioctls"), because back then all the control ioctls took
such a structure as an argument (and for input). However after that commit
we now have an ioctl that does not take that struct as an argument, it
takes a buffer that can be much smaller than that and it's only used for
output, so it does not make sense to treat it as a struct
btrfs_ioctl_vol_args and to validate it as such. Plus doing the
memdup_user() call can result in an -EFAULT error if user space passes a
buffer much smaller than sizeof(struct btrfs_ioctl_vol_args), as
attempting to read beyond its limit can cross an unmapped page.

Fix this by doing the memdup_user() and btrfs_check_ioctl_vol_args_path()
only if the ioctl is not BTRFS_IOC_GET_SUPPORTED_FEATURES.

Fixes: c5868f8362f5 ("btrfs: add GET_SUPPORTED_FEATURES to the control device ioctls")
Link: https://sashiko.dev/#/bug/linux-7dac1d86-8580-4ba2-b8c5-c15fa9cdb0e8
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/super.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b424cc836bd4..90e45becb59b 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2240,7 +2240,7 @@ static int btrfs_control_open(struct inode *inode, struct file *file)
 static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 				unsigned long arg)
 {
-	struct btrfs_ioctl_vol_args *vol;
+	struct btrfs_ioctl_vol_args *vol = NULL;
 	struct btrfs_device *device = NULL;
 	dev_t devt = 0;
 	int ret = -ENOTTY;
@@ -2248,12 +2248,28 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	vol = memdup_user((void __user *)arg, sizeof(*vol));
-	if (IS_ERR(vol))
-		return PTR_ERR(vol);
-	ret = btrfs_check_ioctl_vol_args_path(vol);
-	if (ret < 0)
-		goto out;
+	switch (cmd) {
+	case BTRFS_IOC_SCAN_DEV:
+	case BTRFS_IOC_FORGET_DEV:
+	case BTRFS_IOC_DEVICES_READY:
+		/*
+		 * Not all control ioctls take a struct btrfs_ioctl_vol_args as
+		 * argument, some may pass a smaller buffer and attempting to
+		 * read more may result in an unexpected -EFAULT if the memory
+		 * crosses an unmapped page. BTRFS_IOC_GET_SUPPORTED_FEATURES
+		 * expects a much smaller buffer for a short array of
+		 * struct btrfs_ioctl_feature_flags elements. So attempt a copy
+		 * of a struct btrfs_ioctl_vol_args only for the ioctls that
+		 * expect such an argument.
+		 */
+		vol = memdup_user((void __user *)arg, sizeof(*vol));
+		if (IS_ERR(vol))
+			return PTR_ERR(vol);
+		ret = btrfs_check_ioctl_vol_args_path(vol);
+		if (ret < 0)
+			goto out;
+		break;
+	}
 
 	switch (cmd) {
 	case BTRFS_IOC_SCAN_DEV:
-- 
2.53.0

