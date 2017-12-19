Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:42204 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759693AbdLSKC5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 05:02:57 -0500
Received: by mail-wm0-f68.google.com with SMTP id b199so2413824wme.1
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Dec 2017 02:02:56 -0800 (PST)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH 0/4] Btrfs: just bunch of patches to ioctl.c
Date: Tue, 19 Dec 2017 13:02:43 +0300
Message-Id: <20171219100247.13880-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

1st patch, remove 16MiB restriction from extent_same ioctl(),
by doing iterations over passed range.

I did not see much difference in performance, so it's just remove
logic restriction.

2-3 pathes, update defrag ioctl():
 - Fix bad behaviour with full rewriting all compressed
   extents in defrag range. (that also make autodefrag on compressed fs
   not so expensive)
 - Allow userspace specify NONE as target compression type,
   that allow users to uncompress files by defragmentation with btrfs-progs
 - Make defrag ioctl understood requested compression type and current
   compression type of extents, to make btrfs fi def -rc<type>
   idempotent operation.
   i.e. now possible to say, make all extents compressed with lzo,
   and btrfs will not recompress lzo compressed data.
   Same for zlib, zstd, none.
   (patch to btrfs-progs in PR on kdave GitHub).

4th patch, reduce size of struct btrfs_inode
 - btrfs_inode store fields like: prop_compress, defrag_compress and
   after 3rd patch, change_compress.
   They use unsigned as a type, and use 12 bytes in sum.
   But change_compress is a bitflag, and prop_compress/defrag_compress
   only store compression type, that currently use 0-3 of 2^32-1.
   
   So, set a bitfields on that vars, and reduce size of btrfs_inode:
   1136 -> 1128.

Timofey Titovets (4):
  Btrfs: btrfs_dedupe_file_range() ioctl, remove 16MiB restriction
  Btrfs: make should_defrag_range() understood compressed extents
  Btrfs: allow btrfs_defrag_file() uncompress files on defragmentation
  Btrfs: reduce size of struct btrfs_inode

 fs/btrfs/btrfs_inode.h |   5 +-
 fs/btrfs/inode.c       |   4 +-
 fs/btrfs/ioctl.c       | 203 +++++++++++++++++++++++++++++++------------------
 3 files changed, 133 insertions(+), 79 deletions(-)

-- 
2.15.1
