Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:34422 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033AbbGZVrs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Jul 2015 17:47:48 -0400
Received: by lafd3 with SMTP id d3so28279283laf.1
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Jul 2015 14:47:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <559F131B.30206@cn.fujitsu.com>
References: <CAC8ULPYHuqsZN1Lm_2TxGMw7z6n=4zAprqYr9uoi=3kjoiSxQw@mail.gmail.com>
	<558CB0D4.8060401@cn.fujitsu.com>
	<558CB404.8050300@cn.fujitsu.com>
	<CAJCQCtTMdQG4EB8dNAYPq8H3V68TCb2YQztoXXYMkCYA3GBCXw@mail.gmail.com>
	<CAO5K3OcA1_Z4-jvv_2C0StBkOr++_vUX4kOspY8cuhnX2t3z_A@mail.gmail.com>
	<CAJCQCtQ35xzMBjcUUTzWm3CjC1r=UNgkog2YbB0X1QcZofNj0g@mail.gmail.com>
	<559F131B.30206@cn.fujitsu.com>
Date: Mon, 27 Jul 2015 00:47:46 +0300
Message-ID: <CAC8ULPaOWS=WS-_oSkihrzi7bnWXuevyqL3R7FPFFQQCdjqdvA@mail.gmail.com>
Subject: Re: btrfs partition converted from ext4 becomes read-only minutes
 after booting: WARNING: CPU: 2 PID: 2777 at ../fs/btrfs/super.c:260 __btrfs_abort_transaction+0x4b/0x120
From: Robert Munteanu <robert.munteanu@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Chris Murphy <lists@colorremedies.com>, Vytautas D <vytdau@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 10, 2015 at 3:34 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> One of my patch addressed a problem that a converted btrfs can't pass
> btrfsck.
>
> Not sure if that is the cause, but if you can try btrfs-progs v3.19.1, the
> one without my btrfs-progs patches and some other newer convert related
> patches, and see the result?
>
> I think this would at least provide the base for bisect the btrfs-progs if
> the bug is in btrfs-progs.

Unfortunately, even though I had the original image saved, I was
unable to restore it ;  I went on with btrfs fi defrag and btrfs
balance before realising that there was an issue.

And that issue hid itself for quite some time ( I thought I had
avoided it by using a different /home partition ) and appeared at the
worst possible time - when doing a system update ( zypper dup ). The
system became read-only and I rebooted to

  Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)

Trying to boot an older snapshot ( I use snapper ) shows a more explicit error

  BTRFS: error (device sda1) in btrfs_replay_log:2334: errno=-95
unknown (Failed to recover log tree)
  BTRFS: open_ctree failed

Running

  $ btrfs check /dev/sda1

yields the following output ( note that I'm typing this as I see it on
the screen, some typos might occur ):

  Checking filesystem on /dev/sda1
  UUID: ....
  checking extents
  checking free space cache
  checking fs roots
  root 5 inode 14214570 errors 100, file extent discount
  Found file extent holes:
  root 497 inode 14214570 errors 100, file extent discount
  Found file extent holes:
  root 689 inode 14214570 errors 100, file extent discount
  Found file extent holes:
  root 732 inode 14214570 errors 100, file extent discount
  Found file extent holes:
  root 733 inode 14214570 errors 100, file extent discount
  Found file extent holes:
  root 734 inode 14214570 errors 100, file extent discount
  Found file extent holes:
  root 762 inode 14214570 errors 100, file extent discount
  Found file extent holes:
  ....
  root 1184 inode 14214570 errors 100, file extent discount
  Found file extent holes:
  found 110778231275 bytes used err is 1
  total csum bytes: 104238064
  total tree byes: 4047454208
  total fs tree bytes: 3849125888
  total extend tree bytes: 76496896
  btree space waste bytes: 907307515
  file data blocks allocated: 642367569920
    referenced 211828183040
  btrfs-progs v4.1+20150622

Also, $(uname -r) is 4.1.1-1-desktop

The disk image (still) contains sensitive data so I can't share it
unfortunately. What I can do is keep it untouched until Friday evening
EEST and run any debugging commands that you might think of to trace
down the source of the errors. Alternatively, if there's an easy and
safe fix and debugging is not worth it, I'm happy to apply that fix as
well.

At any rate, looking forward to your replies.

Thanks,

Robert
