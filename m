Return-Path: <SRS0=fY3M=2I=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22C5AC43603
	for <linux-btrfs@archiver.kernel.org>; Wed, 18 Dec 2019 01:19:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3D9021775
	for <linux-btrfs@archiver.kernel.org>; Wed, 18 Dec 2019 01:19:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbfLRBTu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 17 Dec 2019 20:19:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:49724 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726205AbfLRBTu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Dec 2019 20:19:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 68683ABCD
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Dec 2019 01:19:48 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/6] btrfs-progs: Fixes for github issues
Date:   Wed, 18 Dec 2019 09:19:36 +0800
Message-Id: <20191218011942.9830-1-wqu@suse.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There are a new batch of fuzzed images for btrfs-progs. They are all
reported by Ruud van Asseldonk from github.

Patch 1 will make QA life easier by remove the extra 300s wait time.
Patch 2~5 are all the meat for the fuzzed images.

Just a kind reminder, mkfs/020 test will fail due to tons of problems:
- Undefined $csum variable
- Undefined $dev1 variable
- Bad kernel probe for support csum
  E.g. if Blake2 not compiled, it still shows up in supported csum algo,
  but will fail to mount.

All other tests pass.

Qu Wenruo (6):
  btrfs-progs: tests: Add --force for repair command
  btrfs-progs: check/original: Do extra verification on file extent item
  btrfs-progs: disk-io: Verify the bytenr passed in is mapped for
    read_tree_block()
  btrfs-progs: Add extra chunk item size check
  btrfs-progs: extent-tree: Kill the BUG_ON() in btrfs_chunk_readonly()
  btrfs-progs: extent-tree: Fix a by-one error in
    exclude_super_stripes()

 check/main.c  | 34 ++++++++++++++++++++++++++++++++--
 extent-tree.c | 11 ++++++++---
 extent_io.c   | 26 ++++++++++++++++++++++++++
 extent_io.h   |  2 ++
 tests/common  |  2 +-
 volumes.c     | 41 ++++++++++++++++++++++++++++++++++++-----
 6 files changed, 105 insertions(+), 11 deletions(-)

-- 
2.24.1

