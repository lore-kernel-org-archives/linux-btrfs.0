From: Danny Kukawka <danny.kukawka@bisect.de>
Subject: [PATCH 3/4] fix some compiler warnings from cgcc
Date: Thu, 12 Jan 2012 16:17:46 +0100
Message-ID: <1326381467-19848-4-git-send-email-danny.kukawka@bisect.de>
References: <1326381467-19848-1-git-send-email-danny.kukawka@bisect.de>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1326381467-19848-1-git-send-email-danny.kukawka@bisect.de>
List-ID: <linux-btrfs.vger.kernel.org>

Fixed some compiler warnings from cgcc.
---
 btrfs.c        |   12 ++++++------
 btrfslabel.h   |    3 ++-
 extent-cache.c |    2 +-
 extent-tree.c  |    2 +-
 extent_io.c    |    2 +-
 5 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 1def354..0f4b8b7 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -179,7 +179,7 @@ static struct Command commands[] = {
 		"get file system paths for the given logical address.",
 	  NULL
 	},
-	{ 0, 0, 0, 0 }
+	{ NULL, 0, NULL, NULL }
 };
 
 static char *get_prgname(char *programname)
@@ -235,7 +235,7 @@ static int split_command(char *cmd, char ***commands)
 	int	c, l;
 	char	*p, *s;
 
-	for( *commands = 0, l = c = 0, p = s = cmd ; ; p++, l++ ){
+	for( *commands = NULL, l = c = 0, p = s = cmd ; ; p++, l++ ){
 		if ( *p && *p != ' ' )
 			continue;
 
@@ -248,7 +248,7 @@ static int split_command(char *cmd, char ***commands)
 		if( !*p ) break;
 	}
 
-	(*commands)[c] = 0;
+	(*commands)[c] = NULL;
 	return c;
 }
 
@@ -354,7 +354,7 @@ static int parse_args(int argc, char **argv,
 		      int *nargs_, char **cmd_, char ***args_ )
 {
 	struct Command	*cp;
-	struct Command	*matchcmd=0;
+	struct Command	*matchcmd=NULL;
 	char		*prgname = get_prgname(argv[0]);
 	int		i=0, helprequested=0;
 
@@ -446,9 +446,9 @@ static int parse_args(int argc, char **argv,
 int main(int ac, char **av )
 {
 
-	char		*cmd=0, **args=0;
+	char		*cmd=NULL, **args=NULL;
 	int		nargs=0, r;
-	CommandFunction func=0;
+	CommandFunction func=NULL;
 
 	r = parse_args(ac, av, &func, &nargs, &cmd, &args);
 	if( r <= 0 ){
diff --git a/btrfslabel.h b/btrfslabel.h
index abf43ad..62da332 100644
--- a/btrfslabel.h
+++ b/btrfslabel.h
@@ -2,4 +2,5 @@
 
 
 int get_label(char *btrfs_dev);
-int set_label(char *btrfs_dev, char *nLabel);
\ No newline at end of file
+int set_label(char *btrfs_dev, char *nLabel);
+
diff --git a/extent-cache.c b/extent-cache.c
index 3dd6434..673947d 100644
--- a/extent-cache.c
+++ b/extent-cache.c
@@ -81,7 +81,7 @@ static struct rb_node *__tree_search(struct rb_root *root, u64 offset,
 	return NULL;
 }
 
-struct cache_extent *alloc_cache_extent(u64 start, u64 size)
+static struct cache_extent *alloc_cache_extent(u64 start, u64 size)
 {
 	struct cache_extent *pe = malloc(sizeof(*pe));
 
diff --git a/extent-tree.c b/extent-tree.c
index 5bed3c2..c1f68bd 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1067,7 +1067,7 @@ static int lookup_inline_extent_backref(struct btrfs_trans_handle *trans,
 	}
 #endif
 	if (item_size < sizeof(*ei)) {
-		printf("Size is %u, needs to be %u, slot %d\n", item_size,
+		printf("Size is %u, needs to be %lu, slot %d\n", item_size,
 		       sizeof(*ei), path->slots[0]);
 		btrfs_print_leaf(root, leaf);
 		return -EINVAL;
diff --git a/extent_io.c b/extent_io.c
index 973e918..e3eca86 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -28,7 +28,7 @@
 #include "extent_io.h"
 #include "list.h"
 
-u64 cache_max = 1024 * 1024 * 32;
+static u64 cache_max = 1024 * 1024 * 32;
 
 void extent_io_tree_init(struct extent_io_tree *tree)
 {
-- 
1.7.8

