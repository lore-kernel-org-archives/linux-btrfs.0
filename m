Return-Path: <SRS0=8/Zd=P4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C120FC676F4
	for <linux-btrfs@archiver.kernel.org>; Sun, 20 Jan 2019 15:52:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 904ED20861
	for <linux-btrfs@archiver.kernel.org>; Sun, 20 Jan 2019 15:52:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbfATPwC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 20 Jan 2019 10:52:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:42794 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726004AbfATPwC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 20 Jan 2019 10:52:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 66A02AE3C;
        Sun, 20 Jan 2019 15:52:01 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CCDEADA85F; Sun, 20 Jan 2019 16:51:30 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     torvalds@linux-foundation.org
Cc:     David Sterba <dsterba@suse.com>, clm@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 5.0-rc3
Date:   Sun, 20 Jan 2019 16:51:29 +0100
Message-Id: <cover.1547998923.git.dsterba@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

please pull the following branch to obtain a handful of fixes (some of
them in testing for a long time, were briefly mentioned in the 1st
pull):

- fix some test failures regarding cleanup after transaction abort

- revert of a patch that could cause a deadlock

- delayed iput fixes, that can help in ENOSPC situation when there's low
  space and lot data to write

Thanks.

----------------------------------------------------------------
The following changes since commit 1b3922a8bc74231f9a767d1be6d9a061a4d4eeab:

  btrfs: Use real device structure to verify dev extent (2019-01-10 17:13:00 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.0-rc2-tag

for you to fetch changes up to fd340d0f68cc87badfc9efcb226f23a5428826a0:

  btrfs: wakeup cleaner thread when adding delayed iput (2019-01-18 17:27:23 +0100)

----------------------------------------------------------------
David Sterba (1):
      Revert "btrfs: balance dirty metadata pages in btrfs_finish_ordered_io"

Josef Bacik (4):
      btrfs: handle delayed ref head accounting cleanup in abort
      btrfs: wait on ordered extents on abort cleanup
      btrfs: run delayed iputs before committing
      btrfs: wakeup cleaner thread when adding delayed iput

 fs/btrfs/ctree.h       |  7 +++++++
 fs/btrfs/disk-io.c     | 12 ++++++++++++
 fs/btrfs/extent-tree.c | 21 ++++++++++++++-------
 fs/btrfs/inode.c       |  5 ++---
 4 files changed, 35 insertions(+), 10 deletions(-)
