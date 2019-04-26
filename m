Return-Path: <SRS0=BNt3=S4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2801AC43218
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 11:19:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0272F206C1
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 11:19:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbfDZLTj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Apr 2019 07:19:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:49472 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725901AbfDZLTj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Apr 2019 07:19:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1FFADAC10;
        Fri, 26 Apr 2019 11:19:38 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id EEC94DA847; Fri, 26 Apr 2019 13:20:41 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     torvalds@linux-foundation.org
Cc:     David Sterba <dsterba@suse.com>, clm@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fix for 5.1-rc7
Date:   Fri, 26 Apr 2019 13:20:36 +0200
Message-Id: <cover.1556276662.git.dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

one patch to fix a crash in io submission path, due to memory allocation
errors. In short, the multipage bio work that landed in 5.1 caused
larger bios that in turn require larger temporary memory for checksums.
The patch is a workaround, we're going to rework the allocation so it
does not require the vmalloc fallback.

It took a while to identify that it's caused by patches in 5.1 and not a
patchset that did some changes in error handling in the code. I've
tested it on various memory/cpu combinations, it could hit OOM but does
not crash.

The timestamp of the patch is less than a day due to updates in the
changelog, tests were running meanwhile.

Please pull, thanks.

----------------------------------------------------------------
The following changes since commit 272e5326c7837697882ce3162029ba893059b616:

  btrfs: prop: fix vanished compression property after failed set (2019-04-04 17:57:53 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.1-rc6-tag

for you to fetch changes up to a3d46aea46f99d134b4e0726e4826b824c3e5980:

  btrfs: Switch memory allocations in async csum calculation path to kvmalloc (2019-04-25 14:17:38 +0200)

----------------------------------------------------------------
Nikolay Borisov (1):
      btrfs: Switch memory allocations in async csum calculation path to kvmalloc

 fs/btrfs/file-item.c    | 15 +++++++++++----
 fs/btrfs/ordered-data.c |  3 ++-
 2 files changed, 13 insertions(+), 5 deletions(-)
