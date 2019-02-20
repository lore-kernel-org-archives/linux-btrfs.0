Return-Path: <SRS0=IJ3x=Q3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8D89C10F0B
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 15:11:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8082A2086D
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 15:11:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbfBTPLs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Feb 2019 10:11:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:55316 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726648AbfBTPLq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Feb 2019 10:11:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 59DB7B678
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Feb 2019 15:11:45 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2 0/6] Compressed path cleanups
Date:   Wed, 20 Feb 2019 17:11:37 +0200
Message-Id: <20190220151143.19057-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Here is v2 of the compressed path cleanups. The main objective was to remove 
the BUG_ON in cow_file_range_async. This has been achieved by pre-allocating 
an array large enough to hold all async_cow structs for the given range. In 
case this allocation fail we just unlock the range and error out the pages. 


Changes since v1: 

 * Fixed error handling in patch 1 - now properly cleanup on failure. 
 * Fixed subject of patch 3 
 * Added patches 4/5 as minor cleanups to the code. 

Nikolay Borisov (6):
  btrfs: Refactor cow_file_range_async
  btrfs: Remove fs_info from struct async_cow
  btrfs: Make compress_file_range take only struct async_cow
  btrfs: Replace clear_extent_bit with unlock_extent
  btrfs: Set iotree only once in submit_compressed_extents
  btrfs: Factor out common extent locking code in
    submit_compressed_extents

 fs/btrfs/inode.c | 129 +++++++++++++++++++++++++++--------------------
 1 file changed, 73 insertions(+), 56 deletions(-)

-- 
2.17.1

