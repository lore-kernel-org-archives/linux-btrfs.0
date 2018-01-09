Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:38282 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750827AbeAIKxx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 05:53:53 -0500
Received: by mail-io0-f194.google.com with SMTP id 87so18079047ior.5
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jan 2018 02:53:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171219100247.13880-1-nefelim4ag@gmail.com>
References: <20171219100247.13880-1-nefelim4ag@gmail.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Tue, 9 Jan 2018 13:53:11 +0300
Message-ID: <CAGqmi76adh21b34o_B8uj4RN+Ym7TmFdzyVX9pX89XXxWJsxzA@mail.gmail.com>
Subject: Re: [PATCH 0/4] Btrfs: just bunch of patches to ioctl.c
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Gentle ping

2017-12-19 13:02 GMT+03:00 Timofey Titovets <nefelim4ag@gmail.com>:
> 1st patch, remove 16MiB restriction from extent_same ioctl(),
> by doing iterations over passed range.
>
> I did not see much difference in performance, so it's just remove
> logic restriction.
>
> 2-3 pathes, update defrag ioctl():
>  - Fix bad behaviour with full rewriting all compressed
>    extents in defrag range. (that also make autodefrag on compressed fs
>    not so expensive)
>  - Allow userspace specify NONE as target compression type,
>    that allow users to uncompress files by defragmentation with btrfs-progs
>  - Make defrag ioctl understood requested compression type and current
>    compression type of extents, to make btrfs fi def -rc<type>
>    idempotent operation.
>    i.e. now possible to say, make all extents compressed with lzo,
>    and btrfs will not recompress lzo compressed data.
>    Same for zlib, zstd, none.
>    (patch to btrfs-progs in PR on kdave GitHub).
>
> 4th patch, reduce size of struct btrfs_inode
>  - btrfs_inode store fields like: prop_compress, defrag_compress and
>    after 3rd patch, change_compress.
>    They use unsigned as a type, and use 12 bytes in sum.
>    But change_compress is a bitflag, and prop_compress/defrag_compress
>    only store compression type, that currently use 0-3 of 2^32-1.
>
>    So, set a bitfields on that vars, and reduce size of btrfs_inode:
>    1136 -> 1128.
>
> Timofey Titovets (4):
>   Btrfs: btrfs_dedupe_file_range() ioctl, remove 16MiB restriction
>   Btrfs: make should_defrag_range() understood compressed extents
>   Btrfs: allow btrfs_defrag_file() uncompress files on defragmentation
>   Btrfs: reduce size of struct btrfs_inode
>
>  fs/btrfs/btrfs_inode.h |   5 +-
>  fs/btrfs/inode.c       |   4 +-
>  fs/btrfs/ioctl.c       | 203 +++++++++++++++++++++++++++++++------------------
>  3 files changed, 133 insertions(+), 79 deletions(-)
>
> --
> 2.15.1



-- 
Have a nice day,
Timofey.
