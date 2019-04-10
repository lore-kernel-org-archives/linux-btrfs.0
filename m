Return-Path: <SRS0=M5aM=SM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D76E4C282CE
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 14:24:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A758320854
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 14:24:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732721AbfDJOYr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Apr 2019 10:24:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:40148 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732673AbfDJOYr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Apr 2019 10:24:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 71039ABE9
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Apr 2019 14:24:45 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/6] Simplifications around submit_bio_hook
Date:   Wed, 10 Apr 2019 17:24:37 +0300
Message-Id: <20190410142443.6470-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I've been taking a look at the submit_bio_hook et al  and I saw some
opportunities for improvement. First I begin by simplifying the definition of 
submit_bio_hook callback and making one of its arguments explicit. 

Patch 3 removes a redundant extent_io_tree argument that was passed through 
several layers of functions and ultimately made it somewhat cumbersome to reason
what extent_io_tree is being used. 

Patch 4 and 5 hardcode a 0 being passed  for the bio_offset parameter to
btrfs_submit_bio_start/btree_submit_bio_start since it only matters for DIO. 

Patch 6 finally does away with the bio_offset parameter of submit_bio_hook. 

Here is the output of bloat-o-meter for posterity:

add/remove: 0/0 grow/shrink: 4/7 up/down: 48/-319 (-271)
Function                                     old     new   delta
read_extent_buffer_pages                     784     822     +38
btrfs_add_ordered_sum                        100     104      +4
btrfs_submit_bio_hook                        364     367      +3
btree_submit_bio_hook                        175     178      +3
end_bio_extent_readpage                     2119    2116      -3
btrfs_reloc_clone_csums                      272     262     -10
btrfs_csum_one_bio                          1358    1348     -10
btree_read_extent_buffer_pages               282     272     -10
readahead_tree_block                          73      55     -18
reada_tree_block_flagged                     194     165     -29
submit_one_bio                               313      74    -239
Total: Before=1072719, After=1072448, chg -0.03%

Nikolay Borisov (6):
  btrfs: Define submit_bio_hook's type directly
  btrfs: Change submit_bio_hook to taking an inode directly
  btrfs: Remove 'tree' argument from read_extent_buffer_pages
  btrfs: Pass 0 for bio_offset to btrfs_wq_submit_bio
  btrfs: Always pass 0 bio_offset for btree_submit_bio_start
  btrfs: Remove bio_offset argument from submit_bio_hook

 fs/btrfs/disk-io.c   | 22 +++++++---------------
 fs/btrfs/extent_io.c | 10 ++++------
 fs/btrfs/extent_io.h |  9 +++------
 fs/btrfs/inode.c     | 11 +++++------
 4 files changed, 19 insertions(+), 33 deletions(-)

-- 
2.17.1

