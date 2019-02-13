Return-Path: <SRS0=8r0n=QU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE0C0C282C2
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 15:55:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CFF1222E3
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 15:55:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391483AbfBMPzc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Feb 2019 10:55:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:44674 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729981AbfBMPzc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Feb 2019 10:55:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6F730AE15
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Feb 2019 15:55:31 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [RESEND PATCH 0/4] Cleanups around compress path
Date:   Wed, 13 Feb 2019 17:55:25 +0200
Message-Id: <20190213155529.31500-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This series aims to streamline the logic in cow_file_range_async which is 
invoked if extents have to be compressed. The main change is that the logic of 
the loop in the function is now centered around the idea of chunks (in case 
compression is enabled). So it's obvious that we will submit as many chunks as 
necessary. The 2nd improvement is to eliminate the BUG_ON that is dependent on the 
return value of kmalloc. Now, an array of struct async_cow is allocated, preceded 
by an atomic_t, shared by all chunks. This allows to bail out before submitting 
any io whatsoever and mark the page as errored out. 

Rest of the patches are pure quality-of-live improvements - simplifying function
signature, removing unused code/redundant data members. 
 
Needless to say this has survived full xfstest run. 

Nikolay Borisov (4):
  btrfs: Refactor cow_file_range_async
  btrfs: Remove fs_info from struct async_cow
  btrfs: Make compress_file_range only struct async_cow
  btrfs: Replace clear_extent_bit with unlock_extent

 fs/btrfs/inode.c | 105 +++++++++++++++++++++++++++--------------------
 1 file changed, 60 insertions(+), 45 deletions(-)

-- 
2.17.1

