Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay06.ispgateway.de ([80.67.31.101]:42147 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbcEGRIQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 May 2016 13:08:16 -0400
Received: from [77.13.69.74] (helo=hermione.invalid)
	by smtprelay06.ispgateway.de with esmtpsa (TLSv1.2:AES128-GCM-SHA256:128)
	(Exim 4.84)
	(envelope-from <envelope@m-berberich.de>)
	id 1az579-0007Er-4Q
	for linux-btrfs@vger.kernel.org; Sat, 07 May 2016 18:29:59 +0200
Received: from berberic by hermione.invalid with local (Exim 4.87)
	(envelope-from <envelope@m-berberich.de>)
	id 1az578-0002Qn-MP
	for linux-btrfs@vger.kernel.org; Sat, 07 May 2016 18:29:58 +0200
Date: Sat, 7 May 2016 18:29:58 +0200
From: M G Berberich <btrfs@oss.m-berberich.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATHCH] add option to =?utf-8?Q?supress_?=
 =?utf-8?B?IkF0IHN1YnZvbCDigKYi?= message in btrfs send
Message-ID: <20160507162958.GA2241@invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

btrfs send puts a “At subvol …” on stderr, which is very annoying in
scripts, esp. cron-jobs. Piping stderr to /dev/null does suppress this
message, but also error-messages which one would probably want to
see. I added an option to not change the behavior of btrfs send
and possibly break existing scripts, but moving this message to
verbose would be O.K. for me too.


diff -Naur btrfs-progs-4.4.1/cmds-send.c btrfs-progs-4.4.1-neu/cmds-send.c
--- btrfs-progs-4.4.1/cmds-send.c	2016-02-26 18:22:09.000000000 +0100
+++ btrfs-progs-4.4.1-neu/cmds-send.c	2016-05-07 18:10:13.935853568 +0200
@@ -45,6 +45,7 @@
 #include "send-utils.h"
 
 static int g_verbose = 0;
+static int g_quiet = 0;
 
 struct btrfs_send {
 	int send_fd;
@@ -442,7 +443,7 @@
 		static const struct option long_options[] = {
 			{ "no-data", no_argument, NULL, GETOPT_VAL_SEND_NO_DATA }
 		};
-		int c = getopt_long(argc, argv, "vec:f:i:p:", long_options, NULL);
+		int c = getopt_long(argc, argv, "vec:f:i:p:q", long_options, NULL);
 
 		if (c < 0)
 			break;
@@ -534,6 +535,9 @@
 			error("option -i was removed, use -c instead");
 			ret = 1;
 			goto out;
+		case 'q':
+			g_quiet = 1;
+			break;
 		case GETOPT_VAL_SEND_NO_DATA:
 			send_flags |= BTRFS_SEND_FLAG_NO_FILE_DATA;
 			break;
@@ -642,7 +646,8 @@
 		free(subvol);
 		subvol = argv[i];
 
-		fprintf(stderr, "At subvol %s\n", subvol);
+		if (!g_quiet)
+			fprintf(stderr, "At subvol %s\n", subvol);
 
 		subvol = realpath(subvol, NULL);
 		if (!subvol) {
@@ -737,5 +742,6 @@
 	"                 does not contain any file data and thus cannot be used",
 	"                 to transfer changes. This mode is faster and useful to",
 	"                 show the differences in metadata.",
+	"-q               suppress 'At subvol' message on stderr",
 	NULL
 };
diff -Naur btrfs-progs-4.4.1/Documentation/btrfs-send.asciidoc btrfs-progs-4.4.1-neu/Documentation/btrfs-send.asciidoc
--- btrfs-progs-4.4.1/Documentation/btrfs-send.asciidoc	2016-02-26 18:22:09.000000000 +0100
+++ btrfs-progs-4.4.1-neu/Documentation/btrfs-send.asciidoc	2016-05-07 18:14:24.615712654 +0200
@@ -45,6 +45,8 @@
 Send in NO_FILE_DATA mode. The output stream does not contain any file
 data and thus cannot be used to transfer changes. This mode is faster and
 useful to show the differences in metadata.
+-q::
+Suppress "At subvol" message on stderr.
 
 EXIT STATUS
 -----------


	MfG
	bmg

-- 
„Des is völlig wurscht, was heut beschlos- | M G Berberich
 sen wird: I bin sowieso dagegn!“          | mail@m-berberich.de
(SPD-Stadtrat Kurt Schindler; Regensburg)  | 
