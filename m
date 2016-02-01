Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cc-smtpout3.netcologne.de ([89.1.8.213]:60469 "EHLO
	cc-smtpout3.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820AbcBAOKx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Feb 2016 09:10:53 -0500
Subject: Re: btrfs-progs 4.4 re-balance of RAID6 is very slow / limited to one
 cpu core?
To: Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
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
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Christian Rohmann <crohmann@netcologne.de>
Message-ID: <56AF676B.2070902@netcologne.de>
Date: Mon, 1 Feb 2016 15:10:51 +0100
MIME-Version: 1.0
In-Reply-To: <CAJCQCtT9NZdaJ8MKHQw-1ARi7PkLeq_p9dtdZaPYdLt8EpTcbA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey Chris,


sorry for the late reply.


On 01/27/2016 10:53 PM, Chris Murphy wrote:
> I can't exactly reproduce this. I'm using +C qcow2 on Btrfs on one SSD
> to back the drives in the VM.
> 
> 2x btrfs raid1 with files totalling 5G consistently takes ~1 minute
> [1]  to balance (no filters)
> 
> 4x btrfs raid6 with the same files *inconsistently* takes ~1m15s [2]
> to balance (no filters)
> iotop is all over the place, from 21MB/s writes to 527MB/s

To be honest, 5G is not really 21T spread across 12 spindles with LOTS
of data on them. On another box with 8x4TB spinning rust it's also very
slow.


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


Yes:
--- cut ---
[    4.704396] raid6: sse2x1   gen()  4288 MB/s
[    4.772401] raid6: sse2x1   xor()  4036 MB/s
[    4.840403] raid6: sse2x2   gen()  7629 MB/s
[    4.908405] raid6: sse2x2   xor()  6247 MB/s
[    4.976404] raid6: sse2x4   gen() 10221 MB/s
[    5.044397] raid6: sse2x4   xor()  7620 MB/s
[    5.044525] raid6: using algorithm sse2x4 gen() 10221 MB/s
[    5.044641] raid6: .... xor() 7620 MB/s, rmw enabled
[    5.044767] raid6: using ssse3x2 recovery algorithm
--- cut ---






Would some sort of stracing or profiling of the process help to narrow
down where the time is currently spent and why the balancing is only
running single-threaded?




Regards

Christian
