Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:53980 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756701Ab3ETPAc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 May 2013 11:00:32 -0400
Received: from [192.168.226.189] ([77.119.226.254]) by smtp.web.de (mrweb003)
 with ESMTPSA (Nemesis) id 0LnBD3-1U08by0dOn-00h1Kl for
 <linux-btrfs@vger.kernel.org>; Mon, 20 May 2013 17:00:31 +0200
Message-ID: <519A3A8C.7010500@web.de>
Date: Mon, 20 May 2013 17:00:28 +0200
From: Holger Fischer <hoo.mb@web.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs-tools: debian/patches/08-fsck.patch
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear BTRFS-Community,

this patch is a reworked one of the debian-original to address the latest changes in the btrfs-tools source code.

It fixes problems that can occur when you boot a machine with btrfs root filesystem.
Boot can stop, because fsck of the btrfs-root-filesystem fails.

Here the patch:
 >cat 08-fsck.patch
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -3549,6 +3549,12 @@ const char * const cmd_check_usage[] = {
         NULL
  };

+static void cmd_check_info(void)
+{
+       fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
+       exit(0);
+}
+
  int cmd_check(int argc, char **argv)
  {
         struct cache_tree root_cache;
@@ -3566,12 +3572,11 @@ int cmd_check(int argc, char **argv)

         while(1) {
                 int c;
-               c = getopt_long(argc, argv, "as:", long_options,
+               c = getopt_long(argc, argv, "as:nry", long_options,
                                 &option_index);
                 if (c < 0)
                         break;
                 switch(c) {
-                       case 'a': /* ignored */ break;
                         case 's':
                                 num = atol(optarg);
                                 bytenr = btrfs_sb_offset(num);
@@ -3581,6 +3586,13 @@ int cmd_check(int argc, char **argv)
                         case '?':
                         case 'h':
                                 usage(cmd_check_usage);
+                               break;
+                       case 'a':
+                       case 'n':
+                       case 'r':
+                       case 'y':
+                               cmd_check_info();
+
                 }
                 if (option_index == 1) {
                         printf("enabling repair mode\n");
--- a/btrfs.c
+++ b/btrfs.c
@@ -270,7 +270,8 @@ int main(int argc, char **argv)
         else
                 bname = argv[0];

-       if (!strcmp(bname, "btrfsck")) {
+       if (!strcmp(bname, "btrfsck") ||
+           !strcmp(bname, "fsck.btrfs")) {
                 argv[0] = "check";
         } else {
                 argc--;


It addresses 2 issues:


- fsck.btrfs is not working anymore:
   to make it work again:
   - fsck.btrfs must be a (sym)link to btrfs (should be fixed in the Makefile which I did not do)
   - when calling $BINPATH/fsck.btrfs the main-function in btrfs.c must add the option "check" as 1st argument
     or described in a 2nd way: do "btrfs check" when basename of executable is fsck.btrfs

   this is equal to the behaviour of btrfsck

   the changes to btrfs.c resolve this issue


- "fsck -a <btrfsroot> (done during boot of at least ubuntu 12.04 with standard settings)
   does not return 0
   -> boot fails:
   to make it work the debian maintainers decided to create a patch which
   - prints an info (btrfs version) and return 0 when
     fsck.btrfs is called with one of the options
     "-a", "-n", "-r" or "-y"

   I rewrote the original patch to make this work again with newer versions of btrfs-tools

   Somebody upstream already cared about including "-a", so it seems somebody already tried to address this issue.


I would be happy to see these patches (or the thoughts behind, if you don't like how it's made) included upstream.

Best Regards
Holger Fischer

