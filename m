From: "Ahmed Kamal" <email.ahmedkamal@googlemail.com>
Subject: patch improving btrfsctl usage message
Date: Sat, 19 Jul 2008 14:28:20 +0300
Message-ID: <3da3b5b40807190428q6181260dn85ac25436f76a177@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Many options were not mentioned in the usage message, fixing that and
cleaning up the brackets

# HG changeset patch
# User email.ahmedkamal@googlemail.com
# Date 1216477620 -10800
# Node ID efd06f1a7f0634b04ff06cfeac76503439a54b7e
# Parent  f35e2b3b25a97d42452ec90b6c524721d9c9941f
Cleaning up usage message
Signed-Off-By: Ahmed Kamal <email.ahmedkamal@googlemail.com>
user: email.ahmedkamal@googlemail.com

diff -r f35e2b3b25a9 -r efd06f1a7f06 btrfsctl.c
--- a/btrfsctl.c        Fri Jul 18 22:43:09 2008 +0300
+++ b/btrfsctl.c        Sat Jul 19 17:27:00 2008 +0300
@@ -43,15 +43,15 @@

 void print_usage(void)
 {
-       printf("usage: btrfsctl [ -s name ] [-d] [-r size] file_or_dir\n");
-       printf("\t-d filename defragments one file\n");
-       printf("\t-d directory defragments the entire Btree\n");
-       printf("\t-s snap_name existing_subvol creates a new snapshot\n");
-       printf("\t-s snap_name tree_root creates a new subvolume\n");
-       printf("\t-r [+-]size[gkm] resize the FS\n");
-       printf("\t-A device scans the device for a Btrfs filesystem\n");
-       printf("\t-a scans all devices for Btrfs filesystems\n");
-       printf("\t-c forces a single FS sync\n");
+       printf("usage: btrfsctl [ -d file|dir] [ -s snap_name
subvol|tree ] [-r size] [-A device] [-a] [-c]\n");
+       printf("\t-d filename: defragments one file\n");
+       printf("\t-d directory: defragments the entire Btree\n");
+       printf("\t-s snap_name: existing_subvol creates a new snapshot\n");
+       printf("\t-s snap_name: tree_root creates a new subvolume\n");
+       printf("\t-r [+-]size[gkm]: resize the FS by that much\n");
+       printf("\t-A device: scans the device file for a Btrfs filesystem\n");
+       printf("\t-a: scans all devices for Btrfs filesystems\n");
+       printf("\t-c: forces a single FS sync\n");
        exit(1);
 }
