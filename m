Return-Path: <SRS0=//O4=VC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F36CC5B57D
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Jul 2019 07:27:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7832218BA
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Jul 2019 07:27:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbfGEH1D (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Jul 2019 03:27:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:58638 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725863AbfGEH1D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Jul 2019 03:27:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 10DB9AFCB
        for <linux-btrfs@vger.kernel.org>; Fri,  5 Jul 2019 07:27:02 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/5] btrfs-progs: tests: Make 64K page size system happier
Date:   Fri,  5 Jul 2019 15:26:46 +0800
Message-Id: <20190705072651.25150-1-wqu@suse.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Since I got another rockpro64, finally I could do some tests with
aarch64 64K page size mode. (The first board is working as a NAS for
a while)

Unsurprisingly there are several false test alerts in btrfs-progs
selftests.

Although there is no existing CI service based on 64K page sized system,
we'd better support for 64K page size as it's easier and easier to get
SBC with good enough aarch64 SoC to compile kernel/btrfs-progs and run
various tests on them.

The first patch fix a bug which mkfs can't accept any sector size on 64K
page size system.

The remaining patches enhance test cases to make them work on 64K page
size system (skip those tests unless kernel support subpage sized sector
size)

Qu Wenruo (5):
  btrfs-progs: mkfs: Apply the sectorsize user specified on 64k page
    size system
  btrfs-progs: fsck-tests: Check if current kernel can mount fs with
    specified sector size
  btrfs-progs: mkfs-tests: Skip 010-minimal-size if we can't mount with
    4k sector size
  btrfs-progs: misc-tests: Make test cases work or skipped on 64K page
    size system
  btrfs-progs: convert-tests: Skip tests if kernel doesn't support
    subpage sized sector size

 mkfs/main.c                                   | 12 +++++-
 tests/common                                  | 29 +++++++++++++
 tests/convert-tests/001-ext2-basic/test.sh    |  1 +
 tests/convert-tests/002-ext3-basic/test.sh    |  1 +
 tests/convert-tests/003-ext4-basic/test.sh    |  1 +
 .../004-ext2-backup-superblock-ranges/test.sh |  1 +
 .../005-delete-all-rollback/test.sh           |  1 +
 .../006-large-hole-extent/test.sh             |  2 +
 .../convert-tests/008-readonly-image/test.sh  |  1 +
 .../009-common-inode-flags/test.sh            |  1 +
 .../convert-tests/010-reiserfs-basic/test.sh  |  2 +
 .../011-reiserfs-delete-all-rollback/test.sh  |  1 +
 .../012-reiserfs-large-hole-extent/test.sh    |  1 +
 .../013-reiserfs-common-inode-flags/test.sh   |  1 +
 .../014-reiserfs-tail-handling/test.sh        |  1 +
 .../015-no-rollback-after-balance/test.sh     |  1 +
 .../016-invalid-large-inline-extent/test.sh   |  1 +
 tests/fsck-tests/012-leaf-corruption/test.sh  |  1 +
 .../028-unaligned-super-dev-sizes/test.sh     |  1 +
 .../037-freespacetree-repair/test.sh          |  3 +-
 .../010-convert-delete-ext2-subvol/test.sh    |  5 ++-
 tests/mkfs-tests/010-minimal-size/test.sh     | 41 ++++++++++---------
 22 files changed, 86 insertions(+), 23 deletions(-)

-- 
2.22.0

