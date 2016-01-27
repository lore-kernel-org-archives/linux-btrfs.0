Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:34912 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805AbcA0Vxu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jan 2016 16:53:50 -0500
Received: by mail-ig0-f176.google.com with SMTP id t15so94283804igr.0
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jan 2016 13:53:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56A8F18E.3070400@gmail.com>
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
	<56A88452.6020306@netcologne.de>
	<56A8F18E.3070400@gmail.com>
Date: Wed, 27 Jan 2016 14:53:48 -0700
Message-ID: <CAJCQCtT9NZdaJ8MKHQw-1ARi7PkLeq_p9dtdZaPYdLt8EpTcbA@mail.gmail.com>
Subject: Re: btrfs-progs 4.4 re-balance of RAID6 is very slow / limited to one
 cpu core?
From: Chris Murphy <lists@colorremedies.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Christian Rohmann <crohmann@netcologne.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 27, 2016 at 9:34 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:

> Hmm, I did some automated testing in a couple of VM's last night, and I have
> to agree, this _really_ needs to get optimized.  Using the same data-set on
> otherwise identical VM's, I saw an average 28x slowdown (best case was 16x,
> worst was almost 100x) for balancing a RAID6 set versus a RAID1 set.  While
> the parity computations add to the time, there is absolutely no way that
> just that can explain why this is taking so long.  The closest comparison
> using MD or DM RAID is probably a full verification of the array, and the
> greatest difference there that I've seen is around 10x.

I can't exactly reproduce this. I'm using +C qcow2 on Btrfs on one SSD
to back the drives in the VM.

2x btrfs raid1 with files totalling 5G consistently takes ~1 minute
[1]  to balance (no filters)

4x btrfs raid6 with the same files *inconsistently* takes ~1m15s [2]
to balance (no filters)
iotop is all over the place, from 21MB/s writes to 527MB/s


Do both of you get something like this:
[root@f23m ~]# dmesg | grep -i raid
[    1.518682] raid6: sse2x1   gen()  4531 MB/s
[    1.535663] raid6: sse2x1   xor()  3783 MB/s
[    1.552683] raid6: sse2x2   gen() 10140 MB/s
[    1.569658] raid6: sse2x2   xor()  7306 MB/s
[    1.586673] raid6: sse2x4   gen() 11261 MB/s
[    1.603683] raid6: sse2x4   xor()  7009 MB/s
[    1.603685] raid6: using algorithm sse2x4 gen() 11261 MB/s
[    1.603686] raid6: .... xor() 7009 MB/s, rmw enabled
[    1.603687] raid6: using ssse3x2 recovery algorithm



[1] Did it 3 times
1m8
0m58
0m40

[2] Did this multiple times
1m15s
0m55s
0m49s
And then from that point all attempts were 2+m, but never more than
2m29s. I'm not sure why, but there were a lot of drop outs in iotop
where it'd go to 0MB/s for a couple seconds. I captured some sysrq+t
for this.

https://drive.google.com/open?id=0B_2Asp8DGjJ9SE5ZNTBGQUV1ZUk


-- 
Chris Murphy
