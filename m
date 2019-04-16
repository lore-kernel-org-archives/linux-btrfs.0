Return-Path: <SRS0=AHcI=SS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C216C10F13
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 07:15:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 704102073F
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 07:15:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727424AbfDPHPb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Apr 2019 03:15:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:46196 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725865AbfDPHPa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Apr 2019 03:15:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B7082ACD0
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2019 07:15:29 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs-progs: Handle error properly in btrfs_commit_transaction()
Date:   Tue, 16 Apr 2019 15:15:23 +0800
Message-Id: <20190416071526.3576-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patchset can be fetched from github:
https://github.com/adam900710/btrfs-progs/tree/commit_failure_cleanup

This patchset will address the BUG_ON() triggered in fuzz-tests/003 and
fuzz-tests/009.

For proper error handling in btrfs_commit_transaction(), we need a way
to clean up per-transaction data properly.

Currently we only have delayed refs which are per-transaction, so
introduce a new function, btrfs_destroy_delayed_refs() to cleanup
delayed refs.

Now btrfs_commit_transaction() can error out gracefully with proper
cleanup.

Patch 1 and 2 are just some minor cleanups found when crafting the 3rd
patch.

Qu Wenruo (3):
  btrfs-progs: Remove the dead branch in btrfs_run_delayed_refs()
  btrfs-progs: Refactor btrfs_finish_extent_commit()
  btrfs-progs: Handle error properly in btrfs_commit_transaction()

 ctree.h       |  4 +---
 delayed-ref.c | 24 ++++++++++++++++++++++++
 delayed-ref.h |  5 +++++
 extent-tree.c | 22 +++++++++-------------
 transaction.c | 23 +++++++++++++++--------
 5 files changed, 54 insertions(+), 24 deletions(-)

-- 
2.21.0

