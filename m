From: Anand jain <Anand.Jain@oracle.com>
Subject: [PATCH 1/2] Make find_updated_files to return value instead of printing
Date: Tue,  6 Mar 2012 15:56:10 +0800
Message-ID: <1331020571-30261-1-git-send-email-Anand.Jain@oracle.com>
References: <1330484376-16178-1-git-send-email-anand.jain@oracle.com>
Cc: chris.mason@oracle.com, hugo@carfax.org.uk,
	Anand Jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1330484376-16178-1-git-send-email-anand.jain@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

This patch made the function find_updated_files to update the transid
in a pointer instead of printing it on the stdout. This is needed by
the autosnap and anyother program which may want to find the current
transid. Note that when last_gen 3rd parameter is not -1 then
find_updated_files might still print the values on the stdout.

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 btrfs-list.c |    4 ++--
 btrfs_cmds.c |    5 ++++-
 btrfs_cmds.h |    2 +-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 61eddf9..6b642fb 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -872,7 +872,7 @@ static int print_one_extent(int fd, struct btrfs_ioctl_search_header *sh,
 	return 0;
 }
 
-int find_updated_files(int fd, u64 root_id, u64 oldest_gen)
+int find_updated_files(int fd, u64 root_id, u64 oldest_gen, u64 *transid)
 {
 	int ret;
 	struct btrfs_ioctl_search_args args;
@@ -969,7 +969,7 @@ int find_updated_files(int fd, u64 root_id, u64 oldest_gen)
 	}
 	free(cache_dir_name);
 	free(cache_full_name);
-	printf("transid marker was %llu\n", (unsigned long long)max_found);
+	*transid = max_found;
 	return ret;
 }
 
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 7aab105..9357305 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -275,6 +275,7 @@ int do_find_newer(int argc, char **argv)
 	int ret;
 	char *subvol;
 	u64 last_gen;
+	u64 *tranid;
 
 	subvol = argv[1];
 	last_gen = atoll(argv[2]);
@@ -294,9 +295,11 @@ int do_find_newer(int argc, char **argv)
 		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
 		return 12;
 	}
-	ret = find_updated_files(fd, 0, last_gen);
+	ret = find_updated_files(fd, 0, last_gen, tranid);
 	if (ret)
 		return 19;
+
+	printf("transid marker was %llu\n", (unsigned long long)*tranid);
 	return 0;
 }
 
diff --git a/btrfs_cmds.h b/btrfs_cmds.h
index f53c113..218ed20 100644
--- a/btrfs_cmds.h
+++ b/btrfs_cmds.h
@@ -35,7 +35,7 @@ int do_set_default_subvol(int nargs, char **argv);
 int do_get_default_subvol(int nargs, char **argv);
 int list_subvols(int fd, int print_parent, struct sv_list **head, char *mnt);
 int do_df_filesystem(int nargs, char **argv);
-int find_updated_files(int fd, u64 root_id, u64 oldest_gen);
+int find_updated_files(int fd, u64 root_id, u64 oldest_gen, u64 *transid);
 int do_find_newer(int argc, char **argv);
 int do_change_label(int argc, char **argv);
 int open_file_or_dir(const char *fname);
-- 
1.7.9.2.315.g25a78

