Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:59281 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751861AbdIRHV4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 03:21:56 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v3 07/14] btrfs-progs: Doc/mkfs: Add extra condition for rootdir option
Date: Mon, 18 Sep 2017 16:21:32 +0900
Message-Id: <20170918072139.6300-8-quwenruo.btrfs@gmx.com>
In-Reply-To: <20170918072139.6300-1-quwenruo.btrfs@gmx.com>
References: <20170918072139.6300-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add extra limitation explained for --rootdir option, including:
1) Size limitation
   Now I decide to follow "mkfs.ext4 -d" behavior, so user is
   responsible to make sure the block device/file is large enough.

2) Read permission
   If user can't read the content, mkfs will just fail.
   So user is also responsible to make sure to have enough privilege.

3) Extra warning about the behavior change
   Since we we don't shrink fs the create file image, add such warning
   in documentation.

Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 Documentation/mkfs.btrfs.asciidoc | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/mkfs.btrfs.asciidoc b/Documentation/mkfs.btrfs.asciidoc
index d53d9e26..645a2881 100644
--- a/Documentation/mkfs.btrfs.asciidoc
+++ b/Documentation/mkfs.btrfs.asciidoc
@@ -106,6 +106,19 @@ Please see the mount option 'discard' for that in `btrfs`(5).
 *-r|--rootdir <rootdir>*::
 Populate the toplevel subvolume with files from 'rootdir'.  This does not
 require root permissions and does not mount the filesystem.
++
+With this option, only one device can be specified.
++
+NOTE: User should make sure the block device/file has large enough space to
+contain the source directory and has enough previllege to read source directory.
+Or mkfs will just fail.
++
+WARNING: Before v4.14 btrfs-progs, *--rootdir* will shrink the filesystem,
+prevent user to make use of the remaining space.
+In v4.14 btrfs-progs, this behavior is changed, and will not shrink the fs.
+The result should be the same as `mkfs`, `mount` and then `cp -r`. +
+Also, if destination file/block device does not exist, *--rootdir* will not
+create the image file, to make it follow the normal mkfs behavior.
 
 *-O|--features <feature1>[,<feature2>...]*::
 A list of filesystem features turned on at mkfs time. Not all features are
-- 
2.14.1

