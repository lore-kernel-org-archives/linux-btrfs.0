Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34534 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbbDGFJX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Apr 2015 01:09:23 -0400
Received: by pacyx8 with SMTP id yx8so66262888pac.1
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Apr 2015 22:09:22 -0700 (PDT)
From: Davide Italiano <dccitaliano@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Davide Italiano <dccitaliano@gmail.com>
Subject: [PATCH] Improve FL_KEEP_SIZE handling
Date: Mon,  6 Apr 2015 22:09:14 -0700
Message-Id: <1428383355-1686-1-git-send-email-dccitaliano@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This matches the logic of ext4. I think it's more
correct passing (offset + len) to inode_newsize_ok() 
rather than rounding up to block size.
The call can be skipped in some cases too. It works for
me but I'm new to this code so I might miss something.
Let me know what you think.

Davide Italiano (1):
  Btrfs: Improve FL_KEEP_SIZE handling in fallocate.

 fs/btrfs/file.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

-- 
2.3.4

