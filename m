Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4699FC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 19:53:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0533620873
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 19:53:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0533620873
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbeK1Gwz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 01:52:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:35204 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725764AbeK1Gwz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 01:52:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 07D21ABE6
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 19:53:55 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CA3EBDAC3A; Tue, 27 Nov 2018 20:53:38 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 0/9] Switch defines to enums
Date:   Tue, 27 Nov 2018 20:53:38 +0100
Message-Id: <cover.1543348078.git.dsterba@suse.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is motivated by a merging mistake that happened a few releases ago.
Two patches updated BTRFS_FS_* flags independently to the same value,
git did not see any direct merge conflict. The two values got mixed at
runtime and caused crash.

Update all #define sequential values, the above merging problem would
not happen as there would be a conflict and the enum value
auto-increment would prevent duplicated values anyway.

David Sterba (9):
  btrfs: switch BTRFS_FS_STATE_* to enums
  btrfs: switch BTRFS_BLOCK_RSV_* to enums
  btrfs: switch BTRFS_FS_* to enums
  btrfs: switch BTRFS_ROOT_* to enums
  btrfs: swtich EXTENT_BUFFER_* to enums
  btrfs: switch EXTENT_FLAG_* to enums
  btrfs: switch BTRFS_*_LOCK to enums
  btrfs: switch BTRFS_ORDERED_* to enums
  btrfs: drop extra enum initialization where using defaults

 fs/btrfs/btrfs_inode.h  |   2 +-
 fs/btrfs/ctree.h        | 168 ++++++++++++++++++++++------------------
 fs/btrfs/disk-io.h      |  10 +--
 fs/btrfs/extent_io.h    |  28 ++++---
 fs/btrfs/extent_map.h   |  21 +++--
 fs/btrfs/locking.h      |  10 ++-
 fs/btrfs/ordered-data.h |  45 ++++++-----
 fs/btrfs/qgroup.h       |   2 +-
 fs/btrfs/sysfs.h        |   2 +-
 fs/btrfs/transaction.h  |  14 ++--
 10 files changed, 169 insertions(+), 133 deletions(-)

-- 
2.19.1

