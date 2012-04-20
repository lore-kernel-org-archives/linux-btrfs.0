From: Jim Meyering <jim@meyering.net>
Subject: [PATCHv2 4/4] mkfs: avoid heap-buffer-read-underrun for zero-length "size" arg
Date: Fri, 20 Apr 2012 21:27:26 +0200
Message-ID: <1334950046-24147-5-git-send-email-jim@meyering.net>
References: <1334950046-24147-1-git-send-email-jim@meyering.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1334950046-24147-1-git-send-email-jim@meyering.net>
List-ID: <linux-btrfs.vger.kernel.org>

From: Jim Meyering <meyering@redhat.com>

* mkfs.c (parse_size): ./mkfs.btrfs -A '' would read and possibly
write the byte before beginning of strdup'd heap buffer.  All other
size-accepting options were similarly affected.

Reviewed-by: Josef Bacik <josef@redhat.com>
---
 cmds-subvolume.c |    2 +-
 mkfs.c           |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index fc749f1..a01c830 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -380,7 +380,7 @@ static int cmd_snapshot(int argc, char **argv)

 	args.fd = fd;
 	strncpy(args.name, newname, BTRFS_SUBVOL_NAME_MAX);
-	args.name[BTRFS_PATH_NAME_MAX-1] = 0;
+	args.name[BTRFS_SUBVOL_NAME_MAX-1] = 0;
 	res = ioctl(fddst, BTRFS_IOC_SNAP_CREATE_V2, &args);
 	e = errno;

diff --git a/mkfs.c b/mkfs.c
index 03239fb..4aff2fd 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -63,7 +63,7 @@ static u64 parse_size(char *s)

 	s = strdup(s);

-	if (!isdigit(s[len - 1])) {
+	if (len && !isdigit(s[len - 1])) {
 		c = tolower(s[len - 1]);
 		switch (c) {
 		case 'g':
-- 
1.7.10.208.gb4267

