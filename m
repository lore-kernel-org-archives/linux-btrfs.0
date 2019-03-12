Return-Path: <SRS0=uY43=RP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16169C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 15:07:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D949A2147C
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 15:07:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbfCLPHn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Mar 2019 11:07:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:38958 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726561AbfCLPHn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Mar 2019 11:07:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D4D3DB168;
        Tue, 12 Mar 2019 15:07:41 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CC131DA8D5; Tue, 12 Mar 2019 16:08:57 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     torvalds@linux-foundation.org
Cc:     David Sterba <dsterba@suse.com>, clm@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs updates for 5.1, part 2
Date:   Tue, 12 Mar 2019 16:08:52 +0100
Message-Id: <cover.1552401006.git.dsterba@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

here's the second part containing mostly fixes. The changelog would
repeat the subject lines, in summary there are correctness and a
deadlock fixes. Please pull, thanks.

----------------------------------------------------------------
The following changes since commit f65e25e343cfc0e6f4db9a687c4085fad268325d:

  btrfs: Remove unnecessary casts in btrfs_read_root_item (2019-02-25 14:19:23 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.1-part2-tag

for you to fetch changes up to d3865159ac7823f645d313fdbac0b256ac01eeb9:

  btrfs: zstd: ensure reclaim timer is properly cleaned up (2019-02-27 17:45:04 +0100)

----------------------------------------------------------------
David Sterba (1):
      btrfs: move ulist allocation out of transaction in quota enable

Dennis Zhou (1):
      btrfs: zstd: ensure reclaim timer is properly cleaned up

Filipe Manana (2):
      Btrfs: fix corruption reading shared and compressed extents after hole punching
      Btrfs: fix deadlock between clone/dedupe and rename

Josef Bacik (2):
      btrfs: check for refs on snapshot delete resume
      btrfs: save drop_progress if we drop refs at all

 fs/btrfs/ctree.h       |  2 ++
 fs/btrfs/extent-tree.c | 74 +++++++++++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/extent_io.c   |  4 +--
 fs/btrfs/ioctl.c       | 21 ++------------
 fs/btrfs/qgroup.c      | 13 ++++-----
 fs/btrfs/root-tree.c   |  8 ++++--
 fs/btrfs/zstd.c        |  6 ++--
 7 files changed, 90 insertions(+), 38 deletions(-)
