Return-Path: <SRS0=vY8e=3T=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 780B5C33C9E
	for <linux-btrfs@archiver.kernel.org>; Thu, 30 Jan 2020 12:59:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E49720702
	for <linux-btrfs@archiver.kernel.org>; Thu, 30 Jan 2020 12:59:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbgA3M7s (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 30 Jan 2020 07:59:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:38338 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726873AbgA3M7s (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Jan 2020 07:59:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AB513AFB5;
        Thu, 30 Jan 2020 12:59:46 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/2] Refactor snapshot vs nocow writers locking
Date:   Thu, 30 Jan 2020 14:59:40 +0200
Message-Id: <20200130125945.7383-1-nborisov@suse.com>
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

