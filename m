Return-Path: <SRS0=IJ3x=Q3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E315C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 09:37:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 511CE2089F
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 09:37:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbfBTJh3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Feb 2019 04:37:29 -0500
Received: from bang.steev.me.uk ([81.2.120.65]:39957 "EHLO smtp.steev.me.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbfBTJh3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Feb 2019 04:37:29 -0500
X-Greylist: delayed 1283 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Feb 2019 04:37:28 EST
Received: from localhost ([::1] helo=webmail.steev.me.uk)
        by smtp.steev.me.uk with esmtp (Exim 4.91)
        id 1gwNz2-0002FM-H1
        for linux-btrfs@vger.kernel.org; Wed, 20 Feb 2019 09:16:04 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 20 Feb 2019 09:16:04 +0000
From:   Steven Davies <btrfs@steev.me.uk>
To:     linux-btrfs@vger.kernel.org
Subject: [RFC PATCH] btrfs-progs: Quiet mode for btrfs-receive
Message-ID: <7573fc8cc0e99d8815f1616d9503c2b6@steev.me.uk>
X-Sender: btrfs@steev.me.uk
User-Agent: Roundcube Webmail/1.3.8
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Provide an option in `btrfs receive` to suppress the informational
messages when writing files.

Signed-off-by: Steven Davies <btrfs@steev.me.uk>
---
  cmds-receive.c | 67 ++++++++++++++++++++++++++++++--------------------
  1 file changed, 40 insertions(+), 27 deletions(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index 3888149a..96411bac 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -52,7 +52,11 @@
  #include "send-dump.h"
  #include "help.h"

-static int g_verbose = 0;
+/*
+ * Default is 1 for historical reasons, changing may break scripts that 
expect
+ * the 'At subvol' message.
+ */
+static int g_verbose = 1;

  struct btrfs_receive
  {
@@ -111,7 +115,7 @@ static int finish_subvol(struct btrfs_receive *rctx)
         memcpy(rs_args.uuid, rctx->cur_subvol.received_uuid, 
BTRFS_UUID_SIZE);
         rs_args.stransid = rctx->cur_subvol.stransid;

-       if (g_verbose >= 1) {
+       if (g_verbose >= 2) {
                 uuid_unparse((u8*)rs_args.uuid, uuid_str);
                 fprintf(stderr, "BTRFS_IOC_SET_RECEIVED_SUBVOL uuid=%s, 
"
                                 "stransid=%llu\n", uuid_str, 
rs_args.stransid);
@@ -194,12 +198,14 @@ static int process_subvol(const char *path, const 
u8 *uuid, u64 ctransid,
                 goto out;
         }

-       fprintf(stderr, "At subvol %s\n", path);
+       if (g_verbose) {
+               fprintf(stdout, "At subvol %s\n", path);
+       }

         memcpy(rctx->cur_subvol.received_uuid, uuid, BTRFS_UUID_SIZE);
         rctx->cur_subvol.stransid = ctransid;

-       if (g_verbose) {
+       if (g_verbose >= 2) {
                 uuid_unparse((u8*)rctx->cur_subvol.received_uuid, 
uuid_str);
                 fprintf(stderr, "receiving subvol %s uuid=%s, 
stransid=%llu\n",
                                 path, uuid_str,
@@ -263,12 +269,14 @@ static int process_snapshot(const char *path, 
const u8 *uuid, u64 ctransid,
                 goto out;
         }

-       fprintf(stdout, "At snapshot %s\n", path);
+       if (g_verbose) {
+               fprintf(stderr, "At snapshot %s\n", path);
+       }

         memcpy(rctx->cur_subvol.received_uuid, uuid, BTRFS_UUID_SIZE);
         rctx->cur_subvol.stransid = ctransid;

-       if (g_verbose) {
+       if (g_verbose >= 2) {
                 uuid_unparse((u8*)rctx->cur_subvol.received_uuid, 
uuid_str);
                 fprintf(stderr, "receiving snapshot %s uuid=%s, "
                                 "ctransid=%llu ", path, uuid_str,
@@ -395,7 +403,7 @@ static int process_mkfile(const char *path, void 
*user)
                 goto out;
         }

-       if (g_verbose >= 2)
+       if (g_verbose >= 3)
                 fprintf(stderr, "mkfile %s\n", path);

         ret = creat(full_path, 0600);
@@ -423,7 +431,7 @@ static int process_mkdir(const char *path, void 
*user)
                 goto out;
         }

-       if (g_verbose >= 2)
+       if (g_verbose >= 3)
                 fprintf(stderr, "mkdir %s\n", path);

         ret = mkdir(full_path, 0700);
@@ -448,7 +456,7 @@ static int process_mknod(const char *path, u64 mode, 
u64 dev, void *user)
                 goto out;
         }

-       if (g_verbose >= 2)
+       if (g_verbose >= 3)
                 fprintf(stderr, "mknod %s mode=%llu, dev=%llu\n",
                                 path, mode, dev);

@@ -474,7 +482,7 @@ static int process_mkfifo(const char *path, void 
*user)
                 goto out;
         }

-       if (g_verbose >= 2)
+       if (g_verbose >= 3)
                 fprintf(stderr, "mkfifo %s\n", path);

         ret = mkfifo(full_path, 0600);
@@ -499,7 +507,7 @@ static int process_mksock(const char *path, void 
*user)
                 goto out;
         }

-       if (g_verbose >= 2)
+       if (g_verbose >= 3)
                 fprintf(stderr, "mksock %s\n", path);

         ret = mknod(full_path, 0600 | S_IFSOCK, 0);
@@ -524,7 +532,7 @@ static int process_symlink(const char *path, const 
char *lnk, void *user)
                 goto out;
         }

-       if (g_verbose >= 2)
+       if (g_verbose >= 3)
                 fprintf(stderr, "symlink %s -> %s\n", path, lnk);

         ret = symlink(lnk, full_path);
@@ -556,7 +564,7 @@ static int process_rename(const char *from, const 
char *to, void *user)
                 goto out;
         }

-       if (g_verbose >= 2)
+       if (g_verbose >= 3)
                 fprintf(stderr, "rename %s -> %s\n", from, to);

         ret = rename(full_from, full_to);
@@ -588,7 +596,7 @@ static int process_link(const char *path, const char 
*lnk, void *user)
                 goto out;
         }

-       if (g_verbose >= 2)
+       if (g_verbose >= 3)
                 fprintf(stderr, "link %s -> %s\n", path, lnk);

         ret = link(full_link_path, full_path);
@@ -614,7 +622,7 @@ static int process_unlink(const char *path, void 
*user)
                 goto out;
         }

-       if (g_verbose >= 2)
+       if (g_verbose >= 3)
                 fprintf(stderr, "unlink %s\n", path);

         ret = unlink(full_path);
@@ -639,7 +647,7 @@ static int process_rmdir(const char *path, void 
*user)
                 goto out;
         }

-       if (g_verbose >= 2)
+       if (g_verbose >= 3)
                 fprintf(stderr, "rmdir %s\n", path);

         ret = rmdir(full_path);
@@ -845,7 +853,7 @@ static int process_set_xattr(const char *path, const 
char *name,
         }

         if (strcmp("security.capability", name) == 0) {
-               if (g_verbose >= 3)
+               if (g_verbose >= 4)
                         fprintf(stderr, "set_xattr: cache 
capabilities\n");
                 if (rctx->cached_capabilities_len)
                         warning("capabilities set multiple times per 
file: %s",
@@ -860,7 +868,7 @@ static int process_set_xattr(const char *path, const 
char *name,
                 memcpy(rctx->cached_capabilities, data, len);
         }

-       if (g_verbose >= 2) {
+       if (g_verbose >= 3) {
                 fprintf(stderr, "set_xattr %s - name=%s data_len=%d "
                                 "data=%.*s\n", path, name, len,
                                 len, (char*)data);
@@ -890,7 +898,7 @@ static int process_remove_xattr(const char *path, 
const char *name, void *user)
                 goto out;
         }

-       if (g_verbose >= 2) {
+       if (g_verbose >= 3) {
                 fprintf(stderr, "remove_xattr %s - name=%s\n",
                                 path, name);
         }
@@ -918,7 +926,7 @@ static int process_truncate(const char *path, u64 
size, void *user)
                 goto out;
         }

-       if (g_verbose >= 2)
+       if (g_verbose >= 3)
                 fprintf(stderr, "truncate %s size=%llu\n", path, size);

         ret = truncate(full_path, size);
@@ -944,7 +952,7 @@ static int process_chmod(const char *path, u64 mode, 
void *user)
                 goto out;
         }

-       if (g_verbose >= 2)
+       if (g_verbose >= 3)
                 fprintf(stderr, "chmod %s - mode=0%o\n", path, 
(int)mode);

         ret = chmod(full_path, mode);
@@ -970,7 +978,7 @@ static int process_chown(const char *path, u64 uid, 
u64 gid, void *user)
                 goto out;
         }

-       if (g_verbose >= 2)
+       if (g_verbose >= 3)
                 fprintf(stderr, "chown %s - uid=%llu, gid=%llu\n", path,
                                 uid, gid);

@@ -982,7 +990,7 @@ static int process_chown(const char *path, u64 uid, 
u64 gid, void *user)
         }

         if (rctx->cached_capabilities_len) {
-               if (g_verbose >= 2)
+               if (g_verbose >= 3)
                         fprintf(stderr, "chown: restore 
capabilities\n");
                 ret = lsetxattr(full_path, "security.capability",
                                 rctx->cached_capabilities,
@@ -1016,7 +1024,7 @@ static int process_utimes(const char *path, struct 
timespec *at,
                 goto out;
         }

-       if (g_verbose >= 2)
+       if (g_verbose >= 3)
                 fprintf(stderr, "utimes %s\n", path);

         tv[0] = *at;
@@ -1035,7 +1043,7 @@ out:
  static int process_update_extent(const char *path, u64 offset, u64 len,
                 void *user)
  {
-       if (g_verbose >= 2)
+       if (g_verbose >= 3)
                 fprintf(stderr, "update_extent %s: offset=%llu, 
len=%llu\n",
                                 path, (unsigned long long)offset,
                                 (unsigned long long)len);
@@ -1175,7 +1183,7 @@ static int do_receive(struct btrfs_receive *rctx, 
const char *tomnt,

         while (!end) {
                 if (rctx->cached_capabilities_len) {
-                       if (g_verbose >= 3)
+                       if (g_verbose >= 4)
                                 fprintf(stderr, "clear cached 
capabilities\n");
                         memset(rctx->cached_capabilities, 0,
                                         
sizeof(rctx->cached_capabilities));
@@ -1262,10 +1270,11 @@ int cmd_receive(int argc, char **argv)
                         { "max-errors", required_argument, NULL, 'E' },
                         { "chroot", no_argument, NULL, 'C' },
                         { "dump", no_argument, NULL, GETOPT_VAL_DUMP },
+                        { "quiet", no_argument, NULL, 'q' },
                         { NULL, 0, NULL, 0 }
                 };

-               c = getopt_long(argc, argv, "Cevf:m:E:", long_opts, 
NULL);
+               c = getopt_long(argc, argv, "Cevqf:m:E:", long_opts, 
NULL);
                 if (c < 0)
                         break;

@@ -1273,6 +1282,9 @@ int cmd_receive(int argc, char **argv)
                 case 'v':
                         g_verbose++;
                         break;
+               case 'q':
+                       g_verbose = 0;
+                       break;
                 case 'f':
                         if (arg_copy_path(fromfile, optarg, 
sizeof(fromfile))) {
                                 error("input file path too long (%zu)",
@@ -1361,6 +1373,7 @@ const char * const cmd_receive_usage[] = {
         "read-only.",
         "",
         "-v               increase verbosity about performed actions",
+        "-q|--quiet       suppress all messages, except errors",
         "-f FILE          read the stream from FILE instead of stdin",
         "-e               terminate after receiving an <end cmd> marker 
in the stream.",
         "                 Without this option the receiver side 
terminates only in case",
--
2.19.2
