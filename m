Return-Path: <SRS0=rID9=UF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D958CC04AB5
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Jun 2019 13:52:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDD4A20693
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Jun 2019 13:52:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbfFFNwY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Jun 2019 09:52:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:40314 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727522AbfFFNwX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Jun 2019 09:52:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 44DFEAF42;
        Thu,  6 Jun 2019 13:52:22 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, andrea.parri@amarulasolutions.com,
        peterz@infradead.org, paulmck@linux.ibm.com,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/2] Refactor snapshot vs nocow writers locking
Date:   Thu,  6 Jun 2019 16:52:17 +0300
Message-Id: <20190606135219.1086-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patchset first factors out the open code which essentially implements a 
lock that allows to have either multiple reader or multiple writers but not 
both. Then patch 2 just converts the code to using the newly introduced lock. 

The individual patch descriptions contain more information about the technical 
details and invariants that the lock provide. 

I have also CC'ed a copule of the maintainer of linux memory model since my 
patches just factor out the code and I would really like someone proficient 
enough in the usage/semantics of memory barries to review it as well. 

Nikolay Borisov (2):
  btrfs: Implement DRW lock
  btrfs: convert snapshot/nocow exlcusion to drw lock

 fs/btrfs/Makefile      |  2 +-
 fs/btrfs/ctree.h       | 10 ++----
 fs/btrfs/disk-io.c     | 39 ++---------------------
 fs/btrfs/drw_lock.c    | 71 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/drw_lock.h    | 23 ++++++++++++++
 fs/btrfs/extent-tree.c | 35 ---------------------
 fs/btrfs/file.c        | 12 +++----
 fs/btrfs/inode.c       |  8 ++---
 fs/btrfs/ioctl.c       | 10 ++----
 9 files changed, 114 insertions(+), 96 deletions(-)
 create mode 100644 fs/btrfs/drw_lock.c
 create mode 100644 fs/btrfs/drw_lock.h

-- 
2.17.1

