Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:46430 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844Ab2IKRam (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Sep 2012 13:30:42 -0400
Message-ID: <504F7582.8040902@libero.it>
Date: Tue, 11 Sep 2012 19:31:46 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: Yan Zheng <zheng.yan@oracle.com>, M G Berberich <btrfs@oss.m-berberich.de>,
        linux-btrfs@vger.kernel.org
Subject: [RESPOST][BTRFS-PROGS][PATCH] btrfs_read_dev_super(): uninitialized
 variable
References: <20120828195244.GA15021@invalid> <503FAFF5.80204@libero.it> <50410BBE.6030601@libero.it>
In-Reply-To: <50410BBE.6030601@libero.it>
Content-Type: multipart/mixed;
 boundary="------------060008070009020701020804"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060008070009020701020804
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

This is a repost because I rebased the change. The first attempt was 
done with the email "[BTRFS-PROGS][BUG][PATCH] Incorrect detection of a 
removed device  [was Re: “Bug”-report: inconsistency kernel <-> tools]" 
dated 08/31/2012.

In the function btrfs_read_dev_super() it is possible to use the 
variable fsid without initialisation.

In btrfs_read_dev_super(), during the scan of the superblock the 
variable fsid is initialised with the value of fsid of the first 
superblock. But if the first superblock contains an incorrect signature 
this initialisation is skipped.

int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 
sb_bytenr)
{
          u8 fsid[BTRFS_FSID_SIZE];
[...]

line 933:

          for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
                  bytenr = btrfs_sb_offset(i);
                  ret = pread64(fd, &buf, sizeof(buf), bytenr);
                  if (ret < sizeof(buf))
                          break;

                  if (btrfs_super_bytenr(&buf) != bytenr ||
                      strncmp((char *)(&buf.magic), BTRFS_MAGIC,
                              sizeof(buf.magic)))
                          continue;

                  if (i == 0)
                          memcpy(fsid, buf.fsid, sizeof(fsid));
                  else if (memcmp(fsid, buf.fsid, sizeof(fsid)))
                          continue;

                 [...]
          }

This bug could be triggered by the command "btrfs device delete", which 
zeros the signature of the first superblock.

The enclosed patch corrects the initialisation of the fsid variable; 
moreover if the fsid are different between the superblocks (the original 
one and its backups) the function fails because the device cannot be 
trusted. Finally it is handled the special case when the magic fields is 
zeroed in the *first* superblock. In this case the device is skipped.

Please apply, thank.

You can pull from
	http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git
branch
	btrfs_read_dev_super-bug
	

BR
G.Baroncelli

-- 
Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>

diff --git a/disk-io.c b/disk-io.c
index b21a87f..82fc3b8 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -910,6 +910,7 @@ struct btrfs_root *open_ctree_fd(int fp, const char 
*path, u64 sb_bytenr,
  int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 
sb_bytenr)
  {
  	u8 fsid[BTRFS_FSID_SIZE];
+	int fsid_is_initialized = 0;
  	struct btrfs_super_block buf;
  	int i;
  	int ret;
@@ -936,15 +937,26 @@ int btrfs_read_dev_super(int fd, struct 
btrfs_super_block *sb, u64 sb_bytenr)
  		if (ret < sizeof(buf))
  			break;

-		if (btrfs_super_bytenr(&buf) != bytenr ||
-		    strncmp((char *)(&buf.magic), BTRFS_MAGIC,
+		if (btrfs_super_bytenr(&buf) != bytenr )
+			continue;
+		/* if magic is NULL, the device was removed */
+		if (buf.magic == 0 && i==0)
+			return -1;
+		if (strncmp((char *)(&buf.magic), BTRFS_MAGIC,
  			    sizeof(buf.magic)))
  			continue;

-		if (i == 0)
+		if (!fsid_is_initialized){
  			memcpy(fsid, buf.fsid, sizeof(fsid));
-		else if (memcmp(fsid, buf.fsid, sizeof(fsid)))
-			continue;
+			fsid_is_initialized = 1;
+		} else if (memcmp(fsid, buf.fsid, sizeof(fsid))) {
+			/*
+			 * the superblocks (the original one and
+			 * its backups) contain data of different
+			 * filesystems -> the disk cannot be trusted
+			 */
+			return -1;
+		}

  		if (btrfs_super_generation(&buf) > transid) {
  			memcpy(sb, &buf, sizeof(*sb));

--------------060008070009020701020804
Content-Type: text/x-patch;
 name="btrfs_read_dev_super-bug.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="btrfs_read_dev_super-bug.diff"

diff --git a/disk-io.c b/disk-io.c
index b21a87f..82fc3b8 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -910,6 +910,7 @@ struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
 int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr)
 {
 	u8 fsid[BTRFS_FSID_SIZE];
+	int fsid_is_initialized = 0;
 	struct btrfs_super_block buf;
 	int i;
 	int ret;
@@ -936,15 +937,26 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr)
 		if (ret < sizeof(buf))
 			break;
 
-		if (btrfs_super_bytenr(&buf) != bytenr ||
-		    strncmp((char *)(&buf.magic), BTRFS_MAGIC,
+		if (btrfs_super_bytenr(&buf) != bytenr )
+			continue;
+		/* if magic is NULL, the device was removed */
+		if (buf.magic == 0 && i==0)
+			return -1;
+		if (strncmp((char *)(&buf.magic), BTRFS_MAGIC,
 			    sizeof(buf.magic)))
 			continue;
 
-		if (i == 0)
+		if (!fsid_is_initialized){
 			memcpy(fsid, buf.fsid, sizeof(fsid));
-		else if (memcmp(fsid, buf.fsid, sizeof(fsid)))
-			continue;
+			fsid_is_initialized = 1;
+		} else if (memcmp(fsid, buf.fsid, sizeof(fsid))) {
+			/* 
+			 * the superblocks (the original one and
+			 * its backups) contain data of different
+			 * filesystems -> the disk cannot be trusted
+			 */
+			return -1;
+		}
 
 		if (btrfs_super_generation(&buf) > transid) {
 			memcpy(sb, &buf, sizeof(*sb));

--------------060008070009020701020804--
