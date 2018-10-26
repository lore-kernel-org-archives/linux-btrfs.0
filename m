Return-Path: <SRS0=9Rtw=NG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEA93ECDE44
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 11:43:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE5F9205F4
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 11:43:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE5F9205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbeJZUUK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Oct 2018 16:20:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:33528 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727462AbeJZUUK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Oct 2018 16:20:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 368C3ABDC
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Oct 2018 11:43:23 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/5] Misc cleanups in balance code
Date:   Fri, 26 Oct 2018 14:43:16 +0300
Message-Id: <1540554201-11305-1-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

While investigating the balance hang I came across various inconsistencies in 
the source. This series aims to fix those. 

The first patch is (I believe) a fix to a longstanding bug that could cause 
balance to fail due to ENOSPC. The code no properly ensures that there is 
at least 1g of unallocated space on every device being balance.

Patch 2 makes btrfs_can_relocate a bit more obvious and removes leftovers from 
previous cleanup

Patches 3/4/5 remove some redundant code from various functions. 

This series has survived multiple xfstest runs. 

Nikolay Borisov (5):
  btrfs: Ensure at least 1g is free for balance
  btrfs: Refactor btrfs_can_relocate
  btrfs: Remove superfluous check form btrfs_remove_chunk
  btrfs: Sink find_lock_delalloc_range's 'max_bytes' argument
  btrfs: Replace BUG_ON with ASSERT in find_lock_delalloc_range

 fs/btrfs/ctree.h                 |  2 +-
 fs/btrfs/extent-tree.c           | 39 ++++++++++++++-------------------------
 fs/btrfs/extent_io.c             | 13 ++++++-------
 fs/btrfs/extent_io.h             |  2 +-
 fs/btrfs/tests/extent-io-tests.c | 10 +++++-----
 fs/btrfs/volumes.c               | 17 +++++++----------
 6 files changed, 34 insertions(+), 49 deletions(-)

-- 
2.7.4

