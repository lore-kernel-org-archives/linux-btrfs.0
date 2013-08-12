Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:36734 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab3HLLdU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Aug 2013 07:33:20 -0400
Received: by mail-lb0-f179.google.com with SMTP id v1so4748730lbd.10
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Aug 2013 04:33:18 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>, idryomov@gmail.com
Subject: [PATCH 0/4] btrfs_device fixes
Date: Mon, 12 Aug 2013 14:33:00 +0300
Message-Id: <1376307184-7175-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This patch series does two things:

- adds allocation helpers for struct btrfs_device and struct
  btrfs_fs_devices so that all the list_heads, spinlocks, etc are
  properly initialized and the code for that is in one place;

- fixes a bug in the umount sequence, which, under certain conditions,
  can lead to mount failures.

This is on top of 3.11-rc3, but applies cleanly to btrfs-next/master as
of now.  You can pull from:

git://github.com/idryomov/btrfs-unstable.git dev-fixes
 
Thanks,

		Ilya


Ilya Dryomov (4):
  Btrfs: find_next_devid: root -> fs_info
  Btrfs: add btrfs_alloc_device and switch to it
  Btrfs: add alloc_fs_devices and switch to it
  Btrfs: rollback btrfs_device fields on umount

 fs/btrfs/volumes.c |  250 +++++++++++++++++++++++++++++++++-------------------
 fs/btrfs/volumes.h |    3 +
 2 files changed, 162 insertions(+), 91 deletions(-)

-- 
1.7.10.4

