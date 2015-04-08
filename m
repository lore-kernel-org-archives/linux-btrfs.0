Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:34925 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498AbbDHOuF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Apr 2015 10:50:05 -0400
Received: by iggg4 with SMTP id g4so41428041igg.0
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Apr 2015 07:50:04 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 8 Apr 2015 15:50:04 +0100
Message-ID: <CALOYprWfYKJG-9d=J9WLEisWLcpcKwv4bPwfcjggw-EC4phbGA@mail.gmail.com>
Subject: [PATCH] btrfs-progs: use local btrfs-image in leaf corruption test
From: WorMzy Tykashi <wormzy.tykashi@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently this test uses the system btrfs-image. If there isn't a
btrfs-image on $PATH, the test fails. The test should be using the
locally compiled btrfs-image, not the system one.
---

diff --git a/tests/fsck-tests/012-leaf-corruption/test.sh
b/tests/fsck-tests/012-leaf-corruption/test.sh
index 4db4710..98e3185 100755
--- a/tests/fsck-tests/012-leaf-corruption/test.sh
+++ b/tests/fsck-tests/012-leaf-corruption/test.sh
@@ -37,7 +37,7 @@ generate_leaf_corrupt_no_data_ext()
     echo "generating leaf_corrupt_no_data_ext.btrfs-image" >> $RESULTS
     tar xJf ./no_data_extent.tar.xz || \
         _fail "failed to extract leaf_corrupt_no_data_ext.btrfs-image"
-    btrfs-image -r test.img.btrfs-image $dest || \
+    $TOP/btrfs-image -r test.img.btrfs-image $dest || \
         _fail "failed to extract leaf_corrupt_no_data_ext.btrfs-image"

     # leaf at 20832256 contains no regular data extent, clear its csum to
