Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:59392 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755080Ab2HaVg4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Aug 2012 17:36:56 -0400
Message-ID: <50412EA7.7090005@libero.it>
Date: Fri, 31 Aug 2012 23:37:43 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Yan Zheng <zheng.yan@oracle.com>
CC: M G Berberich <btrfs@oss.m-berberich.de>, linux-btrfs@vger.kernel.org,
        Chris Mason <chris.mason@oracle.com>
Subject: =?UTF-8?B?W0JUUkZTLVBST0dTXVtCVUddW1BBVENIXSBJbmNvcnJlY3QgZGV0ZWM=?=
 =?UTF-8?B?dGlvbiBvZiBhIHJlbW92ZWQgZGV2aWNlICBbd2FzIFJlOiDigJxCdWfigJ0tcmU=?=
 =?UTF-8?B?cG9ydDogaW5jb25zaXN0ZW5jeSBrZXJuZWwgPC0+IHRvb2xzXQ==?=
References: <20120828195244.GA15021@invalid> <503FAFF5.80204@libero.it> <50410BBE.6030601@libero.it>
In-Reply-To: <50410BBE.6030601@libero.it>
Content-Type: multipart/mixed;
 boundary="------------040101030603060502000604"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040101030603060502000604
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi all, Yan,

On 08/31/2012 09:08 PM, Goffredo Baroncelli wrote:
> However making a test I found both the behaviours: sometime the removed
> disk disappears from the output of "btrfs fi show" and sometime not...
>
> May be that there is a bug somewhere...


I became crazy looking at this bug. I found that a debian package raises 
the bug, but when I compiled the source by hand the bug disappeared... 
Finally I discovered that this bug depends by an uninitialized variable; 
this lead to the unpredictable behaviour.

The problem is that when a device is removed, the function 
btrfs_read_dev_super() should ignore it. In fact the kernel clear the 
magic number in the *first* superblock. However the function 
btrfs_read_dev_super() checks also the backup superblocks and when it 
found a valid one, the function returns success.

Lukely (?) this function fails very often because the fsid of the backup 
superblock are checked against an uninitialized buffer. However when 
this check has success this device is considered suitable even tough it 
was removed.

The BUG is in the function btrfs_read_dev_super():


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

                 if (btrfs_super_generation(&buf) > transid) {
                         memcpy(sb, &buf, sizeof(*sb));
                         transid = btrfs_super_generation(&buf);
                 }
         }


When a device is removed, the *first* superblock magic field is zeroed 
so the first check "strncmp((char *)(&buf.magic), BTRFS_MAGIC,..." fails 
, "i" is increased, and the "continue" statement is execute.
Then the check "memcmp(fsid...." became unreliable in the next iteration 
because the fsid variable is not initialized.

To me the test is unclear: what is the purpose to continue when the 
superblocks (the original one and its backup) refer to different fsid: 
there is something wrong which require an user decision...
May be that Yan added this check (see commit 
50860d6e31c28cf4789ef099729dfbce2108620a ) to converting from different 
format ? Yan do you remember something about this code ?

The enclosed patch corrects the initialization of the fsid variable; 
morover if the fsid are different between the superblocks (the original 
one and its backup) the function fails because the device cannot be 
trusted. Finally it is handled the special case when the magic fields is 
zeroed in the *first* superblock. In this case the device is skipped.

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

--------------040101030603060502000604
Content-Type: text/x-patch;
 name="btrfs_read_dev_super-bug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="btrfs_read_dev_super-bug.patch"

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

--------------040101030603060502000604--
