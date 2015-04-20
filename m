Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48813 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbbDTIV6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 04:21:58 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] Btrfs-progs: fix typo in btrfs-device.txt
Date: Mon, 20 Apr 2015 18:31:29 +0800
Message-Id: <1429525889-2843-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 Documentation/btrfs-device.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/btrfs-device.txt b/Documentation/btrfs-device.txt
index 4bb5ea5..0bc1be3 100644
--- a/Documentation/btrfs-device.txt
+++ b/Documentation/btrfs-device.txt
@@ -53,7 +53,7 @@ run `btrfs-balance`(8) to rebuild the chunks.
 See `btrfs-balance`(8) for more details.
 
 Device add/remove/replace::
-Device can be added/removed using `btrfs-replace`(8) subcommand and replaced
+Device can be added/removed using `btrfs-delete`(8) subcommand and replaced
 using `btrfs-replace`(8).
 +
 When device is removed or replaced, btrfs will do the chunk rebuild if needed.
-- 
2.0.0.153.g79dcccc

