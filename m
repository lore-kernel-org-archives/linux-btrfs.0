Return-Path: <SRS0=tdFO=AY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13BF2C433E0
	for <linux-btrfs@archiver.kernel.org>; Mon, 13 Jul 2020 01:03:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E844B206B6
	for <linux-btrfs@archiver.kernel.org>; Mon, 13 Jul 2020 01:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgGMBDc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 12 Jul 2020 21:03:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:53890 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726261AbgGMBDc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 12 Jul 2020 21:03:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B7129AC20
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Jul 2020 01:03:32 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3 0/4] btrfs: handle signal interruption during relocation more gracefully
Date:   Mon, 13 Jul 2020 09:03:18 +0800
Message-Id: <20200713010322.18507-1-wqu@suse.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This bug is reported by Hans van Kranenburg <hans@knorrie.org>, that
when a running btrfs balance get fatal signals (including SIGINT), some
bad things can happen, mostly forced RO caused by -EINTR.

It turns out that, although we have addressed the btrfs balance cancel
problems, we haven't addressed the signal related problems.

In theory, processes trapped into kernel space won't get interrupted by
signals, as signal callbacks happen in user space, but kernel code can
still check pending signals and change behavior accordingly.

In this case, the culprit is that, wait_reserve_ticket() can return
-EINTR if there is a pending fatal signal.

While for balance, a lot of situations can't handle the -EINTR from it,
especially for critical cleanup phase.

This patchset will address the bug in two directions:
- Catch fatal signal early
  Now btrfs_should_cancel_balance() will also check pending signals.
  And will exit gracefully and treat it as a canceled balance.

- Don't allow -EINTR for critical cleanup
  For btrfs_drop_snapshot() for reloc trees, we shouldn't be interrupted
  by signal, thus we use btrfs_join_transaction() instead of
  btrfs_start_transaction().
  And for other critical call sites, change the flushing level to avoid
  signal interruption.
  We also enhance the comment for the btrfs_reserve_flush_enum, to make
  it easier to grasp.

Changelog:
v1:
- Change the callers of ticketing system
  Still allow certain tickets to be interrupted by signals, and change
  the call sites to avoid signal interruption.

v2:
- Add comment for why we can reduce the meta rsv for tree swap

v3:
- Add back the not-yet-merged first patch
- Rephrase the commit message of the 2nd patch
- Add comment for the 3rd patch about the canceled balance return value
- Add a new patch explaining the flushing level


Qu Wenruo (4):
  btrfs: relocation: allow signal to cancel balance
  btrfs: avoid possible signal interruption for btrfs_drop_snapshot() on
    relocation tree
  btrfs: relocation: review the call sites which can be interrupted by
    signal
  btrfs: Add comments for btrfs_reserve_flush_enum

 fs/btrfs/ctree.h       | 34 ++++++++++++++++++++++++++++++++--
 fs/btrfs/extent-tree.c |  5 ++++-
 fs/btrfs/relocation.c  | 16 +++++++++++++---
 fs/btrfs/volumes.c     | 14 +++++++++++++-
 4 files changed, 62 insertions(+), 7 deletions(-)

-- 
2.27.0

