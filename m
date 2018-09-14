Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48742 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726822AbeINMiX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 08:38:23 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9EFF4AE1D
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2018 07:25:12 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] Enhanced error messages for btrfs-convert
Date: Fri, 14 Sep 2018 15:25:03 +0800
Message-Id: <20180914072505.15916-1-wqu@suse.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset can be fetched from github:
https://github.com/adam900710/btrfs-progs/tree/convert_error_messages
As usual, it's based on latest stable tag (v4.17.1).

There is one error report of btrfs-convert, the error message looks
pretty meaningless:

  create btrfs filesystem:
      blocksize: 4096
      nodesize:  16384
      features:  extref, skinny-metadata (default)
  creating ext2 image file
  ERROR: failed to create ext2_saved/image: -1
  WARNING: an error occurred during conversion, filesystem is partially
  created but not finalized and not mountable

After some investigation, the problem turns out to be read failure.
But the error number is intermediate number (-1) returned from
read_disk_extent().

This patchset will first fix the intermediate return number of
read_disk_extent(), then add more error messages for btrfs-convert (at
least convert part) to makes it easier to identify the problem.

In this particular case, it should output things like:

  create btrfs filesystem:
      blocksize: 4096
      nodesize:  16384
      features:  extref, skinny-metadata (default)
  creating ext2 image file
  ERROR: failed to calculate csum for bytenr 2732765184 len 4096, Input/output error
  ERROR: failed to create ext2_saved/image: -5
  WARNING: an error occurred during conversion, filesystem is partially
  created but not finalized and not mountable


Qu Wenruo (2):
  btrfs: convert: Make read_disk_extent() return more meaningful -EIO
    other -1
  btrfs-progs: convert: Output meaningful error messages for
    create_image()

 convert/main.c      | 37 ++++++++++++++++++++++++++++++-------
 convert/source-fs.c |  2 +-
 2 files changed, 31 insertions(+), 8 deletions(-)

-- 
2.19.0
