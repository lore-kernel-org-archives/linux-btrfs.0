Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:36245 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751910AbdJCPHF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Oct 2017 11:07:05 -0400
Received: by mail-lf0-f68.google.com with SMTP id l196so3643422lfl.3
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Oct 2017 08:07:04 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH 0/4] Just bunch of btrfs patches
Date: Tue,  3 Oct 2017 18:06:00 +0300
Message-Id: <20171003150604.19596-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some patches has review, some not, all compile tested and hand tested.
(i.e. boot into patched system and do some small tests).

All based on kDave for-next branch

Patches:
1. Just remove useless u64 num_bytes from compress_file_range()
   No functional changes
2. For make compression on on mmap'd files safe,
   while compression logic works, we switch page dirty page bit on whole
   input range, but input range can be much bigger the 128KiB
   So try optimize that by only switch bits on current compression range
3. Function:
   extent_range_clear_dirty_for_io()
   extent_range_redirty_for_io()
   btrfs_set_range_writeback()
   Used to switch some bits on pages,
   but use not obvious while (index <= end_index) to cover
   unaligned end to pages.
   (I don't think that not obvious for me only, as on IRC no one can help me
   understand that until i found answer)
   So i change handling of unaligned end to more obvious way
4. btrfs_dedupe_file_range() on range bigger then 16MiB
   instead of return error, silently set it to 16MiB.
   So just add loop over input range, to get working bigger range
   P.S. May be that make a sense to change loop iterator to some lower value
   if one of deduped files are compressed?

Thanks.

Timofey Titovets (4):
  Btrfs: compress_file_range() remove dead variable num_bytes
  Btrfs: clear_dirty only on pages in compression range
  Btrfs: handle unaligned tail of data ranges more efficient
  Btrfs: btrfs_dedupe_file_range() ioctl, remove 16MiB restriction

 fs/btrfs/extent_io.c | 12 ++++++++++--
 fs/btrfs/inode.c     | 43 ++++++++++++++++++++++++++++++-------------
 fs/btrfs/ioctl.c     | 22 ++++++++++++++++++----
 3 files changed, 58 insertions(+), 19 deletions(-)

--
2.14.2
