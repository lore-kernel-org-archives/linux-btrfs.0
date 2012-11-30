Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:59101 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753184Ab2K3KIr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Nov 2012 05:08:47 -0500
Received: from 3.109.77.188.dynamic.jazztel.es ([188.77.109.3] helo=mail.viric.name)
	by mho-02-ewr.mailhop.org with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.72)
	(envelope-from <viric@viric.name>)
	id 1TeNWV-000MpF-Jr
	for linux-btrfs@vger.kernel.org; Fri, 30 Nov 2012 10:08:43 +0000
Date: Fri, 30 Nov 2012 11:08:39 +0100
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Fix getopt on arm platforms
Message-ID: <20121130100839.GA25766@vicerveza.homeunix.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There, 'char' is unsigned, so once assigned '-1' from getopt, it gets
the value 255. Then, it compared to '-1' gives false.
---
 cmds-scrub.c | 2 +-
 cmds-send.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-scrub.c b/cmds-scrub.c
index 24be20f..c972e3b 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1604,7 +1604,7 @@ static int cmd_scrub_status(int argc, char **argv)
 	int i;
 	int print_raw = 0;
 	int do_stats_per_dev = 0;
-	char c;
+	int c;
 	char fsid[37];
 	int fdres = -1;
 	int err = 0;
diff --git a/cmds-send.c b/cmds-send.c
index 9b47e70..2e44114 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -414,7 +414,7 @@ out:
 int cmd_send_start(int argc, char **argv)
 {
 	char *subvol = NULL;
-	char c;
+	int c;
 	int ret;
 	char *outname = NULL;
 	struct btrfs_send send;
-- 
1.8.0

