Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33948 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750793AbdCNIFR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Mar 2017 04:05:17 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v3 0/7] convert: rollback rework
Date: Tue, 14 Mar 2017 16:05:02 +0800
Message-ID: <20170314080509.31163-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patchset can be fetched from my github, based on v4.10 now.
https://github.com/adam900710/btrfs-progs/tree/rollback_rework_v4.10

Rework rollback to provide a easier to understand new mechnisim, which can
handle both old convert behavior and new convert behavior.

And with these patchset, we can pass convert test again.

The idea itself is to make full use of convert image, which is a valid fs
image, and most of them are at the same position on disk.

In fact, to rollback, we just need to read out the whole convert
image and write it into disk.
However we don't really need to read/write the whole image, but only the
relocated ranges of convert image.

Convert image layout:

|<------------------------ valid old fs ----------------------------->|
| Relocated |   | Direct |  | Direct |   | Direct | | Relocated |
                    ||          ||           ||
                    \/          \/           \/
|<------------------------  new btrfs  ------------------------------>|
| Reserved  |   | Direct |  | Direct |   | Direct | | Reserved  |

Where "Direct" is directly mapped old fs data, whose file offset is the
same as its physical position on disk.
For "Direct" old fs data, we don't need to do anything.

While "Relocated" data is new data, which content is completely the same
as old fs, but they are relocated to btrfs data chunk.
Such "relocated" data is all in btrfs reserved ranges.

If we copy such "Relocated" data from convert image, to their original
physical position, then the old fs is back online.

So the new rollback work flow is:
1) Open btrfs read-only
2) Check convert image
   All file extents except ones in btrfs_reserved_ranges[] must be
   mapped at the same position in convert image and on disk.
3) Read out relocated file extents of convert image
   Use a newly introduced function, btrfs_read_file() to read data at
   specified offset of convert image, and keep them in memory.
4) Close btrfs
5) Write relocated data into its original position

Now old fs is back online, what happened in btrfs is just another dream.

In theory, current behavior can handle the rollback even if the whole fs
is balanced, just ensure we have enough memory, and enlarge the
@btrfs_reserved_ranges to cover the whole convert image.
But that's too crazy and the convert/rollback doesn't see much usage in
recent days.

Along such rework, add more comment to explain both convert and rework.

Convert test will all pass now.

v2:
  Abstract the original code to read out data in one btrfs file to
  btrfs_read_file().
  Use simple_range and btrfs_reserved_ranges[] to cleanup open code.
v3:
  Rebased to v4.10.
  Squash modification in later commits to their previous owner.
  Fix a converity report, which doesn't exit when an error is found in
  check_convert_image()
  Fix a lot of check scripts warning

Qu Wenruo (7):
  btrfs-progs: convert: Add comment for the overall convert workflow
  btrfs-progs: convert: Introduce simple range structure for convert
    reserved ranges
  btrfs-progs: convert: Use reserved ranges array to cleanup open code
  btrfs-progs: file: Introduce function to read out file content
  btrfs-progs: convert: Introduce function to read out btrfs reserved
    range
  btrfs-progs: convert: Introduce function to check if convert image is
    able to be rolled back
  btrfs-progs: convert: Rework rollback

 convert/common.h    |  27 ++
 convert/main.c      | 929 ++++++++++++++++++++++++----------------------------
 convert/source-fs.c |   3 +
 ctree.h             |   2 +
 file.c              | 169 ++++++++++
 5 files changed, 636 insertions(+), 494 deletions(-)

-- 
2.12.0



