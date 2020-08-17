Return-Path: <SRS0=Bqu+=B3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D4C7C433DF
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Aug 2020 12:12:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62DA62072E
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Aug 2020 12:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgHQMMi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 08:12:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:57080 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbgHQMMi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Aug 2020 08:12:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 42F91AD60;
        Mon, 17 Aug 2020 12:13:02 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E8F1BDA6EF; Mon, 17 Aug 2020 14:11:32 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 0/5] Misc warning fixes
Date:   Mon, 17 Aug 2020 14:11:32 +0200
Message-Id: <cover.1597666167.git.dsterba@suse.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Compiling with W=1 or W=2 gives warnings that seem to be worth fixing.

David Sterba (5):
  btrfs: remove const from btrfs_feature_set_name
  btrfs: compression: move declarations to header
  btrfs: remove unnecessarily shadowed variables
  btrfs: scrub: rename ratelimit state varaible to avoid shadowing
  btrfs: send: remove indirect callback parameter for changed_cb

 fs/btrfs/backref.c     |  1 -
 fs/btrfs/compression.c | 35 -----------------------------------
 fs/btrfs/compression.h | 35 +++++++++++++++++++++++++++++++++++
 fs/btrfs/inode.c       |  1 -
 fs/btrfs/scrub.c       |  8 ++++----
 fs/btrfs/send.c        | 11 ++---------
 fs/btrfs/sysfs.c       |  2 +-
 fs/btrfs/sysfs.h       |  2 +-
 8 files changed, 43 insertions(+), 52 deletions(-)

-- 
2.25.0

