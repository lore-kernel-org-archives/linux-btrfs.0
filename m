Return-Path: <SRS0=DppP=NM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED3AC0044C
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 12:09:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 859A020657
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 12:09:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 859A020657
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728459AbeKAVMi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 1 Nov 2018 17:12:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:45974 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728326AbeKAVMi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Nov 2018 17:12:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EB93CABCE
        for <linux-btrfs@vger.kernel.org>; Thu,  1 Nov 2018 12:09:55 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/8] Removal of optional hooks from struct extent_io_ops
Date:   Thu,  1 Nov 2018 14:09:45 +0200
Message-Id: <1541074194-22227-1-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

extent_io_ops has a set of 8 optional hooks which are set only for data and 
freespace inodes. The majority of them actually deal with delallocs in one way 
or another. Inspecting the code it transpired that there is actually no need to
have them as function pointers in a structure. Data/freespace inodes can easily
be distinguished from the btree_inode (which is pending removal anyway) by 
inspecting extent_io_tree::private_data. This member is set by all data/freespace
inodes. This series exploits this fact to remove the majority of them. Others, 
such as fill_delalloc, writepage_start_hook and writepage_end_io_hook are always
called from the data writeout path and can be directly called without having to
check whether the respective pointers are set. 

This series has undergone multiple xfstest runs and no regressions were 
identified. Additionally all but run_delalloc_range functions are given more 
descriptive names, related to their actual intent. 

Nikolay Borisov (8):
  btrfs: Remove extent_io_ops::fill_delalloc
  btrfs: Remove extent_io_ops::writepage_start_hook
  btrfs: Remove extent_io_ops::writepage_end_io_hook
  btrfs: Remove extent_io_ops::check_extent_io_range callback
  btrfs: Remove extent_io_ops::set_bit_hook extent_io callback
  btrfs: Remove extent_io_ops::clear_bit_hook callback
  btrfs: Remove extent_io_ops::merge_extent_hook callback
  btrfs: Remove extent_io_ops::split_extent_hook callback

 fs/btrfs/compression.c           |  11 ++--
 fs/btrfs/ctree.h                 |  15 +++++
 fs/btrfs/extent_io.c             | 131 +++++++++++++++++----------------------
 fs/btrfs/extent_io.h             |  24 -------
 fs/btrfs/inode.c                 |  86 +++++++++----------------
 fs/btrfs/tests/extent-io-tests.c |   2 +-
 6 files changed, 105 insertions(+), 164 deletions(-)

-- 
2.7.4

