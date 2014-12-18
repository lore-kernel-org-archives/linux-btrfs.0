Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40373 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbaLRO17 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Dec 2014 09:27:59 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 18130AD69
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Dec 2014 14:27:58 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 5/6] btrfs-progs: dev usage, update manpage
Date: Thu, 18 Dec 2014 15:27:57 +0100
Message-Id: <50662b31002a19ca0aad200d2317f5ee832c4fc5.1418912740.git.dsterba@suse.cz>
In-Reply-To: <cover.1418912740.git.dsterba@suse.cz>
References: <cover.1418912740.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 Documentation/btrfs-device.txt | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/Documentation/btrfs-device.txt b/Documentation/btrfs-device.txt
index 46c54b94413c..4cd633fe6c03 100644
--- a/Documentation/btrfs-device.txt
+++ b/Documentation/btrfs-device.txt
@@ -98,6 +98,32 @@ identified by <path> or for a single <device>.
 -z::::
 Reset stats to zero after reading them.
 
+*usage* [options] <path> [<path>...]::
+Show detailed information about internal allocations in devices.
++
+`Options`
++
+-b|--raw::::
+raw numbers in bytes, without the 'B' suffix
+-h::::
+print human friendly numbers, base 1024, this is the default
+-H::::
+print human friendly numbers, base 1000
+--iec::::
+select the 1024 base for the following options, according to the IEC standard
+--si::::
+select the 1000 base for the following options, according to the SI standard
+-k|--kbytes::::
+show sizes in KiB, or kB with --si
+-m|--mbytes::::
+show sizes in MiB, or MB with --si
+-g|--gbytes::::
+show sizes in GiB, or GB with --si
+-t|--tbytes::::
+show sizes in TiB, or TB with --si
+
+If conflicting options are passed, the last one takes precedence.
+
 EXIT STATUS
 -----------
 *btrfs device* returns a zero exit status if it succeeds. Non zero is
-- 
2.1.3

