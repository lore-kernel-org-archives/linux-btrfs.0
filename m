Return-Path: <SRS0=NB0J=UR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AAAAC31E5B
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Jun 2019 17:59:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30454205F4
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Jun 2019 17:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729835AbfFRR7P (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 18 Jun 2019 13:59:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:45050 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729349AbfFRR7P (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Jun 2019 13:59:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 88B8CAEA1
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Jun 2019 17:59:13 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5184BDA871; Tue, 18 Jun 2019 20:00:01 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 0/6] Minor cleanups
Date:   Tue, 18 Jun 2019 20:00:00 +0200
Message-Id: <cover.1560880630.git.dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

A few misc cleanups selected from my other branche, all should be safe.

David Sterba (6):
  btrfs: use common helpers for eb leak messages
  btrfs: use common helpers for extent IO state insertion messages
  btrfs: drop default value assignments in enums
  btrfs: use raid_attr to adjust minimal stripe size in
    btrfs_calc_avail_data_space
  btrfs: use raid_attr for minimum stripe count in
    btrfs_calc_avail_data_space
  btrfs: lift bio_set_dev from bio allocation helpers

 fs/btrfs/compression.c | 12 ++++++++----
 fs/btrfs/extent-tree.c | 14 +++++++-------
 fs/btrfs/extent_io.c   | 23 ++++++++++++++---------
 fs/btrfs/extent_io.h   |  2 +-
 fs/btrfs/file.c        |  6 +++---
 fs/btrfs/super.c       | 15 +++++++--------
 6 files changed, 40 insertions(+), 32 deletions(-)

-- 
2.21.0

