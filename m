Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:51396 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbaFWJ2Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jun 2014 05:28:16 -0400
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
        Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] generic/017: skip invalid block sizes for btrfs
Date: Mon, 23 Jun 2014 11:28:00 +0100
Message-Id: <1403519280-24216-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs the block size (called sector size in btrfs) can not be
smaller then the page size. Therefore skip block sizes smaller
then page size if the fs is btrfs, so that the test can succeed
on btrfs (testing only with block sizes of 4kb on systems with a
page size of 4Kb).

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 tests/generic/017 | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tests/generic/017 b/tests/generic/017
index 13b7254..6495be5 100755
--- a/tests/generic/017
+++ b/tests/generic/017
@@ -51,6 +51,14 @@ BLOCKS=10240
 
 for (( BSIZE = 1024; BSIZE <= 4096; BSIZE *= 2 )); do
 
+	# btrfs doesn't support block size smaller then page size
+	if [ "$FSTYP" == "btrfs" ]; then
+		if (( $BSIZE < `getconf PAGE_SIZE` )); then
+			echo "80"
+			continue
+		fi
+	fi
+
 	length=$(($BLOCKS * $BSIZE))
 	case $FSTYP in
 	xfs)
-- 
1.9.1

