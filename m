Return-Path: <SRS0=PiMA=56=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20C24C3815B
	for <linux-btrfs@archiver.kernel.org>; Tue, 14 Apr 2020 14:00:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1E0320578
	for <linux-btrfs@archiver.kernel.org>; Tue, 14 Apr 2020 14:00:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388653AbgDNOAg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 14 Apr 2020 10:00:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:46852 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388611AbgDNOA2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Apr 2020 10:00:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 29568AF3D;
        Tue, 14 Apr 2020 14:00:26 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6AB2ADA72D; Tue, 14 Apr 2020 15:59:47 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     torvalds@linux-foundation.org
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 5.7-rc2
Date:   Tue, 14 Apr 2020 15:59:45 +0200
Message-Id: <cover.1586868872.git.dsterba@suse.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

we have a few regressions and one fix for stable. Please pull, thanks.

* revert fsync optimization

* fix lost i_size update

* fix a space accounting leak

* build fix, add back definition of a deprecated ioctl flag

* fix search condition for old roots in relocation

----------------------------------------------------------------
The following changes since commit 6ff06729c22ec0b7498d900d79cc88cfb8aceaeb:

  btrfs: fix missing semaphore unlock in btrfs_sync_file (2020-03-25 16:29:16 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.7-rc1-tag

for you to fetch changes up to 34c51814b2b87cb2e5a98c92fe957db2ee8e27f4:

  btrfs: re-instantiate the removed BTRFS_SUBVOL_CREATE_ASYNC definition (2020-04-10 18:48:27 +0200)

----------------------------------------------------------------
Eugene Syromiatnikov (1):
      btrfs: re-instantiate the removed BTRFS_SUBVOL_CREATE_ASYNC definition

Filipe Manana (3):
      btrfs: fix lost i_size update after cloning inline extent
      btrfs: make full fsyncs always operate on the entire file again
      btrfs: fix reclaim counter leak of space_info objects

Josef Bacik (1):
      btrfs: check commit root generation in should_ignore_root

 fs/btrfs/block-group.c     |  1 +
 fs/btrfs/file.c            | 15 ++++++++
 fs/btrfs/reflink.c         |  1 +
 fs/btrfs/relocation.c      |  4 +-
 fs/btrfs/space-info.c      | 20 +++++++---
 fs/btrfs/tree-log.c        | 93 +++++++---------------------------------------
 include/uapi/linux/btrfs.h | 10 ++---
 7 files changed, 51 insertions(+), 93 deletions(-)
