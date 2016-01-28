Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:37441 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932651AbcA1M2W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jan 2016 07:28:22 -0500
Received: by mail-ig0-f172.google.com with SMTP id h5so10830697igh.0
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jan 2016 04:28:22 -0800 (PST)
Subject: Re: btrfs-progs 4.4 re-balance of RAID6 is very slow / limited to one
 cpu core?
To: Chris Murphy <lists@colorremedies.com>
References: <56A230C3.3080100@netcologne.de>
 <CAPmG0jZoVmnUjqaWoZgAGEXUREyMyXPxQ_+M282F640jTw5b_A@mail.gmail.com>
 <56A6082C.3030007@netcologne.de>
 <CAJCQCtQ7yGpoUZOmVcoaCGMMqg6oro-0w4HjsXK=HHe9cFg+sw@mail.gmail.com>
 <CAKZK7uxdX9UBPOKButtPjqBOdVUfHdRTimP+W34fkz1h9P+wHg@mail.gmail.com>
 <CAKZK7uxOihVUSo9+LPfUxG7WawggkXSoaTbMVa3a4pkSEuxJdQ@mail.gmail.com>
 <CAJCQCtQe=X4FPzTBKBpP826nswGQyiY4sNES9GugLju3-9HARA@mail.gmail.com>
 <CAJCQCtTA4qUNX1R3Pgxq-17zAPJvwPGfO_Fo-qEy2LsQrpF+fg@mail.gmail.com>
 <56A73460.7080100@netcologne.de>
 <CAJCQCtTdDyv0PkkuHGrEpEnk5yzM1Fx1C0VUT8r7OAfU6i8Dfw@mail.gmail.com>
 <56A7CF97.6030408@gmail.com>
 <CAJCQCtTMEHcc1CnuHqS=g23tsirQv3S9cmDcHaK0WXyQrRds1w@mail.gmail.com>
 <56A88452.6020306@netcologne.de> <56A8F18E.3070400@gmail.com>
 <CAJCQCtT9NZdaJ8MKHQw-1ARi7PkLeq_p9dtdZaPYdLt8EpTcbA@mail.gmail.com>
Cc: Christian Rohmann <crohmann@netcologne.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56AA091C.5090102@gmail.com>
Date: Thu, 28 Jan 2016 07:27:08 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtT9NZdaJ8MKHQw-1ARi7PkLeq_p9dtdZaPYdLt8EpTcbA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-01-27 16:53, Chris Murphy wrote:
> On Wed, Jan 27, 2016 at 9:34 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>
>> Hmm, I did some automated testing in a couple of VM's last night, and I have
>> to agree, this _really_ needs to get optimized.  Using the same data-set on
>> otherwise identical VM's, I saw an average 28x slowdown (best case was 16x,
>> worst was almost 100x) for balancing a RAID6 set versus a RAID1 set.  While
>> the parity computations add to the time, there is absolutely no way that
>> just that can explain why this is taking so long.  The closest comparison
>> using MD or DM RAID is probably a full verification of the array, and the
>> greatest difference there that I've seen is around 10x.
>
> I can't exactly reproduce this. I'm using +C qcow2 on Btrfs on one SSD
> to back the drives in the VM.
In my case I was using a set of 8 thinly-provisioned 256G (virtual size) 
LVM volumes exposed directly to a Xen VM as virtual block devices, 
physically backed by traditional hard drives.
For both tests, I used a filesystem spanning all the disks which had a 
lot of sparse files, and had had a lot of data chunks forced allocated 
and then made almost empty.  I made a point to use snapshots to ensure 
that the filesystem itself was not a variable in this.  It's probably 
worth noting that the system I ran this on does have other VM's running 
at the same time on the same physical CPU's, but we need to plan for 
that use case also.
>
> 2x btrfs raid1 with files totalling 5G consistently takes ~1 minute
> [1]  to balance (no filters)
Similar times here.
>
> 4x btrfs raid6 with the same files *inconsistently* takes ~1m15s [2]
> to balance (no filters)
On this I was literally getting around 30 minutes on average, with one 
case where it only took 16, and one where it took 97.  On both 
configurations, I did 12 runs total.
> iotop is all over the place, from 21MB/s writes to 527MB/s
Similar results with iotop, with values ranging from 2MB/s up to spikes 
of 100MB/s (which is about 150% of the measured streaming write speed 
from the VM going straight to the virtual disk).
>
>
> Do both of you get something like this:
> [root@f23m ~]# dmesg | grep -i raid
> [    1.518682] raid6: sse2x1   gen()  4531 MB/s
> [    1.535663] raid6: sse2x1   xor()  3783 MB/s
> [    1.552683] raid6: sse2x2   gen() 10140 MB/s
> [    1.569658] raid6: sse2x2   xor()  7306 MB/s
> [    1.586673] raid6: sse2x4   gen() 11261 MB/s
> [    1.603683] raid6: sse2x4   xor()  7009 MB/s
> [    1.603685] raid6: using algorithm sse2x4 gen() 11261 MB/s
> [    1.603686] raid6: .... xor() 7009 MB/s, rmw enabled
> [    1.603687] raid6: using ssse3x2 recovery algorithm
My system picks avx2x4, which supposedly gets 6.6 GB/s on this hardware, 
although I've never seen any raid recovery, even on RAM disks, manage 
that kind of computational throughput.
>
>
>
> [1] Did it 3 times
> 1m8
> 0m58
> 0m40
>
> [2] Did this multiple times
> 1m15s
> 0m55s
> 0m49s
> And then from that point all attempts were 2+m, but never more than
> 2m29s. I'm not sure why, but there were a lot of drop outs in iotop
> where it'd go to 0MB/s for a couple seconds. I captured some sysrq+t
> for this.
I saw similar drops in IO performance as well, although I didn't get any 
traces for it.
>
> https://drive.google.com/open?id=0B_2Asp8DGjJ9SE5ZNTBGQUV1ZUk
>
>

