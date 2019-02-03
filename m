Return-Path: <SRS0=vUl+=QK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E27A1C169C4
	for <linux-btrfs@archiver.kernel.org>; Sun,  3 Feb 2019 09:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B60C42083B
	for <linux-btrfs@archiver.kernel.org>; Sun,  3 Feb 2019 09:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727424AbfBCJt3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 3 Feb 2019 04:49:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:42490 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726754AbfBCJt3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 3 Feb 2019 04:49:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 460A1ACD2;
        Sun,  3 Feb 2019 09:49:28 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 55B12DA7D6; Sun,  3 Feb 2019 10:48:52 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     torvalds@linux-foundation.org
Cc:     David Sterba <dsterba@suse.com>, clm@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 5.0-rc5
Date:   Sun,  3 Feb 2019 10:48:46 +0100
Message-Id: <cover.1549186243.git.dsterba@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

there are a few fixes that I'd like to have in the 5.0 release. Last rc
was skipped because one fix had to be reworked and more testing was
needed.  Please pull, thanks.

- regression fix: transaction commit can run away due to delayed ref
  waiting heuristic, this is not necessary now because of the proper
  reservation mechanism introduced in 5.0

- regression fix: potential crash due to use-before-check of an ERR_PTR
  return value

- fix for transaction abort during transaction commit that needs to
  properly clean up pending block groups

- fix deadlock during b-tree node/leaf splitting, when this happens on
  some of the fundamental trees, we must prevent new tree block
  allocation to re-enter indirectly via the block group flushing path

- potential memory leak after errors during mount

----------------------------------------------------------------
The following changes since commit fd340d0f68cc87badfc9efcb226f23a5428826a0:

  btrfs: wakeup cleaner thread when adding delayed iput (2019-01-18 17:27:23 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.0-rc4-tag

for you to fetch changes up to 532b618bdf237250d6d4566536d4b6ce3d0a31fe:

  btrfs: On error always free subvol_name in btrfs_mount (2019-01-30 18:16:47 +0100)

----------------------------------------------------------------
Al Viro (1):
      btrfs: fix potential oops in device_list_add

David Sterba (1):
      btrfs: clean up pending block groups when transaction commit aborts

Eric W. Biederman (1):
      btrfs: On error always free subvol_name in btrfs_mount

Filipe Manana (1):
      Btrfs: fix deadlock when allocating tree block during leaf/node split

Josef Bacik (1):
      btrfs: don't end the transaction for delayed refs in throttle

 fs/btrfs/ctree.c       | 78 ++++++++++++++++++++++++++++++++------------------
 fs/btrfs/super.c       |  3 ++
 fs/btrfs/transaction.c | 24 ++++++++++------
 fs/btrfs/volumes.c     |  4 +--
 4 files changed, 71 insertions(+), 38 deletions(-)
