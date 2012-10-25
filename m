Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49831 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116Ab2JYP2R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 11:28:17 -0400
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com, David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: do not send stream into a terminal
Date: Thu, 25 Oct 2012 17:27:57 +0200
Message-Id: <1351178877-10188-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-send.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/cmds-send.c b/cmds-send.c
index 9b47e70..e37f5d2 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -427,6 +427,11 @@ int cmd_send_start(int argc, char **argv)
 	memset(&send, 0, sizeof(send));
 	send.dump_fd = fileno(stdout);
 
+	if (isatty(send.dump_fd)) {
+		fprintf(stderr, "ERROR: not dumping send stream into a terminal, redirect it into a file\n");
+		return 1;
+	}
+
 	while ((c = getopt(argc, argv, "vf:i:p:")) != -1) {
 		switch (c) {
 		case 'v':
-- 
1.7.6.233.gd79bc

