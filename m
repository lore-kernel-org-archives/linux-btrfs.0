Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:36662 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbcACTAJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Jan 2016 14:00:09 -0500
Received: by mail-pa0-f51.google.com with SMTP id yy13so93270292pab.3
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Jan 2016 11:00:09 -0800 (PST)
Received: from arch-gct.localdomain ([175.114.213.172])
        by smtp.gmail.com with ESMTPSA id fc6sm120726837pac.44.2016.01.03.11.00.07
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 03 Jan 2016 11:00:07 -0800 (PST)
From: Byongho Lee <bhlee.kernel@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/6] fix endian bugs and clean-ups
Date: Mon,  4 Jan 2016 03:59:52 +0900
Message-Id: <1451847598-30666-1-git-send-email-bhlee.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a patch-set after getting running sparse.

There are two endian patches one is new and the other is Zach Brown's work
but we lost.  And rest are just for clean-ups.

Byongho Lee (6):
  btrfs-progs: get sparse checking working
  btrfs-progs: use NULL instead of 0
  btrfs-progs: make private symbols to static
  btrfs-progs: fix endian bugs in chunk rebuilding
  btrfs-progs: fix endian bug in update_super()
  btrfs-progs: fix using on-disk structure to store in memory data

 Makefile.in        |  2 +-
 btrfs-image.c      |  3 +--
 btrfs-show-super.c |  4 ++--
 chunk-recover.c    |  8 ++++----
 cmds-fi-usage.c    | 12 ++++++------
 props.c            |  2 +-
 qgroup-verify.c    | 36 +++++++++++++++++++++---------------
 qgroup.c           |  6 ++++--
 utils.c            |  4 ++--
 9 files changed, 42 insertions(+), 35 deletions(-)

-- 
2.6.4

