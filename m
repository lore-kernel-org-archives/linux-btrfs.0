Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:56146 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891Ab3IWSRl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Sep 2013 14:17:41 -0400
Received: from /spool/local
	by e28smtp01.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 23 Sep 2013 23:47:32 +0530
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
	by d28dlp01.in.ibm.com (Postfix) with ESMTP id E1179E0053
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Sep 2013 23:48:32 +0530 (IST)
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay01.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r8NIJSb723527606
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Sep 2013 23:49:30 +0530
Received: from d28av02.in.ibm.com (localhost [127.0.0.1])
	by d28av02.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id r8NIHDXb001647
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Sep 2013 23:47:14 +0530
From: chandan <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: sekharan@us.ibm.com
Subject: [PATCH] btrfs-progs: cmd_find_new: Sync fs before searching for modified files.
Date: Mon, 23 Sep 2013 23:47:11 +0530
Message-ID: <2363441.CTgOPvMvZp@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The sync makes sure that 'very recently' introduced delayed work is
accounted for in the output of 'btrfs subvolume find-new' command.

Signed-off-by: chandan <chandan@linux.vnet.ibm.com>
---
 cmds-subvolume.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index de246ab..8832303 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -786,6 +786,15 @@ static int cmd_find_new(int argc, char **argv)
 		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
 		return 1;
 	}
+
+	ret = ioctl(fd, BTRFS_IOC_SYNC);
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: unable to fs-syncing '%s' - %s\n",
+			subvol, strerror(errno));
+		close_file_or_dir(fd, dirstream);
+		return 1;
+	}
+
 	ret = btrfs_list_find_updated_files(fd, 0, last_gen);
 	close_file_or_dir(fd, dirstream);
 	return !!ret;
-- 
1.8.3.1


