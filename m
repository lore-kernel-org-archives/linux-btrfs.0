Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:54431 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab3KBPOl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Nov 2013 11:14:41 -0400
Received: by mail-pa0-f45.google.com with SMTP id kp14so5235334pab.32
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Nov 2013 08:14:40 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net, list.btrfs@jan-o-sch.net, wangsl.fnst@cn.fujitsu.com
Subject: [RFC PATCH 0/2] remove exclusive size from btrfs qgroup
Date: Sat,  2 Nov 2013 23:14:31 +0800
Message-Id: <1383405273-27304-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Btrfs qgroup gives us an important feature to know a subvolume's
sole size, however, it brings some problems.

Especially, we can not make qgroup's exclusive size correct when
deleting subvolumes(we haven't found an effective way at least).

Another big problem, some users complain with qgroup enabled, system
memory cost become high.

So i am always thinking that why not implemnt it in a more simple and
direct way, we just keep qgroup's rferenced size, this will make life
simple and easy.

This is only a RFC patch, we need more discussion, and patch itself
need more testing and cleanup work.

Any comments are welcome!

Wang Shilong (2):
  Btrfs: disable qgroup's exclusive size tracking
  Btrfs: remove subvolume qgroup automatically with qgroup enabled

 fs/btrfs/ctree.h  |   2 +
 fs/btrfs/ioctl.c  |   5 +-
 fs/btrfs/qgroup.c | 330 ++++++++++++++++--------------------------------------
 3 files changed, 101 insertions(+), 236 deletions(-)

-- 
1.7.11.7

