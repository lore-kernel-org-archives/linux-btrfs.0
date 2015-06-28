Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:33742 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbbF1Vr0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Jun 2015 17:47:26 -0400
Received: by pdjn11 with SMTP id n11so104938384pdj.0
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Jun 2015 14:47:26 -0700 (PDT)
From: "Davide C. C. Italiano" <dccitaliano@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Davide Italiano <dccitaliano@gmail.com>
Subject: [PATCH 0/2] btrfs_rename bugfixes.
Date: Sun, 28 Jun 2015 17:47:19 -0400
Message-Id: <1435528041-20878-1-git-send-email-dccitaliano@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Davide Italiano <dccitaliano@gmail.com>

These two patches fix some small problems in btrfs_rename() I noticed
while I was implementing RENAME_EXCHANGE.

Davide Italiano (2):
  [btrfs] btrfs_rename: abort transaction in case of error.
  [btrfs] btrfs_rename(): don't ignore btrfs_end_transaction() return

 fs/btrfs/inode.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

-- 
2.4.3

