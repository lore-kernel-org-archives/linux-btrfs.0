Return-Path: <SRS0=NB0J=UR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2AF9C31E5B
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Jun 2019 16:51:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD3392084B
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Jun 2019 16:51:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729892AbfFRQv2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 18 Jun 2019 12:51:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:35536 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729319AbfFRQv1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Jun 2019 12:51:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8B8A0ADF7;
        Tue, 18 Jun 2019 16:51:26 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id DC42EDA871; Tue, 18 Jun 2019 18:52:11 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     torvalds@linux-foundation.org
Cc:     David Sterba <dsterba@suse.com>, clm@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 5.2-rc6
Date:   Tue, 18 Jun 2019 18:52:07 +0200
Message-Id: <cover.1560875945.git.dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

please pull the following btrfs fixes:

- regression where properties stored as xattrs are not properly
  persisted

- a small readahead fix (the fstests testcase for that fix hangs on
  unpatched kernel, so we'd like get it merged to ease future testing)

- fix a race during block group creation and deletion

Thanks.

----------------------------------------------------------------
The following changes since commit 8103d10b71610aa65a65d6611cd3ad3f3bd7beeb:

  btrfs: Always trim all unallocated space in btrfs_trim_free_extents (2019-06-07 14:52:05 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.2-rc5-tag

for you to fetch changes up to 3763771cf60236caaf7ccc79cea244c63d7c49a0:

  Btrfs: fix failure to persist compression property xattr deletion on fsync (2019-06-17 16:37:17 +0200)

----------------------------------------------------------------
Filipe Manana (2):
      Btrfs: fix race between block group removal and block group allocation
      Btrfs: fix failure to persist compression property xattr deletion on fsync

Naohiro Aota (1):
      btrfs: start readahead also in seed devices

 fs/btrfs/extent-tree.c | 24 +++++++++++++-----------
 fs/btrfs/ioctl.c       |  2 --
 fs/btrfs/reada.c       |  5 +++++
 fs/btrfs/xattr.c       |  6 +++---
 4 files changed, 21 insertions(+), 16 deletions(-)
