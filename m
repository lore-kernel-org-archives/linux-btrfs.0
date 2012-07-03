Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.137]:10666 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741Ab2GCRCZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Jul 2012 13:02:25 -0400
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp1) (RZmta 29.19 OK)
	with ESMTP id X02240o62NgObb for <linux-btrfs@vger.kernel.org>;
	Tue, 3 Jul 2012 19:02:22 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: join DEV_STATS ioctls to one
Date: Tue,  3 Jul 2012 19:02:22 +0200
Message-Id: <1341334942-13948-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On June 22th 2012, David Sterba posted a patch to change the ioctls
for the commands to get/reset device stats in the kernel.
Intentionally, this was not backward compatible since the goal was to
get rid of one of the two ioctls. And it was early enough before any
Linux release included the device statistics feature. Only some kernel
RCs include the old ioctl definitions.

This patch here adapts the btrfs-progs side to use the modified ioctl
definitions, also intentionally without backward compatibility, with
the justification, that no Linux kernel release contains the old
definitions.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 cmds-device.c | 13 ++++++-------
 ioctl.h       |  4 ++++
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 7621cc0..c146e91 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -263,13 +263,13 @@ static int cmd_dev_stats(int argc, char **argv)
 	char c;
 	int fdres = -1;
 	int err = 0;
-	int cmd = BTRFS_IOC_GET_DEV_STATS;
+	__u64 flags = 0;
 
 	optind = 1;
 	while ((c = getopt(argc, argv, "z")) != -1) {
 		switch (c) {
 		case 'z':
-			cmd = BTRFS_IOC_GET_AND_RESET_DEV_STATS;
+			flags = BTRFS_DEV_STATS_RESET;
 			break;
 		case '?':
 		default:
@@ -317,12 +317,11 @@ static int cmd_dev_stats(int argc, char **argv)
 
 		args.devid = di_args[i].devid;
 		args.nr_items = BTRFS_DEV_STAT_VALUES_MAX;
+		args.flags = flags;
 
-		if (ioctl(fdmnt, cmd, &args) < 0) {
-			fprintf(stderr, "ERROR: ioctl(%s) on %s failed: %s\n",
-				BTRFS_IOC_GET_AND_RESET_DEV_STATS == cmd ?
-				 "BTRFS_IOC_GET_AND_RESET_DEV_STATS" :
-				 "BTRFS_IOC_GET_DEV_STATS",
+		if (ioctl(fdmnt, BTRFS_IOC_GET_DEV_STATS, &args) < 0) {
+			fprintf(stderr,
+				"ERROR: ioctl(BTRFS_IOC_GET_DEV_STATS) on %s failed: %s\n",
 				path, strerror(errno));
 			err = 1;
 		} else {
diff --git a/ioctl.h b/ioctl.h
index ffc3c29..5ed1d9a 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -291,9 +291,13 @@ enum btrfs_dev_stat_values {
 	BTRFS_DEV_STAT_VALUES_MAX
 };
 
+/* Reset statistics after reading; needs SYS_ADMIN capability */
+#define	BTRFS_DEV_STATS_RESET		(1ULL << 0)
+
 struct btrfs_ioctl_get_dev_stats {
 	__u64 devid;				/* in */
 	__u64 nr_items;				/* in/out */
+	__u64 flags;				/* in/out */
 
 	/* out values: */
 	__u64 values[BTRFS_DEV_STAT_VALUES_MAX];
-- 
1.7.11.1

