Return-Path: <SRS0=NX0b=ZS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EF1DC432C3
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Nov 2019 08:40:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 216FE20722
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Nov 2019 08:40:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfKZIkK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Nov 2019 03:40:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:48198 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725862AbfKZIkJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Nov 2019 03:40:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2CA77AE04;
        Tue, 26 Nov 2019 08:40:08 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v4 0/2] remove BUG_ON()s in btrfs_close_one_device()
Date:   Tue, 26 Nov 2019 09:40:04 +0100
Message-Id: <20191126084006.23262-1-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This series attempts to remove the BUG_ON()s in btrfs_close_one_device().
Therefore some reorganization of btrfs_close_one_device() was needed, to
avoid the memory allocation.

This series has passed fstests without any deviation from the baseline.

Changes to v3:
- Clear BTRFS_DEV_STATE_WRITEABLE after calling btrfs_close_bdev() so
  btrfs_close_bdev() can call sync_blockdev() and invalidate_bdev() (Nikolay)

Changes to v2:
- Completly different approach to the origianl patchset, instead of handling
  eventual allocation failures.
- Dropped already merged patches for ' btrfs_fs_devices::rotating' and
  'btrfs_fs_devices::seeding'
- Kept the 1st patch of the old series, as it's a nice cleanup

Changes to v1:
- Fixed the decremt of btrfs_fs_devices::seeding.
- In addition to this, I've added two patches changing btrfs_fs_devices::seeding
  and btrfs_fs_devices::rotating to bool, as they are in fact used as booleans.

Johannes Thumshirn (2):
  btrfs: decrement number of open devices after closing the device not
    before
  btrfs: reset device back to allocation state when removing

 fs/btrfs/volumes.c | 41 ++++++++++++++++++-----------------------
 1 file changed, 18 insertions(+), 23 deletions(-)

-- 
2.16.4

