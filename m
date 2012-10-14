Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from psi.thgersdorf.net ([176.9.98.78]:48348 "EHLO mail.psioc.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753871Ab2JNPRn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Oct 2012 11:17:43 -0400
From: Dieter Ries <mail@dieterries.net>
To: linux-btrfs@vger.kernel.org, dave@jikos.cz
Cc: chris.mason@fusionio.com, Dieter Ries <mail@dieterries.net>
Subject: [PATCH 2/4] btrfs-progs: btrfsck: Print which filesystem to be checked to stdout
Date: Sun, 14 Oct 2012 17:17:19 +0200
Message-Id: <1350227839-18806-1-git-send-email-mail@dieterries.net>
In-Reply-To: <20121009150844.GT4405@twin.jikos.cz>
References: <20121009150844.GT4405@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch makes btrfsck print the filesystem, which is to be checked,
to stdout, as well as the UUID of the corresponding partition.
This should be helpful when analyzing (copied and pasted) output of
btrfsck.

Signed-off-by: Dieter Ries <mail@dieterries.net>
---
 btrfsck.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/btrfsck.c b/btrfsck.c
index 67f4a9d..ea654de 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -20,6 +20,7 @@
 #define _GNU_SOURCE 1
 #include <stdio.h>
 #include <stdlib.h>
+#include <uuid/uuid.h>
 #include <unistd.h>
 #include <fcntl.h>
 #include <sys/stat.h>
@@ -3492,6 +3493,7 @@ int main(int ac, char **av)
 	struct btrfs_fs_info *info;
 	struct btrfs_trans_handle *trans = NULL;
 	u64 bytenr = 0;
+	char uuidbuf[37];
 	int ret;
 	int num;
 	int repair = 0;
@@ -3540,9 +3542,10 @@ int main(int ac, char **av)
 	} else if(ret) {
 		fprintf(stderr, "%s is currently mounted. Aborting.\n", av[optind]);
 		return -EBUSY;
-	}
-
+	} 
 	info = open_ctree_fs_info(av[optind], bytenr, rw, 1);
+	uuid_unparse(info->super_copy.fsid, uuidbuf);
+	printf("Checking filesystem on %s\nUUID: %s\n",av[optind],uuidbuf);
 
 	if (info == NULL)
 		return 1;
-- 
1.7.3.GIT

