Return-Path: <SRS0=L0dM=NW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02A5EC43441
	for <linux-btrfs@archiver.kernel.org>; Sun, 11 Nov 2018 12:11:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C84B3208A3
	for <linux-btrfs@archiver.kernel.org>; Sun, 11 Nov 2018 12:11:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C84B3208A3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbeKKV7h (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 11 Nov 2018 16:59:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:54888 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727467AbeKKV7h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Nov 2018 16:59:37 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0DF61AE56;
        Sun, 11 Nov 2018 12:11:12 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 93528DA8A7; Sun, 11 Nov 2018 13:10:57 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     torvalds@linux-foundation.org
Cc:     David Sterba <dsterba@suse.com>, clm@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 4.20-rc1
Date:   Sun, 11 Nov 2018 13:10:56 +0100
Message-Id: <cover.1541937408.git.dsterba@suse.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

this update brings several fixes to recent release (4.19, fixes tagged
for stable) and other fixes. No merge conflicts. Please pull, thanks.

----------------------------------------------------------------
The following changes since commit 9084cb6a24bf5838a665af92ded1af8363f9e563:

  Btrfs: fix use-after-free when dumping free space (2018-10-22 20:31:22 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.20-rc1-tag

for you to fetch changes up to d6fd0ae25c6495674dc5a41a8d16bc8e0073276d:

  Btrfs: fix missing delayed iputs on unmount (2018-11-07 20:17:45 +0100)

----------------------------------------------------------------
Arnd Bergmann (1):
      btrfs: avoid link error with CONFIG_NO_AUTO_INLINE

Filipe Manana (4):
      Btrfs: fix missing data checksums after a ranged fsync (msync)
      Btrfs: fix deadlock on tree root leaf when finding free extent
      Btrfs: fix infinite loop on inode eviction after deduplication of eof block
      Btrfs: fix data corruption due to cloning of eof block

Lu Fengqi (1):
      btrfs: fix pinned underflow after transaction aborted

Omar Sandoval (1):
      Btrfs: fix missing delayed iputs on unmount

Robbie Ko (1):
      Btrfs: fix cur_offset in the error case for nocow

Shaokun Zhang (1):
      btrfs: tree-checker: Fix misleading group system information

 fs/btrfs/ctree.h            |  3 +++
 fs/btrfs/disk-io.c          | 63 +++++++++++++++++++--------------------------
 fs/btrfs/free-space-cache.c | 22 +++++++++++++++-
 fs/btrfs/inode.c            | 37 ++++++++++++++++----------
 fs/btrfs/ioctl.c            | 14 ++++++++--
 fs/btrfs/super.c            |  6 ++---
 fs/btrfs/tree-checker.c     |  2 +-
 fs/btrfs/tree-log.c         | 17 ++++++++++++
 8 files changed, 107 insertions(+), 57 deletions(-)
