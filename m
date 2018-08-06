Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41370 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726412AbeHFIHm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Aug 2018 04:07:42 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7E883AE86
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Aug 2018 06:00:13 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs-progs: cmds-qgroup: Use bool to replace int for @rescan
Date: Mon,  6 Aug 2018 14:00:06 +0800
Message-Id: <20180806060008.9556-2-wqu@suse.com>
In-Reply-To: <20180806060008.9556-1-wqu@suse.com>
References: <20180806060008.9556-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just a cleanup to avoid abuse of int.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds-qgroup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 93206900693d..7a505443d271 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -40,7 +40,7 @@ static int _cmd_qgroup_assign(int assign, int argc, char **argv,
 {
 	int ret = 0;
 	int fd;
-	int rescan = 0;
+	bool rescan = false;
 	char *path;
 	struct btrfs_ioctl_qgroup_assign_args args;
 	DIR *dirstream = NULL;
@@ -61,10 +61,10 @@ static int _cmd_qgroup_assign(int assign, int argc, char **argv,
 				break;
 			switch (c) {
 			case GETOPT_VAL_RESCAN:
-				rescan = 1;
+				rescan = true;
 				break;
 			case GETOPT_VAL_NO_RESCAN:
-				rescan = 0;
+				rescan = false;
 				break;
 			default:
 				/* Usage printed by the caller */
-- 
2.18.0

