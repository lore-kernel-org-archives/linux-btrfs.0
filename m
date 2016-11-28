Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:47694 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751438AbcK1Swv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Nov 2016 13:52:51 -0500
From: Adam Borowski <kilobyte@angband.pl>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: Adam Borowski <kilobyte@angband.pl>
Date: Mon, 28 Nov 2016 19:52:43 +0100
Message-Id: <20161128185243.15013-1-kilobyte@angband.pl>
Subject: [PATCH] btrfs-progs: man mkfs: warn about RAID5/6 being experimental
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 Documentation/mkfs.btrfs.asciidoc | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/mkfs.btrfs.asciidoc b/Documentation/mkfs.btrfs.asciidoc
index 9b1d45a..c92d730 100644
--- a/Documentation/mkfs.btrfs.asciidoc
+++ b/Documentation/mkfs.btrfs.asciidoc
@@ -164,6 +164,9 @@ root partition created with RAID1/10/5/6 profiles. The mount action can happen
 before all block devices are discovered. The waiting is usually done on the
 initramfs/initrd systems.
 
+As of kernel 4.9, RAID5/6 is still considered experimental and shouldn't be
+employed for production use.
+
 FILESYSTEM FEATURES
 -------------------
 
-- 
2.10.2

