Return-Path: <SRS0=LIGD=RL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36BD0C43381
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Mar 2019 07:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10E9C2081B
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Mar 2019 07:29:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbfCHH3f (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Mar 2019 02:29:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:33450 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726297AbfCHH3e (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Mar 2019 02:29:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A4045AF9C;
        Fri,  8 Mar 2019 07:29:33 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Yoon Jungyeon <jungyeon@gatech.edu>
Subject: [PATCH 0/3] btrfs: tree-checker: Enhancement and fixes for new fuzzed image report
Date:   Fri,  8 Mar 2019 15:29:26 +0800
Message-Id: <20190308072929.30863-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patchset can be fetched from:
https://github.com/adam900710/linux/tree/tree_checker_enhancement

The base branch write_time_tree_checker, the base commit is:
commit cb3ba69132a83d5e87f243dece5db09a022b0be7 (github/write_time_tree_checker, write_time_tree_checker)
Author: Qu Wenruo <wqu@suse.com>
Date:   Thu Jan 17 15:15:14 2019 +0800

    btrfs: Do mandatory tree block check before submitting bio


Yoon Jungyeon reported several fuzzed image screwing up btrfs.

3 of the reported images are mount panic and can be addressed by tree
checker enhancement and fix.

This patchset addresses those 3 mount panic by:
- Verify chunk items
  This merges the existing btrfs_check_chunk_valid() and apply it to all
  chunk items, both in super block syschunk array and all tree blocks.

- Verify dev item
  This could avoid NULL pointer workaround for seed dummy.

- Don't trigger comprehensive root owner check if tree root is not
  initialized yet

The remaining runtime problem needs extra inspection, and some isn't so
easy to fix by tree-checker alone.

Reported-by: Yoon Jungyeon <jungyeon@gatech.edu>

Qu Wenruo (3):
  btrfs: tree-checker: Verify chunk items
  btrfs: tree-checker: Verify dev item
  btrfs: tree-checker: Fix NULL pointer access for corrupted chunk root

 fs/btrfs/tree-checker.c | 242 +++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/tree-checker.h |   3 +
 fs/btrfs/volumes.c      | 103 +----------------
 fs/btrfs/volumes.h      |   9 ++
 4 files changed, 254 insertions(+), 103 deletions(-)

-- 
2.21.0

