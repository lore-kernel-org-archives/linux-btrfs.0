Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:53072 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab3JaE7q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Oct 2013 00:59:46 -0400
Received: by mail-ie0-f173.google.com with SMTP id u16so4136089iet.32
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Oct 2013 21:59:45 -0700 (PDT)
Received: from dshgna ([124.43.179.229])
        by mx.google.com with ESMTPSA id ka1sm1670144igb.7.2013.10.30.21.59.43
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Wed, 30 Oct 2013 21:59:44 -0700 (PDT)
Date: Thu, 31 Oct 2013 10:29:38 +0530
From: Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/6] btrfs: Remove redundant local zero structure
Message-ID: <d1106ebfdc6660a3ccdaeb29d92f68edaae8c61e.1383193392.git.dulshani.gunawardhana89@gmail.com>
References: <5b7cf598562052b708988056bfea67a9913ac660.1383193392.git.dulshani.gunawardhana89@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5b7cf598562052b708988056bfea67a9913ac660.1383193392.git.dulshani.gunawardhana89@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove redundant local zero structure, replacing it by the kernel's
global ZERO_PAGE.

Signed-off-by: Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>
Reviewed-by: Zach Brown <zab@redhat.com>
---
 fs/btrfs/ioctl.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9d46f60..62c2a28 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -369,9 +369,8 @@ static noinline int btrfs_ioctl_fitrim(struct file *file, void __user *arg)
 
 int btrfs_is_empty_uuid(u8 *uuid)
 {
-	static char empty_uuid[BTRFS_UUID_SIZE] = {0};
-
-	return !memcmp(uuid, empty_uuid, BTRFS_UUID_SIZE);
+	BUILD_BUG_ON(BTRFS_UUID_SIZE > PAGE_SIZE);
+	return !memcmp(uuid, empty_zero_page, BTRFS_UUID_SIZE);
 }
 
 static noinline int create_subvol(struct inode *dir,
-- 
1.8.1.2

