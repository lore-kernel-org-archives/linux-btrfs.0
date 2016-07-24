Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-31.italiaonline.it ([212.48.25.159]:50804 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752175AbcGXLDg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Jul 2016 07:03:36 -0400
From: Goffredo Baroncelli <kreijack@libero.it>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Chris Mason <clm@fb.com>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 4/5] Add man page for command btrfs insp physical-find
Date: Sun, 24 Jul 2016 13:03:28 +0200
Message-Id: <1469358209-9427-5-git-send-email-kreijack@libero.it>
In-Reply-To: <1469358209-9427-1-git-send-email-kreijack@libero.it>
References: <1469358209-9427-1-git-send-email-kreijack@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 Documentation/btrfs-inspect-internal.asciidoc | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/btrfs-inspect-internal.asciidoc b/Documentation/btrfs-inspect-internal.asciidoc
index 74f6dea..35e2237 100644
--- a/Documentation/btrfs-inspect-internal.asciidoc
+++ b/Documentation/btrfs-inspect-internal.asciidoc
@@ -146,6 +146,11 @@ Print sizes and statistics of trees.
 -b::::
 Print raw numbers in bytes.
 
+*physical-find* <path> [<off>]::
+(needs root privileges)
++
+Show the placement of a given file (at offset 'off', default 0) on the disks.
+
 EXIT STATUS
 -----------
 *btrfs inspect-internal* returns a zero exit status if it succeeds. Non zero is
-- 
2.8.1

