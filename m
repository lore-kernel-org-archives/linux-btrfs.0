From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH v3 1/5] btrfs-progs: commands added
Date: Mon, 18 Jul 2011 14:37:21 +0200
Message-ID: <ac1ef7fc3e25d7f766ace6934fb183945e9ac3f0.1310990184.git.list.btrfs@jan-o-sch.net>
References: <cover.1310990184.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1310990184.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1310990184.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

- scrub commands added
- open_file_or_dir no longer static (needed by scrub.c)

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 Makefile     |    4 ++--
 btrfs.c      |   23 +++++++++++++++++++++++
 btrfs_cmds.c |    2 +-
 btrfs_cmds.h |    5 +++++
 4 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 22bae25..edee1a0 100644
--- a/Makefile
+++ b/Makefile
@@ -35,8 +35,8 @@ all: version $(progs) manpages
 version:
 	bash version.sh
 
-btrfs: $(objects) btrfs.o btrfs_cmds.o
-	$(CC) -lpthread $(CFLAGS) -o btrfs btrfs.o btrfs_cmds.o \
+btrfs: $(objects) btrfs.o btrfs_cmds.o scrub.o
+	$(CC) -lpthread $(CFLAGS) -o btrfs btrfs.o btrfs_cmds.o scrub.o \
 		$(objects) $(LDFLAGS) $(LIBS)
 
 btrfsctl: $(objects) btrfsctl.o
diff --git a/btrfs.c b/btrfs.c
index ee4e756..f494738 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -142,6 +142,29 @@ static struct Command commands[] = {
 	  "balance cancel", "<path>\n"
 		"Cancel the balance operation running on <path>."
 	},
+	{ do_scrub_start, -1,
+	  "scrub start", "[-Bdqr] <path>|<device>\n"
+		"Start a new scrub.",
+		"\n-B  do not background\n"
+		"-d  stats per device (-B only)\n"
+		"-q  quiet\n"
+		"-r  read only mode\n"
+	},
+	{ do_scrub_cancel, 1,
+	  "scrub cancel", "<path>|<device>\n"
+		"Cancel a running scrub.",
+	  NULL
+	},
+	{ do_scrub_resume, -1,
+	  "scrub resume", "[-Bdqr] <path>|<device>\n"
+		"Resume previously canceled or interrupted scrub.",
+	  NULL
+	},
+	{ do_scrub_status, -1,
+	  "scrub status", "[-d] <path>|<device>\n"
+		"Show status of running or finished scrub.",
+	  NULL
+	},
 	{ do_scan, 999, 
 	  "device scan", "[--all-devices|<device> [<device> ...]]\n"
 		"Scan all device for or the passed device for a btrfs\n"
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 43ffc38..0612f34 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -92,7 +92,7 @@ static int test_isdir(char *path)
 
 }
 
-static int open_file_or_dir(const char *fname)
+int open_file_or_dir(const char *fname)
 {
 	int ret;
 	struct stat st;
diff --git a/btrfs_cmds.h b/btrfs_cmds.h
index 067b53f..83faa5b 100644
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
 int do_balance_progress(int nargs, char **argv);
 int do_balance_cancel(int nargs, char **argv);
 int do_remove_volume(int nargs, char **args);
@@ -35,3 +39,4 @@ int do_df_filesystem(int nargs, char **argv);
 int find_updated_files(int fd, u64 root_id, u64 oldest_gen);
 int do_find_newer(int argc, char **argv);
 int do_change_label(int argc, char **argv);
+int open_file_or_dir(const char *fname);
-- 
1.7.3.4

