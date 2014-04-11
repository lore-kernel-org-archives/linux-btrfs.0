Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57198 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754560AbaDKCnC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Apr 2014 22:43:02 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Marc MERLIN <marc@merlins.org>
Subject: [PATCH 2/2] btrfs-progs: Add explain on btrfs-zero-log.
Date: Fri, 11 Apr 2014 10:43:53 +0800
Message-ID: <1397184233-18535-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1397184233-18535-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1397184233-18535-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add more explain on btrfs-zero-log about when to use it.

Cc: Marc MERLIN <marc@merlins.org>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfs-zero-log.txt | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/Documentation/btrfs-zero-log.txt b/Documentation/btrfs-zero-log.txt
index e3041fa..a8e4dd3 100644
--- a/Documentation/btrfs-zero-log.txt
+++ b/Documentation/btrfs-zero-log.txt
@@ -17,6 +17,24 @@ allow you to mount the filesystem again.
 The common case where this happens has been fixed a long time ago,
 so it is unlikely that you will see this particular problem.
 
+One can determine whether 'btrfs-zero-log' is needed according to the kernel
+backtrace:
+----
+? replay_one_dir_item+0xb5/0xb5 [btrfs]
+? walk_log_tree+0x9c/0x19d [btrfs]
+? btrfs_read_fs_root_no_radix+0x169/0x1a1 [btrfs]
+? btrfs_recover_log_trees+0x195/0x29c [btrfs]
+? replay_one_dir_item+0xb5/0xb5 [btrfs]
+? btree_read_extent_buffer_pages+0x76/0xbc [btrfs]
+? open_ctree+0xff6/0x132c [btrfs]
+----
+
+If the errors are like above, then 'btrfs-zero-log' should be used to clear
+the log and the filesystem may be mounted normally again.
+
+NOTE: If you use btrfs as the root filesystem, you may want to include
+'btrfs-zero-log' into initramdisk if the log problems hits you often.
+
 EXIT STATUS
 -----------
 'btrfs-zero-log' will return 0 if no error happened.
-- 
1.9.2

