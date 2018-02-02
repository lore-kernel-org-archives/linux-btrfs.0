Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:8752 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751886AbeBBI2L (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Feb 2018 03:28:11 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id BA1A149F19BA
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Feb 2018 16:28:05 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 10/10] btrfs-progs: undelete-subvol: update completion and documentation
Date: Fri, 2 Feb 2018 16:27:51 +0800
Message-ID: <20180202082751.26225-11-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180202082751.26225-1-lufq.fnst@cn.fujitsu.com>
References: <20180202082751.26225-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add undelete-subvol to btrfs-completion, and update btrfs-rescue
documentation to introduce undelete-subvol.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 Documentation/btrfs-rescue.asciidoc | 6 ++++++
 btrfs-completion                    | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-rescue.asciidoc b/Documentation/btrfs-rescue.asciidoc
index 743a23a64287..9c6fbd82ef2d 100644
--- a/Documentation/btrfs-rescue.asciidoc
+++ b/Documentation/btrfs-rescue.asciidoc
@@ -60,6 +60,12 @@ assume an answer of 'yes' to all questions.
 -v::::
 verbose mode.
 
+*undelete-subvol* <device>::
+Undelete all deleted subvolumes that still left intact on the device.
++
+This command will create the lost+found directory, and recover all the
+subvolumes to this directory with the name "sub<id>".
+
 *zero-log* <device>::
 clear the filesystem log tree
 +
diff --git a/btrfs-completion b/btrfs-completion
index ae683f4ecf61..859595155a4b 100644
--- a/btrfs-completion
+++ b/btrfs-completion
@@ -35,7 +35,7 @@ _btrfs()
 	commands_balance='start pause cancel resume status'
 	commands_device='scan add delete remove ready stats usage'
 	commands_scrub='start cancel resume status'
-	commands_rescue='chunk-recover super-recover zero-log'
+	commands_rescue='chunk-recover super-recover undelete-subvol zero-log'
 	commands_inspect_internal='inode-resolve logical-resolve subvolid-resolve rootid min-dev-size dump-tree dump-super tree-stats'
 	commands_property='get set list'
 	commands_quota='enable disable rescan'
-- 
2.16.1



