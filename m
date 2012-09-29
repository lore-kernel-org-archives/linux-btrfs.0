Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40417 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964919Ab2I2BIR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Sep 2012 21:08:17 -0400
Received: by padhz1 with SMTP id hz1so2716715pad.19
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2012 18:08:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAE5mzvj-rOzVfuhUsNjd5=GyZrN4W-gGJ-yqdSJFemAyC=8e=w@mail.gmail.com>
References: <CAKZ=RP8V7J=vYerLGzavq5GBFmNtmyRYeautEoAyWqOud9b3Pw@mail.gmail.com>
	<CAE5mzvj-rOzVfuhUsNjd5=GyZrN4W-gGJ-yqdSJFemAyC=8e=w@mail.gmail.com>
Date: Sat, 29 Sep 2012 03:08:16 +0200
Message-ID: <CAKZ=RP8KpCBUL=Q51rTp7WEPuqiXnxBXjXkjDLTCZgdMeHEumw@mail.gmail.com>
Subject: Re: [PATCH] btrfs-convert: show progress
From: Alfredo Esteban <aedelatorre@gmail.com>
To: cwillu <cwillu@cwillu.com>, Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2012/9/28 cwillu <cwillu@cwillu.com>
>
> On Thu, Sep 27, 2012 at 6:02 PM, Alfredo Esteban <aedelatorre@gmail.com>
> wrote:
> > Hello,
> >
> > I'm sending a patch to show progress of btrfs-convert command. I put a
> > progress bar in the only heavy process: the btrfs metadata creation
> > (due to CRC calculation):
>
> Please include patches inline in the email, not as an attachment.
>

Ok

> >> ./btrfs-convert /dev/loop1
> > Creating btrfs metadata
> > [================================================] 100%
> > Creating ext2fs image file... [DONE]
> > Cleaning up system chunk... [DONE]
> > Conversion complete.
> >
> > I just used "\r". I think it is a simple but effective approach
> > without ncurses either other dependencies.
>
> There should probably be some way to disable the progress bar (ideally
> defaulting to a istty check) so that log files don't capture hundreds
> if not thousands of lines of "[========          ]".

Here it is the new patch:

diff --git a/convert.c b/convert.c
index fa7bf8c..522b021 100644
--- a/convert.c
+++ b/convert.c
@@ -46,6 +46,22 @@
 #define STRIPE_LEN (64 * 1024)
 #define EXT2_IMAGE_SUBVOL_OBJECTID BTRFS_FIRST_FREE_OBJECTID

+#define PROGRESS_BAR_LENGTH 48
+
+typedef struct {
+	__u32 inoinuse;
+	__u32 inocopied;
+	__u32 progressunit;
+	__u32 halfprogunit;
+	__u32 progressperc;
+	int istty;
+	int progress;
+	int flagprint;
+	float perc;
+	char msg[128];
+	char bar[256];
+} progress_bar;
+
 /*
  * Open Ext2fs in readonly mode, read block allocation bitmap and
  * inode bitmap into memory.
@@ -1119,6 +1135,78 @@ fail:
 		ret = -1;
 	return ret;
 }
+
+/*
+ * init values of progress bar.
+ */
+static void init_progress_bar(ext2_filsys ext2_fs, progress_bar *pb)
+{
+	int i;
+	sprintf(pb->msg, "Creating btrfs metadata");
+	
+	if (isatty(fileno(stdout)) != 0)
+		pb->istty = 1;
+	else
+		pb->istty = 0;
+	pb->inoinuse = ext2_fs->super->s_inodes_count
+		- ext2_fs->super->s_free_inodes_count;
+	pb->inocopied = 0;
+	pb->progressunit = pb->inoinuse / PROGRESS_BAR_LENGTH;
+	pb->halfprogunit = (int)(pb->progressunit/2);
+	pb->progressperc = pb->inoinuse / 100;
+	pb->progress = 0;
+	pb->flagprint = 0;
+	pb->perc = 0;
+	pb->bar[0] = '[';
+	for (i = 1; i < PROGRESS_BAR_LENGTH+1; i++) pb->bar[i] = ' ';
+	pb->bar[PROGRESS_BAR_LENGTH+1] = ']';
+	pb->bar[PROGRESS_BAR_LENGTH+2] = '\0';
+	if (pb->istty) {
+		printf("\e[?25l"); // hide the cursor
+		printf("\r%s %s %3d%% ", pb->msg, pb->bar, (int)pb->perc);
+		fflush(stdout);
+	}
+}
+
+/*
+ * show progress in bar.
+ */
+static void update_progress_bar(progress_bar *pb)
+{
+	pb->flagprint = 0;
+	if (pb->inocopied % pb->progressunit == 0) {
+		pb->flagprint = 1;
+		pb->progress += 1;
+		if (pb->progress < PROGRESS_BAR_LENGTH+1) pb->bar[pb->progress] = '=';
+	} else if (pb->inocopied % pb->progressunit == pb->halfprogunit) {
+		pb->flagprint = 1;
+		if (pb->progress+1 < PROGRESS_BAR_LENGTH+1) pb->bar[pb->progress+1] = '-';
+	}
+	if (pb->inocopied % pb->progressperc == 0) {
+		pb->flagprint = 1;
+		pb->perc = ((float)pb->inocopied / (float)pb->inoinuse) * 100;
+	}
+	if (pb->flagprint) {
+		printf("\r%s %s %3d%%", pb->msg, pb->bar, (int)pb->perc);
+		fflush(stdout);
+	}
+}
+
+/*
+ * show process is complete in progress bar.
+ */
+static void close_progress_bar(progress_bar *pb)
+{
+	pb->progress++;
+	for (; pb->progress < PROGRESS_BAR_LENGTH+1; pb->progress++)
pb->bar[pb->progress] = '=';
+	if (pb->istty) {
+		printf("\r%s %s 100%%\n", pb->msg, pb->bar);
+		printf("\e[?25h"); // show the cursor
+	} else
+		printf("%s %s 100%%\n", pb->msg, pb->bar);
+	fflush(stdout);
+}
+
 /*
  * scan ext2's inode bitmap and copy all used inodes.
  */
