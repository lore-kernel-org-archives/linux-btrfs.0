Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33325 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752662AbdLEIjz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 03:39:55 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5F54CADE9
        for <linux-btrfs@vger.kernel.org>; Tue,  5 Dec 2017 08:39:54 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 5/7] btrfs-progs: Document logic of btrfs_read_dev_super
Date: Tue,  5 Dec 2017 10:39:47 +0200
Message-Id: <1512463189-24724-6-git-send-email-nborisov@suse.com>
In-Reply-To: <1512463189-24724-1-git-send-email-nborisov@suse.com>
References: <1512463189-24724-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 disk-io.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/disk-io.c b/disk-io.c
index 3d8785d5bb37..40077d4919c6 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1419,6 +1419,23 @@ static int check_super(struct btrfs_super_block *sb, unsigned sbflags)
 	return -EIO;
 }
 
+/*
+ * btrfs_read_dev_super - read a valid superblock from a block device
+ * @fd:		file descrioptor of the device
+ * @sb:		buffer where the superblock is going to be read in
+ * @sb_bytenr:  offset of the particular superblock copie we want
+ * @sbflags:	flags controlling how the superblock is read.
+ *
+ * This function is used by various btrfs comands to obtain a valid superblock.
+ *
+ * It's mode of operation is controlled by the @sb_bytenr and @sbdflags
+ * parameters. If SBREAD_RECOVER flag is set and @sb_bytenr is
+ * BTRFS_SUPER_INFO_OFFSET then the function reads all 3 superblock copies and
+ * returns the newest one. If SBREAD_RECOVER is not set then only a single
+ * copy is read, which one is decided by @sb_bytenr. If @sb_bytenr !=
+ * BTRFS_SUPER_INFO_OFFSET then the sbflags is effectively ignored and only a
+ * single copy is read.
+ */
 int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
 			 unsigned sbflags)
 {
-- 
2.7.4

