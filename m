Return-Path: <SRS0=gdyl=Y4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8943CA9EA0
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Nov 2019 12:04:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE86E222C2
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Nov 2019 12:04:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728713AbfKDMEN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 07:04:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:44022 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728592AbfKDMEM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Nov 2019 07:04:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 53166AF7E
        for <linux-btrfs@vger.kernel.org>; Mon,  4 Nov 2019 12:04:11 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 0/7] 
Date:   Mon,  4 Nov 2019 20:03:54 +0800
Message-Id: <20191104120401.56408-1-wqu@suse.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patchset can be fetched from github:
https://github.com/adam900710/btrfs-progs/tree/skinny_bg_tree
Which is based on david/devel branch.
HEAD is:
bdb42fb63382e8aca6bd02fd04a28e415408d4ea (david/devel) btrfs-progs: tests: Test backup root retention logic

This patchset provides the needed user space infrastructure for
SKINNY_BG_TREE feature.

Since it's an new incompatible feature, unlike SKINNY_METADATA, btrfs-progs
is needed to convert existing fs (unmounted) to new format.
Or determined at mkfs time.

For the performance improvement, please check the kernel patchset cover
letter or the last patch.
(SPOILER ALERT: It's super-duper fast, even faster than regular bg tree)

The chanllege here is, even we have some patches merged into devel
branch, due to the change of definition of key->offset for block group
item, we have to refactor more functions to implement SKINNY_BG_TREE.

Qu Wenruo (7):
  btrfs-progs: check/lowmem: Lookup block group item in a seperate
    function
  btrfs-progs: Enable read-write ability for 'skinny_bg_tree' feature
  btrfs-progs: mkfs: Introduce -O skinny-bg-tree
  btrfs-progs: dump-tree/dump-super: Introduce support for skinny bg
    tree
  btrfs-progs: Refactor btrfs_new_block_group_record() to accept
    parameters directly
  btrfs-progs: check: Introduce support for bg-tree feature
  btrfs-progs: btrfstune: Allow to enable bg-tree feature offline

 Documentation/btrfstune.asciidoc |   6 +
 btrfsck.h                        |   4 +-
 btrfstune.c                      |  45 +++++-
 check/common.h                   |   4 +-
 check/main.c                     |  63 ++++++--
 check/mode-lowmem.c              | 137 ++++++++++++----
 cmds/inspect-dump-super.c        |   3 +-
 cmds/inspect-dump-tree.c         |   5 +
 cmds/rescue-chunk-recover.c      |   6 +-
 common/fsfeatures.c              |   6 +
 ctree.h                          |  18 ++-
 disk-io.c                        |  21 ++-
 extent-tree.c                    | 269 +++++++++++++++++++++++++++++--
 mkfs/common.c                    |   5 +-
 mkfs/main.c                      |  25 +++
 print-tree.c                     |   4 +
 transaction.c                    |   1 +
 17 files changed, 549 insertions(+), 73 deletions(-)

-- 
2.23.0

