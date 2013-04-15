Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:39797 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab3DONre (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 09:47:34 -0400
Received: by mail-ie0-f177.google.com with SMTP id 9so5472360iec.22
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Apr 2013 06:47:33 -0700 (PDT)
From: Dan McGrath <danmcgrath.ca@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Dan McGrath <danmcgrath.ca@gmail.com>
Subject: [PATCH] btrfs-progs: No-op when called as fsck.btrfsck
Date: Mon, 15 Apr 2013 09:47:08 -0400
Message-Id: <1366033629-25121-1-git-send-email-danmcgrath.ca@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I thought that I would attempt a quick little patch that will make btrfsck into
a No-op when called as fsck.btrfsck.

The reasoning is that the FAQ states that it is recommended and safe to do so,
and the current 12.04 version of Ubuntu just symlinks fsck.btrfsck to btrfsck
instead of /bin/true.

PS - Apologies if I mess this git send-email up!



Dan McGrath (1):
  btrfs-progs: No-op when called as fsck.btrfsck

 btrfs.c |    2 ++
 1 file changed, 2 insertions(+)

-- 
1.7.9.5

