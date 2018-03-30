Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:41470 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751163AbeC3Hfo (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 30 Mar 2018 03:35:44 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs-progs: Enhance btrfs-image to handle missing device
Date: Fri, 30 Mar 2018 15:35:25 +0800
Message-Id: <20180330073528.20650-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Can be fetched from github:
https://github.com/adam900710/btrfs-progs/tree/btrfs_image_fix

Bug report:
https://github.com/kdave/btrfs-progs/issues/118

In short, the problem is caused by some old code (read_extent_data()
from ancient btrfs check code) and offset-by-one from btrfs-image.
Which makes btrfs-image can only read from the first stripe of RAID1.

And if device of the first stripe is missing, btrfs-image will fail.

Fix the problem and add test case for it.

Qu Wenruo (3):
  btrfs-progs: disk-io: Fix read_extent_data() error handler for missing
    device
  btrfs-progs: convert: Fix offset-by-one error in read_data_extent()
  btrfs-progs: tests/misc: Test if btrfs-image can handle RAID1 missing
    device

 disk-io.c                                         |  6 ++-
 image/main.c                                      |  2 +-
 tests/misc-tests/030-missing-device-image/test.sh | 57 +++++++++++++++++++++++
 3 files changed, 62 insertions(+), 3 deletions(-)
 create mode 100755 tests/misc-tests/030-missing-device-image/test.sh

-- 
2.16.3

