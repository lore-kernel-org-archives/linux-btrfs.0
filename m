Return-Path: <SRS0=xnYl=RX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63BC7C4360F
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 06:37:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CAF42184E
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 06:37:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbfCTGhW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Mar 2019 02:37:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:40832 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727143AbfCTGhV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Mar 2019 02:37:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A5C67AC69
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Mar 2019 06:37:20 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCh v2 0/9] btrfs: tree-checker: More enhancement for fuzzed
Date:   Wed, 20 Mar 2019 14:37:08 +0800
Message-Id: <20190320063717.31770-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patchset can be fetched from github:
It can be fetched from github:
https://github.com/adam900710/linux/tree/tree_checker_enhancement
Which is based on my previous write time tree checker patchset (based on
v5.1-rc1 tag)

Thanks for the report from Yoon Jungyeon <jungyeon@gatech.edu>, we have
more fuzzed image to torture btrfs.

Those images exposed the following problems:

- Chunk check is not comprehensive nor early enough
  Chunk item check lacks profile bits check (e.g RAID|DUP profile is
  invalid).
  And for certain fuzzed image, the other copy can be valid, current
  check timming is after tree block read, so no way to retry the other
  copy.

  Address the check timing in the 1st~4th patch, while for the profile bits,
  check it in the 7th patch.

- Lack of device item check
  Address it in the 5nd patch.

- First key and level check be exploited by cached extent buffer
  Cached bad extent buffer can avoid first key and level check.
  This is addressed in the 6rd patch.

- Inode type mismatch can lead to NULL dereference in endio function
  If an inode claims itself as symlink but still has regular file
  extent, then endio function will cause NULL pointer dereference.
  Fix it by do extra inode mode and dir item type cross check, at
  get_extent() time and inode lookup time.
  Addressed in the last 2 patches.

Changelog:
v2:
- Split patches for btrfs_check_chunk_valid() merge into tree-checker.
- Rebase to v5.1-rc1 based write_time_tree_checker branch.
- Add reviewed-by tags.

Qu Wenruo (9):
  btrfs: Move btrfs_check_chunk_valid() to tree-check.[ch] and export it
  btrfs: tree-checker: Make chunk item checker more readable
  btrfs: tree-checker: Make btrfs_check_chunk_valid() return EUCLEAN
    instead of EIO
  btrfs: tree-checker: Check chunk item at tree block read time
  btrfs: tree-checker: Verify dev item
  btrfs: Check the first key and level for cached extent buffer
  btrfs: tree-checker: Enhance chunk checker to validate chunk profiler
  btrfs: tree-checker: Verify inode item
  btrfs: inode: Verify inode mode to avoid NULL pointer dereference

 fs/btrfs/ctree.c             |  10 +
 fs/btrfs/ctree.h             |   2 +
 fs/btrfs/disk-io.c           |  10 +-
 fs/btrfs/disk-io.h           |   3 +
 fs/btrfs/inode.c             |  38 +++-
 fs/btrfs/tests/inode-tests.c |   1 +
 fs/btrfs/tree-checker.c      | 349 +++++++++++++++++++++++++++++++++++
 fs/btrfs/tree-checker.h      |   3 +
 fs/btrfs/volumes.c           | 115 +-----------
 fs/btrfs/volumes.h           |   9 +
 10 files changed, 422 insertions(+), 118 deletions(-)

-- 
2.21.0

