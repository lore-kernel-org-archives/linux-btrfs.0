Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46333 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754620Ab3ICRSG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Sep 2013 13:18:06 -0400
Date: Tue, 3 Sep 2013 10:18:05 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: dsterba@suse.cz, Gabriel de Perthuis <g2p.code@gmail.com>,
        Josef Bacik <jbacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PROGS PATCH] Import btrfs-extent-same
Message-ID: <20130903171805.GP31381@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <51CB6D5B.70302@gmail.com> <20130806153112.GL5284@twin.jikos.cz> <20130813193515.GG31381@wotan.suse.de> <20130902164358.GE23113@twin.jikos.cz> <20130903134129.GB18147@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130903134129.GB18147@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 03, 2013 at 03:41:29PM +0200, David Sterba wrote:
> On Mon, Sep 02, 2013 at 06:43:58PM +0200, David Sterba wrote:
> > > So I would suggest maybe something like the syhntax of btrfs-extent-same.c:
> > > 
> > > btrfs dedupe files len file1 loff1 file2 loff2 ...
> > 
> > I'm not sure I see what 'len' means here, length of the dedup block?
> 
> Now I'm reading more carefully, the arguments are the same as for
> btrfs-extent-same that does only the simple task of deduping just one
> extent, but that's not the point behind 'btrfs dedup files *'.
> 
> So there are 2 usecases:
> 
> 1 - give it a bunch of files and try to dedup as much as possible among
>     their data
> 2 - what btrfs-extent-same does, dedup just a specified range in 2 files
> 
> I'm not sure if #2 is going to be used widely though it would bring some
> flexibility and fine tuning, besides testing purposes.
> 
> I think it would be good to keep both modes under one command, so it's a
> matter of a sane UI.
> 
> #2 would look like:
> 
> $ btrfs dedup files --length 4096 --src-offset 0 --dest-offset 4096 file1 file2
> 
> and fail if != 2 files are given

Each file can have it's own start offset and of course we could include
multiple files, etc.

> 
> #1 :
> 
> $ btrfs dedup files --min-length 65536 file1 file2 file3 ...
> 
> I think we could come up with more hints like 'min-length' based on user
> requirements, but I'd like to get some agreement if this is the way to
> go.


I'm also wondering whether #1 is something that's within the scope of
btrfs-progs.


Btw, attached is a patch to merge what btrfs-extent-same does in the manner
which I was talking about before.


Frankly though I don't like where much of this is going. Aside from
the lazy naming ("btrfs dedupe" would make more sense) I have two major
problems:

1 - We usually change the file system in tunefs. I don't see why turning
online dedupe on / off should be any different. IMHO, this will confuse the end
user who is already used to turning on fs features via tunefs.

2 - That the dedupe command bunches online and offline modes together
is also problematic from an end-user perspective. For example, I had to
include a note in the "files" subcommand that it does not require online
dedupe to be turned on. Again I think most new end users are going to look
at this and be confused.
	--Mark

--
Mark Fasheh

>From 8285eacdffa9fad783efca0ce0b7979f607e9e24 Mon Sep 17 00:00:00 2001
From: Mark Fasheh <mfasheh@suse.de>
Date: Fri, 23 Aug 2013 00:48:17 -0700
Subject: btrfs-progs: add dedupe ioctl support

This patch adds a "files" subcommand to "btrfs dedup".

The files command wraps BTRFS_IOC_FILE_EXTENT_SAME, allowing the user to
do dedupe on a list of predefinied extents.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 cmds-dedup.c | 94 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 ioctl.h      | 27 +++++++++++++++++
 2 files changed, 119 insertions(+), 2 deletions(-)

diff --git a/cmds-dedup.c b/cmds-dedup.c
index 215fddc..f4ebb8c 100644
--- a/cmds-dedup.c
+++ b/cmds-dedup.c
@@ -17,7 +17,10 @@
  */
 
 #include <sys/ioctl.h>
+#include <sys/types.h>
+#include <sys/stat.h>
 #include <unistd.h>
+#include <fcntl.h>
 
 #include "ctree.h"
 #include "ioctl.h"
@@ -25,6 +28,91 @@
 #include "commands.h"
 #include "utils.h"
 
