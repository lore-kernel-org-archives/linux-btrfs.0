Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:55993 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab3IPO67 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Sep 2013 10:58:59 -0400
Received: by mail-ea0-f169.google.com with SMTP id k11so2095022eaj.14
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Sep 2013 07:58:58 -0700 (PDT)
From: Ross Kirk <ross.kirk@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Ross Kirk <ross.kirk@gmail.com>
Subject: [PATCH] Drop unused parameter from btrfs_item_nr
Date: Mon, 16 Sep 2013 15:58:08 +0100
Message-Id: <1379343489-20066-1-git-send-email-ross.kirk@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Unused parameter cleanup

Ross Kirk (1):
  btrfs: drop unused parameter from btrfs_item_nr

 fs/btrfs/backref.c    |    2 +-
 fs/btrfs/ctree.c      |   34 +++++++++++++++++-----------------
 fs/btrfs/ctree.h      |   13 ++++++-------
 fs/btrfs/dir-item.c   |    2 +-
 fs/btrfs/inode-item.c |    2 +-
 fs/btrfs/inode.c      |    4 ++--
 fs/btrfs/print-tree.c |    2 +-
 fs/btrfs/send.c       |    4 ++--
 8 files changed, 31 insertions(+), 32 deletions(-)

-- 
1.7.7.6

