From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: [PATCH 2/5] Add support for read-only subvolumes.
Date: Tue, 26 Apr 2011 10:02:41 +0200
Message-ID: <1303804964-2840-3-git-send-email-philipp.andreas@gmail.com>
References: <There is kernel side support for the creation of read-only snapshots>
 <1303804964-2840-1-git-send-email-philipp.andreas@gmail.com>
Cc: Andreas Philipp <philipp.andreas@gmail.com>,
	chris.mason@oracle.com, dcrmorgado@gmail.com, kreijack@libero.it,
	lizf@cn.fujitsu.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1303804964-2840-1-git-send-email-philipp.andreas@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Use BTRFS_IOC_CREATE_SNAP_V2 instead of BTRFS_IOC_CREATE_SNAP and add
an option for the creation of a readonly snapshot.

Signed-off-by: Andreas Philipp <philipp.andreas@gmail.com>
---
 btrfs_cmds.c |   48 ++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 8031c58..9367bac 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -43,7 +43,7 @@
 
 #ifdef __CHECKER__
 #define BLKGETSIZE64 0
-#define BTRFS_IOC_SNAP_CREATE 0
+#define BTRFS_IOC_SNAP_CREATE_V2 0
 #define BTRFS_VOL_NAME_MAX 255
 struct btrfs_ioctl_vol_args { char name[BTRFS_VOL_NAME_MAX]; };
 static inline int ioctl(int fd, int define, void *arg) { return 0; }
@@ -310,13 +310,38 @@ int do_subvol_list(int argc, char **argv)
 int do_clone(int argc, char **argv)
 {
 	char	*subvol, *dst;
-	int	res, fd, fddst, len;
+	int	res, fd, fddst, len, optind = 0, readonly = 0;
 	char	*newname;
 	char	*dstdir;
+	struct btrfs_ioctl_vol_args_v2	args;
 
-	subvol = argv[1];
-	dst = argv[2];
-	struct btrfs_ioctl_vol_args	args;
+	memset(&args, 0, sizeof(args));
+
+	while (1) {
+		int c = getopt(argc, argv, "r");
+
+		if (c < 0)
+			break;
+		switch (c) {
+		case 'r':
+			optind++;
+			readonly = 1;
+			break;
+		default:
+			fprintf(stderr,
+				"Invalid arguments for subvolume snapshot\n");
+			free(argv);
+			return 1;
+		}
+	}
+	if (argc - optind < 2) {
+		fprintf(stderr, "Invalid arguments for subvolume snapshot\n");
+		free(argv);
+		return 1;
+	}
+
+	subvol = argv[optind+1];
+	dst = argv[optind+2];
 
 	res = test_issubvolume(subvol);
 	if(res<0){
@@ -372,11 +397,18 @@ int do_clone(int argc, char **argv)
 		return 12;
 	}
 
-	printf("Create a snapshot of '%s' in '%s/%s'\n",
-	       subvol, dstdir, newname);
+	if (readonly) {
+		args.flags |= BTRFS_SUBVOL_RDONLY;
+		printf("Create a readonly snapshot of '%s' in '%s/%s'\n",
+		       subvol, dstdir, newname);
+	} else {
+		printf("Create a snapshot of '%s' in '%s/%s'\n",
+		       subvol, dstdir, newname);
+	}
+
 	args.fd = fd;
 	strcpy(args.name, newname);
-	res = ioctl(fddst, BTRFS_IOC_SNAP_CREATE, &args);
+	res = ioctl(fddst, BTRFS_IOC_SNAP_CREATE_V2, &args);
 
 	close(fd);
 	close(fddst);
-- 
1.7.4.1

