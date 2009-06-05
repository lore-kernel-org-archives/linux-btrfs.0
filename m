From: Hu Tao <hu.taoo@gmail.com>
Subject: [PATCH] End a btrfsctl err msg "-s requires an arg" with a newline.
Date: Fri,  5 Jun 2009 14:30:51 +0800
Message-ID: <1244183451-32576-1-git-send-email-hu.taoo@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Hu Tao <hu.taoo@gmail.com>
---
 btrfsctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/btrfsctl.c b/btrfsctl.c
index b323818..fa401ab 100644
--- a/btrfsctl.c
+++ b/btrfsctl.c
@@ -109,7 +109,7 @@ int main(int ac, char **av)
 	for (i = 1; i < ac; i++) {
 		if (strcmp(av[i], "-s") == 0) {
 			if (i + 1 >= ac - 1) {
-				fprintf(stderr, "-s requires an arg");
+				fprintf(stderr, "-s requires an arg\n");
 				print_usage();
 			}
 			fullpath = av[i + 1];
-- 
1.6.3.1

