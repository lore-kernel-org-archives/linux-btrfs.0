Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:58843 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754108AbdJJHv1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Oct 2017 03:51:27 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, yoasif@gmail.com, rrauenza@gmail.com
Subject: [PATCH 0/4] btrfs-progs repair support for unaligned/mismatched device sizes
Date: Tue, 10 Oct 2017 07:51:09 +0000
Message-Id: <20171010075113.10718-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patchset can be fetched from github:
https://github.com/adam900710/btrfs-progs/tree/check_unaligned_dev

There are several reports in mail list for btrfs device size related
problems.

1) Unmountable fs, due to mismatched super total_bytes
   Unmountable if super total_bytes is smaller than total rw bytes of
   all devices.
   Root cause under investigation, but only one report here.

   This patchset provides the tool to fix it offline.
   (At least better than unmountable forever)

2) Harmless kernel warning for btrfs_update_device()
   v4.14 introduced restrict device size checker.
   This somewhat break the backward compatibility and causing kernel
   warning.

   It can be fixed online with "btrfs filesystem resize".
   (Although it is better to fixed it at mount time)

   This patchset also provide a fallback method to fix it.

Qu Wenruo (4):
  btrfs-progs: Introduce functions to repair unaligned/mismatch device
    size
  btrfs-progs: fsck: Introduce --fix-dev-size option
  btrfs-progs: check: Also check unalignment/mismatch device and super
    size
  btrfs-progs: test/fsck: Add test case image for --fix-dev-size

Qu Wenruo (4):
  btrfs-progs: Introduce functions to repair unaligned/mismatch device
    size
  btrfs-progs: fsck: Introduce --fix-dev-size option
  btrfs-progs: check: Also check unalignment/mismatch device and super
    size
  btrfs-progs: test/fsck: Add test case image for --fix-dev-size

 Documentation/btrfs-check.asciidoc                 |  23 ++
 cmds-check.c                                       | 292 ++++++++++++++++++++-
 .../dev_and_super_mismatch_unaligned.raw.xz        | Bin 0 -> 21536 bytes
 3 files changed, 314 insertions(+), 1 deletion(-)
 create mode 100644 tests/fsck-tests/027-unaligned-super-dev-sizes/dev_and_super_mismatch_unaligned.raw.xz

-- 
2.14.2

