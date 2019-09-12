Return-Path: <SRS0=o9HI=XH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91F8AC4CEC7
	for <linux-btrfs@archiver.kernel.org>; Thu, 12 Sep 2019 17:37:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70D632081B
	for <linux-btrfs@archiver.kernel.org>; Thu, 12 Sep 2019 17:37:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387758AbfILRhJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 12 Sep 2019 13:37:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:33424 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387431AbfILRhJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Sep 2019 13:37:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5DC0DAEF8;
        Thu, 12 Sep 2019 17:37:07 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 3B506DA835; Thu, 12 Sep 2019 19:37:28 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     torvalds@linux-foundation.org
Cc:     David Sterba <dsterba@suse.com>, clm@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Last btrfs fixes for 5.3
Date:   Thu, 12 Sep 2019 19:37:26 +0200
Message-Id: <cover.1568307806.git.dsterba@suse.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

there are two fixes, one of them urgent fixing a bug introduced in 5.2
and reported by many users. It took time to identify the root cause,
catching the 5.3 release is higly desired also to push the fix to 5.2
stable tree.

The bug is a mess up of return values after adding proper error handling
and honestly the kind of bug that can cause sleeping disorders until
it's caught. My appologies to everybody who was affected.

Summary of what could happen:

1) either a hang when committing a transaction, if this happens there's
   no risk of corruption, still the hang is very inconvenient and can't be
   resolved without a reboot

2) writeback for some btree nodes may never be started and we end up
   committing a transaction without noticing that, this is really serious
   and that will lead to the "parent transid verify failed" messages

Please pull, thanks.

----------------------------------------------------------------
The following changes since commit 07301df7d2fc220d3de5f7ad804dcb941400cb00:

  btrfs: trim: Check the range passed into to prevent overflow (2019-08-07 16:42:39 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.3-rc8-tag

for you to fetch changes up to 18dfa7117a3f379862dcd3f67cadd678013bb9dd:

  Btrfs: fix unwritten extent buffers and hangs on future writeback attempts (2019-09-12 13:37:25 +0200)

----------------------------------------------------------------
Filipe Manana (2):
      Btrfs: fix assertion failure during fsync and use of stale transaction
      Btrfs: fix unwritten extent buffers and hangs on future writeback attempts

 fs/btrfs/extent_io.c | 35 ++++++++++++++++++++++++++---------
 fs/btrfs/tree-log.c  | 16 ++++++++--------
 2 files changed, 34 insertions(+), 17 deletions(-)
