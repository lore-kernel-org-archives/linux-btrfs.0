Return-Path: <SRS0=zIgm=QV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A61AC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Feb 2019 15:17:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5ABAA222D7
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Feb 2019 15:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550157447;
	bh=97nTdyDm27SzkLYtCpPUcLWRq1Fj5T5xRAPsRj7srXc=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=H4cM5tBBkujwddWowXteROobtcPjy+/Vmphq9ZNI6++AYM0ulYLkryOsGY2TYS0RH
	 /y4m7yOEhqWg1jctsc1lZX8wLWQNBWrOrnHfVCriSW8showZdsfs0sEuqk45dg/zdG
	 oYotU8kj2J5DU9Ii8L1S+CksaBFXHQ2u0jgg8658=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405022AbfBNPR0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Feb 2019 10:17:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:50334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393538AbfBNPR0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Feb 2019 10:17:26 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44B73222C9;
        Thu, 14 Feb 2019 15:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550157444;
        bh=97nTdyDm27SzkLYtCpPUcLWRq1Fj5T5xRAPsRj7srXc=;
        h=From:To:Cc:Subject:Date:From;
        b=MtEVwzhaZdxg6Zb/rwaJMIBFh8UFZWRJAHlT+AlDwuKnYxXhjufiVD2x4fG+4N5qG
         Hp5SqPvHlmWkHsQMgD4mCVhG0RrDVnAVkC34dF4DDtkJJ8VsrXFe2Mj+df0MPeXhkR
         tQLJZzN3vXA0aONvBpKTHd3Q8FB51KF4b7nQN9cI=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Cc:     ce3g8jdj@umail.furryterror.org
Subject: [PATCH] Btrfs: fix corruption reading shared and compressed extents after hole punching
Date:   Thu, 14 Feb 2019 15:17:20 +0000
Message-Id: <20190214151720.23563-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

In the past we had data corruption when reading compressed extents that
are shared within the same file and they are consecutive, this got fixed
by commit 005efedf2c7d0 ("Btrfs: fix read corruption of compressed and
shared extents") and by commit 808f80b46790f ("Btrfs: update fix for read
corruption of compressed and shared extents"). However there was a case
that was missing in those fixes, which is when the shared and compressed
extents are referenced with a non-zero offset. The following shell script
creates a reproducer for this issue:

  #!/bin/bash

  mkfs.btrfs -f /dev/sdc &> /dev/null
  mount -o compress /dev/sdc /mnt/sdc

  # Create a file with 3 consecutive compressed extents, each has an
  # uncompressed size of 128Kb and a compressed size of 4Kb.
  for ((i = 1; i <= 3; i++)); do
      head -c 4096 /dev/zero
      for ((j = 1; j <= 31; j++)); do
          head -c 4096 /dev/zero | tr '\0' "\377"
      done
  done > /mnt/sdc/foobar
  sync

  echo "Digest after file creation:   $(md5sum /mnt/sdc/foobar)"

  # Clone the first extent into offsets 128K and 256K.
  xfs_io -c "reflink /mnt/sdc/foobar 0 128K 128K" /mnt/sdc/foobar
  xfs_io -c "reflink /mnt/sdc/foobar 0 256K 128K" /mnt/sdc/foobar
  sync

  echo "Digest after cloning:         $(md5sum /mnt/sdc/foobar)"

  # Punch holes into the regions that are already full of zeroes.
  xfs_io -c "fpunch 0 4K" /mnt/sdc/foobar
  xfs_io -c "fpunch 128K 4K" /mnt/sdc/foobar
  xfs_io -c "fpunch 256K 4K" /mnt/sdc/foobar
  sync

  echo "Digest after hole punching:   $(md5sum /mnt/sdc/foobar)"

  echo "Dropping page cache..."
  sysctl -q vm.drop_caches=1
  echo "Digest after hole punching:   $(md5sum /mnt/sdc/foobar)"

  umount /dev/sdc

When running the script we get the following output:

  Digest after file creation:   5a0888d80d7ab1fd31c229f83a3bbcc8  /mnt/sdc/foobar
  linked 131072/131072 bytes at offset 131072
  128 KiB, 1 ops; 0.0033 sec (36.960 MiB/sec and 295.6830 ops/sec)
  linked 131072/131072 bytes at offset 262144
  128 KiB, 1 ops; 0.0015 sec (78.567 MiB/sec and 628.5355 ops/sec)
  Digest after cloning:         5a0888d80d7ab1fd31c229f83a3bbcc8  /mnt/sdc/foobar
  Digest after hole punching:   5a0888d80d7ab1fd31c229f83a3bbcc8  /mnt/sdc/foobar
  Dropping page cache...
  Digest after hole punching:   fba694ae8664ed0c2e9ff8937e7f1484  /mnt/sdc/foobar

This happens because after reading all the pages of the extent in the
range from 128K to 256K for example, we read the hole at offset 256K
and then when reading the page at offset 260K we don't submit the
existing bio, which is responsible for filling all the page in the
range 128K to 256K only, therefore adding the pages from range 260K
to 384K to the existing bio and submitting it after iterating over the
entire range. Once the bio completes, the uncompressed data fills only
the pages in the range 128K to 256K because there's no more data read
from disk, leaving the pages in the range 260K to 384K unfilled. It is
just a slightly different variant of what was solved by commit
005efedf2c7d0 ("Btrfs: fix read corruption of compressed and shared
extents").

Fix this by forcing a bio submit, during readpages(), whenever we find a
compressed extent map for a page that is different from the extent map
for the previous page or has a different starting offset (in case it's
the same compressed extent), instead of the extent map's original start
offset.

A test case for fstests follows soon.

Reported-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Tested-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: stable@vger.kernel.org # 4.3+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent_io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 52abe4082680..1bfb7207bbf0 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2985,11 +2985,11 @@ static int __do_readpage(struct extent_io_tree *tree,
 		 */
 		if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags) &&
 		    prev_em_start && *prev_em_start != (u64)-1 &&
-		    *prev_em_start != em->orig_start)
+		    *prev_em_start != em->start)
 			force_bio_submit = true;
 
 		if (prev_em_start)
-			*prev_em_start = em->orig_start;
+			*prev_em_start = em->start;
 
 		free_extent_map(em);
 		em = NULL;
-- 
2.11.0

