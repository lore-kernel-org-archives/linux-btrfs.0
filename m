Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:55635 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750984AbdIKGg3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 02:36:29 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 7/7] btrfs-progs: Doc/mkfs: Add extra condition for rootdir option
Date: Mon, 11 Sep 2017 15:36:12 +0900
Message-Id: <20170911063612.32114-8-quwenruo.btrfs@gmx.com>
In-Reply-To: <20170911063612.32114-1-quwenruo.btrfs@gmx.com>
References: <20170911063612.32114-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add extra limitation explained for --rootdir option, including:
1) Size limitation
   Now I decide to follow "mkfs.ext4 -d" behavior, so we user is
   responsible to make sure the block device/file is large enough.

2) Read permission
   If user can't read the content, mkfs will just fail.
   So user is also responsible to make sure to have enough privilege.

3) Extra warning about the behavior change
   Since we we don't shrink fs the create file image, add such warning
   in documentation.

Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 Documentation/mkfs.btrfs.asciidoc | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/mkfs.btrfs.asciidoc b/Documentation/mkfs.btrfs.asciidoc
index d53d9e26..843e25cd 100644
--- a/Documentation/mkfs.btrfs.asciidoc
+++ b/Documentation/mkfs.btrfs.asciidoc
@@ -106,6 +106,17 @@ Please see the mount option 'discard' for that in `btrfs`(5).
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
+The result should be the same as `mkfs`, `mount` and then `cp -r`.
 
 *-O|--features <feature1>[,<feature2>...]*::
 A list of filesystem features turned on at mkfs time. Not all features are
-- 
2.14.1

