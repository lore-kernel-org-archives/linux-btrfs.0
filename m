Return-Path: <SRS0=+tro=YL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90458CA9EA0
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Oct 2019 09:58:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7193F222BD
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Oct 2019 09:58:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405530AbfJRJ6l (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 18 Oct 2019 05:58:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:40238 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388377AbfJRJ6l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Oct 2019 05:58:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2E77BB579;
        Fri, 18 Oct 2019 09:58:40 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 0/4] Small coding style cleanups
Date:   Fri, 18 Oct 2019 11:58:19 +0200
Message-Id: <20191018095823.15282-1-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Here are some minor coding style cleanups which I think are neat as they make
some functions a bit easier to read.

None of these patches is really needed though.

The patches have no regressions with regrads to the basline
btrfs-devel/misc-next on an xfstests -g auto run.

A gitweb preview can be found at
https://git.kernel.org/pub/scm/linux/kernel/git/jth/linux.git/log/?h=btrfs-raid-cleanups

Note I did rebase the branch because one patch did not have a changelog.

Johannes Thumshirn (4):
  btrfs: reduce indentation in lock_stripe_add
  btrfs: remove pointless local variable in lock_stripe_add()
  btrfs: reduce indentation in btrfs_may_alloc_data_chunk
  btrfs: remove pointless indentation in btrfs_read_sys_array()

 fs/btrfs/raid56.c  |  95 ++++++++++++++++++++++-----------------------
 fs/btrfs/volumes.c | 112 +++++++++++++++++++++++++++--------------------------
 2 files changed, 103 insertions(+), 104 deletions(-)

-- 
2.16.4

