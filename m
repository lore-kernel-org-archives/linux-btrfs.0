Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:35553 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751877AbaERSAW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 18 May 2014 14:00:22 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Hang while deleting file
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAOUy=vobwRvhDAJHj_XWAdPvXwzGu47viCY=cDaTbJVkZjJmFA@mail.gmail.com>
Date: Sun, 18 May 2014 12:00:21 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <972A5831-6DC4-48C6-99A0-8EAF20E11EFE@colorremedies.com>
References: <CAOUy=vobwRvhDAJHj_XWAdPvXwzGu47viCY=cDaTbJVkZjJmFA@mail.gmail.com>
To: Joshua McKinney <joshka@joshka.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 18, 2014, at 10:36 AM, Joshua McKinney <joshka@joshka.net> wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=76421
> 
> Perceived issue: SABNZBD hangs, requires restart.
> Diagnosis shows the following in my system log at the time of hang.
> This happens more than once.
> Log:
> 
> [ 5883.464766] INFO: task SABnzbd.py:994 blocked for more than 120 seconds.
> [ 5883.464906]       Not tainted 3.14.4-1-ARCH #1
> [ 5883.464989] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 5883.465130] SABnzbd.py      D ffff880196d1f5c0     0   994      1 0x00000000
> [ 5883.465140]  ffff8800765c9ce8 0000000000000082 0000005000000002
> ffff880196d1f5c0
> [ 5883.465148]  00000000000146c0 ffff8800765c9fd8 00000000000146c0
> ffff880196d1f5c0
> [ 5883.465156]  00000000ffffffef ffff880177d9a000 ffffffffa02d0dbc
> ffff8800765c9c50
> [ 5883.465163] Call Trace:
> [ 5883.465218]  [<ffffffffa02d0dbc>] ? __set_extent_bit+0x45c/0x550 [btrfs]
> [ 5883.465252]  [<ffffffffa02d03c3>] ? free_extent_state+0x43/0xc0 [btrfs]
> [ 5883.465284]  [<ffffffffa02d0dbc>] ? __set_extent_bit+0x45c/0x550 [btrfs]
> [ 5883.465295]  [<ffffffff810b3ba4>] ? __wake_up+0x44/0x50
> [ 5883.465304]  [<ffffffff8150b729>] schedule+0x29/0x70
> [ 5883.465335]  [<ffffffffa02d1cd2>] lock_extent_bits+0x152/0x1e0 [btrfs]
> [ 5883.465344]  [<ffffffff810b4020>] ? __wake_up_sync+0x20/0x20
> [ 5883.465375]  [<ffffffffa02bfa59>] btrfs_evict_inode+0x139/0x520 [btrfs]
> [ 5883.465387]  [<ffffffff811d5a80>] evict+0xb0/0x1c0
> [ 5883.465394]  [<ffffffff811d6335>] iput+0xf5/0x1a0
> [ 5883.465402]  [<ffffffff811ca9c5>] do_unlinkat+0x1b5/0x300
> [ 5883.465411]  [<ffffffff8117899c>] ? vm_munmap+0x4c/0x60
> [ 5883.465418]  [<ffffffff811cb986>] SyS_unlink+0x16/0x20
> [ 5883.465427]  [<ffffffff81517769>] system_call_fastpath+0x16/0x1b
> 
> Filesystem:
> # btrfs filesystem show
> Btrfs v3.14.1
> 
> running Data RAID, sys/meta RAID10 on 5x4TB. SABNzbd is a usenet
> download program, so the file attempting to be deleted was possibly
> large (>GB)
> 
> Recently updated to 3.14 kernel provided in arch linux. I haven't seen
> this issue before the last couple of days.
> 
> Happy to provide more info if necessary.

I'd include as an attachment to the bug the output from sysrq-w.

echo 1 > /proc/sys/kernel/sysrq
echo w > /proc/sysrq-trigger
dmesg

https://www.kernel.org/doc/Documentation/sysrq.txt


Chris Murphy