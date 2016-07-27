Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-31-i2.italiaonline.it ([212.48.25.200]:42083 "EHLO
	libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757452AbcG0Rne (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jul 2016 13:43:34 -0400
From: Goffredo Baroncelli <kreijack@libero.it>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Chris Mason <clm@fb.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 5/5] Add new command to man pages: btrfs insp physical-dump
Date: Wed, 27 Jul 2016 19:43:18 +0200
Message-Id: <1469641398-3879-6-git-send-email-kreijack@libero.it>
In-Reply-To: <1469641398-3879-1-git-send-email-kreijack@libero.it>
References: <1469641398-3879-1-git-send-email-kreijack@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 Documentation/btrfs-inspect-internal.asciidoc | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/btrfs-inspect-internal.asciidoc b/Documentation/btrfs-inspect-internal.asciidoc
index c132a0e..569681d 100644
--- a/Documentation/btrfs-inspect-internal.asciidoc
+++ b/Documentation/btrfs-inspect-internal.asciidoc
@@ -153,6 +153,18 @@ Show the placement of a given file (at offset 'off', default 0) on the disks.
 If 'logical' is given, this command shows the palcement of a logical address
 on the disks.
 
+*physical-dump* [-c <copynr>|-s <stripenr>|-p <paritynr>] <path> [<off>|-l <logical>]::
+(needs root privileges)
++
+Dump the disk content of a given file (at offset 'off', default 0). If 'logical'
+is passed, it is dumped the content of the given logical address.
+For RAID1/RAID10/DUP 'copynr', select which copy will be dumped. For
+RAID5/RAID6, 'paritynr' specifies which parity will be dumped. For
+RAID5/RAID6, 'stripenr' specifies which stripe elemnt will be dumped.
++
+'off' and 'logical' must be a multiple of 4096. 4096 bytes are dumped, even if
+the file is shorter.
+
 EXIT STATUS
 -----------
 *btrfs inspect-internal* returns a zero exit status if it succeeds. Non zero is
-- 
2.8.1

