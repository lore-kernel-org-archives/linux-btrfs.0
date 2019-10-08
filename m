Return-Path: <SRS0=GeaY=YB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7436FC4360C
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Oct 2019 04:49:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D4AA206C2
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Oct 2019 04:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729650AbfJHEtl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Oct 2019 00:49:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:33582 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729489AbfJHEtl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Oct 2019 00:49:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BDFF7AE35
        for <linux-btrfs@vger.kernel.org>; Tue,  8 Oct 2019 04:49:39 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/7] btrfs-progs: Support for BG_TREE feature
Date:   Tue,  8 Oct 2019 12:49:29 +0800
Message-Id: <20191008044936.157873-1-wqu@suse.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patchset can be fetched from github:
https://github.com/adam900710/btrfs-progs/tree/bg_tree
Which is based on v5.2.2 tag.

This patchset provides the needed user space infrastructure for BG_TREE
feature.

Since it's an new incompatible feature, unlike SKINNY_METADATA, btrfs-progs
is needed to convert existing fs (unmounted) to new format.

Now btrfstune can convert regular extent tree fs to bg tree fs to
improve mount time.

For the performance improvement, please check the kernel patchset cover
letter or the last patch.
(SPOILER ALERT: It's super fast)

Changelog:
v2:
- Rebase to v5.2.2 tag
- Add btrfstune ability to convert existing fs to BG_TREE feature

Qu Wenruo (7):
  btrfs-progs: Refactor excluded extent functions to use fs_info
  btrfs-progs: Refactor btrfs_read_block_groups()
  btrfs-progs: Enable read-write ability for 'bg_tree' feature
  btrfs-progs: mkfs: Introduce -O bg-tree
  btrfs-progs: dump-tree/dump-super: Introduce support for bg tree
  btrfs-progs: check: Introduce support for bg-tree feature
  btrfs-progs: btrfstune: Allow to enable bg-tree feature offline

 Documentation/btrfstune.asciidoc |   6 +
 btrfstune.c                      |  44 +++-
 check/main.c                     |   7 +-
 check/mode-lowmem.c              |   9 +-
 cmds/inspect-dump-super.c        |   3 +-
 cmds/inspect-dump-tree.c         |   5 +
 common/fsfeatures.c              |   6 +
 ctree.h                          |  18 +-
 disk-io.c                        |  29 ++-
 extent-tree.c                    | 364 +++++++++++++++++++++++--------
 mkfs/common.c                    |   6 +-
 mkfs/main.c                      |   9 +
 print-tree.c                     |   3 +
 transaction.c                    |   1 +
 14 files changed, 402 insertions(+), 108 deletions(-)

-- 
2.23.0

