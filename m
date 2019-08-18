Return-Path: <SRS0=wLzA=WO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7E5BC3A59F
	for <linux-btrfs@archiver.kernel.org>; Sun, 18 Aug 2019 11:58:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEDCD2183E
	for <linux-btrfs@archiver.kernel.org>; Sun, 18 Aug 2019 11:58:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbfHRL6Y (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 18 Aug 2019 07:58:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:44876 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725786AbfHRL6Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 18 Aug 2019 07:58:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E711DACEF;
        Sun, 18 Aug 2019 11:58:22 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 0AE76DABE0; Sun, 18 Aug 2019 13:58:49 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     torvalds@linux-foundation.org
Cc:     David Sterba <dsterba@suse.com>, clm@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 5.3-rc5
Date:   Sun, 18 Aug 2019 13:58:46 +0200
Message-Id: <cover.1566128979.git.dsterba@suse.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

please pull two fixes that pop during testing:

* fix for sysfs-related code that adds/removes block groups, warnings
  appear during several fstests in connection with sysfs updates in 5.3,
  the fix essentially replaces a workaround with scope NOFS and applies
  to 5.2-based branch too

* add sanity check of trim range

Thanks.

----------------------------------------------------------------
The following changes since commit a6d155d2e363f26290ffd50591169cb96c2a609e:

  Btrfs: fix deadlock between fiemap and transaction commits (2019-07-30 18:25:12 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.3-rc4-tag

for you to fetch changes up to 07301df7d2fc220d3de5f7ad804dcb941400cb00:

  btrfs: trim: Check the range passed into to prevent overflow (2019-08-07 16:42:39 +0200)

----------------------------------------------------------------
Filipe Manana (1):
      Btrfs: fix sysfs warning and missing raid sysfs directories

Qu Wenruo (1):
      btrfs: trim: Check the range passed into to prevent overflow

 fs/btrfs/ctree.h       |  4 ---
 fs/btrfs/disk-io.c     |  2 --
 fs/btrfs/extent-tree.c | 71 +++++++++++++++++++++++++-------------------------
 fs/btrfs/volumes.c     | 13 ---------
 4 files changed, 35 insertions(+), 55 deletions(-)
