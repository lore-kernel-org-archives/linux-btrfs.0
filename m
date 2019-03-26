Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9296AC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 14:14:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D2752075D
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 14:14:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731464AbfCZOOk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 10:14:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:40884 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726261AbfCZOOk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 10:14:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F344BAF99;
        Tue, 26 Mar 2019 14:14:38 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8391BDA8A5; Tue, 26 Mar 2019 15:15:51 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     torvalds@linux-foundation.org
Cc:     David Sterba <dsterba@suse.com>, clm@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 5.1-rc3
Date:   Tue, 26 Mar 2019 15:15:45 +0100
Message-Id: <cover.1553608661.git.dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

please pull the following tag to receive:

- fsync fixes: i_size for truncate vs fsync, dio vs buffered during
  snapshotting, remove complicated but incomplete assertion

- removed excessive warnigs, misreported device stats updates

- fix raid56 page mapping for 32bit arch

- fixes reported by static analyzer

Thanks.

----------------------------------------------------------------
The following changes since commit d3865159ac7823f645d313fdbac0b256ac01eeb9:

  btrfs: zstd: ensure reclaim timer is properly cleaned up (2019-02-27 17:45:04 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.1-rc2-tag

for you to fetch changes up to 0ccc3876e4b2a1559a4dbe3126dda4459d38a83b:

  Btrfs: fix assertion failure on fsync with NO_HOLES enabled (2019-03-20 19:53:39 +0100)

----------------------------------------------------------------
Andrea Righi (1):
      btrfs: raid56: properly unmap parity page in finish_parity_scrub()

David Sterba (1):
      btrfs: don't report readahead errors and don't update statistics

Filipe Manana (3):
      Btrfs: fix incorrect file size after shrinking truncate and fsync
      Btrfs: fix file corruption after snapshotting due to mix of buffered/DIO writes
      Btrfs: fix assertion failure on fsync with NO_HOLES enabled

Josef Bacik (1):
      btrfs: remove WARN_ON in log_dir_items

Nikolay Borisov (2):
      btrfs: Fix bound checking in qgroup_trace_new_subtree_blocks
      btrfs: Avoid possible qgroup_rsv_size overflow in btrfs_calculate_inode_block_rsv_size

 fs/btrfs/extent-tree.c |  2 +-
 fs/btrfs/qgroup.c      |  4 ++--
 fs/btrfs/raid56.c      |  3 ++-
 fs/btrfs/transaction.c | 49 +++++++++++++++++++++++++++++++++++++++++++------
 fs/btrfs/tree-log.c    | 33 +++++++++++++++++++++++----------
 fs/btrfs/volumes.c     |  2 +-
 6 files changed, 72 insertions(+), 21 deletions(-)
