Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:34938 "EHLO
	mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbcADBCA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Jan 2016 20:02:00 -0500
Received: by mail-pf0-f182.google.com with SMTP id 78so194760916pfw.2
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Jan 2016 17:01:59 -0800 (PST)
Received: from arch-gct.localdomain ([175.114.213.172])
        by smtp.gmail.com with ESMTPSA id 184sm45125786pfa.15.2016.01.03.17.01.57
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 03 Jan 2016 17:01:58 -0800 (PST)
From: Byongho Lee <bhlee.kernel@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/6] btrfs-progs: fix endian bugs and clean-ups
Date: Mon,  4 Jan 2016 10:01:28 +0900
Message-Id: <1451869294-4291-1-git-send-email-bhlee.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a patch-set after getting running sparse.

There are two endian patches one is new and the other is Zach Brown's work
but we lost.  And rest are just for clean-ups.

v2:
 - cover-letter:
    add, 'btrfs-progs' prefix in subject
 - btrfs-progs: fix using on-disk structure to store in memory data:
    remove, "Signed-off-by: Zach Brown <zab@redhat.com>" which was for
    below patch but added by mistake.
    '[PATCH 4/6] btrfs-progs: fix endian bugs in chunk rebuilding'

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

