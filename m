Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay03.libero.it ([212.52.84.103]:49938 "EHLO
	outrelay03.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527Ab2IRKDw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Sep 2012 06:03:52 -0400
Message-ID: <26356142.2062531347962627486.JavaMail.root@wmail62>
Date: Tue, 18 Sep 2012 12:03:47 +0200 (CEST)
From: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
Reply-To: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
To: <seto.hidetoshi@jp.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: R: [PATCH 2/2] Btrfs-progs: add mount-option command
MIME-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <5057CDA7.3090201@jp.fujitsu.com>

Hi Seto,

please could you update also the man page too ? 
Why it was not provided a way to clear a *single* flag ? To me it seems a bit 
too long to clear all the flag (btrfs mount-option clear) and then set the 
right one.

As user interface I suggest something like chmod:

   btrfs mount-option set +ssd,skip_balance -nodatacow /dev/sdX

or

   btrfs mount-option set =ssd,skip_balance,nodatacow /dev/sdX


Finally I have some small concern about two macro (see below)

>----Messaggio originale----
>Da: seto.hidetoshi@jp.fujitsu.com
>Data: 18/09/2012 3.30
>A: <linux-btrfs@vger.kernel.org>
>Ogg: [PATCH 2/2] Btrfs-progs: add mount-option command
>
[...]
>+/*
>+ * Flags for mount options.
>+ *
>+ * Note: don't forget to add new options to btrfs_show_options()
>+ */
>+#define BTRFS_MOUNT_NODATASUM		(1 << 0)
>+#define BTRFS_MOUNT_NODATACOW		(1 << 1)
>+#define BTRFS_MOUNT_NOBARRIER		(1 << 2)
>+#define BTRFS_MOUNT_SSD			(1 << 3)
>+#define BTRFS_MOUNT_DEGRADED		(1 << 4)
>+#define BTRFS_MOUNT_COMPRESS		(1 << 5)
>+#define BTRFS_MOUNT_NOTREELOG           (1 << 6)
>+#define BTRFS_MOUNT_FLUSHONCOMMIT       (1 << 7)
>+#define BTRFS_MOUNT_SSD_SPREAD		(1 << 8)
>+#define BTRFS_MOUNT_NOSSD		(1 << 9)
>+#define BTRFS_MOUNT_DISCARD		(1 << 10)
>+#define BTRFS_MOUNT_FORCE_COMPRESS      (1 << 11)
>+#define BTRFS_MOUNT_SPACE_CACHE		(1 << 12)
>+#define BTRFS_MOUNT_CLEAR_CACHE		(1 << 13)
>+#define BTRFS_MOUNT_USER_SUBVOL_RM_ALLOWED (1 << 14)
>+#define BTRFS_MOUNT_ENOSPC_DEBUG	 (1 << 15)
>+#define BTRFS_MOUNT_AUTO_DEFRAG		(1 << 16)
>+#define BTRFS_MOUNT_INODE_MAP_CACHE	(1 << 17)
>+#define BTRFS_MOUNT_RECOVERY		(1 << 18)
>+#define BTRFS_MOUNT_SKIP_BALANCE	(1 << 19)
>+#define BTRFS_MOUNT_CHECK_INTEGRITY	(1 << 20)
>+#define BTRFS_MOUNT_CHECK_INTEGRITY_INCLUDING_EXTENT_DATA (1 << 21)
>+#define BTRFS_MOUNT_PANIC_ON_FATAL_ERROR	(1 << 22)
>+
>+#define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
>+#define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
>+#define btrfs_test_opt(root, opt)	((root)->fs_info->mount_opt& \
>+					 BTRFS_MOUNT_##opt)

I think that the macro names are too generic, I suggest to rename the three 
macros above as

#define btrfs_mount_XXXX_opt

Also, the last one should be 

#define btrfs_test_opt(o, opt)	( o & BTRFS_MOUNT_##opt)

Or better the other two

#define btrfs_mount_clear_opt(root, opt)		(((root)->fs_info->mount_opt) &= 
~BTRFS_MOUNT_##opt)
#define btrfs_mount_set_opt(root, opt)		(((root)->fs_info->mount_opt) |= 
BTRFS_MOUNT_##opt)




>-- 
>1.7.7.6
>
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


