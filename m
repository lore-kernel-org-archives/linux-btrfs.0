Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33049 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbaIRInq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 04:43:46 -0400
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id D50083EE0BD
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 17:43:44 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 1D19DAC0806
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 17:43:44 +0900 (JST)
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id BC2911DB803F
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 17:43:43 +0900 (JST)
Received: from g01jpexchyt36.g01.fujitsu.local (unknown [10.128.193.4])
	by g01jpfmpwyt03.exch.g01.fujitsu.local (Postfix) with ESMTP id B6C0446E599
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 17:43:42 +0900 (JST)
Message-ID: <541A9B39.7040202@jp.fujitsu.com>
Date: Thu, 18 Sep 2014 17:43:37 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH 5/5] btrfs: rework compression related options processing
References: <541A9717.5000003@jp.fujitsu.com>
In-Reply-To: <541A9717.5000003@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Naohiro Aota <naota@elisp.net>

There are mutual exclusive mount options corresponding to
compression options. If we set these options at once, we get
improper messages and states, and a verbose message.

 * Improper states
  - We can't disable "compress forcing" with compress={zlib,lzo}
    mount option.

    ====
    # mount -o remount,compress-force=zlib,compress=lzo
    [58852.210209] BTRFS info (device vda2): force zlib compression
    (We should see "use lzo compression" here)
    # mount | grep btrfs
    /dev/vda2 on / type btrfs (rw,relatime,seclabel,compress-force=lzo,space_cache)
    (We should also change "compress-force=lzo" to "compress=lzo")
    ====

 * Improper messages
  - We don't see compression enabled message when we enables it
    after disabling it.

    ====
    # mount -o remount,compress=no,compress=zlib; dmesg -c
    [ 4077.130625] BTRFS info (device vda2): btrfs: use no compression
    (We should see "use zlib compression" here)
    ====

  - We don't see any message when we change compression type.

    ====
    # mount -o remount,compress=zlib,compress=lzo
    (Since "BTRFS info" is at the beginning of this message, "btrfs: " is verbose
     and we don't need it.)
    ====

  - We don't see datacow and/or datasum enabling message when we
    enable compression.

    ====
    # mount -o remount,nodatacow,nodatasum,compress
    [58913.704536] BTRFS info (device vda2): setting nodatacow
    (We should see "use zlib compression, setting datacow and datasum" here)
    ====

    ====
    # mount -o remount,nodatasum,compress
    [58950.529392] BTRFS info (device vda2): setting nodatasum
    (We should see "use zlib compression, setting datasum" here)
    ====

 * A verbose message
  - We see verbose "btrfs: " prefix on disabling compression.

    ====
    # mount -o remount,compress=zlib,compress=no
    [58790.727788] BTRFS info (device vda2): btrfs: use no compression
    ("btrfs: " is verbose here. We don't need it, since we already
    state this is btrfs with "BTRFS info")
    ====

This commit solves all these problems.

I separated the code in the following two parts:

  a) Parse the options.
  b) Set and clear flags of mount_opt and show proper messages.

I've confirmed that this patch doesn't cause any regression
by running the following script, which tests all combinations
of corresponding mount options (compress, compress-force,
datacow, and datasum).

=====================
#!/bin/bash

BTRFS_ROOT=/

states=(
  compress=zlib,datacow,datasum
  compress=lzo,datacow,datasum
  compress-force=zlib,datacow,datasum
  compress-force=lzo,datacow,datasum
  compress=no,nodatacow,nodatasum
  compress=no,datacow,nodatasum
  compress=no,datacow,datasum
)

options=(
  compress
  compress=zlib
  compress=lzo
  compress=no
  compress=badopt
  compress-force
  compress-force=zlib
  compress-force=lzo
  compress-force=no
  compress-force=badopt
  nodatacow
  datacow
  nodatasum
  datasum
)

