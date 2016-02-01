Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:36312 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbcBAUwe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Feb 2016 15:52:34 -0500
Received: by mail-ig0-f174.google.com with SMTP id z14so44978441igp.1
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Feb 2016 12:52:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56AF676B.2070902@netcologne.de>
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
	<CAJCQCtT9NZdaJ8MKHQw-1ARi7PkLeq_p9dtdZaPYdLt8EpTcbA@mail.gmail.com>
	<56AF676B.2070902@netcologne.de>
Date: Mon, 1 Feb 2016 13:52:33 -0700
Message-ID: <CAJCQCtS1gX4jbnpjmgnGn2WE5TTfHnSfeyQioDwRL4vgZrXMhA@mail.gmail.com>
Subject: Re: btrfs-progs 4.4 re-balance of RAID6 is very slow / limited to one
 cpu core?
From: Chris Murphy <lists@colorremedies.com>
To: Christian Rohmann <crohmann@netcologne.de>
Cc: Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 1, 2016 at 7:10 AM, Christian Rohmann
<crohmann@netcologne.de> wrote:
> Hey Chris,
>
>
> sorry for the late reply.
>
>
> On 01/27/2016 10:53 PM, Chris Murphy wrote:
>> I can't exactly reproduce this. I'm using +C qcow2 on Btrfs on one SSD
>> to back the drives in the VM.
>>
>> 2x btrfs raid1 with files totalling 5G consistently takes ~1 minute
>> [1]  to balance (no filters)
>>
>> 4x btrfs raid6 with the same files *inconsistently* takes ~1m15s [2]
>> to balance (no filters)
>> iotop is all over the place, from 21MB/s writes to 527MB/s
>
> To be honest, 5G is not really 21T spread across 12 spindles with LOTS
> of data on them. On another box with 8x4TB spinning rust it's also very
> slow.

5G vs 21T is relevant if the mere fact there's more metadata (bigger
file system) is the source of the problem. Otherwise, at a moment in
time, neither one of us have 5G let alone 21T of data in-flight.

But you have 12 drives, with a theoretical data bandwidth for reads
and writes of about 1GiB/s depending on the performance of the drives,
and where on the platter the read/write happens. So my test is
actually the disadvantaged one. My scenario with 4 qcow2 files on a
single SSD should not perform better, except possibly with respect to
IOPS. But this is not a metdata intensive test, it was merely two
large sequential files.

So if you have very heavy metadata intensive workload, that's actually
pretty bad for any RAID6 and it's probably not great for Btrfs either.
A consideration is how metadata chunks get balanced on raid6 where the
strip size is 64K and the nodesize is 16K. If there's a lot of
metadata being produced, I think we'd expect first that 16K nodes are
fully packed, and then each 64K strip per device is fully packed, then
parity is computed for that stripe, and then the whole stripe is
written.

But when modified, what does a single key change look like? The
minimum initial change is a single 16KiB node has to be CoWd, but
since it's raid6, that means what?

1. Read the 64K strip containing the 16K node.
2. Read the separate 64K strip containing its csum? Not sure if the
node's csum is actually in the node itself.
3. Does btrfs raid6 always check parity on every read? That's not the
case with md raid. On normal reads where the drive does not report a
read error, parity strips are never read, so in effect it's raid0
using n-2 drives, with the strip being the minimum read size.

Depending on all of this, a single 16K read means 1-3 IOs. And a
modification would require 4-6 IOs. Each IO is 64K. So this is not
going to be small file friendly at all the way I see it, hence why it
could be really valuable to have raid1 metadata (with n way
mirroring). Or possibly set the nodesize to 64K to match the strip
size?

So the test I did is relevant in that a.) it's sufficiently different
from your setup, b.) I can't reproduce the problem where raid6 balance
takes longer than raid1 balance. So there's something else going on
other than it merely being raid6. It's raid6 *and* it's something
else, like the workload.


> Would some sort of stracing or profiling of the process help to narrow
> down where the time is currently spent and why the balancing is only
> running single-threaded?

This can't be straced. Someone a lot more knowledgeable than I am
might figure out where all the waits are with just a sysrq + t, if it
is a hold up in say parity computations. Otherwise perf which is a
rabbit hole but perf top is kinda cool to watch. That might give you
an idea where most of the cpu cycles are going if you can isolate the
workload to just the balance. Otherwise you may end up with noisy
data.



-- 
Chris Murphy
