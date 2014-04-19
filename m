Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nbl-ex10-fe02.nebula.fi ([188.117.32.122]:62194 "EHLO
	ex10.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755081AbaDSTFp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Apr 2014 15:05:45 -0400
Date: Sat, 19 Apr 2014 22:05:41 +0300
From: Rakesh Pandit <rakesh@tuxera.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: make smatch checker happy (trivial fixes)
Message-ID: <20140419190540.GA10872@hercules.tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It complains errno never gets assigned to zero in find-root and since
errno anyway is zero at program started up, lets remove it.

Check "copy is less then zero" isn't possible because strtoull used by
arg_strtou64 wouldn't return -ve number.

Trivial space fixes.

Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>
---
 btrfs-find-root.c   | 1 -
 btrfs-map-logical.c | 2 --
 cmds-check.c        | 4 ++--
 3 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index db01923..25d79f1 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -287,7 +287,6 @@ int main(int argc, char **argv)
 
 	while ((opt = getopt(argc, argv, "l:o:g:")) != -1) {
 		switch(opt) {
-			errno = 0;
 			case 'o':
 				search_objectid = arg_strtou64(optarg);
 				break;
diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index a907e4d..e47a1ae 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -153,8 +153,6 @@ int main(int ac, char **av)
 		print_usage();
 	if (logical == 0)
 		print_usage();
-	if (copy < 0)
-		print_usage();
 
 	dev = av[optind];
 
diff --git a/cmds-check.c b/cmds-check.c
index 93f9ae6..04bdae5 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2886,7 +2886,7 @@ static int add_data_backref(struct cache_tree *extent_cache, u64 bytenr,
 	} else {
 		if (back->node.found_extent_tree) {
 			fprintf(stderr, "Extent back ref already exists "
-				"for %llu parent %llu root %llu"
+				"for %llu parent %llu root %llu "
 				"owner %llu offset %llu num_refs %lu\n",
 				(unsigned long long)bytenr,
 				(unsigned long long)parent,
@@ -4859,7 +4859,7 @@ static int verify_backrefs(struct btrfs_trans_handle *trans,
 	if (!best) {
 		entry = find_entry(&entries, rec->start, rec->nr);
 		if (!entry && (!broken_entries || !rec->found_rec)) {
-			fprintf(stderr, "Backrefs don't agree with eachother "
+			fprintf(stderr, "Backrefs don't agree with each other "
 				"and extent record doesn't agree with anybody,"
 				" so we can't fix bytenr %Lu bytes %Lu\n",
 				rec->start, rec->nr);
-- 
1.8.5.3