for s in ${states[@]}; do
  for o in ${options[@]}; do
    # set initial state
    echo initial: mount -o remount,$s
    mount -o remount,$s ${BTRFS_ROOT}
    # mount with each option
    echo mount -o remount,$o
    dmesg -C
    mount -o remount,$o ${BTRFS_ROOT}
    echo dmesg:
    dmesg -t | perl -ne 'if(/^BTRFS info \(device .+?\): (.+)$/){print "\t$1\n"}'
    echo -n 'mount options: '
    grep -v rootfs /proc/mounts | \
      awk "{if(\$2==\"${BTRFS_ROOT}\"){print \$4}}" | \
      perl -ne '@a=split(/,/); for(@a){print "$_ " if(/^compress(-force)?=|nodata(cow|sum)$/)}'
    echo
    echo
  done
done
=====================

Signed-off-by: Naohiro Aota <naota@elisp.net>
Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
 fs/btrfs/super.c | 57 +++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 40 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 03131c5..83433e15 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -401,6 +401,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 	char *compress_type;
 	bool compress_force = false;
 	bool compress = false;
+	unsigned long old_compress_type;
 
 	cache_gen = btrfs_super_cache_generation(root->fs_info->super_copy);
 	if (cache_gen)
@@ -486,40 +487,62 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 		case Opt_compress:
 		case Opt_compress_type:
 			compress = true;
+			old_compress_type = info->compress_type;
 			if (token == Opt_compress ||
 			    token == Opt_compress_force ||
 			    strcmp(args[0].from, "zlib") == 0) {
 				compress_type = "zlib";
 				info->compress_type = BTRFS_COMPRESS_ZLIB;
-				btrfs_set_opt(info->mount_opt, COMPRESS);
-				btrfs_clear_opt(info->mount_opt, NODATACOW);
-				btrfs_clear_opt(info->mount_opt, NODATASUM);
 			} else if (strcmp(args[0].from, "lzo") == 0) {
 				compress_type = "lzo";
 				info->compress_type = BTRFS_COMPRESS_LZO;
-				btrfs_set_opt(info->mount_opt, COMPRESS);
-				btrfs_clear_opt(info->mount_opt, NODATACOW);
-				btrfs_clear_opt(info->mount_opt, NODATASUM);
 				btrfs_set_fs_incompat(info, COMPRESS_LZO);
 			} else if (strncmp(args[0].from, "no", 2) == 0) {
 				compress_type = "no";
-				btrfs_clear_opt(info->mount_opt, COMPRESS);
-				btrfs_clear_opt(info->mount_opt, FORCE_COMPRESS);
-				compress_force = false;
+				compress = compress_force = false;
 			} else {
 				ret = -EINVAL;
 				goto out;
 			}
 
-			if (compress_force) {
-				btrfs_set_and_info(root, FORCE_COMPRESS,
-						   "force %s compression",
-						   compress_type);
-			} else if (compress) {
-				if (!btrfs_test_opt(root, COMPRESS))
+			if (compress_force || compress) {
+				const char *method = "", *setting = "";
+
+				if ((info->compress_type != old_compress_type) ||
+				    (compress_force &&
+				     !btrfs_test_opt(root, FORCE_COMPRESS)) ||
+				    (!compress_force &&
+				     btrfs_test_opt(root, FORCE_COMPRESS)) ||
+				    (compress && !btrfs_test_opt(root, COMPRESS))) {
+					method = compress_force?"force":"use";
+				}
+
+				if (btrfs_test_opt(root, NODATACOW))
+					setting = ", setting datacow and datasum";
+				else if (btrfs_test_opt(root, NODATASUM))
+					setting = ", setting datasum";
+
+				if (strcmp(method, "") != 0) {
 					btrfs_info(root->fs_info,
-						   "btrfs: use %s compression",
-						   compress_type);
+						   "%s %s compression%s",
+						   method, compress_type,
+						   setting);
+				}
+				if (compress_force) {
+					btrfs_set_opt(info->mount_opt,
+						      FORCE_COMPRESS);
+				} else {
+					btrfs_clear_opt(info->mount_opt,
+							FORCE_COMPRESS);
+				}
+				btrfs_set_opt(info->mount_opt, COMPRESS);
+				btrfs_clear_opt(info->mount_opt, NODATACOW);
+				btrfs_clear_opt(info->mount_opt, NODATASUM);
+			} else {
+				btrfs_clear_and_info(root, COMPRESS,
+						     "use no compression");
+				btrfs_clear_opt(info->mount_opt,
+						FORCE_COMPRESS);
 			}
 			break;
 		case Opt_ssd:
-- 1.8.3.1 

