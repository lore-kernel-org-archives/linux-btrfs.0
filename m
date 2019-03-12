Return-Path: <SRS0=uY43=RP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A567BC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 15:20:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76A892054F
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 15:20:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfCLPUg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Mar 2019 11:20:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:41116 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726255AbfCLPUg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Mar 2019 11:20:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2261AB69B
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2019 15:20:35 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v4 0/7] Compress path cleanups
Date:   Tue, 12 Mar 2019 17:20:23 +0200
Message-Id: <20190312152030.31987-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Here is the v4 of the compress path cleanups, this version  incorporates 
feeback from v3, namely: 

* Use struct_size when calculating the size of the struct to allocated in 
cow_file_range_async

* Reinstated the comment about ihold in cow_file_range_async

* Renamed "struct async_chunk *" variables from async_cow to async_chunk

* Gave patch 1 a more explicit title. 

* added RB tags from Johanness to patch 3 and 4

Nikolay Borisov (7):
  btrfs: Preallocate chunks in cow_file_range_async
  btrfs: Rename async_cow to async_chunk
  btrfs: Remove fs_info from struct async_chunk
  btrfs: Make compress_file_range take only struct async_chunk
  btrfs: Replace clear_extent_bit with unlock_extent
  btrfs: Set iotree only once in submit_compressed_extents
  btrfs: Factor out common extent locking code in
    submit_compressed_extents

 fs/btrfs/inode.c | 177 ++++++++++++++++++++++++++---------------------
 1 file changed, 100 insertions(+), 77 deletions(-)

-- 
2.17.1

