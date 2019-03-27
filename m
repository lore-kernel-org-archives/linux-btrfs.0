Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB311C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 12:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDD342087C
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 12:24:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbfC0MYW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 08:24:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:55204 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726233AbfC0MYW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 08:24:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E0A5FAF3F
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2019 12:24:20 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v4 00/15] FITRIM improvement 
Date:   Wed, 27 Mar 2019 14:24:03 +0200
Message-Id: <20190327122418.24027-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Here is the (hopefully final) v4 of the fitrim patches. Main changes since v3:

* Fixed leaked btrfs_path in patch 3.

* Fixed multiple assignemnt on single line in patch 3.

* New patch 9 transposing btrfs_close_devices/btrfs_mapping_tree_free, in v3
this change was wrongly squashed in patch "Introduce new bits for device allocation tree".

* Introduced new patch "Implement set_extent_bits_nowait" and use it instead
of exposing __set_extent_bit in patch 9.

* Introduce new patch "Stop using call_rcu for device freeing" which simplifies
the resulting code freeing the mapping tree, this is prep for patch 9. This also 
fixes a bunch of places that weren't correctly freeing the extent mapping tree
upon device close.

* Fixed ASSERT condition in patch 2

Jeff Mahoney (1):
  btrfs: replace pending/pinned chunks lists with io tree

Nikolay Borisov (14):
  btrfs: Honour FITRIM range constraints during free space trim
  btrfs: combine device update operations during transaction commit
  btrfs: Handle pending/pinned chunks before blockgroup relocation
    during device shrink
  btrfs: Rename and export clear_btree_io_tree
  btrfs: Populate ->orig_block_len during read_one_chunk
  btrfs: Introduce new bits for device allocation tree
  btrfs: Implement set_extent_bits_nowait
  btrfs: Stop using call_rcu for device freeing
  btrfs: Transpose btrfs_close_devices/btrfs_mapping_tree_free in
    close_ctree
  btrfs: Remove 'trans' argument from find_free_dev_extent(_start)
  btrfs: Factor out in_range macro
  btrfs: Optimize unallocated chunks discard
  btrfs: Implement find_first_clear_extent_bit
  btrfs: Switch btrfs_trim_free_extents to find_first_clear_extent_bit

 fs/btrfs/ctree.h            |   8 +-
 fs/btrfs/dev-replace.c      |   2 +-
 fs/btrfs/disk-io.c          |  20 +--
 fs/btrfs/extent-tree.c      | 102 +++++--------
 fs/btrfs/extent_io.c        | 108 +++++++++++++
 fs/btrfs/extent_io.h        |  15 ++
 fs/btrfs/extent_map.c       |  37 +++++
 fs/btrfs/extent_map.h       |   1 -
 fs/btrfs/free-space-cache.c |   4 -
 fs/btrfs/transaction.c      |  51 +------
 fs/btrfs/transaction.h      |   2 +-
 fs/btrfs/volumes.c          | 296 ++++++++++++++----------------------
 fs/btrfs/volumes.h          |  24 +--
 13 files changed, 341 insertions(+), 329 deletions(-)

-- 
2.17.1

