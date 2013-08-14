Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:53181 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758856Ab3HNCAb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Aug 2013 22:00:31 -0400
Received: by mail-wg0-f47.google.com with SMTP id j13so7030183wgh.2
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Aug 2013 19:00:30 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 0/2] BTRFS_IOC_INO_LOOKUP ioctl fixes
Date: Wed, 14 Aug 2013 03:00:19 +0100
Message-Id: <1376445621-18561-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This set of patches fixes 2 issues with the BTRFS_IOC_INO_LOOKUP ioctl:

1) missing error code return when path is too long;
2) ocassional ENOENT error even when the desired inode ref items exist.

Filipe David Borba Manana (2):
  Btrfs: add missing error code to BTRFS_IOC_INO_LOOKUP handler
  Btrfs: don't miss inode ref items in BTRFS_IOC_INO_LOOKUP

 fs/btrfs/ioctl.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

-- 
1.7.9.5

