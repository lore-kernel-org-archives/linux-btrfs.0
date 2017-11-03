Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:46305 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755795AbdKCI24 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Nov 2017 04:28:56 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 5FDA648089D1
        for <linux-btrfs@vger.kernel.org>; Fri,  3 Nov 2017 16:28:48 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH RESEND 0/4] fix alert and add testcase lowmem check
Date: Fri, 3 Nov 2017 16:28:02 +0800
Message-ID: <20171103082806.22448-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patch 1 add a test case for commit 4c75ae7a4e20 ("btrfs-progs: test: Add
test image for lowmem mode file extent interrupt")
Patch 2 output more detailed information about file extent interrupt
Patch 3 fix a false alert for lowmem check
Patch 4 add a test case for Patch 3

Lu Fengqi (4):
  btrfs-progs: test: Add test image for lowmem mode file extent
    interrupt
  btrfs-progs: lowmem check: Output more detailed information about file
    extent interrupt
  btrfs-progs: lowmem check: Fix false alert about referencer count
    mismatch
  btrfs-progs: test: Add test image for lowmem mode referencer count
    mismatch false alert

 cmds-check.c                                             |   8 +++++---
 .../020-extent-ref-cases/inline_regular_coexist.img      | Bin 0 -> 4096 bytes
 .../ref_count_mismatch_false_alert.img                   | Bin 0 -> 4096 bytes
 3 files changed, 5 insertions(+), 3 deletions(-)
 create mode 100644 tests/fsck-tests/020-extent-ref-cases/inline_regular_coexist.img
 create mode 100644 tests/fsck-tests/020-extent-ref-cases/ref_count_mismatch_false_alert.img

-- 
2.15.0



