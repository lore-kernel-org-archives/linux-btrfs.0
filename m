Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:34579 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751677AbdK1NFq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Nov 2017 08:05:46 -0500
Received: by mail-it0-f47.google.com with SMTP id m11so23110761iti.1
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Nov 2017 05:05:46 -0800 (PST)
Subject: Re: swapon: swapfile has holes
To: Cristian <caravena@gmail.com>, linux-btrfs@vger.kernel.org
References: <CABwnbUnS0EQfq+L_cbz53OMG7VBbGC-gEt0JXJyUv9qU2RcdEQ@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <2b408b4e-8dfc-3d2f-18b5-8d9f6d03e4ad@gmail.com>
Date: Tue, 28 Nov 2017 08:05:41 -0500
MIME-Version: 1.0
In-Reply-To: <CABwnbUnS0EQfq+L_cbz53OMG7VBbGC-gEt0JXJyUv9qU2RcdEQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-11-28 07:31, Cristian wrote:
> Hello,
> 
> Report in:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1723449
> 
> dmesg:
> [ 3.782191] swapon: swapfile has holes

As mentioned in the linked bug report, this is a known issue.  To use a 
swap file on BTRFS, you need to:

1. Create an empty file.
2. Mark it NOCOW with `chattr +C`
3. Use fallocate to pre-allocate to the appropriate size.
4. Hook it up to a loop device.
5. Use the loop device for swap.

This is because the kernel needs a consistent block mapping for a swap 
file, since it bypasses the filesystem and accesses the block device 
directly.  However, since BTRFS has copy-on-write semantics, blocks move 
around on each write, which violates the requirement for a consistent 
block mapping, you can't use a file on a BTRFS filesystem directly as a 
swap file.

Of the above steps, you technically don't need to mark the file NOCOW or 
pre-allocate it, but those are good practice to remove random latency.
