Return-Path: <SRS0=iJ2R=NK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7637BC6786F
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 13:24:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4837520827
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 13:24:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4837520827
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728128AbeJ3WRe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 30 Oct 2018 18:17:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:54576 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726135AbeJ3WRe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Oct 2018 18:17:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D36CEACA9;
        Tue, 30 Oct 2018 13:24:06 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A4AE3DAB9E; Tue, 30 Oct 2018 14:23:56 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     torvalds@linux-foundation.org
Cc:     David Sterba <dsterba@suse.com>, clm@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs updates for 4.20, part 2
Date:   Tue, 30 Oct 2018 14:23:52 +0100
Message-Id: <cover.1540904580.git.dsterba@suse.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

this part contains a few minor updates and fixes that were under testing
or arrived shortly after the merge window freeze, mostly stable material.

Please pull, thanks.

----------------------------------------------------------------
The following changes since commit d9352794dad9f28535439d85a815978878c141ab:

  btrfs: switch return_bigger to bool in find_ref_head (2018-10-15 17:23:41 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.20-part2-tag

for you to fetch changes up to 9084cb6a24bf5838a665af92ded1af8363f9e563:

  Btrfs: fix use-after-free when dumping free space (2018-10-22 20:31:22 +0200)

----------------------------------------------------------------
Filipe Manana (5):
      Btrfs: fix null pointer dereference on compressed write path error
      Btrfs: fix assertion on fsync of regular file when using no-holes feature
      Btrfs: fix deadlock when writing out free space caches
      Btrfs: fix use-after-free during inode eviction
      Btrfs: fix use-after-free when dumping free space

Josef Bacik (8):
      MAINTAINERS: update my email address for btrfs
      btrfs: reset max_extent_size properly
      btrfs: set max_extent_size properly
      btrfs: don't use ctl->free_space for max_extent_size
      btrfs: only free reserved extent if we didn't insert it
      btrfs: fix insert_reserved error handling
      btrfs: don't run delayed_iputs in commit
      btrfs: move the dio_sem higher up the callchain

Lu Fengqi (1):
      btrfs: delayed-ref: extract find_first_ref_head from find_ref_head

 MAINTAINERS                 |  2 +-
 fs/btrfs/ctree.c            | 17 +++++++++++++++
 fs/btrfs/delayed-ref.c      | 50 ++++++++++++++++++++++++---------------------
 fs/btrfs/extent-tree.c      | 37 +++++++++++++++------------------
 fs/btrfs/file.c             | 12 +++++++++++
 fs/btrfs/free-space-cache.c | 32 ++++++++++++++++++++---------
 fs/btrfs/inode.c            | 15 ++++++++++++--
 fs/btrfs/transaction.c      |  9 --------
 fs/btrfs/tree-log.c         |  5 ++---
 9 files changed, 111 insertions(+), 68 deletions(-)
