Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbaF0Vuh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 17:50:37 -0400
Message-ID: <53ADE727.5000400@redhat.com>
Date: Fri, 27 Jun 2014 16:50:31 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Roman Mamedov <rm@romanrm.net>
Subject: [PATCH] btrfs: fix nossd and ssd_spread mount option regression
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The commit

0780253 btrfs: Cleanup the btrfs_parse_options for remount.

broke ssd options quite badly; it stopped making ssd_spread
imply ssd, and it made "nossd" unsettable.

Put things back at least as well as they were before
(though ssd mount option handling is still pretty odd:
# mount -o "nossd,ssd_spread" works?)

Reported-by: Roman Mamedov <rm@romanrm.net>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I've tested this insofar as I was actually able to mount with
nossd,and see it reflected in /proc/mounts.

If SSD_SPREAD is set, show_options() won't show you the ssd
option, so that's not totally obvious.  Still, this is what
the code did before the regression.

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 4662d92..0e8edcc 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -522,9 +522,10 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 		case Opt_ssd_spread:
 			btrfs_set_and_info(root, SSD_SPREAD,
 					   "use spread ssd allocation scheme");
+			btrfs_set_opt(info->mount_opt, SSD);
 			break;
 		case Opt_nossd:
-			btrfs_clear_and_info(root, NOSSD,
+			btrfs_set_and_info(root, NOSSD,
 					     "not using ssd allocation scheme");
 			btrfs_clear_opt(info->mount_opt, SSD);
 			break;

