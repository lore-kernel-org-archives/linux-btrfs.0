Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:44044 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753003AbdKCLa3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Nov 2017 07:30:29 -0400
Received: by mail-io0-f182.google.com with SMTP id m16so5591560iod.1
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Nov 2017 04:30:29 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id v203sm1047500itf.33.2017.11.03.04.30.26
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Nov 2017 04:30:27 -0700 (PDT)
Subject: Re: defragmenting best practice?
To: linux-btrfs@vger.kernel.org
References: <20170831070558.GB5783@rus.uni-stuttgart.de>
 <CABB28CyM9wQuDgn1ONTw3hrXQrLHwk30dxPcF_qnvdCM+A0gxA@mail.gmail.com>
 <20170914172434.39eae89d@jupiter.sol.kaishome.de>
 <CABB28Cx13a4eP3nM7PVYknmug-jpyeKv1ai5DWT0jKt4Zi0Rgg@mail.gmail.com>
 <59BBB15E.8010002@sarach.com.pl>
 <CABB28CxYR35HQgvf5PvRpDkGvtBxMR1LBDQO60N6QZ1cBmZGjQ@mail.gmail.com>
 <59BBDFA6.4020500@sarach.com.pl>
 <20170915190826.1f0be8a9@jupiter.sol.kaishome.de>
 <CABB28Cw6A-xYnwkcaoc=1XJa=K8g-Bz6_KFT2Q33FUJhbXD8JQ@mail.gmail.com>
 <CAH=dxU7R2fZQY12mJnYigt2s4BqVrsALJjxgbpvo7hfEwMXt-Q@mail.gmail.com>
 <pan$a362c$5b92cac0$d2d78b7f$25ff3b3a@cox.net>
 <CAH=dxU6f_DunAsOqKQTXKp469bOaLCiqOMuSE0T3QYqc9CqFNQ@mail.gmail.com>
 <23033.512.820691.680916@tree.ty.sabi.co.uk>
 <CAH=dxU7aNg+VTeQFk-9Tk4yzPemsgL1E0iqSFXFQOxM8=ATDFQ@mail.gmail.com>
 <20171102221610.006c1e9c@jupiter.sol.kaishome.de>
 <CAH=dxU636fRCN8-gm2fL6TBiT+-h0b8KZtzip9qQuSN5Dd13PQ@mail.gmail.com>
 <20171103082624.5a2e12e9@jupiter.sol.kaishome.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5f81ce65-614c-0e45-f1f3-0e3ec5beb5a9@gmail.com>
Date: Fri, 3 Nov 2017 07:30:23 -0400
MIME-Version: 1.0
In-Reply-To: <20171103082624.5a2e12e9@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-11-03 03:26, Kai Krakow wrote:
> Am Thu, 2 Nov 2017 22:47:31 -0400
> schrieb Dave <davestechshop@gmail.com>:
> 
>> On Thu, Nov 2, 2017 at 5:16 PM, Kai Krakow <hurikhan77@gmail.com>
>> wrote:
>>
>>>
>>> You may want to try btrfs autodefrag mount option and see if it
>>> improves things (tho, the effect may take days or weeks to apply if
>>> you didn't enable it right from the creation of the filesystem).
>>>
>>> Also, autodefrag will probably unshare reflinks on your snapshots.
>>> You may be able to use bees[1] to work against this effect. Its
>>> interaction with autodefrag is not well tested but it works fine
>>> for me. Also, bees is able to reduce some of the fragmentation
>>> during deduplication because it will rewrite extents back into
>>> bigger chunks (but only for duplicated data).
>>>
>>> [1]: https://github.com/Zygo/bees
>>
>> I will look into bees. And yes, I plan to try autodefrag. (I already
>> have it enabled now.) However, I need to understand something about
>> how btrfs send-receive works in regard to reflinks and fragmentation.
>>
>> Say I have 2 snapshots on my live volume. The earlier one of them has
>> already been sent to another block device by btrfs send-receive (full
>> backup). Now defrag runs on the live volume and breaks some percentage
>> of the reflinks. At this point I do an incremental btrfs send-receive
>> using "-p" (or "-c") with the diff going to the same other block
>> device where the prior snapshot was already sent.
>>
>> Will reflinks be "made whole" (restored) on the receiving block
>> device? Or is the state of the source volume replicated so closely
>> that reflink status is the same on the target?
>>
>> Also, is fragmentation reduced on the receiving block device?
>>
>> My expectation is that fragmentation would be reduced and duplication
>> would be reduced too. In other words, does send-receive result in
>> defragmentation and deduplication too?
> 
> As far as I understand, btrfs send/receive doesn't create an exact
> mirror. It just replays the block operations between generation
> numbers. That is: If it finds new blocks referenced between
> generations, it will write a _new_ block to the destination.
That is mostly correct, except it's not a block level copy.  To put it 
in a heavily simplified manner, send/receive will recreate the subvolume 
using nothing more than basic file manipulation syscalls (write(), 
chown(), chmod(), etc), the clone ioctl, and some extra logic to figure 
out the correct location to clone from.  IOW, it's functionally 
equivalent to using rsync to copy the data, and then deduplicating, 
albeit a bit smarter about when to deduplicate (and more efficient in 
that respect).
> 
> So, no, it won't reduce fragmentation or duplication. It just keeps
> reflinks intact as long as such extents weren't touched within the
> generation range. Otherwise they are rewritten as new extents.
A received subvolume will almost always be less fragmented than the 
source, since everything is received serially, and each file is written 
out one at a time.
> 
> Autodefrag and deduplication processes will as such probably increase
> duplication at the destination. A developer may have a better clue, tho.
In theory, yes, but in practice, not so much.  Autodefrag generally 
operates on very small blocks of data (64k IIRC), and I'm pretty sure it 
has some heuristic that only triggers it on small random writes, so 
depending on the workload, it may not be triggering much (for example, 
it often won't trigger on cache directories, since those almost never 
have files rewritten in place).
