Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51205 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbbDUEZQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Apr 2015 00:25:16 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2] Btrfs-progs: fix typo in btrfs-device.txt
Date: Tue, 21 Apr 2015 15:12:03 +0800
Message-Id: <1429600323-5199-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1429525889-2843-1-git-send-email-anand.jain@oracle.com>
References: <1429525889-2843-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 v1->v2: Oh no. Typo while fixing typo. oops ! thanks Duncan.

 Documentation/btrfs-device.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/btrfs-device.txt b/Documentation/btrfs-device.txt
index 4bb5ea5..7807450 100644
--- a/Documentation/btrfs-device.txt
+++ b/Documentation/btrfs-device.txt
@@ -53,12 +53,12 @@ run `btrfs-balance`(8) to rebuild the chunks.
 See `btrfs-balance`(8) for more details.
 
 Device add/remove/replace::
-Device can be added/removed using `btrfs-replace`(8) subcommand and replaced
+Device can be added/removed using `btrfs-device`(8) subcommand and replaced
 using `btrfs-replace`(8).
 +
 When device is removed or replaced, btrfs will do the chunk rebuild if needed.
 +
-See `btrfs-replace`(8) and this man page for more details.
+See `btrfs-replace`(8) man page for more details on device replace.
 
 SUBCOMMAND
 ----------
-- 
2.0.0.153.g79dcccc

