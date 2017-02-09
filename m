Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:35101 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751525AbdBIMsj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Feb 2017 07:48:39 -0500
Received: by mail-it0-f54.google.com with SMTP id 203so124349522ith.0
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Feb 2017 04:48:02 -0800 (PST)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id g76sm13081817ioj.36.2017.02.09.04.48.00
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Feb 2017 04:48:00 -0800 (PST)
Subject: Re: understanding disk space usage
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
References: <CALg=eG_C-Xkw+TTHpNq9y_euza81TPTd+YN10_V=9WSprN0BPw@mail.gmail.com>
 <7912da41-d58a-d57f-47cd-508bc709a761@cn.fujitsu.com>
 <22683.12104.679173.639568@tree.ty.sabi.co.uk>
 <171155ef-93c2-f438-3bbd-ca550381c80d@gmail.com>
 <22683.37260.208424.336485@tree.ty.sabi.co.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <125c2b27-928e-5261-a0ce-1622b7a70a76@gmail.com>
Date: Thu, 9 Feb 2017 07:47:56 -0500
MIME-Version: 1.0
In-Reply-To: <22683.37260.208424.336485@tree.ty.sabi.co.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-08 16:45, Peter Grandi wrote:
> [ ... ]
>> The issue isn't total size, it's the difference between total
>> size and the amount of data you want to store on it. and how
>> well you manage chunk usage. If you're balancing regularly to
>> compact chunks that are less than 50% full, [ ... ] BTRFS on
>> 16GB disk images before with absolutely zero issues, and have
>> a handful of fairly active 8GB BTRFS volumes [ ... ]
>
> Unfortunately balance operations are quite expensive, especially
> from inside VMs. On the other hand if the system is not much
> disk constrained relatively frequent balances is a good idea
> indeed. It is a bit like the advice in the other thread on OLTP
> to run frequent data defrags, which are also quite expensive.
That depends on how and when you do them.  A full balance isn't part of 
regular maintenance, and should never be such.  Regular partial balances 
done to clean up mostly empty chunks absolutely should be part of 
regular maintenance, and are pretty inexpensive in terms of both time 
and resource usage.  Balance with -dusage=20 -musage=20 should run in at 
most a few seconds on most reasonably sized filesystems even on low-end 
systems like a Raspberry Pi, and running that on an at least weekly 
basis will significantly improve the chances that you don't encounter a 
situation like this.
>
> Both combined are like running the compactor/cleaner on log
> structured (another variants of "COW") filesystems like NILFS2:
> running that frequently means tighter space use and better
> locality, but is quite expensive too.
If you run with autodefrag, then you should rarely if ever need to 
actually run a full defrag operation unless you're storing lots of 
database files, VM disk images, or similar stuff.  This goes double on 
an SSD.
>
>>> [ ... ] My impression is that the Btrfs design trades space
>>> for performance and reliability.
>
>> In general, yes, but a more accurate statement would be that
>> it offers a trade-off between space and convenience. [ ... ]
>
> It is not quite "convenience", it is overhead: whole-volume
> operations like compacting, defragmenting (or fscking) tend to
> cost significantly in IOPS and also in transfer rate, and on
> flash SSDs they also consume lifetime.
Overhead is the inverse of convenience.  By over-provisioning to a 
greater degree, you're reducing the need to worry about those 
'expensive' operations, reducing both resource overhead, and management 
overhead.
>
> Therefore personally I prefer to have quite a bit of unused
> space in Btrfs or NILFS2, at a minimum around double at 10-20%
> than the 5-10% that I think is the minimum advisable with
> conventional designs.
I can agree on this point, over-provisioning is mandatory to a much 
greater degree on COW filesystems.
