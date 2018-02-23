Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:39201 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752014AbeBWXxf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Feb 2018 18:53:35 -0500
Received: by mail-io0-f174.google.com with SMTP id b34so11544611ioj.6
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Feb 2018 15:53:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTnTTN2t=J5=YThBd3Yb=tVfHBrODMnyZPWbuj9wQKSrg@mail.gmail.com>
References: <CAG+QAKXX95w4gtRCqjDkUJoSqgVOM2qEX4oDsb-C_gGbY3+w6A@mail.gmail.com>
 <CAJCQCtTnTTN2t=J5=YThBd3Yb=tVfHBrODMnyZPWbuj9wQKSrg@mail.gmail.com>
From: Rich Rauenzahn <rrauenza@gmail.com>
Date: Fri, 23 Feb 2018 15:53:34 -0800
Message-ID: <CAG+QAKVL83pbVGbfi2O=UeMiL7TW106ec17fZc-DPUo85RX6CA@mail.gmail.com>
Subject: Re: fs was hung and sort of full
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It is still hanging afterall.  Currently, it hangs on mount:

[154422.778624] mount           D    0 27894  27742 0x00000084
[154422.778625] Call Trace:
[154422.779018]  __schedule+0x28d/0x880
[154422.779494]  schedule+0x36/0x80
[154422.779886]  io_schedule+0x16/0x40
[154422.780288]  do_read_cache_page+0x3da/0x5c0
[154422.780669]  ? blkdev_writepages+0x10/0x10
[154422.781052]  ? mntput+0x24/0x40
[154422.781457]  ? page_cache_tree_insert+0xd0/0xd0
[154422.781849]  read_cache_page_gfp+0x1b/0x20
[154422.782272]  btrfs_scan_one_device+0x71/0x260 [btrfs]
[154422.782658]  ? __free_pages+0x25/0x30
[154422.783052]  ? free_pages.part.94+0x40/0x50
[154422.783521]  ? free_pages+0x13/0x20
[154422.783940]  btrfs_mount+0x2cd/0xfa0 [btrfs]
[154422.784353]  ? find_next_bit+0xb/0x10
[154422.784736]  ? pcpu_next_unpop+0x3c/0x50
[154422.785124]  ? find_next_bit+0xb/0x10
[154422.785565]  mount_fs+0x39/0x150
[154422.785949]  ? __alloc_percpu+0x15/0x20
[154422.786349]  vfs_kern_mount+0x67/0x130
[154422.786732]  btrfs_mount+0x19d/0xfa0 [btrfs]
[154422.787120]  ? find_next_bit+0xb/0x10
[154422.787586]  ? pcpu_next_unpop+0x3c/0x50
[154422.787966]  mount_fs+0x39/0x150
[154422.788360]  ? __alloc_percpu+0x15/0x20
[154422.788732]  vfs_kern_mount+0x67/0x130
[154422.789109]  do_mount+0x1f5/0xca0
[154422.789525]  SyS_mount+0x83/0xd0
[154422.789900]  do_syscall_64+0x74/0x1b0
[154422.790313]  entry_SYSCALL_64_after_hwframe+0x21/0x86

I do have a disk 100% busy (only one of the pair ...) ... so maybe
it's "working"?

Running 4.15.4-1.el7.elrepo.x86_64


On Thu, Feb 22, 2018 at 3:52 PM, Chris Murphy <lists@colorremedies.com> wrote:
> If there's no hung task listed in dmesg you could try to do sysrq+t to
> find out what everything's up to, although then you have to learn how
> to parse the result.
>
>
> Chris Murphy
