From: Luca Bruno <lucab@debian.org>
Subject: [PATCH] Add -V|--version to mkfs.btrfs argument parser
Date: Sun, 15 Mar 2009 12:23:52 +0100
Message-ID: <1237116232-29808-1-git-send-email-lucab@debian.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

mkfs.btrfs now prints its version when invoked with -V|--version
and exits without error.
All other mkfs.* tools provide this feature and follow this
implicit argument naming convention, as it is commonly used to
check for helper tools presence.
The corrisponding manual already mentions this option, no need to
touch it.

Signed-off-by: Luca Bruno <lucab@debian.org>
---
 mkfs.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index d664254..af7d12c 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -275,6 +275,12 @@ static void print_usage(void)
 	exit(1);
 }
 
+static void print_version(void)
+{
+	fprintf(stderr, "mkfs.btrfs, part of %s\n", BTRFS_BUILD_VERSION);
+	exit(0);
+}
+
 static u64 parse_profile(char *s)
 {
 	if (strcmp(s, "raid0") == 0) {
@@ -320,6 +326,7 @@ static struct option long_options[] = {
 	{ "nodesize", 1, NULL, 'n' },
 	{ "sectorsize", 1, NULL, 's' },
 	{ "data", 1, NULL, 'd' },
+	{ "version", 0, NULL, 'V' },
 	{ 0, 0, 0, 0}
 };
 
@@ -349,7 +356,7 @@ int main(int ac, char **av)
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "A:b:l:n:s:m:d:L:", long_options,
+		c = getopt_long(ac, av, "A:b:l:n:s:m:d:L:V", long_options,
 				&option_index);
 		if (c < 0)
 			break;
@@ -386,6 +393,9 @@ int main(int ac, char **av)
 				}
 				zero_end = 0;
 				break;
+			case 'V':
+				print_version();
+				break;
 			default:
 				print_usage();
 		}
-- 
1.6.2

