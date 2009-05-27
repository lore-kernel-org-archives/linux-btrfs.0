From: Edward Shishkin <edward.shishkin@gmail.com>
Subject: [patch] btrfs-progs: fix btrfs_read_dev_super
Date: Wed, 27 May 2009 15:30:19 +0200
Message-ID: <4A1D406B.6090404@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030607010405040703030002"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030607010405040703030002
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



--------------030607010405040703030002
Content-Type: text/plain;
 name="btrfsprogs-fix-read_super.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="btrfsprogs-fix-read_super.patch"

Don't break in the middle of search,
taste also other super mirrors.

Signed-off-by: Edward Shishkin <edward.shishkin@gmail.com>
---
 disk-io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- btrfs-progs-0.18.orig/disk-io.c
+++ btrfs-progs-0.18/disk-io.c
@@ -716,7 +716,7 @@ int btrfs_read_dev_super(int fd, struct 
 		bytenr = btrfs_sb_offset(i);
 		ret = pread64(fd, &buf, sizeof(buf), bytenr);
 		if (ret < sizeof(buf))
-			break;
+			continue;
 
 		if (btrfs_super_bytenr(&buf) != bytenr ||
 		    strncmp((char *)(&buf.magic), BTRFS_MAGIC,

--------------030607010405040703030002--
