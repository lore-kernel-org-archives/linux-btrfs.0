Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-31.italiaonline.it ([212.48.25.159]:52035 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756658AbcG0Rne (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jul 2016 13:43:34 -0400
From: Goffredo Baroncelli <kreijack@libero.it>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Chris Mason <clm@fb.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 4/5] Add man page for command btrfs insp physical-find
Date: Wed, 27 Jul 2016 19:43:17 +0200
Message-Id: <1469641398-3879-5-git-send-email-kreijack@libero.it>
In-Reply-To: <1469641398-3879-1-git-send-email-kreijack@libero.it>
References: <1469641398-3879-1-git-send-email-kreijack@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 Documentation/btrfs-inspect-internal.asciidoc | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/btrfs-inspect-internal.asciidoc b/Documentation/btrfs-inspect-internal.asciidoc
index 74f6dea..c132a0e 100644
--- a/Documentation/btrfs-inspect-internal.asciidoc
+++ b/Documentation/btrfs-inspect-internal.asciidoc
@@ -146,6 +146,13 @@ Print sizes and statistics of trees.
 -b::::
 Print raw numbers in bytes.
 
+*physical-find* <path> [<off>|-l <logical>]::
+(needs root privileges)
++
+Show the placement of a given file (at offset 'off', default 0) on the disks.
+If 'logical' is given, this command shows the palcement of a logical address
+on the disks.
+
 EXIT STATUS
 -----------
 *btrfs inspect-internal* returns a zero exit status if it succeeds. Non zero is
-- 
2.8.1

