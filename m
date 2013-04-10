Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:59647 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab3DJLXT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Apr 2013 07:23:19 -0400
Received: by mail-pd0-f169.google.com with SMTP id 10so216650pdc.14
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Apr 2013 04:23:18 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: wangsl-fnst@cn.fujitsu.com, list.btrfs@jan-o-sch.net
Subject: [PATCH 0/2] cleanups when walking backref tree
Date: Wed, 10 Apr 2013 19:22:49 +0800
Message-Id: <1365592971-1535-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

The first patch removes some BUG_ONs() when walking backref tree.
These BUG_ON()s can only be triggered because of ENOMEM, and the caller
has checked the return value about it. So we just return directly rather
than trigger BUG_ON() when out of memory happens.

The second patch just makes some functions' return value be void, Since
these functions always return 0.

Wang Shilong (2):
  Btrfs: remove some BUG_ONs() when walking backref tree
  Btrfs: make some functions return type be void in backref.c

 fs/btrfs/backref.c |   28 ++++++++++++----------------
 1 files changed, 12 insertions(+), 16 deletions(-)

-- 
1.7.7.6

