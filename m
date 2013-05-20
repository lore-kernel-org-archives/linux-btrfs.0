Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:58272 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755796Ab3ETM7c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 May 2013 08:59:32 -0400
Received: from [192.168.226.189] ([77.119.226.254]) by smtp.web.de (mrweb001)
 with ESMTPSA (Nemesis) id 0LnSKE-1TzGuK0TLK-00h8N0 for
 <linux-btrfs@vger.kernel.org>; Mon, 20 May 2013 14:59:30 +0200
Message-ID: <519A1E2F.5050207@web.de>
Date: Mon, 20 May 2013 14:59:27 +0200
From: Holger Fischer <hoo.mb@web.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs-tools: debian/patches/02-ftbfs.patch
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear BTRFS-Community,

as far as I understand I believe it would make sense to apply that one upstream:

like described, it ...  Fixes FTBFS on alpha and ia64 ...

 >cat 02-ftbfs.patch
Authors:
  Luca Bruno <lucab@debian.org>
  Alexander Kurtz <kurtz.alex@googlemail.com>
  Daniel Baumann <daniel.baumann@progress-technologies.net>
Description:
  Patch to properly cast and avoiding compiler warnings. Fixes FTBFS on alpha
  and ia64 (Closes: #539433, #583768).

Index: b/convert.c
===================================================================
--- a/convert.c
+++ b/convert.c
@@ -2512,7 +2512,7 @@ int do_rollback(const char *devname, int
         ext2_root = btrfs_read_fs_root(root->fs_info, &key);
         if (!ext2_root || IS_ERR(ext2_root)) {
                 fprintf(stderr, "unable to open subvol %llu\n",
-                       key.objectid);
+                       (unsigned long long) key.objectid);
                 goto fail;
         }


The file convert.c was renamed recently to btrfs-convert.c.
The fprintf in the do_rollback-function doesn't contain the mentioned fix.

Best Regards
Holger Fischer
