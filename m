Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:33269 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab2GTWQw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jul 2012 18:16:52 -0400
Received: by gglu4 with SMTP id u4so4475922ggl.19
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Jul 2012 15:16:52 -0700 (PDT)
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: linux-btrfs@vger.kernel.org
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: [PATCH v3 0/1] LZO INCOMPAT Checking
Date: Fri, 20 Jul 2012 17:16:40 -0500
Message-Id: <1342822601-18340-1-git-send-email-mitch.harder@sabayonlinux.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The following patch is against Josef's btrfs-next repository,
and depends on Arnd Hannemann's patch:
"Btrfs: allow mount -o remount,compress=no"

The method was based on a previous example of checking for
lzo INCOMPAT used by Li Zefan when defragmenting with explicit
compression ("btrfs: Allow to specify compress method when defrag")
in ioctl.c.

Based on feedback on IRC, the two patch version presented in the
previous version has been consolidated into a single patch, and
the helper function was converted to a static inline function.

Mitch Harder (1):
  Btrfs: Check INCOMPAT flags on remount and add helper function

 fs/btrfs/ctree.h |   13 +++++++++++++
 fs/btrfs/ioctl.c |    7 +------
 fs/btrfs/super.c |    1 +
 3 files changed, 15 insertions(+), 6 deletions(-)

-- 
1.7.8.6

