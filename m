Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:33083 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901AbbIWX3K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 19:29:10 -0400
Received: by igbkq10 with SMTP id kq10so3416786igb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Sep 2015 16:29:09 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 24 Sep 2015 01:29:09 +0200
Message-ID: <CALest0f91kMWz_3wnaT=vvG3X_9KOcW8oumbZLYMZi8oymygcw@mail.gmail.com>
Subject: kernel panic during btrfs balance, afterwards kernel panics during mount
From: phire skyde <phireskyde@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A few days ago, I added a 500GB drive to my RAID0 of two 1TB drives. I then ran

sudo btrfs fi balance start -dconvert=single .

after two minutes, my PC hung, not even SysRq worked.

I rebooted, ran

sudo mount /mnt/backup

which hung for a few minutes and then hang my PC again completely
(SysReq not working)

Next day mounting worked, but some minutes later it panicked again.
On one of these, I had this message in kernel log afterwards:

kernel: ------------[ cut here ]------------
kernel: kernel BUG at fs/btrfs/extent-tree.c:1833!
(thats all)

on another occasion, I left `dmesg -w` open and took this photo:
http://i.imgur.com/Qemzlr9.png but the stack trace is cut off

I also have some of these in my logs from when mounting/unmounting
hung for longer times: http://i.imgur.com/I8moyYG.png

At some point, I upgraded my kernel from 4.1.6 to
Linux 4.2.1-1-ARCH #1 SMP PREEMPT Tue Sep 22 06:57:07 CEST 2015 x86_64 GNU/Linux
and btrfs-progs v4.2.1
but panics still happened afterwards.

I also tried mounting with
`mount /mnt/backup -o skip_balance` but that took 2 minutes and
resulted in the same kernel panic.

Now I tried to reproduce to get the full stack trace, but it did not
kernel panic this time, instead I got this: http://sprunge.us/cACT
crash, afterwards the drive is mounted readonly.

What can I do?
