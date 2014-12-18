Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40368 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbaLRO1w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Dec 2014 09:27:52 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 53DE6AD2F
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Dec 2014 14:27:51 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 3/6] btrfs-progs: fi usage, update manpage
Date: Thu, 18 Dec 2014 15:27:50 +0100
Message-Id: <488c53a0e5e255f9504cfc2a029e7c1c72994f66.1418912740.git.dsterba@suse.cz>
In-Reply-To: <cover.1418912740.git.dsterba@suse.cz>
References: <cover.1418912740.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 Documentation/btrfs-filesystem.txt | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/Documentation/btrfs-filesystem.txt b/Documentation/btrfs-filesystem.txt
index a8f2972a0e1a..85a94eb52569 100644
--- a/Documentation/btrfs-filesystem.txt
+++ b/Documentation/btrfs-filesystem.txt
@@ -123,6 +123,34 @@ Show or update the label of a filesystem.
 If a newlabel optional argument is passed, the label is changed.
 NOTE: the maximum allowable length shall be less than 256 chars
 
+*usage* [options] <path> [<path>...]::
+Show detailed information about internal filesystem usage.
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
+-T::::
+show data in tabular format
+
+If conflicting options are passed, the last one takes precedence.
+
 EXIT STATUS
 -----------
 *btrfs filesystem* returns a zero exit status if it succeeds. Non zero is
-- 
2.1.3