+static const char * const cmd_dedup_files_usage[] = {
+	"btrfs dedup files <len> <path1> <off1> <path2> <off2> ...",
+	"Try to deduplicate the file extents given in arguments.",
+	"Automatic deduplication support does not have to be turned on for this to work.",
+	"Extents whose data differs will be skipped for deduplication.",
+	NULL
+};
+
+static int cmd_dedup_files(int argc, char **argv)
+{
+	int ret, src_fd, i, idx, numfiles;
+	char *srcf, *destf;
+	struct btrfs_ioctl_same_args *same;
+	struct btrfs_ioctl_same_extent_info *info;
+
+	if (check_argc_min(argc, 6) || check_argc_exact(argc % 2, 0)) {
+		usage(cmd_dedup_files_usage);
+		return -1;
+	}
+
+	numfiles = (argc - 2) / 2; /* - 2 for cmd, and len args */
+	same = calloc(1,
+		      sizeof(struct btrfs_ioctl_same_args) +
+		      sizeof(struct btrfs_ioctl_same_extent_info) * numfiles);
+	if (!same)
+		return -ENOMEM;
+
+	srcf = argv[2];
+
+	src_fd = open(srcf, O_RDWR);
+	if (src_fd < 0) {
+		ret = -errno;
+		fprintf(stderr, "Could not open file %s: (%d) %s\n",
+			srcf, ret, strerror(-ret));
+		return ret;
+	}
+
+	same->length = parse_size(argv[1]);
+	same->logical_offset = parse_size(argv[3]);
+
+	for (i = 0; i < (numfiles - 1); i++) {
+		idx = 4 + (i * 2);
+		destf = argv[idx];
+
+		ret = open(destf, O_RDONLY);
+		if (ret < 0) {
+			ret = -errno;
+			fprintf(stderr, "Could not open file %s: (%d) %s\n",
+				destf, ret, strerror(-ret));
+			goto close_files;
+		}
+
+		same->info[i].fd = ret;
+		same->info[i].logical_offset = parse_size(argv[idx + 1]);
+		same->dest_count++;
+	}
+
+	printf("Deduplicate extents identical to (%llu, %llu) from %s\n",
+	       (unsigned long long)same->logical_offset,
+	       (unsigned long long)same->length, srcf);
+
+	ret = ioctl(src_fd, BTRFS_IOC_FILE_EXTENT_SAME, same);
+	if (ret) {
+		ret = -errno;
+		fprintf(stderr, "ioctl failed (%d): %s\n", ret, strerror(-ret));
+		goto close_files;
+	}
+
+	printf("%-40s  %-7s  %-s\n", "File", "Status", "Bytes Deduped");
+	for (i = 0; i < same->dest_count; i++) {
+		info = &same->info[i];
+		idx = 4 + (i * 2);
+
+		printf("%-40s   %-6d   %-llu\n", argv[idx],
+		       info->status, (unsigned long long)info->bytes_deduped);
+	}
+
+close_files:
+	close(src_fd);
+	for (i = 0; i < same->dest_count; i++)
+		close(same->info[i].fd);
+
+	return ret;
+}
+
 static const char * const dedup_cmd_group_usage[] = {
 	"btrfs dedup <command> [options] <path>",
 	NULL
@@ -62,7 +150,8 @@ int dedup_ctl(int cmd, int argc, char **argv)
 
 static const char * const cmd_dedup_reg_usage[] = {
 	"btrfs dedup register <path>",
-	"Enable data deduplication support for a filesystem.",
+	"Enable automatic data deduplication support for a filesystem.",
+	"If this is turned on, btrfs will try to deduplicate every file write.",
 	NULL
 };
 
@@ -76,7 +165,7 @@ static int cmd_dedup_reg(int argc, char **argv)
 
 static const char * const cmd_dedup_unreg_usage[] = {
 	"btrfs dedup unregister <path>",
-	"Disable data deduplication support for a filesystem.",
+	"Disable automatic data deduplication support for a filesystem.",
 	NULL
 };
 
@@ -90,6 +179,7 @@ static int cmd_dedup_unreg(int argc, char **argv)
 
 const struct cmd_group dedup_cmd_group = {
 	dedup_cmd_group_usage, NULL, {
+		{ "files", cmd_dedup_files, cmd_dedup_files_usage, 0, 0},
 		{ "register", cmd_dedup_reg, cmd_dedup_reg_usage, NULL, 0 },
 		{ "unregister", cmd_dedup_unreg, cmd_dedup_unreg_usage, 0, 0 },
 		{ 0, 0, 0, 0, 0 }
diff --git a/ioctl.h b/ioctl.h
index e959720..449d912 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -317,6 +317,31 @@ struct btrfs_ioctl_defrag_range_args {
 	__u32 unused[4];
 };
 
+#define BTRFS_SAME_DATA_DIFFERS	1
+/* For extent-same ioctl */
+struct btrfs_ioctl_same_extent_info {
+	__s64 fd;		/* in - destination file */
+	__u64 logical_offset;	/* in - start of extent in destination */
+	__u64 bytes_deduped;	/* out - total # of bytes we were able
+				 * to dedupe from this file */
+	/* status of this dedupe operation:
+	 * 0 if dedup succeeds
+	 * < 0 for error
+	 * == BTRFS_SAME_DATA_DIFFERS if data differs
+	 */
+	__s32 status;		/* out - see above description */
+	__u32 reserved;
+};
+
+struct btrfs_ioctl_same_args {
+	__u64 logical_offset;	/* in - start of extent in source */
+	__u64 length;		/* in - length of extent */
+	__u16 dest_count;	/* in - total elements in info array */
+	__u16 reserved1;
+	__u32 reserved2;
+	struct btrfs_ioctl_same_extent_info info[0];
+};
+
 struct btrfs_ioctl_space_info {
 	__u64 flags;
 	__u64 total_bytes;
@@ -597,6 +622,8 @@ struct btrfs_ioctl_clone_range_args {
 				      struct btrfs_ioctl_get_dev_stats)
 #define BTRFS_IOC_DEV_REPLACE _IOWR(BTRFS_IOCTL_MAGIC, 53, \
 				    struct btrfs_ioctl_dev_replace_args)
+#define BTRFS_IOC_FILE_EXTENT_SAME _IOWR(BTRFS_IOCTL_MAGIC, 54, \
+					 struct btrfs_ioctl_same_args)
 #define BTRFS_IOC_DEDUP_CTL _IOW(BTRFS_IOCTL_MAGIC, 55, int)
 
 #ifdef __cplusplus
-- 
1.8.1.4

