From: slyich@gmail.com
Subject: [PATCH] btrfsck: decode error properly
Date: Sun, 28 Aug 2011 14:23:24 +0300
Message-ID: <1314530604-27245-1-git-send-email-slyich@gmail.com>
Cc: Sergei Trofimovich <slyfox@gentoo.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Sergei Trofimovich <slyfox@gentoo.org>

check_mounted() returns kernel-style negative errors.
Patch drops sign for strerror().

Before the patch:
check_mounted(): Could not open /dev/sdb2
Could not check mount status: Unknown error 18446744073709551603

After the patch:
check_mounted(): Could not open /dev/sdb2
Could not check mount status: Permission denied

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 btrfs-select-super.c |    2 +-
 btrfs-zero-log.c     |    2 +-
 btrfsck.c            |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/btrfs-select-super.c b/btrfs-select-super.c
index f12f36c..51eb9c9 100644
--- a/btrfs-select-super.c
+++ b/btrfs-select-super.c
@@ -75,7 +75,7 @@ int main(int ac, char **av)
 	radix_tree_init();
 
 	if((ret = check_mounted(av[optind])) < 0) {
-		fprintf(stderr, "Could not check mount status: %s\n", strerror(ret));
+		fprintf(stderr, "Could not check mount status: %s\n", strerror(-ret));
 		return ret;
 	} else if(ret) {
 		fprintf(stderr, "%s is currently mounted. Aborting.\n", av[optind]);
diff --git a/btrfs-zero-log.c b/btrfs-zero-log.c
index f10438b..54d7858 100644
--- a/btrfs-zero-log.c
+++ b/btrfs-zero-log.c
@@ -50,7 +50,7 @@ int main(int ac, char **av)
 	radix_tree_init();
 
 	if((ret = check_mounted(av[1])) < 0) {
-		fprintf(stderr, "Could not check mount status: %s\n", strerror(ret));
+		fprintf(stderr, "Could not check mount status: %s\n", strerror(-ret));
 		return ret;
 	} else if(ret) {
 		fprintf(stderr, "%s is currently mounted. Aborting.\n", av[1]);
diff --git a/btrfsck.c b/btrfsck.c
index fc2ac88..3a23e66 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -2838,7 +2838,7 @@ int main(int ac, char **av)
 	cache_tree_init(&root_cache);
 
 	if((ret = check_mounted(av[optind])) < 0) {
-		fprintf(stderr, "Could not check mount status: %s\n", strerror(ret));
+		fprintf(stderr, "Could not check mount status: %s\n", strerror(-ret));
 		return ret;
 	} else if(ret) {
 		fprintf(stderr, "%s is currently mounted. Aborting.\n", av[optind]);
-- 
1.7.3.4

