Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:48063 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab3GDJtB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jul 2013 05:49:01 -0400
Received: by mail-wg0-f54.google.com with SMTP id n11so947538wgh.33
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Jul 2013 02:49:00 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2 0/5] Small fixes for btrfs-progs
Date: Thu,  4 Jul 2013 10:48:38 +0100
Message-Id: <1372931320-8340-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1372593106-6593-1-git-send-email-fdmanana@gmail.com>
References: <1372593106-6593-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

1) add missing write checks for mkfs
2) add kstrdup() return value check
3) remove unused code
4) make_btrfs() return error code on write failure
5) check for errors in btrfs_add_block_group()

V2: added patches 4 and 5.

Filipe David Borba Manana (5):
  Btrfs-progs: add missing write check for mkfs
  Btrfs-progs: add kstrdup() return value check
  Btrfs-progs: remove unused code
  Btrfs-progs: return error on write failure in make_btrfs()
  Btrfs-progs: don't ignore errors in btrfs_add_block_group()

 btrfs-convert.c |    3 ++-
 extent-cache.c  |    1 -
 extent-tree.c   |   12 +++++++-----
 mkfs.c          |    2 +-
 utils.c         |   34 ++++++++++++++++++++++++++++------
 volumes.c       |    7 +++++--
 6 files changed, 43 insertions(+), 16 deletions(-)

-- 
1.7.9.5

