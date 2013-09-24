Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:36437 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab3IXXjw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Sep 2013 19:39:52 -0400
Received: by mail-la0-f48.google.com with SMTP id er20so4221115lab.7
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Sep 2013 16:39:51 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 25 Sep 2013 05:09:51 +0530
Message-ID: <CALe5Emw4u1g2XPet5goM5V3YFbb4isqA4OTecR9RxnD7gxZr7g@mail.gmail.com>
Subject: hi
From: vgrvelu <vgrajan2005@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hi

I created  btrfs file system  on one of  sda partition. when I mount
with mount -t /dev/sda17  /btrfs,

it is failing with wrong fs type bad option. when i see the dmesg,
mount command is searching  for ext3, ext2 filesystem on sda17. but
not btrfs.
even in the man page of mount, btrfs is not mentioned as supported
file system type.

Please help me to solve this issue.

thanks
rajan
