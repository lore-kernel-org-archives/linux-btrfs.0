From: David Sterba <dsterba@suse.cz>
Subject: Re: A sample tool how to use the new ioctl
Date: Mon, 19 Dec 2011 18:27:35 +0100
Message-ID: <20111219172735.GF12898@ds.suse.cz>
References: <1324304223-19079-1-git-send-email-dsterba@suse.cz>
 <20111219142539.GE12898@ds.suse.cz>
 <20111219144706.GD24793@shiny>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111219144706.GD24793@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 19, 2011 at 09:47:06AM -0500, Chris Mason wrote:
> On Mon, Dec 19, 2011 at 03:25:39PM +0100, David Sterba wrote:
> > This is a standalone tool I've used to exercise the ioctl, simply pass
> Could you please add this to btrfs filesystem stat <filename>

Here it is, but I haven't really thought about the userspace interface and
calling it 'stat' just for reading compressed size does not seem right (and I
have renamed to 'csize' for now).

I will extend the ioctl to return the uncompressed size as well, it is provided
by the extent anyway. The original implementation returned just one u64 for the
whole file, I did the range-aware version because the lock_extent blocked for a
long time when the file was being modified and it could be avoided. However I
missed the options to utilize the information provided by the extents,
so this is not a final version.

From: David Sterba <dsterba@suse.cz>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 btrfs.c      |    9 ++++++++-
 btrfs_cmds.c |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 btrfs_cmds.h |    1 +
 ioctl.h      |   11 +++++++++++
 4 files changed, 73 insertions(+), 1 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 1def354..5ce207a 100644
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
+		  "Read compressed size of extents in the range [start,end)\n"
+		  "-s start  range start inclusive\n"
+		  "-e end    range end exclusive\n",
+	  NULL
 	},
 	{ do_scrub_start, -1,
 	  "scrub start", "[-Bdqr] <path>|<device>\n"
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index b59e9cb..4c8bf5c 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -1305,3 +1305,56 @@ out:
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
+		int c = getopt(argc, argv, "s:e:");
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
+		fprintf(stderr, "ERROR: ioctl returned %d, errno %d %s\n", ret, errno, strerror(errno));
+		return errno;
+	}
+
+	printf("Compressed size: %llu\n", args.size << 9);
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
index 1ae7537..792ffc0 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -224,6 +224,15 @@ struct btrfs_ioctl_logical_ino_args {
 	__u64				inodes;
 };
 
+struct btrfs_ioctl_compr_size_args {
+	/* Range start, inclusive */
+	__u64                           start;          /* in */
+	/* Range end, exclusive */
+	__u64                           end;            /* in */
+	__u64                           size;           /* out */
+	__u64                           reserved[2];
+};
+
 /* BTRFS_IOC_SNAP_CREATE is no longer used by the btrfs command */
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
@@ -277,5 +286,7 @@ struct btrfs_ioctl_logical_ino_args {
 					struct btrfs_ioctl_ino_path_args)
 #define BTRFS_IOC_LOGICAL_INO _IOWR(BTRFS_IOCTL_MAGIC, 36, \
 					struct btrfs_ioctl_ino_path_args)
+#define BTRFS_IOC_COMPR_SIZE _IOR(BTRFS_IOCTL_MAGIC, 51, \
+		                struct btrfs_ioctl_compr_size_args)
 
 #endif
-- 
1.7.7.3

