From: Peter Klotz <peter.klotz@aon.at>
Subject: Misleading error message in btrfsctl
Date: Sun, 18 Jan 2009 14:40:08 +0100
Message-ID: <49733138.4010309@aon.at>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030305040000070203030000"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030305040000070203030000
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Calling btrfsctl results in this message when module btrfs.ko is not loaded:

root@asus:/root# btrfsctl -A /dev/sda
ioctl:: Bad file descriptor

An strace shows that actually opening of /dev/btrfs-control failed.

open("/dev/btrfs-control", O_RDWR)      = -1 ENOENT (No such file or 
directory)
ioctl(4294967295, 0x50009404, 0x7fff11fb76b0) = -1 EBADF (Bad file 
descriptor)

The attached patch (against btrfsctl 0.18) terminates btrfsctl if 
/dev/btrfs-control cannot be opened.

The output with applied patch:

root@asus:/root# btrfsctl -A /dev/sda
failed to open /dev/btrfs-control

Regards, Peter.

--------------030305040000070203030000
Content-Type: text/x-patch;
 name="btrfs-control-open.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="btrfs-control-open.patch"

diff -Nur btrfs-progs-0.18/btrfsctl.c btrfs-progs-0.18.patched/btrfsctl.c
--- btrfs-progs-0.18/btrfsctl.c	2009-01-17 02:08:19.000000000 +0100
+++ btrfs-progs-0.18.patched/btrfsctl.c	2009-01-18 14:16:25.000000000 +0100
@@ -189,6 +189,10 @@
 
 	if (command == BTRFS_IOC_SCAN_DEV) {
 		fd = open("/dev/btrfs-control", O_RDWR);
+		if (fd < 0) {
+                	fprintf(stderr, "failed to open /dev/btrfs-control\n");
+                       exit(1);
+	        }
 		name = fname;
 	 } else {
 		fd = open_file_or_dir(fname);

--------------030305040000070203030000--
