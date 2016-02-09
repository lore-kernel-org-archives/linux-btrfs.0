Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:34767 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512AbcBIVqC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Feb 2016 16:46:02 -0500
Received: by mail-io0-f171.google.com with SMTP id 9so1992566iom.1
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Feb 2016 13:46:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56B9EE1E.2040000@netcologne.de>
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
	<CAJCQCtS1gX4jbnpjmgnGn2WE5TTfHnSfeyQioDwRL4vgZrXMhA@mail.gmail.com>
	<56B9EE1E.2040000@netcologne.de>
Date: Tue, 9 Feb 2016 14:46:01 -0700
Message-ID: <CAJCQCtTPQE+hBzaktURR1v3GtObSjH=UV806qU-RmFVomwK3GA@mail.gmail.com>
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

On Tue, Feb 9, 2016 at 6:48 AM, Christian Rohmann
<crohmann@netcologne.de> wrote:
>
>
> On 02/01/2016 09:52 PM, Chris Murphy wrote:
>>> Would some sort of stracing or profiling of the process help to narrow
>>> > down where the time is currently spent and why the balancing is only
>>> > running single-threaded?
>> This can't be straced. Someone a lot more knowledgeable than I am
>> might figure out where all the waits are with just a sysrq + t, if it
>> is a hold up in say parity computations. Otherwise perf which is a
>> rabbit hole but perf top is kinda cool to watch. That might give you
>> an idea where most of the cpu cycles are going if you can isolate the
>> workload to just the balance. Otherwise you may end up with noisy
>> data.
>
> My balance run is now working away since 19th of January:
>  "885 out of about 3492 chunks balanced (996 considered),  75% left"
>
> So this will take several more WEEKS to finish. Is there really nothing
> anyone here wants me to do or analyze to help finding the root cause of
> this?

Can you run 'perf top' and let it run for a few minutes, then
copy/paste or screenshot it somewhere? I'll definitely say in advance
this is just a matter of curiosity where the kernel is spending all of
its time, that this is going so slowly. In no way can I imagine being
able to help fix it. I'm a bit surprised there's no dev response,
maybe try the IRC channel? Weeks is just too long. My concern is if
there's a drive failure, a.) what state is the fs going to be in and
b.) will device replace be this slow too? I'd expect the code path for
balance and replace to be the same, so I suspect yes.


> I mean with this kind of performance there is no way a RAID6 can
> be used in production. Not because the code is not stable or
> functioning, but because regular maintenance like replacing a drive or
> growing an array takes WEEKS in which another maintenance procedure
> could be necessary or, much worse, another drive might have failed.

That's right.

In my dummy test, which should have run slower than your setup, the
other differences on my end:

elevator=noop    ## because I'm running an SSD
kernel 4.5rc0

I could redo my test, using 'perf top' also and see if there's any
glaring difference in where the kernel is spending its time on a
system pushing the block device to its max write ability, vs ones that
aren't. I don't have any other ideas. I'd rather a developer say, "try
this" to gather more useful information, rather than just poking
things with a random stick.



-- 
Chris Murphy
