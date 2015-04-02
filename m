Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:35818 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbbDBD44 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Apr 2015 23:56:56 -0400
Received: by pabli10 with SMTP id li10so14563247pab.2
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2015 20:56:55 -0700 (PDT)
From: Davide Italiano <dccitaliano@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Davide Italiano <dccitaliano@gmail.com>
Subject: [PATCH] Btrfs: implement RENAME_EXCHANGE semantic
Date: Wed,  1 Apr 2015 20:56:50 -0700
Message-Id: <1427947011-4978-1-git-send-email-dccitaliano@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an attempt to implement RENAME_EXCHANGE in btrfs.
It survived basic testing and I think it's ready for others' feedback.
I'll stress test {and, or} rewrite it depending on people's comments.

Davide Italiano (1):
  Btrfs: RENAME_EXCHANGE semantic for renameat2()

 fs/btrfs/inode.c | 190 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 189 insertions(+), 1 deletion(-)

-- 
2.3.4

