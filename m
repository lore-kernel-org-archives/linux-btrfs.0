Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from psi.thgersdorf.net ([176.9.98.78]:44040 "EHLO mail.psioc.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab2I3OYr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Sep 2012 10:24:47 -0400
From: Dieter Ries <mail@dieterries.net>
To: linux-btrfs@vger.kernel.org
Cc: Dieter Ries <mail@dieterries.net>
Subject: [PATCH 2/3] btrfs-progs: btrfsck: Print which filesystem to be checked to stdout
Date: Sun, 30 Sep 2012 16:18:29 +0200
Message-Id: <1349014710-16089-3-git-send-email-mail@dieterries.net>
In-Reply-To: <1349014710-16089-1-git-send-email-mail@dieterries.net>
References: <1349014710-16089-1-git-send-email-mail@dieterries.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch makes btrfsck print the filesystem, which is to be checked,
to stdout. This should be helpful when analyzing (copied and pasted)
output of btrfsck.

Signed-off-by: Dieter Ries <mail@dieterries.net>
---
 btrfsck.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/btrfsck.c b/btrfsck.c
index 088b9f4..dde63e7 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -3538,6 +3538,8 @@ int main(int ac, char **av)
 	} else if(ret) {
 		fprintf(stderr, "%s is currently mounted. Aborting.\n", av[optind]);
 		return -EBUSY;
+	} else {
+		printf("Checking filesystem on %s\n",av[optind]);
 	}
 
 	info = open_ctree_fs_info(av[optind], bytenr, rw, 1);
-- 
1.7.3.GIT

