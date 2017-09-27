Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:41592 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751782AbdI0Gbs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 02:31:48 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id C69C947CAACF
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Sep 2017 14:31:39 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/5] btrfs-progs: check: original and lowmem mode fix
Date: Wed, 27 Sep 2017 14:34:35 +0800
Message-ID: <20170927063440.25961-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The head three patches is independent from later two.
Include:
1) Let check_extent_refs() return error instead of 0 if something wrong
   is found in original mode.
2) repair_root_items() should be called before any repair. Put it
   before do_check_chunks_and_extents();
3) Error status should not be modified if repair_root_items() succeeded
   in original repair.

The late two patches are about invalid type in extent_inline_ref.

Only original mode applied 001-003 patches can handle the case in the
last patch. So I gather those 5 patches together.


Su Yue (5):
  btrfs-progs: check: return value of check_extent_refs()
  btrfs-progs: check: call repair_root_items() before any repair
  btrfs-progs: check: error or return value of repair_root_items()
  btrfs-progs: check: check extent_inline_ref in lowmem
  btrfs-progs: fsck-tests: 027/bad_extent_inline_ref_type

 cmds-check.c                                       |  83 +++++++++++++++------
 .../bad-extent-inline-ref-type.raw.xz              | Bin 0 -> 17144 bytes
 2 files changed, 62 insertions(+), 21 deletions(-)
 create mode 100644 tests/fsck-tests/027-bad-extent-inline-ref-type/bad-extent-inline-ref-type.raw.xz

-- 
2.14.1



