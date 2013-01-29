Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:33727 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab3A2GGu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 01:06:50 -0500
Received: by mail-ob0-f202.google.com with SMTP id lz20so15345obb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Jan 2013 22:06:47 -0800 (PST)
From: Filipe Brandenburger <filbranden@google.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Brandenburger <filbranden@google.com>
Subject: [PATCH 1/3] Add support for Btrfs ioctls: decode them by name
Date: Mon, 28 Jan 2013 22:06:36 -0800
Message-Id: <1359439598-4141-2-git-send-email-filbranden@google.com>
In-Reply-To: <1359439598-4141-1-git-send-email-filbranden@google.com>
References: <1359439598-4141-1-git-send-email-filbranden@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch will include Btrfs-specific ioctls from linux/btrfs.h into
ioctlent.h.in so that they get translated by strace. That's useful for using
strace to debug the tools in btrfs-progs.

Signed-off-by: Filipe Brandenburger <filbranden@google.com>
---
 linux/ioctlent.h.in | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/linux/ioctlent.h.in b/linux/ioctlent.h.in
index 8843b47..06a5300 100644
--- a/linux/ioctlent.h.in
+++ b/linux/ioctlent.h.in
@@ -1825,6 +1825,50 @@
 	{"linux/auto_fs4.h",	"AUTOFS_IOC_EXPIRE_MULTI",	0x9366},
 	{"linux/auto_fs4.h",	"AUTOFS_IOC_PROTOSUBVER",	0x9367},
 	{"linux/auto_fs4.h",	"AUTOFS_IOC_ASKUMOUNT",	0x9370},
+	{"linux/btrfs.h",	"BTRFS_IOC_SNAP_CREATE",	0x9401},
+	{"linux/btrfs.h",	"BTRFS_IOC_DEFRAG",	0x9402},
+	{"linux/btrfs.h",	"BTRFS_IOC_RESIZE",	0x9403},
+	{"linux/btrfs.h",	"BTRFS_IOC_SCAN_DEV",	0x9404},
+	{"linux/btrfs.h",	"BTRFS_IOC_TRANS_START",	0x9406},
+	{"linux/btrfs.h",	"BTRFS_IOC_TRANS_END",	0x9407},
+	{"linux/btrfs.h",	"BTRFS_IOC_SYNC",	0x9408},
+	{"linux/btrfs.h",	"BTRFS_IOC_CLONE",	0x9409},
+	{"linux/btrfs.h",	"BTRFS_IOC_ADD_DEV",	0x940a},
+	{"linux/btrfs.h",	"BTRFS_IOC_RM_DEV",	0x940b},
+	{"linux/btrfs.h",	"BTRFS_IOC_BALANCE",	0x940c},
+	{"linux/btrfs.h",	"BTRFS_IOC_CLONE_RANGE",	0x940d},
+	{"linux/btrfs.h",	"BTRFS_IOC_SUBVOL_CREATE",	0x940e},
+	{"linux/btrfs.h",	"BTRFS_IOC_SNAP_DESTROY",	0x940f},
+	{"linux/btrfs.h",	"BTRFS_IOC_DEFRAG_RANGE",	0x9410},
+	{"linux/btrfs.h",	"BTRFS_IOC_TREE_SEARCH",	0x9411},
+	{"linux/btrfs.h",	"BTRFS_IOC_INO_LOOKUP",	0x9412},
+	{"linux/btrfs.h",	"BTRFS_IOC_DEFAULT_SUBVOL",	0x9413},
+	{"linux/btrfs.h",	"BTRFS_IOC_SPACE_INFO",	0x9414},
+	{"linux/btrfs.h",	"BTRFS_IOC_WAIT_SYNC",	0x9416},
+	{"linux/btrfs.h",	"BTRFS_IOC_SNAP_CREATE_V2",	0x9417},
+	{"linux/btrfs.h",	"BTRFS_IOC_START_SYNC",	0x9418},
+	{"linux/btrfs.h",	"BTRFS_IOC_SUBVOL_CREATE_V2",	0x9418},
+	{"linux/btrfs.h",	"BTRFS_IOC_SUBVOL_GETFLAGS",	0x9419},
+	{"linux/btrfs.h",	"BTRFS_IOC_SUBVOL_SETFLAGS",	0x941a},
+	{"linux/btrfs.h",	"BTRFS_IOC_SCRUB",	0x941b},
+	{"linux/btrfs.h",	"BTRFS_IOC_SCRUB_CANCEL",	0x941c},
+	{"linux/btrfs.h",	"BTRFS_IOC_SCRUB_PROGRESS",	0x941d},
+	{"linux/btrfs.h",	"BTRFS_IOC_DEV_INFO",	0x941e},
+	{"linux/btrfs.h",	"BTRFS_IOC_FS_INFO",	0x941f},
+	{"linux/btrfs.h",	"BTRFS_IOC_BALANCE_V2",	0x9420},
+	{"linux/btrfs.h",	"BTRFS_IOC_BALANCE_CTL",	0x9421},
+	{"linux/btrfs.h",	"BTRFS_IOC_BALANCE_PROGRESS",	0x9422},
+	{"linux/btrfs.h",	"BTRFS_IOC_INO_PATHS",	0x9423},
+	{"linux/btrfs.h",	"BTRFS_IOC_LOGICAL_INO",	0x9424},
+	{"linux/btrfs.h",	"BTRFS_IOC_SET_RECEIVED_SUBVOL",	0x9425},
+	{"linux/btrfs.h",	"BTRFS_IOC_SEND",	0x9426},
+	{"linux/btrfs.h",	"BTRFS_IOC_DEVICES_READY",	0x9427},
+	{"linux/btrfs.h",	"BTRFS_IOC_QUOTA_CTL",	0x9428},
+	{"linux/btrfs.h",	"BTRFS_IOC_QGROUP_ASSIGN",	0x9429},
+	{"linux/btrfs.h",	"BTRFS_IOC_QGROUP_CREATE",	0x942a},
+	{"linux/btrfs.h",	"BTRFS_IOC_QGROUP_LIMIT",	0x942b},
+	{"linux/btrfs.h",	"BTRFS_IOC_GET_DEV_STATS",	0x9434},
+	{"linux/btrfs.h",	"BTRFS_IOC_DEV_REPLACE",	0x9435},
 	{"linux/nbd.h",	"NBD_SET_SOCK",	0xab00},
 	{"linux/nbd.h",	"NBD_SET_BLKSIZE",	0xab01},
 	{"linux/nbd.h",	"NBD_SET_SIZE",	0xab02},
-- 
1.7.11.7

