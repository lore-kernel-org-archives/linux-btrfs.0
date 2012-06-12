Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49398 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059Ab2FLTPb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jun 2012 15:15:31 -0400
Date: Tue, 12 Jun 2012 15:15:27 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: kreijack@inwind.it
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: Btrfs and data nocow per inode basis
Message-ID: <20120612191527.GA11966@thunk.org>
References: <4FD442F1.7040008@inwind.it>
 <4FD77F45.3060000@libero.it>
 <20120612183209.GC1803@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120612183209.GC1803@thunk.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It appears the NOCOW_FL flag is currently a no-op in the 3.2 kernel?

<tytso.root@tytso-glaptop.cam.corp.google.com> {/mnt}  
2062# grep /mnt /proc/mounts 
/dev/mapper/funarg-btrfs /mnt btrfs rw,relatime,space_cache 0 0
<tytso.root@tytso-glaptop.cam.corp.google.com> {/mnt}  
2063# sync ; filefrag -v a
Filesystem type is: 9123683e
File size of a is 32768 (8 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0     3096               8 eof
a: 1 extent found
<tytso.root@tytso-glaptop.cam.corp.google.com> {/mnt}  
2064# dd if=/dev/zero of=a bs=32k conv=notrunc,nocreat count=1 
1+0 records in
1+0 records out
32768 bytes (33 kB) copied, 0.000119266 s, 275 MB/s
<tytso.root@tytso-glaptop.cam.corp.google.com> {/mnt}  
2065# sync ; filefrag -v a
Filesystem type is: 9123683e
File size of a is 32768 (8 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0     3088               8 eof
a: 1 extent found
<tytso.root@tytso-glaptop.cam.corp.google.com> {/mnt}  
2066# lsattr a
---------------C a

I've attached the patch which I was going to commit, but when I tested
it, it appears the flag is being set and displayed correctly, but
btrfs doesn't appear to be honoring it.

Anyway want to explain what's going on?

						- Ted

diff --git a/lib/e2p/pf.c b/lib/e2p/pf.c
index f03193c..69181e7 100644
--- a/lib/e2p/pf.c
+++ b/lib/e2p/pf.c
@@ -49,6 +49,7 @@ static struct flags_name flags_array[] = {
 	{ EXT2_TOPDIR_FL, "T", "Top_of_Directory_Hierarchies" },
 	{ EXT4_EXTENTS_FL, "e", "Extents" },
 	{ EXT4_HUGE_FILE_FL, "h", "Huge_file" },
+	{ FS_NOCOW_FL, "C", "Huge_file" },
 	{ 0, NULL, NULL }
 };
 
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index f46a1a9..fb3f7cc 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -301,6 +301,7 @@ struct ext2_dx_countlimit {
 #define EXT4_EXTENTS_FL 		0x00080000 /* Inode uses extents */
 #define EXT4_EA_INODE_FL	        0x00200000 /* Inode used for large EA */
 /* EXT4_EOFBLOCKS_FL 0x00400000 was here */
+#define FS_NOCOW_FL			0x00800000 /* Do not cow file */
 #define EXT4_SNAPFILE_FL		0x01000000  /* Inode is a snapshot */
 #define EXT4_SNAPFILE_DELETED_FL	0x04000000  /* Snapshot is being deleted */
 #define EXT4_SNAPFILE_SHRUNK_FL		0x08000000  /* Snapshot shrink has completed */
diff --git a/misc/chattr.1.in b/misc/chattr.1.in
index 92f6d70..18b44bd 100644
--- a/misc/chattr.1.in
+++ b/misc/chattr.1.in
@@ -64,6 +64,10 @@ this file compresses data before storing them on the disk.  Note: please
 make sure to read the bugs and limitations section at the end of this
 document.
 .PP
+A file with the 'C' attribute set will not be subject to copy-on-write
+updates.  This flag is only supported on file systems which perform
+copy-on-write, obviously.
+.PP
 When a directory with the `D' attribute set is modified,
 the changes are written synchronously on the disk; this is equivalent to
 the `dirsync' mount option applied to a subset of the files.
diff --git a/misc/chattr.c b/misc/chattr.c
index 8a2d61f..141ea6e 100644
--- a/misc/chattr.c
+++ b/misc/chattr.c
@@ -107,6 +107,7 @@ static const struct flags_char flags_array[] = {
 	{ EXT2_UNRM_FL, 'u' },
 	{ EXT2_NOTAIL_FL, 't' },
 	{ EXT2_TOPDIR_FL, 'T' },
+	{ FS_NOCOW_FL, 'C' },
 	{ 0, 0 }
 };
 
