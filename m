Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35847 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbcD1Rds (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Apr 2016 13:33:48 -0400
Received: by mail-pa0-f53.google.com with SMTP id bt5so34515665pac.3
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Apr 2016 10:33:48 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Omar Sandoval <osandov@fb.com>
Subject: [PATCH v2 0/2] fstests: btrfs: the lost levels
Date: Thu, 28 Apr 2016 10:33:35 -0700
Message-Id: <cover.1461864695.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Changes since v1:

- Fixed _supported_fs and _supported_os in patch 2
- Added Josef's Reviewed-by

Original cover letter below:

Inspired by a conversation a few of us had at LSF about forgotten
fstests, I went back and checked if I had let any tests disappear into
the ether. Turns out that I did, so here are the tests for Btrfs replace
missing that I never got merged, updated with everyone's comments from
last time around ([1], [2]). Patch 1/3 in that original series did get
merged but the last two didn't fare so well.

Thanks!

1: https://patchwork.kernel.org/patch/6856101/
2: https://patchwork.kernel.org/patch/6856051/

Omar Sandoval (2):
  btrfs: add replace missing and replace RAID 5/6 to profile configs
  btrfs: add test for replacing a missing device

 common/rc           |  95 ++++++++++++++++++++---------------------
 tests/btrfs/027     | 119 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/027.out |   2 +
 tests/btrfs/group   |   1 +
 4 files changed, 170 insertions(+), 47 deletions(-)
 create mode 100755 tests/btrfs/027
 create mode 100644 tests/btrfs/027.out

-- 
2.8.0

