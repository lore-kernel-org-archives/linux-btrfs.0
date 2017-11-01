Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:58227 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752319AbdKABaw (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 31 Oct 2017 21:30:52 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v4 0/4] mkfs: Fix minimal device check so that reported
Date: Wed,  1 Nov 2017 09:30:39 +0800
Message-Id: <20171101013043.19294-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Original reported by Wesley AC:
https://github.com/kdave/btrfs-progs/issues/70

Fix it by taking data/meta profile and minimal chunk size into
consideration.

Also introduce a test case for that.

Changelog:
v2:
  Refactor test_minimum_size() to take @min_dev_size directly. Refactor
  patch already in devel branch.
v3:
  Split test/common modification into separate patch.
v4:
  Further split run_mustfail_stdout() and prepare_test_dev()
  modification into separate patch.
  Include the real mkfs fix into patchset, to prevent possible test
  failure.
  Use suggestion from David to use run_check_mount_test_dev() and
  run_check_umount_test_dev().
  Add "-b $good_size" to mkfs command line, so we can see the size in
  test result, to help further debugging.

Qu Wenruo (4):
  btrfs-progs: mkfs: Enhance minimal device size calculation to fix mkfs
    failure on small file
  btrfs-progs: test/common: Introduce run_mustfail_stdout
  btrfs-progs: test/common: Enhance prepare_test_dev to reset device
    size
  btrfs-progs: test/mkfs: Test if the minimal device size is valid

 mkfs/common.c                            | 68 ++++++++++++++++++++++++++++----
 mkfs/common.h                            |  4 +-
 mkfs/main.c                              |  3 +-
 tests/common                             | 58 ++++++++++++++++++++++++++-
 tests/mkfs-tests/010-small-image/test.sh | 49 +++++++++++++++++++++++
 5 files changed, 171 insertions(+), 11 deletions(-)
 create mode 100755 tests/mkfs-tests/010-small-image/test.sh

-- 
2.14.3

