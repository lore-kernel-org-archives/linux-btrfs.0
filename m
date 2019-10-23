Return-Path: <SRS0=avBk=YQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C59DCA9EB6
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Oct 2019 08:50:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDDC721920
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Oct 2019 08:50:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390605AbfJWIu4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Oct 2019 04:50:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:37882 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390394AbfJWIuz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Oct 2019 04:50:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F310EB1D62
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Oct 2019 08:50:52 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: trim: Fix a bug certain range may not be trimmed properly
Date:   Wed, 23 Oct 2019 16:50:35 +0800
Message-Id: <20191023085037.14838-1-wqu@suse.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There is a bug report about discard mount option not trimming some range
properly, and causing unexpected space usage for thin device.

It turns out to be that, if there are pinned extents across block group
boundary, we will only trim to the end of current block group, skipping
the remaining.

This patchset will fix it by ensuring btrfs_discard_extent() will
iterate the full range before exiting.

Meanwhile I'm still looking into how to craft such test case for btrfs,
so the test case may be late for several days.

Qu Wenruo (2):
  btrfs: volumes: Return the mapped length for discard
  btrfs: extent-tree: Ensure we trim ranges across block group boundary

 fs/btrfs/extent-tree.c | 40 ++++++++++++++++++++++++++++++----------
 fs/btrfs/volumes.c     |  8 +++++---
 2 files changed, 35 insertions(+), 13 deletions(-)

-- 
2.23.0

