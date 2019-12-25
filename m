Return-Path: <SRS0=NIdW=2P=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DA9BC2D0DA
	for <linux-btrfs@archiver.kernel.org>; Wed, 25 Dec 2019 13:40:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 434E52077B
	for <linux-btrfs@archiver.kernel.org>; Wed, 25 Dec 2019 13:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbfLYNjn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 25 Dec 2019 08:39:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:56346 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726106AbfLYNjn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Dec 2019 08:39:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D72E6AAA6
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Dec 2019 13:39:41 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 0/3] Introduce per-profile available space array to avoid over-confident can_overcommit()
Date:   Wed, 25 Dec 2019 21:39:35 +0800
Message-Id: <20191225133938.115733-1-wqu@suse.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There are several bug reports of ENOSPC error in
btrfs_run_delalloc_range().

With some extra info from one reporter, it turns out that
can_overcommit() is using a wrong way to calculate allocatable metadata
space.

The most typical case would look like:
  devid 1 unallocated:	1G
  devid 2 unallocated:  10G
  metadata profile:	RAID1

In above case, we can at most allocate 1G chunk for metadata, due to
unbalanced disk free space.
But current can_overcommit() uses factor based calculation, which never
consider the disk free space balance.


To address this problem, here comes the per-profile available space
array, which gets updated every time a chunk get allocated/removed or a
device get grown or shrunk.

This provides a quick way for hotter place like can_overcommit() to grab
an estimation on how many bytes it can over-commit.

The per-profile available space calculation tries to keep the behavior
of chunk allocator, thus it can handle uneven disks pretty well.

The RFC tag is here because I'm not yet confident enough about the
implementation.
I'm not sure this is the proper to go, or just a over-engineered mess.

Qu Wenruo (3):
  btrfs: Introduce per-profile available space facility
  btrfs: Update per-profile available space when device size/used space
    get updated
  btrfs: space-info: Use per-profile available space in can_overcommit()

 fs/btrfs/space-info.c |  15 ++--
 fs/btrfs/volumes.c    | 205 ++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/volumes.h    |  10 +++
 3 files changed, 203 insertions(+), 27 deletions(-)

-- 
2.24.1

