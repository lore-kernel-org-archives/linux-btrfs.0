From: Hubert Kario <kario@wit.edu.pl>
Subject: [PATCH 1/2] add advanced use of --help to help message
Date: Sun, 23 Jan 2011 13:39:36 +0100
Message-ID: <201101231339.36599.kario@wit.edu.pl>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

explain how to use

        btrfs <cmd> --help

command in help message

Signed-off-by: Hubert Kario <kario@wit.edu.pl>
---
 btrfs.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 46314cf..b84607a 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -151,6 +151,8 @@ static void help(char *np)
 		print_help(np, cp);
 
 	printf("\n\t%s help|--help|-h\n\t\tShow the help.\n",np);
+	printf("\n\t%s <cmd> --help\n\t\tShow detailed help for a command 
or\n\t\t"
+            "subset of commands.\n",np);
 	printf("\n%s\n", BTRFS_BUILD_VERSION);
 }
 
-- 
1.7.3.5

