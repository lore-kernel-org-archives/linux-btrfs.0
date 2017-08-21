Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:58912 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751050AbdHUG5N (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 02:57:13 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs-progs: Doc: Fix asciidoc grammar of btrfs-rescue
Date: Mon, 21 Aug 2017 15:57:04 +0900
Message-Id: <20170821065704.12119-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Code block of kernel backtrace lacks leading change line, causing the
following man page result:
------
           One can determine whether zero-log is needed according to the
           kernel backtrace:

           ? replay_one_dir_item+0xb5/0xb5 [btrfs]
           ? walk_log_tree+0x9c/0x19d [btrfs]
           ? btrfs_read_fs_root_no_radix+0x169/0x1a1 [btrfs]
           ? btrfs_recover_log_trees+0x195/0x29c [btrfs]
           ? replay_one_dir_item+0xb5/0xb5 [btrfs]
           ? btree_read_extent_buffer_pages+0x76/0xbc [btrfs]
           ? open_ctree+0xff6/0x132c [btrfs]

       + If the errors are like above, then zero-log should be used to clear
       the log and the filesystem may be mounted normally again. The keywords
------

Not only "+" is rendered as is, but also wrong indent.

Fix it by adding change line before code block.

Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 Documentation/btrfs-rescue.asciidoc | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/btrfs-rescue.asciidoc b/Documentation/btrfs-rescue.asciidoc
index a9b471fe..24b619c6 100644
--- a/Documentation/btrfs-rescue.asciidoc
+++ b/Documentation/btrfs-rescue.asciidoc
@@ -57,6 +57,7 @@ or less if the commit was implied by other filesystem activity.
 +
 One can determine whether *zero-log* is needed according to the kernel
 backtrace:
++
 ----
 ? replay_one_dir_item+0xb5/0xb5 [btrfs]
 ? walk_log_tree+0x9c/0x19d [btrfs]
-- 
2.14.1

