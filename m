Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f41.google.com ([209.85.213.41]:43727 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbbBPAvy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Feb 2015 19:51:54 -0500
Received: by mail-yh0-f41.google.com with SMTP id 29so12703236yhl.0
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Feb 2015 16:51:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEr6y+XdwTMvg67CJmu8LgUgxCayoHLrBYm9En0vfB=BMqL_vg@mail.gmail.com>
References: <CAEr6y+XdwTMvg67CJmu8LgUgxCayoHLrBYm9En0vfB=BMqL_vg@mail.gmail.com>
Date: Sun, 15 Feb 2015 17:51:53 -0700
Message-ID: <CAJCQCtRCCV6qdcbEnu=hk__SJVH-xf4JhtKzPbriQHkY-rLBfQ@mail.gmail.com>
Subject: Re: init-scum-tree Assertion `ret` failed
From: Chris Murphy <lists@colorremedies.com>
To: Tim DeNike <tim@denike.us>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 15, 2015 at 5:06 PM, Tim DeNike <tim@denike.us> wrote:
> Long story short.. Ive been having problems with random files getting
> uncorrectable CRC errors on a 23TB filesystem.. RAID6 on an LSI card.
> Replaced all SAS cables, replaced single drives at a time, replaced
> controller card.
>
> Finally came to the conclusion that something must be corrupt in the
> CRCs as the LSI runs through its consistency checks and patrol reads
> with no problems found.
>
> I hesitantly ran "btrfs check --init-csum-tree" with the Centos 7
> stock binaries (btrfs-progs v3.12).  It ran very fast, yet
> successfully... After mounting, every file had an invalid checksum and
> wouldn't read.
>
> I already had 3.18.2 compiled in a separate path on the filesystem and
> tried again with that.. I got the following output after about an hour
> or so:
>
> [root@938el btrfs-progs]# ./btrfs check --init-csum-tree /dev/sda
> Creating a new CRC tree
> Checking filesystem on /dev/sda
> UUID: 1de92eed-c588-4471-b853-7f6a0a22c9a6
> Reinit crc root
> extent-tree.c:2657: btrfs_reserve_extent: Assertion `ret` failed.
> ./btrfs[0x43d4df]
> ./btrfs(btrfs_reserve_extent+0xaf8)[0x442b23]
> ./btrfs(btrfs_alloc_free_block+0x57)[0x442bcb]
> ./btrfs[0x43630d]
> ./btrfs(btrfs_search_slot+0x130b)[0x4381ab]
> ./btrfs(btrfs_csum_file_block+0x3c2)[0x446e74]
> ./btrfs(cmd_check+0xf72)[0x42608e]
> ./btrfs(main+0x15d)[0x4099e1]
> /lib64/libc.so.6(__libc_start_main+0xf5)[0x7ffc305dfaf5]
> ./btrfs[0x409599]
>
>
>
> Tried again with 3.19-rc2 and got the same thing.
>
> Kernel is 3.18.1

Looks similar.
http://www.spinics.net/lists/linux-btrfs/msg40944.html

So maybe it's worth seeing if 3.18 works and this is a regression? The
.1 and .2's had pretty minor fixes though. Otherwise I'd say file a
bug at bugzilla.kernel.org

-- 
Chris Murphy
