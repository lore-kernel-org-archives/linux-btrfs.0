Return-Path: <SRS0=iUkD=SG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 826A3C4360F
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 03:47:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FD47214AF
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 03:47:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbfDDDrO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Apr 2019 23:47:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:37276 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726833AbfDDDrO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 Apr 2019 23:47:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4614BAE7A
        for <linux-btrfs@vger.kernel.org>; Thu,  4 Apr 2019 03:47:13 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] Fixup and optimization for write time tree checker
Date:   Thu,  4 Apr 2019 11:47:06 +0800
Message-Id: <20190404034708.3399-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patchset can be fetched from github:
https://github.com/adam900710/linux/tree/tree_checker_testing

Which is based on misc-next, with the following commit as HEAD:
commit 56d46f96de92ec69963acb7b1d9aed83d2a56a7b (david/misc-next-with-write-checks, david/misc-next)
Author: Nikolay Borisov <nborisov@suse.com>
Date:   Wed Mar 27 14:24:18 2019 +0200

    btrfs: Switch btrfs_trim_free_extents to find_first_clear_extent_bit

These two patches changes the behavior of write time tree-checker, where
the initial patches didn't check the content of the leaf, leaving memory
bit flipping possible to sneak in.

This patchset also introduces a new optimization, where original empty
leaf owner check can be pretty expensive and cause false alerts for
write time tree checker.
With this new optimization, write time tree checker can reuse the
existing btrfs_check_leaf_full().

Qu Wenruo (2):
  btrfs: tree-checker: Remove comprehensive root owner check
  btrfs: Do mandatory tree block check before submitting bio

 fs/btrfs/disk-io.c      | 13 +++++++++++++
 fs/btrfs/tree-checker.c | 24 ------------------------
 2 files changed, 13 insertions(+), 24 deletions(-)

-- 
2.21.0

