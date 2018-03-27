Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:32429 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752066AbeC0HHT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 03:07:19 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id B909148AE780
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 15:07:12 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 10/10] btrfs-progs: undelete-subvol: update completion and documentation
Date: Tue, 27 Mar 2018 15:06:58 +0800
Message-ID: <20180327070658.13064-11-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
References: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add undelete-subvol to btrfs-completion, and update btrfs-rescue
documentation to introduce undelete-subvol.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
v2: just add -s option documentation.

 Documentation/btrfs-rescue.asciidoc | 12 ++++++++++++
 btrfs-completion                    |  2 +-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-rescue.asciidoc b/Documentation/btrfs-rescue.asciidoc
index f94a0ff2b45e..573a865b1158 100644
--- a/Documentation/btrfs-rescue.asciidoc
+++ b/Documentation/btrfs-rescue.asciidoc
@@ -60,6 +60,18 @@ assume an answer of 'yes' to all questions.
 -v::::
 verbose mode.
 
+*undelete-subvol* <device>::
+Undelete deleted subvolumes that still left intact on the device.
++
+This command will create the lost+found directory, and recover all the
+subvolumes to this directory with the name "sub<id>". If -s <subvolid> option
+is given, then just recover the subvolume which specified by <subvolid>.
++
+`Options`
++
+-s::::
+specify the subvolume which will be recovered.
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
2.16.2



