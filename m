Return-Path: <SRS0=hUT/=SD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E2EAC43381
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 05:55:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4818A20850
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 05:55:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbfDAFz4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Apr 2019 01:55:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:54318 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725860AbfDAFz4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Apr 2019 01:55:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1C66FACBF
        for <linux-btrfs@vger.kernel.org>; Mon,  1 Apr 2019 05:55:55 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/7] btrfs: check: Check and repair invalid free space cahce inode mode
Date:   Mon,  1 Apr 2019 13:55:44 +0800
Message-Id: <20190401055551.6837-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patchset can be fetched from github:
https://github.com/adam900710/btrfs-progs/tree/free_space_cache_imode_fix
Which is based on v4.20.2 tag.

There is a minor problem reported in mail list where invalid inode mode
(0) can sneak into free space cache inodes:
        item 9 key (256 INODE_ITEM 0) itemoff 13702 itemsize 160
                generation 30 transid 30 size 65536 nbytes 1507328
                block group 0 mode 0 links 1 uid 0 gid 0 rdev 0
                sequence 23 flags 0x1b(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
                atime 0.0 (1970-01-01 08:00:00)
                ctime 1553491158.189771625 (2019-03-25 13:19:18)
                mtime 0.0 (1970-01-01 08:00:00)
                otime 0.0 (1970-01-01 08:00:00)

Kernel free space cache code doesn't realy care about the inode mode,
but tree-checker inode item checker cares and will report this as big
problem, rejecting the image.

I didn't see any reason to make inode item checker any less strict, as
there is already fuzzed image can break kernel using invalid inode mode.

So here I just enhance btrfs-progs before strict inode item checker
lands.

Next time when users report kernel rejecting previously valid fs, they
should have a way to fix it in btrfs-progs.

Changelog:
v2:
- Minor refactor to make common code more common.

Qu Wenruo (7):
  btrfs-progs: check/lowmem: Add inode mode check
  btrfs-progs: check/original: Add inode mode check
  btrfs-progs: check/lowmem: Repair invalid inode mode in root tree
  btrfs-progs: check/original: Repair invalid inode mode in root tree
  btrfs: check/lowmem: Check and repair free space cache inode mode
  btrfs: check/original: Check and repair free space cache inode item
  btrfs: tests/fsck: Add test image for free space cache mode repair

 check/main.c                                  |  42 ++++++
 check/mode-common.c                           | 129 ++++++++++++++++++
 check/mode-common.h                           |  29 ++++
 check/mode-lowmem.c                           |  22 +++
 check/mode-lowmem.h                           |   3 +
 check/mode-original.h                         |   1 +
 .../test.raw.xz                               | Bin 0 -> 159128 bytes
 7 files changed, 226 insertions(+)
 create mode 100644 tests/fsck-tests/038-bad-free-space-cache-inode-mode/test.raw.xz

-- 
2.21.0

