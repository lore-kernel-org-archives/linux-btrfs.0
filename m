Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:34681 "EHLO
	mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbcFUPSH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jun 2016 11:18:07 -0400
Received: by mail-it0-f65.google.com with SMTP id f6so2559721ith.1
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Jun 2016 08:17:05 -0700 (PDT)
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.com
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Subject: [PATCH] btrfs-progs: add option to run balance as daemon
Date: Tue, 21 Jun 2016 11:16:59 -0400
Message-Id: <20160621151659.32157-1-ahferroin7@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, balance operations are run synchronously in the foreground.
This is nice for interactive management, but is kind of crappy when you
start looking at automation and similar things.

This patch adds an option to `btrfs balance start` to tell it to
daemonize prior to running the balance operation, thus allowing us to
preform balances asynchronously.  The two biggest use cases I have for
this are starting a balance on a remote server without establishing a
full shell session, and being able to background the balance in a
recovery shell (which usually has no job control) so I can still get
progress information.

Because it simply daemonizes prior to calling the balance ioctl, this
doesn't actually need any kernel support.

Signed-off-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
---
This works as is, but there are two specific things I would love to
eventually fix but don't have the time to fix right now:
* There is no way to get any feedback from the balance operation.
* Because of how everything works, trying to start a new balance with
  --background while one iw already running won't return an error but
  won't queue or start a new balance either.

The first one is more a utility item than anything else, and probably
would not be hard to add.  Ideally, it should be output to a user
specified file, and this should work even for a normal foreground balance.

The second is very much a UX issue, but can't be easily sovled without
doing some creative process monitoring from the parrent processes.

 Documentation/btrfs-balance.asciidoc |  2 ++
 cmds-balance.c                       | 43 +++++++++++++++++++++++++++++++++++-
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-balance.asciidoc b/Documentation/btrfs-balance.asciidoc
index 7df40b9..f487dbb 100644
--- a/Documentation/btrfs-balance.asciidoc
+++ b/Documentation/btrfs-balance.asciidoc
@@ -85,6 +85,8 @@ act on system chunks (requires '-f'), see `FILTERS` section for details about 'f
 be verbose and print balance filter arguments
 -f::::
 force reducing of metadata integrity, eg. when going from 'raid1' to 'single'
+--background::::
+run the balance operation asynchronously in the background
 
 *status* [-v] <path>::
 Show status of running or paused balance.
diff --git a/cmds-balance.c b/cmds-balance.c
index 708bbf4..66169b7 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -20,6 +20,9 @@
 #include <unistd.h>
 #include <getopt.h>
 #include <sys/ioctl.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
 #include <errno.h>
 
 #include "kerncompat.h"
@@ -510,6 +513,7 @@ static const char * const cmd_balance_start_usage[] = {
 	"-v             be verbose",
 	"-f             force reducing of metadata integrity",
 	"--full-balance do not print warning and do not delay start",
+	"--background   run the balance as a background process",
 	NULL
 };
 
@@ -520,6 +524,7 @@ static int cmd_balance_start(int argc, char **argv)
 						&args.meta, NULL };
 	int force = 0;
 	int verbose = 0;
+	int background = 0;
 	unsigned start_flags = 0;
 	int i;
 
@@ -527,7 +532,8 @@ static int cmd_balance_start(int argc, char **argv)
 
 	optind = 1;
 	while (1) {
-		enum { GETOPT_VAL_FULL_BALANCE = 256 };
+		enum { GETOPT_VAL_FULL_BALANCE = 256,
+			GETOPT_VAL_BACKGROUND = 257 };
 		static const struct option longopts[] = {
 			{ "data", optional_argument, NULL, 'd'},
 			{ "metadata", optional_argument, NULL, 'm' },
@@ -536,6 +542,8 @@ static int cmd_balance_start(int argc, char **argv)
 			{ "verbose", no_argument, NULL, 'v' },
 			{ "full-balance", no_argument, NULL,
 				GETOPT_VAL_FULL_BALANCE },
+			{ "background", no_argument, NULL,
+				GETOPT_VAL_BACKGROUND },
 			{ NULL, 0, NULL, 0 }
 		};
 
@@ -574,6 +582,9 @@ static int cmd_balance_start(int argc, char **argv)
 		case GETOPT_VAL_FULL_BALANCE:
 			start_flags |= BALANCE_START_NOWARN;
 			break;
+		case GETOPT_VAL_BACKGROUND:
+			background = 1;
+			break;
 		default:
 			usage(cmd_balance_start_usage);
 		}
@@ -626,6 +637,36 @@ static int cmd_balance_start(int argc, char **argv)
 		args.flags |= BTRFS_BALANCE_FORCE;
 	if (verbose)
 		dump_ioctl_balance_args(&args);
+	if (background) {
+		switch (fork()) {
+		case (-1):
+			error("Unable to fork to run balance in background");
+			return 1;
+			break;
+		case (0):
+			setsid();
+			switch(fork()) {
+				case (-1):
+					error("Unable to fork to run balance in background");
+					exit(1);
+					break;
+				case (0):
+					chdir("/");
+					close(0);
+					close(1);
+					close(2);
+					open("/dev/null", O_RDONLY);
+					open("/dev/null", O_WRONLY);
+					open("/dev/null", O_WRONLY);
+					break;
+				default:
+					exit(0);
+			}
+			break;
+		default:
+			exit(0);
+		}
+	}
 
 	return do_balance(argv[optind], &args, start_flags);
 }
-- 
2.9.0

