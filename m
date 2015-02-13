Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36307 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbbBMOIu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Feb 2015 09:08:50 -0500
Date: Fri, 13 Feb 2015 22:08:42 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: "P. Remek" <p.remek1@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs performance, sudden drop to 0 IOPs
Message-ID: <20150213140842.GE25697@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CABdHLQ7QPjUbzqNdzCfR0QxC-0coYs0dofuFvsROYXy-M9u4ig@mail.gmail.com>
 <20150212045902.GD2416@localhost.localdomain>
 <CABdHLQ5JwhizkAPA8GUFf_hBH4_LO4yJV5qkf+sRiNFG90oMGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CABdHLQ5JwhizkAPA8GUFf_hBH4_LO4yJV5qkf+sRiNFG90oMGg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 13, 2015 at 02:06:27PM +0100, P. Remek wrote:
> > I'd use a blktrace based tool like iowatcher or seekwatcher to see
> > what's really happening on the performance drops.
> 
> So I used this command to see if there are any outstanding requests in
> the I/O scheduler queue when the performance drops to 0 IOPs
> root@lab1:/# iostat -c -d -x -t -m /dev/sdi 1 10000
> 
> The output is:
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s
> avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> 
> sdi               0.00     0.00    0.00    0.00     0.00     0.00
> 0.00     0.00    0.00    0.00    0.00   0.00   0.00
> 
> "avgqu-sz" gives the queue length (1 second avarage). So really it
> seems that the system is not stuck in the Block I/O layer but in upper
> layer instead (most likely filesystem layer).
> 
> I also created ext4 filesystem on another pair of disks - so I was
> able to run simultaneous benchmark - one for ext4 and one for btrfs
> (each having 4 SSDs assigned) and when btrfs went down to 0 IOPs the
> ext4 fio benchmark kept generating high IOPs.
> 
> I also tried to mount the system with nodatacow:
> 
> /dev/sdi on /mnt/btrfs type btrfs (rw,nodatacow)
> 
> It didn't help with the performance drops.

It's just weird since 10s is too much for filesystems, I don't know
what's happening and didn't have such an experience in my tests,

Perhaps Try "perf record -a -g" to see magic.

Thanks,

-liubo
