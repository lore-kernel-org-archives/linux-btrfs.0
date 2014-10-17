Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49233 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbaJQQfu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Oct 2014 12:35:50 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 34D50AAF3
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Oct 2014 16:35:49 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: run fsck image tests in filename order
Date: Fri, 17 Oct 2014 18:35:48 +0200
Message-Id: <1413563748-19925-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---

Based on "Btrfs-progs: check, ability to detect and fix outdated snapshot root items"

 tests/fsck-tests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/fsck-tests.sh b/tests/fsck-tests.sh
index 3f04626eda8c..8987d0442a6b 100644
--- a/tests/fsck-tests.sh
+++ b/tests/fsck-tests.sh
@@ -32,7 +32,7 @@ run_check make btrfs-corrupt-block
 # image (the backing file of a loop device, as a sparse file). The reason for
 # keeping some as tarballs of raw images is that for these cases btrfs-image
 # isn't able to preserve all the (bad) filesystem structure for some reason.
-for i in $(find $here/tests/fsck-tests -name '*.img' -o -name '*.tar.xz')
+for i in $(find $here/tests/fsck-tests -name '*.img' -o -name '*.tar.xz' | sort)
 do
 	echo "     [TEST]    $(basename $i)"
 	echo "testing image $i" >> $RESULT
-- 
2.1.1

