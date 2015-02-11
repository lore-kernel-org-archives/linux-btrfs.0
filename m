Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:37689 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbbBKMkf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Feb 2015 07:40:35 -0500
Received: by mail-ig0-f181.google.com with SMTP id hn18so4002905igb.2
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Feb 2015 04:40:34 -0800 (PST)
Message-ID: <54DB4DB8.2020705@gmail.com>
Date: Wed, 11 Feb 2015 07:40:24 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: "P. Remek" <p.remek1@googlemail.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs performance, sudden drop to 0 IOPs
References: <CABdHLQ7QPjUbzqNdzCfR0QxC-0coYs0dofuFvsROYXy-M9u4ig@mail.gmail.com>
In-Reply-To: <CABdHLQ7QPjUbzqNdzCfR0QxC-0coYs0dofuFvsROYXy-M9u4ig@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-02-09 12:26, P. Remek wrote:
> Hello,
>
> I am benchmarking Btrfs and when benchmarking random writes with fio
> utility, I noticed following two things:
>
Based on what I know about BTRFS, I think that these issues actually 
have distinct causes.
> 1) On first run when target file doesn't exist yet, perfromance is
> about 8000 IOPs. On second, and every other run, performance goes up
> to 70000 IOPs. Its massive difference. The target file is the one
> created during the first run.
I've noticed that almost always, file creation on BTRFS is slower than 
file re-writes.  This seems to especially be the case when using AIO 
and/or O_DIRECT (although O_DIRECT on a COW filesystem is _really_ 
complicated to get right).  I don't know that there is really any way 
currently to solve this, although it would be interesting to see if 
fallocat'ing the files prior to the initial run would have any 
significant performance impact.
>
> 2) There are windows during the test where IOPs drop to 0 and stay 0
> about 10 seconds and then it goes back again, and after couple of
> seconds again to 0. This is reproducible 100% times.
I've seen this same behavior on a number of filesystems (not just BTRFS) 
when using the default I/O scheduler with it's default parameters, 
especially on systems with high performance storage.  IIRC, Ubuntu 13.10 
switched from using the upstream default I/O scheduler (CFQ) to using 
the Deadline I/O scheduler because it has better performance (and is 
more deterministic) on most cheap commodity desktop/laptop hardware. 
I've found however that the Deadline scheduler actually tends to perform 
worse than CFQ when used on higher-end server systems and/or SSD's, 
although CFQ with default parameters only does marginally better.  I'd 
suggest experimenting with some of the parameters under /sys/block 
(check the files in the Documentation/block directory of the Linux 
kernel sources for information about what (almost) everything there does).

