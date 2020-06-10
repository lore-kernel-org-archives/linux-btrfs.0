Return-Path: <SRS0=J01l=7X=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29988C433DF
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Jun 2020 00:58:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D310206C3
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Jun 2020 00:58:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgFJA56 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Jun 2020 20:57:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:33382 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726039AbgFJA55 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Jun 2020 20:57:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6E873ACBD
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jun 2020 00:57:59 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/5] btrfs: qgroup: detect and fix leaked data reserved space
Date:   Wed, 10 Jun 2020 08:57:46 +0800
Message-Id: <20200610005751.10645-1-wqu@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There is an internal report complaining that qgroup is only half of the
limit, but they still get EDQUOT errors.

With some extra debugging patch added, it turns out that even fsstress
with 10 steps can sometimes cause qgroup reserved data space to leak.

The root cause is the chaotic lifespan of qgroup data rsv.
Here is the chart explaining the difference between the old and new
lifespan of qgroup data rsv:
  ||: Qgroup data rsv is reserved
   |: Qgroup data rsv is released but not freed
    : Qgroup data rsv is freed

	The old		The new

	   TT		   TT		Page get dirtied
 	   ||		   ||
           ||		   ||
  	   || ------------ || --------- btrfs_run_delalloc_range()
	   ||		    |		|- btrfs_add_ordered_extent()
	   ||		    |
	    | ------------  | --------- btrfs_finish_ordered_io()
	    |		    |
	      ------------    --------- btrfs_account_extents()

Since there is a large window between btrfs_add_ordered_extent() and
btrfs_finish_ordered_io(), during which page can be released and clear
the QGROUP_RESERVED bit.

In fact during dio, dio will try to flush the range, and then invalidate
the pages before submitting direct IO.

Due to the fact that filemap_write_and_wait_range() will only wait for
page writeback get cleared, not page dirty cleared, so it will release
pages before btrfs_finish_ordered_io() get executed, and clearing
QGROUP_RESERVED bit without triggering qgroup rsv release, leading to
qgroup data rsv leakage.

With the new timing, QGROUP_RESERVED bit is cleared before
filemap_write_and_wait_range() returns, and doing proper qgroup rsv
releasing, so there is no window to screw up qgroup rsv anymore.

Although to co-operate the timing change, quite some existing chaotic
btrfs_qgroup_release/free_data() calls must be modified/removed to
follow the more restrict calling protocol.

But overall, this make the qgroup data rsv lifespan more clear, so it
should be still worthy.

After all the big timing change and fixes, add an extra and hopefully
final safe net to catch qgroup data rsv leakage.
Now extent io tree based QGROUP_RESERVED bit should detect case like
missing btrfs_qgroup_release/free_data() call, while the unmount check
should detect unexpected QGROUP_RESERVED bit clearing.

The existing test case btrfs/022 can already catch the bug pretty
reliably.

Changelog:
v2:
- Change the lifespan of qgroup data rsv
  From the original whac-a-mole method to a more proper timing, to
  use ordered extents as the proper owner of qgroup data rsv.

- Add commit message for the final patch

- Adds extra refactor to make insert_reserved_file_extent() use less
  parameters

Qu Wenruo (5):
  btrfs: inode: refactor the parameters of insert_reserved_file_extent()
  btrfs: inode: move the qgroup reserved data space release into the
    callers of insert_reserved_file_extent()
  btrfs: file: reserve qgroup space after the hole punch range locked
  btrfs: change the timing for qgroup reserved space for ordered extents
    to fix reserved space leak
  btrfs: qgroup: catch reserved space leakage at unmount time

 fs/btrfs/ctree.h        |   6 +-
 fs/btrfs/disk-io.c      |   6 ++
 fs/btrfs/file.c         |   8 +--
 fs/btrfs/inode.c        | 119 +++++++++++++++++++++++-----------------
 fs/btrfs/ordered-data.c |  22 +++++++-
 fs/btrfs/ordered-data.h |   3 +
 fs/btrfs/qgroup.c       |  43 +++++++++++++++
 fs/btrfs/qgroup.h       |   2 +-
 8 files changed, 152 insertions(+), 57 deletions(-)

-- 
2.26.2

