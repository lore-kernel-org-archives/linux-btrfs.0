Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-31-i2.italiaonline.it ([212.48.25.200]:54285 "EHLO
	libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752182AbcGXLDg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Jul 2016 07:03:36 -0400
From: Goffredo Baroncelli <kreijack@libero.it>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Chris Mason <clm@fb.com>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 5/5] Add new command to man pages: btrfs insp physical-dump
Date: Sun, 24 Jul 2016 13:03:29 +0200
Message-Id: <1469358209-9427-6-git-send-email-kreijack@libero.it>
In-Reply-To: <1469358209-9427-1-git-send-email-kreijack@libero.it>
References: <1469358209-9427-1-git-send-email-kreijack@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 Documentation/btrfs-inspect-internal.asciidoc | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/btrfs-inspect-internal.asciidoc b/Documentation/btrfs-inspect-internal.asciidoc
index 35e2237..0497d08 100644
--- a/Documentation/btrfs-inspect-internal.asciidoc
+++ b/Documentation/btrfs-inspect-internal.asciidoc
@@ -151,6 +151,17 @@ Print raw numbers in bytes.
 +
 Show the placement of a given file (at offset 'off', default 0) on the disks.
 
+*physical-dump* [-c <copynr>|-s <stripenr>|-p <paritynr>] <path> [<off>]::
+(needs root privileges)
++
+Dump the disk content of a given file (at offset 'off', default 0).
+For RAID1/RAID10/DUP 'copynr', select which copy will be dumped. For
+RAID5/RAID6, 'paritynr' specifies which parity will be dumped. For
+RAID5/RAID6, 'stripenr' specifies which stripe elemnt will be dumped.
++
+'off' must be a multiple of 4096. 4096 bytes are dumped, even if the file
+is shorter.
+
 EXIT STATUS
 -----------
 *btrfs inspect-internal* returns a zero exit status if it succeeds. Non zero is
-- 
2.8.1

