Return-Path: <SRS0=dhPA=NU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FBE2C43441
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 14:08:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A82A20825
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 14:08:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1A82A20825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbeKIXt1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 9 Nov 2018 18:49:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:49788 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728682AbeKIXt0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Nov 2018 18:49:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9E4EBADD6
        for <linux-btrfs@vger.kernel.org>; Fri,  9 Nov 2018 14:08:40 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCHv2 0/9] Removal of optionsl extent_io_ops callbacks 
Date:   Fri,  9 Nov 2018 16:08:29 +0200
Message-Id: <20181109140838.10457-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Here is the 2nd revision of the extent_io_ops optinal callbacks removal. What 
prompted this version was that I identified a flaw in the initial version - while
it did check for the presence of an inode in extent_io_tree::private_data, i 
forgot to explicitly check the ino to be different than the ino of the btree inode. 

While this doesn't lead to any corruption or risks at the moment it results in 
additional operation being performed on the btree inode io_tree. 

This is now fixed by introducing a new function in the first patch and changing
everything that follows to utilize it in addition to the presence of ->private_data

Testing with xfstests didn't uncover any regressions so this series should be 
good to replace the on in misc-next. 

Nikolay Borisov (9):
  btrfs: Add function to distinguish between data and btree inode
  btrfs: Remove extent_io_ops::fill_delalloc
  btrfs: Remove extent_io_ops::writepage_start_hook
  btrfs: Remove extent_io_ops::writepage_end_io_hook
  btrfs: Remove extent_io_ops::check_extent_io_range callback
  btrfs: Remove extent_io_ops::set_bit_hook extent_io callback
  btrfs: Remove extent_io_ops::clear_bit_hook callback
  btrfs: Remove extent_io_ops::merge_extent_hook callback
  btrfs: Remove extent_io_ops::split_extent_hook callback

 fs/btrfs/btrfs_inode.h           |   5 ++
 fs/btrfs/compression.c           |  11 +--
 fs/btrfs/ctree.h                 |  14 +++
 fs/btrfs/extent_io.c             | 141 +++++++++++++------------------
 fs/btrfs/extent_io.h             |  24 ------
 fs/btrfs/inode.c                 |  91 +++++++-------------
 fs/btrfs/tests/extent-io-tests.c |   2 +-
 7 files changed, 113 insertions(+), 175 deletions(-)

-- 
2.17.1

