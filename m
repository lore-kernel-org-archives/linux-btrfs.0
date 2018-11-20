Return-Path: <SRS0=yZnd=N7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D84CC18DF5
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 12:51:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41A1A20831
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 12:51:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 41A1A20831
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbeKTXUR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 20 Nov 2018 18:20:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:44652 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727836AbeKTXUR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Nov 2018 18:20:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 97A20AF95
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 12:51:17 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6C0FCDA78B; Tue, 20 Nov 2018 13:50:56 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 0/4] Replace custom device-replace locking with rwsem
Date:   Tue, 20 Nov 2018 13:50:54 +0100
Message-Id: <cover.1542717531.git.dsterba@suse.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The first cleanup part went to 4.19, the actual switch from the custom
locking to rswem was postponed as I found performance degradation. This
turned out to be related to VM cache settings, so I'm resending the
series again.

The custom locking is based on rwlock protected reader/writer counters,
waitqueues, which essentially is what the readwrite semaphore does.

Previous patchset:
https://lore.kernel.org/linux-btrfs/cover.1536331604.git.dsterba@suse.com/

Patches correspond to 8/11-11/11 and there's no change besides
refreshing on top of current misc-next.

David Sterba (4):
  btrfs: reada: reorder dev-replace locks before radix tree preload
  btrfs: dev-replace: swich locking to rw semaphore
  btrfs: dev-replace: remove custom read/write blocking scheme
  btrfs: dev-replace: open code trivial locking helpers

 fs/btrfs/ctree.h       |  4 +-
 fs/btrfs/dev-replace.c | 97 ++++++++++++++----------------------------
 fs/btrfs/dev-replace.h |  5 ---
 fs/btrfs/disk-io.c     |  4 +-
 fs/btrfs/reada.c       | 16 ++++---
 fs/btrfs/scrub.c       | 15 ++++---
 fs/btrfs/volumes.c     | 27 ++++++------
 7 files changed, 63 insertions(+), 105 deletions(-)

-- 
2.19.1

