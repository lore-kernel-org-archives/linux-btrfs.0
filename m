Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57655 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750822AbeEUFTb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 May 2018 01:19:31 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AFC89AD4E
        for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2018 05:19:29 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/4] btrfs: lzo: Harden decompression callers to avoid kernel memory corruption.
Date: Mon, 21 May 2018 13:19:23 +0800
Message-Id: <20180521051927.3715-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset can be fetched from github:
https://github.com/adam900710/linux/tree/lzo_corruption
Which is based on v4.17-rc5.

James Harvey reported pretty strange kernel misbehavior where after
reading certain btrfs compressed data, kernel crash with unrelated
calltrace.
(https://bugzilla.kernel.org/show_bug.cgi?id=199707 and
 https://www.spinics.net/lists/linux-btrfs/msg77971.html)

Thanks for his comprehensive debug help, we located the problem to:

1) Bad lzo decompression verification check
   The direct cause.
   The lzo decompression code involves memory copy for compressed data
   who crosses page boundary.
   And if corrupted segment header contains invalid length, btrfs will
   do memory copy and then corrupt kernel memory.

   Fix it by add header length check for each segment, and just in case,
   also add uncompressed data length check. (Patch 3)
   The full explanation and kasan output can also be found in that patch.

2) Compressed extent created for NODATASUM inode
   The root cause.
   Will be addressed in another patchset.

Other patches are mostly cosmetic, like adding extra include for
compression.h, to avoid later compiling error. (Patch 1)
Or adding comment of how btrfs organise its compressed data (Patch 2)
And adding extra check for inlined compressed data even it's not really
possible to happen (Patch 4)

Changelog:
v2:
  Cosmetic updates. Mostly for comment and gramma.
  Comment and gramma fixes suggested by Nikolay.
  One 4 bytes <-> LE32 convert fixes in comment.
  Added reviewed-by tag for the 1st patch.

Qu Wenruo (4):
  btrfs: compression: Add linux/sizes.h for compression.h
  btrfs: lzo: Add comment about the how btrfs records its lzo compressed
    data
  btrfs: lzo: Add header length check to avoid slab out of bounds access
  btrfs: lzo: Harden inline lzo compressed extent decompression

 fs/btrfs/compression.h |  1 +
 fs/btrfs/lzo.c         | 63 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 63 insertions(+), 1 deletion(-)

-- 
2.17.0

