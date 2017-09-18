Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:56184 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752403AbdIRHhQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 03:37:16 -0400
Received: by mail-qk0-f182.google.com with SMTP id u73so6392473qkl.12
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Sep 2017 00:37:15 -0700 (PDT)
MIME-Version: 1.0
From: shally verma <shallyvermacavium@gmail.com>
Date: Mon, 18 Sep 2017 13:06:45 +0530
Message-ID: <CAP9W88j+UZCiF6-Bj6Nyh83L=jpTfM5vF-Pz0y09TJ5dsbciZw@mail.gmail.com>
Subject: using fio to test btrfs compression
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

I wanted to test btrfs compression using fio command but somehow
during fio writes, I don't see code taking route of compression blocks
where as If I do a copy to btrfs compression enabled mount point then
I can easily see code falling through compression.c.

Here's how I do my setup

1. mkfs.btrfs /dev/sdb1
2. mount -t btrfs -o compress=zlib,compress-force /dev/sdb1 /mnt
3. cp <some large test file> /mnt
4. dmesg shows print staments from compression.c and zlib.c confirming
compression routine was invoked during write
5. now, copy back from btrfs mount point to home directory also shows
decompress call invokation

Now, try same with fio commands:

fio command

fio --directory=/mnt/ --numjobs=1 --direct=0 --buffered=1
--ioengine=libaio --group_reporting --bs=64k --rw=write --iodepth=128
--name=test --size=10G --runtime=180 --time_based

But it seems to write uncompressed data.

Any help here? what's missing?

Thanks
Shally
