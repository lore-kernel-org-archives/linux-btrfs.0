Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:61803 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab3A2GFL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 01:05:11 -0500
Received: by mail-oa0-f73.google.com with SMTP id n12so15012oag.2
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Jan 2013 22:05:11 -0800 (PST)
From: Filipe Brandenburger <filbranden@google.com>
To: Chris Mason <chris.mason@fusionio.com>, Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, Filipe Brandenburger <filbranden@google.com>
Subject: [PATCH] Btrfs: move fs/btrfs/ioctl.h to include/uapi/linux/btrfs.h
Date: Mon, 28 Jan 2013 22:04:49 -0800
Message-Id: <1359439490-4012-1-git-send-email-filbranden@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This is a cleanup patch to move ioctl.h to create an include/linux/btrfs.h

The suggestion was listed in this cleanup page:
https://btrfs.wiki.kernel.org/index.php/Cleanup_ideas#Remove_ioctl.h_in_btrfs_and_btrfs-progs_world.2C_create_include.2Flinux.2Fbtrfs.h_with_those_definitions

It will serve as base to add Btrfs-specific ioctl support to strace (which I just claimed):
https://btrfs.wiki.kernel.org/index.php/Project_ideas#strace

It's using the new UAPI model for header files, include/uapi/linux/btrfs.h
should contain everything that should be exported to userspace (this file will
be post-processed to remove __user, etc. and installed to /usr/include/linux)
and include/linux/btrfs.h should have everything that's private to the kernel
(right now the latter only contains an #include of the former.)

This is the first patch to export these constants and structs, later on we might
need to move other things around, but this is a good starting point.

The patch is trivial, but I tested a kernel build, booting with the kernel,
loading the module and mounting a filesystem. Also tested "make headers_install"
to make sure the btrfs.h header will be installed at the right place.

Thanks,
Filipe


Filipe Brandenburger (1):
  Btrfs: move fs/btrfs/ioctl.h to include/uapi/linux/btrfs.h

 fs/btrfs/backref.h                             | 2 +-
 fs/btrfs/ctree.h                               | 2 +-
 fs/btrfs/file.c                                | 2 +-
 fs/btrfs/inode.c                               | 2 +-
 fs/btrfs/ioctl.c                               | 2 +-
 fs/btrfs/qgroup.c                              | 2 +-
 fs/btrfs/super.c                               | 2 +-
 fs/btrfs/volumes.h                             | 2 +-
 include/linux/btrfs.h                          | 6 ++++++
 include/uapi/linux/Kbuild                      | 1 +
 fs/btrfs/ioctl.h => include/uapi/linux/btrfs.h | 7 ++++---
 11 files changed, 19 insertions(+), 11 deletions(-)
 create mode 100644 include/linux/btrfs.h
 rename fs/btrfs/ioctl.h => include/uapi/linux/btrfs.h (99%)

-- 
1.7.11.7

