Return-Path: <SRS0=R2l8=VB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25727C0650E
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Jul 2019 06:11:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E997B20881
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Jul 2019 06:11:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbfGDGLI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Jul 2019 02:11:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:54338 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725861AbfGDGLI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 Jul 2019 02:11:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 96273AFFB
        for <linux-btrfs@vger.kernel.org>; Thu,  4 Jul 2019 06:11:07 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2.1 00/10] btrfs-progs: image: Enhancement with new data dump feature
Date:   Thu,  4 Jul 2019 14:10:53 +0800
Message-Id: <20190704061103.20096-1-wqu@suse.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This updated patchset is rebased on devel branch, whose HEAD is:
commit 73289664917ad7c73f3f3393593e93a118228ad8 (david/devel)
Author: David Sterba <dsterba@suse.com>
Date:   Thu Jul 4 01:42:15 2019 +0200

    btrfs-progs: kerncompat: define __always_inline conditionally

This updated patchset includes the following features:

- Small fixes to improve btrfs-image error report
  * Output error message for chunk tree build error
  * Fix error output to show correct return value
  Patch 1 and 2.

- Reduce memory usage when decompress super block
  Independent change, for current btrfs-image, it will reduce buffer
  size from 256K to fixed 4K.
  Patch 3.

- Rework how we search chunk tree blocks
  Instead of iterating clusters again and again for each chunk tree
  block, record system chunk array and iterate clusters once for all
  chunk tree blocks.
  This should reduce restore time for large image dump.
  Patch 4, 5 and 6.

- Introduce data dump feature to dump the whole fs.
  This will introduce a new magic number to prevent old btrfs-image to
  hit failure as the item size limit is enlarged.
  Patch 7 and 8.

- Reduce memory usage for data dump restore
  This is mostly due to the fact that we have much larger
  max_pending_size introduced by data dump(256K -> 256M).
  Using 4 * max_pending_size for each decompress thread as buffer is way
  too expensive now.
  Use proper inflate() to replace uncompress() calls.
  Patch 9 and 10.

Changelog:
v2:
- New small fixes:
  * Fix a confusing error message due to unpopulated errno
  * Output error message for chunk tree build error
  
- Fix a regression of previous version
  Patch "btrfs-progs: image: Rework how we search chunk tree blocks"
  deleted a "ret = 0" line which could cause false early exit.

- Reduce memory usage for data dump

v2.1:
- Rebased to devel branch
  Removing 4 already merged patches from the patchset.

- Re-order the patchset
  Put small and independent patches at the top of queue, and put the
  data dump related feature at the end.

- Fix -Wmaybe-uninitialized warnings
  Strangely, D=1 won't trigger these warnings thus they sneak into v2
  without being detected.

- Fix FROM: line
  Reverted to old smtp setup. The new setup will override FROM: line,
  messing up the name of author.

Qu Wenruo (10):
  btrfs-progs: image: Output error message for chunk tree build error
  btrfs-progs: image: Fix error output to show correct return value
  btrfs-progs: image: Don't waste memory when we're just extracting
    super block
  btrfs-progs: image: Allow restore to record system chunk ranges for
    later usage
  btrfs-progs: image: Introduce helper to determine if a tree block is
    in the range of system chunks
  btrfs-progs: image: Rework how we search chunk tree blocks
  btrfs-progs: image: Introduce framework for more dump versions
  btrfs-progs: image: Introduce -d option to dump data
  btrfs-progs: image: Reduce memory requirement for decompression
  btrfs-progs: image: Reduce memory usage for chunk tree search

 image/main.c     | 866 +++++++++++++++++++++++++++++++++++------------
 image/metadump.h |  13 +-
 2 files changed, 654 insertions(+), 225 deletions(-)

-- 
2.22.0

