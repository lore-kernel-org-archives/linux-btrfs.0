Return-Path: <SRS0=4fXr=V6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AB0FC433FF
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Aug 2019 13:39:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68F4820679
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Aug 2019 13:39:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391589AbfHBNj2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 2 Aug 2019 09:39:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:59928 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725886AbfHBNj2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Aug 2019 09:39:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4D7DDB62C
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Aug 2019 13:39:27 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1D0EFDADC0; Fri,  2 Aug 2019 15:40:01 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 00/13] Sysfs cleanups
Date:   Fri,  2 Aug 2019 15:40:00 +0200
Message-Id: <cover.1564752900.git.dsterba@suse.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Handful of almost trivial changes that clean up the sysfs structures and
helpers so the sysfs-related api is used only inside sysfs.c and that
the API facing btrfs is minimized.

David Sterba (13):
  btrfs: move sysfs declarations out of ctree.h
  btrfs: move btrfs_add_raid_kobjects to sysfs.c
  btrfs: factor sysfs code out of link_block_group
  btrfs: sysfs: unexport btrfs_raid_ktype
  btrfs: factor out sysfs code for creating space infos
  btrfs: sysfs: unexport space_info_ktype
  btrfs: sysfs: replace direct access to feature set names with a helper
  btrfs: factor out sysfs code for sending device uevent
  btrfs: factor out sysfs code for deleting block group and space infos
  btrfs: factor out sysfs code for updating sprout fsid
  btrfs: cleanup kobject.h includes
  btrfs: sysfs: move helper macros to sysfs.c
  btrfs: sysfs: move type conversion helpers to sysfs.c

 fs/btrfs/ctree.h       |  15 ---
 fs/btrfs/extent-tree.c |  59 +----------
 fs/btrfs/ioctl.c       |   2 +-
 fs/btrfs/space-info.c  |  25 +----
 fs/btrfs/super.c       |   1 +
 fs/btrfs/sysfs.c       | 217 ++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/sysfs.h       |  80 +++------------
 fs/btrfs/volumes.c     |  25 +----
 8 files changed, 238 insertions(+), 186 deletions(-)

-- 
2.22.0