@@ -1132,6 +1220,7 @@ static int copy_inodes(struct btrfs_root *root,
ext2_filsys ext2_fs,
 	ext2_ino_t ext2_ino;
 	u64 objectid;
 	struct btrfs_trans_handle *trans;
+	progress_bar pb;

 	trans = btrfs_start_transaction(root, 1);
 	if (!trans)
@@ -1141,6 +1230,8 @@ static int copy_inodes(struct btrfs_root *root,
ext2_filsys ext2_fs,
 		fprintf(stderr, "ext2fs_open_inode_scan: %s\n", error_message(err));
 		return -1;
 	}
+	
+	init_progress_bar(ext2_fs, &pb);
 	while (!(err = ext2fs_get_next_inode(ext2_scan, &ext2_ino,
 					     &ext2_inode))) {
 		/* no more inodes */
@@ -1163,13 +1254,19 @@ static int copy_inodes(struct btrfs_root
*root, ext2_filsys ext2_fs,
 			trans = btrfs_start_transaction(root, 1);
 			BUG_ON(!trans);
 		}
+		if (pb.istty) {
+			pb.inocopied += 1;
+			update_progress_bar(&pb);
+		}
 	}
 	if (err) {
+		printf("\e[?25h"); // show the cursor
 		fprintf(stderr, "ext2fs_get_next_inode: %s\n", error_message(err));
 		return -1;
 	}
 	ret = btrfs_commit_transaction(trans, root);
 	BUG_ON(ret);
+	close_progress_bar(&pb);

 	return ret;
 }
@@ -2347,13 +2444,13 @@ int do_convert(const char *devname, int
datacsum, int packing, int noxattr)
 		fprintf(stderr, "unable to setup the root tree\n");
 		goto fail;
 	}
-	printf("creating btrfs metadata.\n");
 	ret = copy_inodes(root, ext2_fs, datacsum, packing, noxattr);
 	if (ret) {
 		fprintf(stderr, "error during copy_inodes %d\n", ret);
 		goto fail;
 	}
-	printf("creating ext2fs image file.\n");
+	printf("Creating ext2fs image file...");
+	fflush(stdout);
 	ext2_root = link_subvol(root, "ext2_saved", EXT2_IMAGE_SUBVOL_OBJECTID);
 	if (!ext2_root) {
 		fprintf(stderr, "unable to create subvol\n");
@@ -2364,7 +2461,9 @@ int do_convert(const char *devname, int
datacsum, int packing, int noxattr)
 		fprintf(stderr, "error during create_ext2_image %d\n", ret);
 		goto fail;
 	}
-	printf("cleaning up system chunk.\n");
+	printf(" [DONE]\n");
+	printf("Cleaning up system chunk...");
+	fflush(stdout);
 	ret = cleanup_sys_chunk(root, ext2_root);
 	if (ret) {
 		fprintf(stderr, "error during cleanup_sys_chunk %d\n", ret);
@@ -2400,11 +2499,12 @@ int do_convert(const char *devname, int
datacsum, int packing, int noxattr)
 	}
 	ret = close_ctree(root);
 	close(fd);
+	printf(" [DONE]\n");

-	printf("conversion complete.\n");
+	printf("Conversion complete.\n");
 	return 0;
 fail:
-	fprintf(stderr, "conversion aborted.\n");
+	fprintf(stderr, "Conversion aborted.\n");
 	return -1;
 }
