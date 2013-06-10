Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:33215 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab3FJTvy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Jun 2013 15:51:54 -0400
Received: by mail-we0-f179.google.com with SMTP id w59so5167838wes.38
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 12:51:52 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 0/5] Btrfs-progs: coalesce of patches
Date: Mon, 10 Jun 2013 20:51:30 +0100
Message-Id: <1370893895-24884-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some fixes and minor enhancements.

Filipe David Borba Manana (5):
  Btrfs-progs: fix closing of devices
  Btrfs-progs: Add missing free_extent_buffer() call to debug-tree
  Btrfs-progs: Add missing close_ctree() calls to debug-tree
  Btrfs-progs: pretty print dir_item type
  Btrfs-progs: Validate super block checksum

 btrfs-debug-tree.c |   10 ++++---
 disk-io.c          |   80 +++++++++++++++++++++++++++++++++++++++++-----------
 print-tree.c       |   40 +++++++++++++++++++++++++-
 volumes.c          |    4 +--
 4 files changed, 111 insertions(+), 23 deletions(-)

-- 
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
