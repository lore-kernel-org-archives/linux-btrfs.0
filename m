From: David Sterba <dsterba@suse.cz>
Subject: [PATCH V2] btrfs-progs: Add ioctl to read compressed size of a file
Date: Tue, 20 Dec 2011 18:49:58 +0100
Message-ID: <1324403398-12489-1-git-send-email-dsterba@suse.cz>
References: <20111219144706.GD24793@shiny>
Cc: chris.mason@oracle.com, David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111219144706.GD24793@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
V1-V2:
* match current kernel side and print uncompressed length as well
* now it's easy to print the compression ratio for the given range

 btrfs.c      |    9 ++++++-
 btrfs_cmds.c |   68 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 btrfs_cmds.h |    1 +
 ioctl.h      |   13 +++++++++++
 4 files changed, 90 insertions(+), 1 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 1def354..dbb7224 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -128,7 +128,14 @@ static struct Command commands[] = {
 	  "filesystem label", "<device> [<newlabel>]\n"
 	  "With one argument, get the label of filesystem on <device>.\n"
 	  "If <newlabel> is passed, set the filesystem label to <newlabel>.\n"
-	  "The filesystem must be unmounted.\n"
+	  "The filesystem must be unmounted."
+	},
+	{ do_compr_size, -1,
+	  "filesystem csize", "[-s start] [-e end] file\n"
+		  "Read ordinary and compressed size of extents in the range [start,end)\n"
+		  "-s start  range start inclusive, accepts K/M/G modifiers\n"
+		  "-e end    range end exclusive, accepts K/M/G modifiers\n",
+	  NULL
 	},
 	{ do_scrub_start, -1,
 	  "scrub start", "[-Bdqr] <path>|<device>\n"
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index b59e9cb..1074ade 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -1305,3 +1305,71 @@ out:
 	free(inodes);
 	return ret;
 }
+
+int do_compr_size(int argc, char **argv)
+{
+	int ret;
+	int fd;
+	struct btrfs_ioctl_compr_size_args args;
+
+	args.start = 0;
+	args.end = (u64)-1;
+	optind = 1;
+	while (1) {
+		int c = getopt(argc, argv, "s:e:r");
+		if (c < 0)
+			break;
+		switch (c) {
+		case 's':
+			args.start = parse_size(optarg);
+			break;
+		case 'e':
+			args.end = parse_size(optarg);
+			break;
+		default:
+			fprintf(stderr, "ERROR: Invalid arguments for csize\n");
+			return 1;
+		}
+	}
+
+	if (args.start > args.end) {
+		fprintf(stderr, "ERROR: Invalid range for csize\n");
+		return 1;
+	}
+
+	if (argc - optind == 0) {
+		fprintf(stderr, "ERROR: Invalid arguments for csize\n");
+		return 1;
+	}
+	argc -= optind;
+
+	fd = open_file_or_dir(argv[optind]);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", argv[optind]);
+		return 1;
+	}
+
+	ret = ioctl(fd, BTRFS_IOC_COMPR_SIZE, &args);
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: ioctl returned %d, errno %d %s\n",
+				ret, errno, strerror(errno));
+		return errno;
+	}
+
+	printf("File name: %s\n", argv[optind]);
+	if (args.end == (u64)-1)
+		printf("File range:        %llu-EOF\n",
+				(unsigned long long)args.start);
+	else
+		printf("File range:        %llu-%llu\n",
+				(unsigned long long)args.start,
+				(unsigned long long)args.end);
+
+	printf("Compressed size:   %llu\n",
+			(unsigned long long)(args.compressed_size << 9));
+	printf("Uncompressed size: %llu\n",
+			(unsigned long long)(args.size << 9));
+	printf("Ratio:             %3.2f%%\n",
+			100.0 * args.compressed_size / args.size);
+	return 0;
+}
diff --git a/btrfs_cmds.h b/btrfs_cmds.h
index 81182b1..d171214 100644
--- a/btrfs_cmds.h
+++ b/btrfs_cmds.h
@@ -42,3 +42,4 @@ int open_file_or_dir(const char *fname);
 int do_ino_to_path(int nargs, char **argv);
 int do_logical_to_ino(int nargs, char **argv);
 char *path_for_root(int fd, u64 root);
+int do_compr_size(int argc, char **argv);
diff --git a/ioctl.h b/ioctl.h
index 1ae7537..5b5208a 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -224,6 +224,17 @@ struct btrfs_ioctl_logical_ino_args {
 	__u64				inodes;
 };
 
+struct btrfs_ioctl_compr_size_args {
+	/* Range start, inclusive */
+	__u64   start;                          /* in */
+	/* Range end, exclusive */
+	__u64   end;                            /* in */
+	__u64   size;                           /* out */
+	__u64   compressed_size;                /* out */
+	__u64   reserved[2];
+};
+
+
 /* BTRFS_IOC_SNAP_CREATE is no longer used by the btrfs command */
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
@@ -277,5 +288,7 @@ struct btrfs_ioctl_logical_ino_args {
 					struct btrfs_ioctl_ino_path_args)
 #define BTRFS_IOC_LOGICAL_INO _IOWR(BTRFS_IOCTL_MAGIC, 36, \
 					struct btrfs_ioctl_ino_path_args)
+#define BTRFS_IOC_COMPR_SIZE _IOR(BTRFS_IOCTL_MAGIC, 51, \
+		                struct btrfs_ioctl_compr_size_args)
 
 #endif
-- 
1.7.7.3

