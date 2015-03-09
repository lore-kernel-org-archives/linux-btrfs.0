Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38871 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbbCILCv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Mar 2015 07:02:51 -0400
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: jeromepoulin@gmail.com, David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: convert, add option to disable progress
Date: Mon,  9 Mar 2015 12:02:47 +0100
Message-Id: <1425898967-5972-1-git-send-email-dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With progress turned on by default we should be able to disable it
as well.

Reported-by: Jérôme Poulin <jeromepoulin@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 Documentation/btrfs-convert.txt |  2 ++
 btrfs-convert.c                 | 14 +++++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-convert.txt b/Documentation/btrfs-convert.txt
index 170919706e71..6a9e1de0bf6f 100644
--- a/Documentation/btrfs-convert.txt
+++ b/Documentation/btrfs-convert.txt
@@ -31,6 +31,8 @@ set filesystem label during conversion.
 use label from the converted filesystem.
 -p::
 Show progress of conversion, on by default.
+--no-progress::
+Disable detailed progress and show only the main phases of conversion.
 
 EXIT STATUS
 -----------
diff --git a/btrfs-convert.c b/btrfs-convert.c
index 730fead4a86c..6a0668a4e572 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -29,6 +29,7 @@
 #include <unistd.h>
 #include <uuid/uuid.h>
 #include <linux/limits.h>
+#include <getopt.h>
 
 #include "ctree.h"
 #include "disk-io.h"
@@ -2767,6 +2768,7 @@ static void print_usage(void)
 	printf("\t-l LABEL     set filesystem label\n");
 	printf("\t-L           use label from converted fs\n");
 	printf("\t-p           show converting progress (default)\n");
+	printf("\t--no-progress  show only overview, not the detailed progress\n");
 }
 
 int main(int argc, char *argv[])
@@ -2783,7 +2785,14 @@ int main(int argc, char *argv[])
 	char *fslabel = NULL;
 
 	while(1) {
-		int c = getopt(argc, argv, "dinrl:Lp");
+		int long_index;
+		enum { GETOPT_VAL_NO_PROGRESS = 256 };
+		static const struct option long_options[] = {
+			{ "no-progress", no_argument, NULL, GETOPT_VAL_IEC},
+			{ NULL, 0, NULL, 0 }
+		};
+		int c = getopt_long(argc, argv, "dinrl:Lp", long_options,
+				&long_index);
 		if (c < 0)
 			break;
 		switch(c) {
@@ -2815,6 +2824,9 @@ int main(int argc, char *argv[])
 			case 'p':
 				progress = 1;
 				break;
+			case GETOPT_VAL_NO_PROGRESS:
+				progress = 0;
+				break;
 			default:
 				print_usage();
 				return 1;
-- 
2.1.3

