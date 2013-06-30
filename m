Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:60352 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab3F3Lwu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Jun 2013 07:52:50 -0400
Received: by mail-wi0-f179.google.com with SMTP id hj3so2234759wib.0
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Jun 2013 04:52:49 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 0/3] Small fixes for btrfs-progs
Date: Sun, 30 Jun 2013 12:51:43 +0100
Message-Id: <1372593106-6593-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

1) add missing write check for mkfs
2) add kstrdup() return value check
3) remove unused code in btrfs_scan_one_device()

Filipe David Borba Manana (3):
  Btrfs-progs: add missing write check for mkfs
  Btrfs-progs: add kstrdup() return value check
  Btrfs-progs: remove unused code in btrfs_scan_one_device()

 utils.c   |    1 +
 volumes.c |    7 +++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

-- 
1.7.9.5

