Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33467 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab2GTRgb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jul 2012 13:36:31 -0400
Received: by yhmm54 with SMTP id m54so4229236yhm.19
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Jul 2012 10:36:31 -0700 (PDT)
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: linux-btrfs@vger.kernel.org
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: [PATCH 0/2] LZO INCOMPAT Checking
Date: Fri, 20 Jul 2012 12:36:19 -0500
Message-Id: <1342805781-12162-1-git-send-email-mitch.harder@sabayonlinux.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The following patches are against Josef's btrfs-next repository,
and depend on Arnd Hannemann's "Btrfs: allow mount -o remount,compress=no"
patch.

The method was based on a previous example of checking for
lzo INCOMPAT used by Li Zefan when defragmenting with explicit
compression ("btrfs: Allow to specify compress method when defrag")
in ioctl.c.

The second patch uses the new function in the above referenced
existing check for lzo INCOMPAT performed when defragmenting
with explicit lzo compression.  This patch provides no
functional changes.

Mitch Harder (2):
  Btrfs: Check INCOMPAT flags on remount with lzo compression
  Btrfs: Use common function to check lzo INCOMPAT on defrag.

 fs/btrfs/ctree.h |    1 +
 fs/btrfs/ioctl.c |    7 +------
 fs/btrfs/super.c |   21 ++++++++++++++++++++-
 3 files changed, 22 insertions(+), 7 deletions(-)

-- 
1.7.8.6

