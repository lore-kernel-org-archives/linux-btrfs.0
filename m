Return-Path: <SRS0=cBAG=QG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C7E9C282D7
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 14:51:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08CD320882
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 14:51:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731407AbfA3OvG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jan 2019 09:51:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:38088 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730093AbfA3OvG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jan 2019 09:51:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2EDEFB079
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2019 14:51:04 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     jeffm@suse.com, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 00/15] Improvements to fitrim 
Date:   Wed, 30 Jan 2019 16:50:47 +0200
Message-Id: <20190130145102.4708-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Here's a series that spruces up btrfs' trim implementation. The main goal is to 
optimise trim of freespace so that when a range is trimmed once and not allocated, 
subsequent trims will skip it, thus improving performance. 

First 3 patches are misc cleanups which are mostly independent. Of them, perhaps
the first one is the most important since it adds support for FITRIM ranges and 
is likely stable material. Currently btrfs will entirely ignore range options 
of the FITRIM ioctl. 

Patch 4 is from Jeff and it simplifies management of resized_devices/pending_chunks
lists. Apart from a nice cleanup it's a prep patch for further removal of 
pinned/pending chunks lists

Patch 5 is a self-contained cleanup that resulted from me investigating how 
contains_pending_extent is being used. The gist is that the check for pending
extents can be done before the main shrink loop in btrfs_shrink_device. This
makes the code more linear. 

Patches 6/7/8 small, self-explanatory, prep patches for removal of pinned/pending
chunk lists. 

Patch 9 replaces the now-reduced scope of pending/pinned chunks with an 
extent_io_tree. The patch was initially developed by Jeff and I just finished 
his work by fixing several bugs. Those were mainly around memory allocation 
contexts and locking.

Patches 10/11 perform refactoring which is enabled by the previous patch. Mainly, 
simplifying find_free_dev_extent and no longer requiring a transaction be held 
open during trim. This is already a performance improvement in and of itself. 
Though find_free_dev_extent_start is still used that is the device tree is being
read.

Patch 12 makes trimming code smarter by recording which trange has been trimmed 
and avoid trimming when possible - i.e a range has been trimmed and subsequently 
not allocated. 

Patch 13 minor quality-of-life patch, self-explanatory

Patch 14/15 switch btrfs_trim_free_extents to using an entirely in-memory 
datastructure when looking for ranges to trim. The idea is this should be faster
than working with the device tree. In practice, though, I'm not entirely sure 
since :

1. We still have to hold the chunk_mutex
2. I suspect that the device tree will be more or less cached in memory. 

Review of the series is welcome, I'd also urge people to pay attention  when 
reviewing code responsible for calculating trim ranges. An error there could
lead to data loss if allocated space is trimmed. I have manually tested the 
ranged trim support to ensure this won't happen but one can never get enough 
testing :). Also, this series survived multiple xfstest runs. 

Jeff Mahoney (2):
  btrfs: combine device update operations during transaction commit
  btrfs: replace pending/pinned chunks lists with io tree

Nikolay Borisov (13):
  btrfs: Honour FITRIM range constraints during free space trim
  btrfs: Make WARN_ON in a canonical form
  btrfs: Remove  EXTENT_FIRST_DELALLOC bit
  btrfs: Handle pending/pinned chunks before blockgroup relocation
    during device shrink
  btrfs: Rename and export clear_btree_io_tree
  btrfs: Populate ->orig_block_len during read_one_chunk
  btrfs: Introduce new bits for device allocation tree
  btrfs: Remove 'trans' argument from find_free_dev_extent(_start)
  btrfs: Factor out in_range macro
  btrfs: Optimize unallocated chunks discard
  btrfs: Fix gross misnaming
  btrfs: Implement find_first_clear_extent_bit
  btrfs: Switch btrfs_trim_free_extents to find_first_clear_extent_bit

 fs/btrfs/ctree.h            |   8 +-
 fs/btrfs/dev-replace.c      |   2 +-
 fs/btrfs/disk-io.c          |  20 ++-
 fs/btrfs/extent-tree.c      | 107 +++++---------
 fs/btrfs/extent_io.c        | 126 ++++++++++++++--
 fs/btrfs/extent_io.h        |  34 +++--
 fs/btrfs/extent_map.c       |  38 +++++
 fs/btrfs/extent_map.h       |   1 -
 fs/btrfs/free-space-cache.c |   4 -
 fs/btrfs/transaction.c      |  53 ++-----
 fs/btrfs/transaction.h      |   2 +-
 fs/btrfs/volumes.c          | 277 ++++++++++++++----------------------
 fs/btrfs/volumes.h          |  23 ++-
 13 files changed, 354 insertions(+), 341 deletions(-)

-- 
2.17.1

