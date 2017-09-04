Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:51864 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753258AbdIDGlZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Sep 2017 02:41:25 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 5/5] btrfs-progs: Doc/mkfs: Add explanation for rootdir parameter
Date: Mon,  4 Sep 2017 15:41:10 +0900
Message-Id: <20170904064110.25951-6-quwenruo.btrfs@gmx.com>
In-Reply-To: <20170904064110.25951-1-quwenruo.btrfs@gmx.com>
References: <20170904064110.25951-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Original --rootdir parameter will shrink the filesystem to its minimal
size, which is quite confusing for some users.

Add extra note for this behavior.

Reported-by: Goffredo Baroncelli <kreijack@libero.it>
Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 Documentation/mkfs.btrfs.asciidoc | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/mkfs.btrfs.asciidoc b/Documentation/mkfs.btrfs.asciidoc
index d53d9e26..8977761f 100644
--- a/Documentation/mkfs.btrfs.asciidoc
+++ b/Documentation/mkfs.btrfs.asciidoc
@@ -106,6 +106,9 @@ Please see the mount option 'discard' for that in `btrfs`(5).
 *-r|--rootdir <rootdir>*::
 Populate the toplevel subvolume with files from 'rootdir'.  This does not
 require root permissions and does not mount the filesystem.
++
+NOTE: Result btrfs will be shrink to it minimal size, exceeding space will not
+be accessible unless resized.
 
 *-O|--features <feature1>[,<feature2>...]*::
 A list of filesystem features turned on at mkfs time. Not all features are
-- 
2.14.1

