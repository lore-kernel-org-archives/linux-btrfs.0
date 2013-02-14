Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42152 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab3BNKPr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Feb 2013 05:15:47 -0500
Received: by mail-wi0-f178.google.com with SMTP id o1so2500118wic.17
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Feb 2013 02:15:46 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 14 Feb 2013 02:15:45 -0800
Message-ID: <CABdGeLgO0ncKTx2Hs_KGoJ43vM2FjWE4+WQB_i3KdcHfrphEcg@mail.gmail.com>
Subject: [btrfs] Periodic write spikes while idling, on btrfs root
From: Vedant Kumar <vk@vedantk.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm experiencing periodic write spikes while my system is idle.

According to iotop, they're being caused by "btrfs-endio-write",
"btrfs-transaction", and "btrfs-dealloc". Mostly, the issue is with
"endio-write": I've seen up to four of these processes write at the
same time. Using iostat, I've determined that these writes range from
1 to 6 megabytes in size, and that they occur roughly every 5 seconds.

These write spikes may prevent my disk from spinning down and lower
my battery life.

I fetched the latest unpatched mainline kernel and modified
linux/fs/btrfs/inode.c:2051 to add a debugging printk() inside of
btrfs_writepage_end_io_hook(). After running that kernel, I can confirm
two things;

1. The write spikes occur whenever btrfs does:

/* btrfs/inode.c:2051 */
workers = &root->fs_info->endio_write_workers;
btrfs_queue_worker(workers, &ordered_extent->work);

2. The write spikes seem to affect only one inode. That is to say, every
time there is a write spike, my printk() indicates that it is the exact
same inode being written to over and over again.

I actually scanned my entire disk for this mysterious inode (using
find / -inum ...), and it turned out to be some systemd log in
/var/log/journal. I turned off journald and rebooted, but the write spike
behavior remained. I tried removing write priviliges to that file and then
deleting it outright, but endio-write just picked another inode to write
to (which was again in /var/log/journal!).

I am not a kernel hacker and I'm not absolutely convinced this is a btrfs
issue, but I'd appreciate some pointers in the right direction.

best,
-vk
