From: "Ahmed Kamal" <email.ahmedkamal@googlemail.com>
Subject: Fix: btrfsctl arguments handling
Date: Fri, 18 Jul 2008 19:37:48 +0300
Message-ID: <3da3b5b40807180937md87cb4aj965b1b3a52ae7358@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfsctl -A
in the current -unstable branch, does not result in the error message
designated for it, namely "-A requires an arg\n". Turns out the whole
loop was being skipped!
Please find a patch attached that fixed it for me.

diff -r 1aa4b32e3efd btrfsctl.c
--- a/btrfsctl.c        Tue Jun 10 10:09:18 2008 -0400
+++ b/btrfsctl.c        Fri Jul 18 22:34:46 2008 +0300
@@ -73,7 +73,7 @@
                btrfs_scan_one_dir("/dev", 1);
                exit(0);
        }
-       for (i = 1; i < ac - 1; i++) {
+       for (i = 1; i <= ac - 1; i++) {
                if (strcmp(av[i], "-s") == 0) {
                        if (i + 1 >= ac - 1) {
                                fprintf(stderr, "-s requires an arg");


PS: Is this the correct way to submit patches ?
