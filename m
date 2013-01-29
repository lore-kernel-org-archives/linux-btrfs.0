Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:35653 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab3A2GGq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 01:06:46 -0500
Received: by mail-ob0-f202.google.com with SMTP id lz20so14996obb.5
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Jan 2013 22:06:46 -0800 (PST)
From: Filipe Brandenburger <filbranden@google.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Brandenburger <filbranden@google.com>
Subject: [PATCH 0/3] strace: Add support for Btrfs ioctls
Date: Mon, 28 Jan 2013 22:06:35 -0800
Message-Id: <1359439598-4141-1-git-send-email-filbranden@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

This is a patch to strace!!! Not btrfs-next or btrfs-progs. I just wanted to
circulate it on this list before submitting it to the strace maintainers.

It also depends on "[PATCH] Btrfs: move fs/btrfs/ioctl.h to
include/uapi/linux/btrfs.h" being committed as that's what will export
linux/btrfs.h to userspace and this patch to strace depends on that file.

I added a patch decoding a specific ioctl to have an idea of whether the output
format is good or should be tweaked differently. I opted to be a bit more
verbose but increase readability. I also ended up deciding to truncate the
output to show at most 10 results, not sure if that's OK or should be
configurable somewhere (maybe I can tap into strace's "-s" parameter to
estimate the size of output allowable?)

Without the patch:

    $ strace -e ioctl btrfs fi df .
    ioctl(3, 0xc0109414, 0x195b040)         = 0
    ioctl(3, 0xc0109414, 0x195b040)         = 0
    Data: total=1.01GB, used=4.87MB
    System, DUP: total=8.00MB, used=4.00KB
    System: total=4.00MB, used=0.00
    Metadata, DUP: total=1.75GB, used=1.38GB
    Metadata: total=8.00MB, used=0.00
    +++ exited with 0 +++


With the patch:

    $ strace -e ioctl btrfs fi df .
    ioctl(3, BTRFS_IOC_SPACE_INFO, {space_slots=0, total_spaces=5}) = 0
    ioctl(3, BTRFS_IOC_SPACE_INFO, {space_slots=5, total_spaces=5, spaces={[0]={flags=0x1 /* BTRFS_BLOCK_GROUP_DATA */, total_bytes=1081999360, used_bytes=5107712}, [1]={flags=0x22 /* BTRFS_BLOCK_GROUP_SYSTEM|BTRFS_BLOCK_GROUP_DUP */, total_bytes=8388608, used_bytes=4096}, [2]={flags=0x2 /* BTRFS_BLOCK_GROUP_SYSTEM */, total_bytes=4194304, used_bytes=0}, [3]={flags=0x24 /* BTRFS_BLOCK_GROUP_METADATA|BTRFS_BLOCK_GROUP_DUP */, total_bytes=1878982656, used_bytes=1485590528}, [4]={flags=0x4 /* BTRFS_BLOCK_GROUP_METADATA */, total_bytes=8388608, used_bytes=0}}}) = 0
    Data: total=1.01GB, used=4.87MB
    System, DUP: total=8.00MB, used=4.00KB
    System: total=4.00MB, used=0.00
    Metadata, DUP: total=1.75GB, used=1.38GB
    Metadata: total=8.00MB, used=0.00
    +++ exited with 0 +++


Any comments? Or do you think this is good enough? Before submitting to the
strace project I'd like to review the constants and structs that need to be in
linux/btrfs.h and move them there (which should be further commits to
btrfs-next) so that I don't need to duplicate them there, but before I do that
I'd like to have some feedback if you think this is the right approach.

Thanks!
Filipe


Filipe Brandenburger (3):
  Add support for Btrfs ioctls: decode them by name
  Add support for Btrfs ioctls: infrastructure to decode ioctl structs
  Add support for Btrfs ioctls: BTRFS_IOC_SPACE_INFO (filesystem df)

 Makefile.am         |   2 +-
 btrfs.c             | 159 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 configure.ac        |   1 +
 defs.h              |   1 +
 ioctl.c             |   2 +
 linux/ioctlent.h.in |  44 +++++++++++++++
 6 files changed, 208 insertions(+), 1 deletion(-)
 create mode 100644 btrfs.c

-- 
1.7.11.7

