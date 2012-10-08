Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from psi.thgersdorf.net ([176.9.98.78]:57771 "EHLO mail.psioc.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754388Ab2JHTIK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Oct 2012 15:08:10 -0400
From: Dieter Ries <mail@dieterries.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Cc: Dieter Ries <mail@dieterries.net>
Subject: [PATCH 2/4] btrfs-progs: btrfsck: Print which filesystem to be checked to stdout
Date: Mon,  8 Oct 2012 21:07:48 +0200
Message-Id: <1349723270-12773-3-git-send-email-mail@dieterries.net>
In-Reply-To: <1349723270-12773-1-git-send-email-mail@dieterries.net>
References: <1349723270-12773-1-git-send-email-mail@dieterries.net>
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
index 67f4a9d..516bcdf 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -3540,6 +3540,8 @@ int main(int ac, char **av)
 	} else if(ret) {
 		fprintf(stderr, "%s is currently mounted. Aborting.\n", av[optind]);
 		return -EBUSY;
+	} else {
+		printf("Checking filesystem on %s\n",av[optind]);
 	}
 
 	info = open_ctree_fs_info(av[optind], bytenr, rw, 1);
-- 
1.7.3.GIT

