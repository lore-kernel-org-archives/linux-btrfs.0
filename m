Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:44017 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab3LTH3O (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Dec 2013 02:29:14 -0500
From: Wenliang Fan <fanwlexca@gmail.com>
To: clm@fb.com, jbacik@fb.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wenliang Fan <fanwlexca@gmail.com>
Subject: [PATCH] fs/btrfs: Integer overflow in btrfs_ioctl_resize()
Date: Fri, 20 Dec 2013 15:28:56 +0800
Message-Id: <1387524536-29828-1-git-send-email-fanwlexca@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The local variable 'new_size' comes from userspace. If a large number
was passed, there would be an integer overflow in the following line:
	new_size = old_size + new_size;

Signed-off-by: Wenliang Fan <fanwlexca@gmail.com>
---
 fs/btrfs/ioctl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 21da576..92f7707 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1466,6 +1466,10 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 		}
 		new_size = old_size - new_size;
 	} else if (mod > 0) {
+		if (new_size > ULLONG_MAX - old_size) {
+			ret = -EINVAL;
+			goto out_free;
+		}
 		new_size = old_size + new_size;
 	}
 
-- 
1.8.5.rc1.28.g7061504

