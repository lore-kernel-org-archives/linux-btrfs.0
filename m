Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96499C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 10:16:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E9C020823
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 10:16:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbfBVKQw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 05:16:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:44568 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726083AbfBVKQw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 05:16:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F0C47B158;
        Fri, 22 Feb 2019 10:16:50 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     dan.carpenter@oracle.com
Subject: [PATCH 0/5] Unify the return value of alloc/clone_extent_buffer()
Date:   Fri, 22 Feb 2019 18:16:39 +0800
Message-Id: <20190222101645.4403-1-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patchset can be fetched from github:
https://github.com/adam900710/linux/tree/cleanup_alloc_extent_buffer
Which is based on v5.0-rc7

There are 5 extent buffer alloc functions in btrfs:
__alloc_extent_buffer();
alloc_extent_buffer();
__alloc_dummy_extent_buffer();
alloc_dummy_extent_buffer();
alloc_test_extent_buffer();

However their return value is not unified for failure mode:
__alloc_extent_buffer()		Never fail
alloc_extent_buffer()		PTR_ERR()
__alloc_dummy_extent_buffer()	NULL
alloc_dummy_extent_buffer()	NULL
alloc_test_extent_buffer()	NULL

This causes some wrapper function to have 2 failure modes, like
btrfs_find_create_tree_block() can return NULL or PTR_ERR(-ENOMEM) for
its failure.

This inconsistent behavior is making static checker and reader crazy.

This patchset will unify the failure more of above 5 functions to
PTR_ERR().

Qu Wenruo (5):
  btrfs: extent_io: Add comment about the return value of
    alloc_extent_buffer()
  btrfs: extent_io: Unify the return value of __alloc_extent_buffer()
    with alloc_extent_buffer()
  btrfs: extent_io: Unify the return value of
    alloc_dummy_extent_buffer() with alloc_extent_buffer()
  btrfs: extent_io: Unify the return value of alloc_test_extent_buffer()
    with alloc_extent_buffer()
  btrfs: extent_io: Unify the return value of
    btrfs_clone_extent_buffer() with alloc_extent_buffer()

 fs/btrfs/backref.c                     |  8 ++--
 fs/btrfs/ctree.c                       | 16 ++++----
 fs/btrfs/extent_io.c                   | 56 +++++++++++++++++---------
 fs/btrfs/qgroup.c                      |  5 ++-
 fs/btrfs/tests/extent-buffer-tests.c   |  6 ++-
 fs/btrfs/tests/extent-io-tests.c       |  4 +-
 fs/btrfs/tests/free-space-tree-tests.c |  3 +-
 fs/btrfs/tests/inode-tests.c           |  6 ++-
 fs/btrfs/tests/qgroup-tests.c          |  3 +-
 9 files changed, 68 insertions(+), 39 deletions(-)

-- 
2.20.1

