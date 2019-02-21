Return-Path: <SRS0=uD29=Q4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1877C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Feb 2019 11:57:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C94012084F
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Feb 2019 11:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727625AbfBUL5U (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 21 Feb 2019 06:57:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:48442 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726165AbfBUL5U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Feb 2019 06:57:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9DCD6AD3B
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Feb 2019 11:57:19 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v3 0/6] Compress path cleanups
Date:   Thu, 21 Feb 2019 13:57:11 +0200
Message-Id: <20190221115717.5128-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Another day, another revision, hopefully this is the last one. 

 Changes since v2: 

 * Reworked patch 1 and made async_cow be the top-level context struct and each
 chunk is tracked by async_chunk. This cleansup the pointer gymnastics I was 
 doing in the previous version (Johannes)
 
 * Reworded changelogs in various patches to reflect the usage of async_chunk.

 * Fixed changelog in patch2 to properly reflect fs_info is referenced from 
 btrfs_work (Johannes)
  
 * Added Reviwed-by to patches 4/5/6

 Changes since v1:

 * Fixed error handling in patch 1 - now properly cleanup on failure.
 * Fixed subject of patch 3
 * Added patches 4/5 as minor cleanups to the code.

Nikolay Borisov (6):
  btrfs: Refactor cow_file_range_async
  btrfs: Remove fs_info from struct async_chunk
  btrfs: Make compress_file_range take only struct async_chunk
  btrfs: Replace clear_extent_bit with unlock_extent
  btrfs: Set iotree only once in submit_compressed_extents
  btrfs: Factor out common extent locking code in
    submit_compressed_extents

 fs/btrfs/inode.c | 148 +++++++++++++++++++++++++++--------------------
 1 file changed, 84 insertions(+), 64 deletions(-)

-- 
2.17.1

