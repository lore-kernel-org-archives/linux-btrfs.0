Return-Path: <SRS0=xVbL=5D=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89EABC10DCE
	for <linux-btrfs@archiver.kernel.org>; Wed, 18 Mar 2020 07:54:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CF3C2076C
	for <linux-btrfs@archiver.kernel.org>; Wed, 18 Mar 2020 07:54:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgCRHyj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 18 Mar 2020 03:54:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:57910 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbgCRHyj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Mar 2020 03:54:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 63336AC37
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Mar 2020 07:54:38 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v4 0/4] btrfs-progs: image: Enhancement with new data dump feature
Date:   Wed, 18 Mar 2020 15:54:30 +0800
Message-Id: <20200318075434.27258-1-wqu@suse.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patchset includes the following features:

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

- A fix for small dev extent size mismatch with superblock

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

v3:
- Fix a wrong option in error string
- Fix a bug that we always dump data extents

v4:
- Rebased to latest devel branch
- Add a new small fix to kill the tiny dev extent size mismatch.

Qu Wenruo (4):
  btrfs-progs: image: Introduce framework for more dump versions
  btrfs-progs: image: Introduce -d option to dump data
  btrfs-progs: image: Reduce memory requirement for decompression
  btrfs: image: Fix restored image size misalignment

 image/main.c     | 347 ++++++++++++++++++++++++++++++++++-------------
 image/metadump.h |  13 +-
 2 files changed, 264 insertions(+), 96 deletions(-)

-- 
2.25.1

