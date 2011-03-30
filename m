From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH v2 1/5] commands added
Date: Wed, 30 Mar 2011 18:53:09 +0200
Message-ID: <c1e42995310a3424784535d4f684ea97a5622b2a.1301503683.git.list.btrfs@jan-o-sch.net>
References: <cover.1301503683.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1301503683.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1301503683.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

- scrub commands added
- open_file_or_dir no longer static (needed by scrub.c)

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 Makefile     |    4 ++--
 btrfs.c      |   18 +++++++++++++++++-
 btrfs_cmds.c |    3 ++-
 btrfs_cmds.h |    5 +++++
 4 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index 6e6f6c6..6630887 100644
--- a/Makefile
+++ b/Makefile
@@ -37,8 +37,8 @@ all: version $(progs) manpages
 version:
 	bash version.sh
 
-btrfs: $(objects) btrfs.o btrfs_cmds.o
-	gcc $(CFLAGS) -o btrfs btrfs.o btrfs_cmds.o \
+btrfs: $(objects) btrfs.o btrfs_cmds.o scrub.o
+	gcc -lpthread $(CFLAGS) -o btrfs btrfs.o btrfs_cmds.o scrub.o \
 		$(objects) $(LDFLAGS) $(LIBS)
 
 btrfsctl: $(objects) btrfsctl.o
diff --git a/btrfs.c b/btrfs.c
index 46314cf..2dfa0b7 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -89,12 +89,28 @@ static struct Command commands[] = {
 	},
 	{ do_df_filesystem, 1,
 	  "filesystem df", "<path>\n"
-		"Show space usage information for a mount point\n."
+		"Show space usage information for a mount point."
 	},
 	{ do_balance, 1,
 	  "filesystem balance", "<path>\n"
 		"Balance the chunks across the device."
 	},
+	{ do_scrub_start, -1,
+	  "scrub start", "[-Bdqr] <path>|<device>\n"
+		"Start a new scrub."
+	}, 
+	{ do_scrub_cancel, 1,
+	  "scrub cancel", "<path>|<device>\n"
+		"Cancel a running scrub."
+	}, 
+	{ do_scrub_resume, -1,
+	  "scrub resume", "[-Bdqr] <path>|<device>\n"
+		"Resume previously canceled or interrupted scrub."
+	}, 
+	{ do_scrub_status, -1,
+	  "scrub status", "[-d] <path>|<device>\n"
+		"Show status of running or finished scrub."
+	}, 
 	{ do_scan,
 	  999, "device scan", "[<device> [<device>..]\n"
 		"Scan all device for or the passed device for a btrfs\n"
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 8031c58..39f84a8 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -90,7 +90,7 @@ static int test_isdir(char *path)
 
 }
 
-static int open_file_or_dir(const char *fname)
+int open_file_or_dir(const char *fname)
 {
 	int ret;
 	struct stat st;
@@ -776,6 +776,7 @@ int do_balance(int argc, char **argv)
 	}
 	return 0;
 }
+
 int do_remove_volume(int nargs, char **args)
 {
 
diff --git a/btrfs_cmds.h b/btrfs_cmds.h
index 7bde191..a879288 100644
--- a/btrfs_cmds.h
+++ b/btrfs_cmds.h
@@ -23,6 +23,10 @@ int do_defrag(int argc, char **argv);
 int do_show_filesystem(int nargs, char **argv);
 int do_add_volume(int nargs, char **args);
 int do_balance(int nargs, char **argv);
+int do_scrub_start(int nargs, char **argv);
+int do_scrub_status(int argc, char **argv);
+int do_scrub_resume(int argc, char **argv);
+int do_scrub_cancel(int nargs, char **argv);
 int do_remove_volume(int nargs, char **args);
 int do_scan(int nargs, char **argv);
 int do_resize(int nargs, char **argv);
@@ -32,3 +36,4 @@ int list_subvols(int fd);
 int do_df_filesystem(int nargs, char **argv);
 int find_updated_files(int fd, u64 root_id, u64 oldest_gen);
 int do_find_newer(int argc, char **argv);
+int open_file_or_dir(const char *fname);
-- 
1.7.3.4

