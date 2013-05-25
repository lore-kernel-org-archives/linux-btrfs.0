Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:41799 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756160Ab3EYNuA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 May 2013 09:50:00 -0400
Received: by mail-we0-f171.google.com with SMTP id t59so3387268wes.16
        for <linux-btrfs@vger.kernel.org>; Sat, 25 May 2013 06:49:59 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs-progs: Add missing free() against fs_info->super_copy
Date: Sat, 25 May 2013 14:49:51 +0100
Message-Id: <1369489792-5673-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There was a missing free() call against fs_info->super_copy
in several places:

1) close_ctree()

2) open_ctree_broken() on failure

3) __open_ctree_fd() on failure

Filipe David Borba Manana (1):
  Btrfs-progs: Add missing free() against fs_info->super_copy

 btrfs-find-root.c |    4 ++--
 disk-io.c         |    5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

-- 
1.7.9.5

