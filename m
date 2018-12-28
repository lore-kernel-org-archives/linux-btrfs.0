Return-Path: <SRS0=VlvV=PF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6397C43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Dec 2018 08:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E2F320866
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Dec 2018 08:38:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731539AbeL1IiK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Dec 2018 03:38:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:34438 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726580AbeL1IiK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Dec 2018 03:38:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 53D77AB93
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Dec 2018 08:38:09 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/6] btrfs-progs: Support for BG_TREE feature
Date:   Fri, 28 Dec 2018 16:38:00 +0800
Message-Id: <20181228083806.3204-1-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patchset can be fetched from github:
https://github.com/adam900710/btrfs-progs/tree/bg_tree
The basis commit is:

commit 7d16a2b460182ee98c649533a6975b6e419c3d71
Author: Qu Wenruo <wqu@suse.com>
Date:   Thu Dec 27 13:49:18 2018 +0800

    btrfs-progs: Create uuid tree with proper contents

Which is further based on devel branch.

This patchset provides the needed user space infrastructure for BG_TREE
feature.

Since it's an new exclusive feature, unlike SKINNY_METADATA, btrfs-progs
is needed to convert existing fs (unmounted) to new format.

Although I have prepared the functionality, convert_to_bg_tree(), and
already uses it in mkfs, I haven't decided if I should put it under
btrfstune, as btrfstune isn't such offline convert tool.

If anyone has better idea on the new convert tool interface, I'm all
ears.

For the performance improvement, please check the kernel patchset cover
letter or the last patch.
(SPOILER ALERT: It's super fast)

Qu Wenruo (6):
  btrfs-progs: Refactor excluded extent functions to use fs_info
  btrfs-progs: Refactor btrfs_read_block_groups()
  btrfs-progs: Enable read-write ability for 'bg_tree' feature
  btrfs-progs: mkfs: Introduce -O bg-tree
  btrfs-progs: dump-tree/dump-super: Introduce support for bg tree
  btrfs-progs: check: Introduce support for bg-tree feature

 check/main.c              |   7 +-
 check/mode-lowmem.c       |   9 +-
 cmds-inspect-dump-super.c |   3 +-
 cmds-inspect-dump-tree.c  |   5 +
 ctree.h                   |  17 +-
 disk-io.c                 |  29 +++-
 extent-tree.c             | 326 +++++++++++++++++++++++++++-----------
 fsfeatures.c              |   6 +
 mkfs/common.c             |   7 +-
 mkfs/common.h             |   1 +
 mkfs/main.c               |  57 +++++++
 print-tree.c              |   3 +
 transaction.c             |   1 +
 13 files changed, 365 insertions(+), 106 deletions(-)

-- 
2.20.1

