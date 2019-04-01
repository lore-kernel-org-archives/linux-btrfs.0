Return-Path: <SRS0=hUT/=SD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABBDFC43381
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 08:30:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84CA520857
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 08:30:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732010AbfDAIaC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Apr 2019 04:30:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:51628 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726206AbfDAIaC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Apr 2019 04:30:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8BC81AE78
        for <linux-btrfs@vger.kernel.org>; Mon,  1 Apr 2019 08:30:01 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/2] Preamture OOM fixes
Date:   Mon,  1 Apr 2019 11:29:56 +0300
Message-Id: <20190401082958.26470-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

David reported that following the async cow path refactoring that got into 
misc-next he started seeing premature OOM kills due to large page allocations 
(order 4). This was due to now the whole async context (alongisde ancillary 
structures, describing chunks) being allocated in a single kmalloc call. The 
first patch of this series aims to fix that by converting the kmalloc call to 
kvmalloc. This will have virtually no perfromance impact for small writes and 
for larger ones will fallback to vmalloc. 

However, while testing the first patch I observed BUG_ONs in the async
csum calculation path to trigger. This is clearly caused by the fact that 
the first patch introduces a fairly large memory allocation. Nevertheless, 
having large allocations in the csum path without a fallback to some sort of 
order 0 page allocation or at least graceful handling of memory errors is gross.
Patch 2 aims to rectify this by switching the allocation in btrfs_csum_one_bio
to using kvmalloc, giving greated chance for success. Even if patch 1 is ignored
nothing prevents the csum calculation to trigger the bug on depending on the memory 
usage/fragmentation of the server so IMO it's beneficial either ways.

Nikolay Borisov (2):
  btrfs: Use kvmalloc for allocating compressed path context
  btrfs: Switch memory allocations in async csum calculation path to
    kvmalloc

 fs/btrfs/file-item.c    | 15 +++++++++++----
 fs/btrfs/inode.c        |  9 +++++++--
 fs/btrfs/ordered-data.c |  3 ++-
 3 files changed, 20 insertions(+), 7 deletions(-)

-- 
2.17.1

