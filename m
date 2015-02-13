Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f175.google.com ([209.85.160.175]:58607 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbbBMNG2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Feb 2015 08:06:28 -0500
Received: by mail-yk0-f175.google.com with SMTP id q200so5009575ykb.6
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Feb 2015 05:06:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150212045902.GD2416@localhost.localdomain>
References: <CABdHLQ7QPjUbzqNdzCfR0QxC-0coYs0dofuFvsROYXy-M9u4ig@mail.gmail.com>
	<20150212045902.GD2416@localhost.localdomain>
Date: Fri, 13 Feb 2015 14:06:27 +0100
Message-ID: <CABdHLQ5JwhizkAPA8GUFf_hBH4_LO4yJV5qkf+sRiNFG90oMGg@mail.gmail.com>
Subject: Re: btrfs performance, sudden drop to 0 IOPs
From: "P. Remek" <p.remek1@googlemail.com>
To: bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I'd use a blktrace based tool like iowatcher or seekwatcher to see
> what's really happening on the performance drops.

So I used this command to see if there are any outstanding requests in
the I/O scheduler queue when the performance drops to 0 IOPs
root@lab1:/# iostat -c -d -x -t -m /dev/sdi 1 10000

The output is:

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util

sdi               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00

"avgqu-sz" gives the queue length (1 second avarage). So really it
seems that the system is not stuck in the Block I/O layer but in upper
layer instead (most likely filesystem layer).

I also created ext4 filesystem on another pair of disks - so I was
able to run simultaneous benchmark - one for ext4 and one for btrfs
(each having 4 SSDs assigned) and when btrfs went down to 0 IOPs the
ext4 fio benchmark kept generating high IOPs.

I also tried to mount the system with nodatacow:

/dev/sdi on /mnt/btrfs type btrfs (rw,nodatacow)

It didn't help with the performance drops.
