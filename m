Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:44580 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaIDFam (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Sep 2014 01:30:42 -0400
Received: by mail-la0-f49.google.com with SMTP id b17so10908896lan.8
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Sep 2014 22:30:37 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 4 Sep 2014 07:30:37 +0200
Message-ID: <CANg_oxxmR+qkSfZeVYK5dF1HnbSJapEF1tZ+3-9ij5hq7d2E=w@mail.gmail.com>
Subject: BTRFS critical (device dm-0): invalid dir item name len: 45389
From: john terragon <jterragon@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

When I traverse one of my btrfs, for example with a simple "find /", I
get the following in kmsg

BTRFS critical (device dm-0): invalid dir item name len: 45389

The message appears just one time (so I guess it involves just one
file/dir). dm-0 is the first dmcrypt device of a pair on which I have
btrfs in RAID0 (btrfs native raid). Though I can't be 100% sure, this
seems to be a very recent problem (I would have noticed something
"critical" in kmsg if it happened before). Everything else seems to
work fine.

So, should I be worried. Is there a way to fix this? (I assume that a
scrub would not do any good since it seems to be related to btrfs data
structures more than actual file data). Is there at least a way to
know which file/dir is involved? Maybe a verbose debug mode? Or maybe
I should just add some printk in the verify_dir_item function that
seems to generate the message.

Thanks
John
