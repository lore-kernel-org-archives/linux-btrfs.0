Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:49750 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab3EYOQs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 May 2013 10:16:48 -0400
Received: by mail-wg0-f49.google.com with SMTP id y10so3519069wgg.16
        for <linux-btrfs@vger.kernel.org>; Sat, 25 May 2013 07:16:47 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs-progs: Add missing free() against fs_info->super_copy
Date: Sat, 25 May 2013 15:16:38 +0100
Message-Id: <1369491399-6769-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There was a missing free() call against fs_info->super_copy
in several places:

1) close_ctree()

2) open_ctree_broken() on failure

3) __open_ctree_fd() on failure

Filipe David Borba Manana (1):
  Btrfs-progs: Add missing free() against fs_info->super_copy

 btrfs-find-root.c |    5 +++--
 disk-io.c         |    6 ++++--
 2 files changed, 7 insertions(+), 4 deletions(-)

-- 
1.7.9.5

