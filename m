Return-Path: <SRS0=vnEf=YA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6484C47404
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Oct 2019 19:37:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8602C206C0
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Oct 2019 19:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbfJGTh1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 7 Oct 2019 15:37:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:44386 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728079AbfJGTh1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 Oct 2019 15:37:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E6BC0AD7F;
        Mon,  7 Oct 2019 19:37:25 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 27B96DA7FB; Mon,  7 Oct 2019 21:37:41 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 0/5] Remove extent_map::bdev
Date:   Mon,  7 Oct 2019 21:37:40 +0200
Message-Id: <cover.1570474492.git.dsterba@suse.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The extent_map::bdev is unused and and can be removed, but it's not
straightforward so there are several steps. The first patch decouples
bdev from map_lookup. The remaining patches clean up use of the bdev,
removing a few bio_set_dev on the way. In the end, submit_extent_page is
one parameter lighter.

This has survived several fstests runs

David Sterba (5):
  btrfs: assert extent_map bdevs and lookup_map and split
  btrfs: get bdev from latest_dev for dio bh_result
  btrfs: drop bio_set_dev where not needed
  btrfs: remove extent_map::bdev
  btrfs: drop bdev argument from submit_extent_page

 fs/btrfs/compression.c | 10 ----------
 fs/btrfs/disk-io.c     |  3 ---
 fs/btrfs/extent_io.c   | 15 +++------------
 fs/btrfs/extent_map.c  |  6 +++++-
 fs/btrfs/extent_map.h  | 11 ++---------
 fs/btrfs/file-item.c   |  1 -
 fs/btrfs/file.c        |  3 ---
 fs/btrfs/inode.c       | 14 ++++----------
 fs/btrfs/relocation.c  |  2 --
 9 files changed, 14 insertions(+), 51 deletions(-)

-- 
2.23.0

