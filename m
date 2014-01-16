Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:63646 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbaAPE0r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jan 2014 23:26:47 -0500
Received: by mail-pa0-f53.google.com with SMTP id lj1so2108181pab.12
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jan 2014 20:26:46 -0800 (PST)
From: Mitchel Humpherys <mitch.special@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Mitchel Humpherys <mitch.special@gmail.com>
Subject: [PATCH] add help switches
Date: Wed, 15 Jan 2014 20:26:29 -0800
Message-Id: <1389846390-17585-1-git-send-email-mitch.special@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some -h and --help love.

Mitchel Humpherys (1):
  btrfs-progs: add help switches where needed

 btrfs-calc-size.c     | 3 ++-
 btrfs-convert.c       | 3 ++-
 btrfs-corrupt-block.c | 3 ++-
 btrfs-debug-tree.c    | 3 ++-
 btrfs-find-root.c     | 3 ++-
 btrfs-image.c         | 3 ++-
 btrfs-map-logical.c   | 4 +++-
 btrfs-select-super.c  | 3 ++-
 btrfs-show-super.c    | 3 ++-
 btrfs-zero-log.c      | 2 +-
 btrfs.c               | 2 +-
 btrfstune.c           | 3 ++-
 mkfs.c                | 4 +++-
 13 files changed, 26 insertions(+), 13 deletions(-)

-- 
Mitch
