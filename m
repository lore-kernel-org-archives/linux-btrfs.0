Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cc-smtpout1.netcologne.de ([89.1.8.211]:53927 "EHLO
	cc-smtpout1.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbcBINsS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Feb 2016 08:48:18 -0500
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
 <56AF676B.2070902@netcologne.de>
 <CAJCQCtS1gX4jbnpjmgnGn2WE5TTfHnSfeyQioDwRL4vgZrXMhA@mail.gmail.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
From: Christian Rohmann <crohmann@netcologne.de>
Message-ID: <56B9EE1E.2040000@netcologne.de>
Date: Tue, 9 Feb 2016 14:48:14 +0100
MIME-Version: 1.0
In-Reply-To: <CAJCQCtS1gX4jbnpjmgnGn2WE5TTfHnSfeyQioDwRL4vgZrXMhA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/01/2016 09:52 PM, Chris Murphy wrote:
>> Would some sort of stracing or profiling of the process help to narrow
>> > down where the time is currently spent and why the balancing is only
>> > running single-threaded?
> This can't be straced. Someone a lot more knowledgeable than I am
> might figure out where all the waits are with just a sysrq + t, if it
> is a hold up in say parity computations. Otherwise perf which is a
> rabbit hole but perf top is kinda cool to watch. That might give you
> an idea where most of the cpu cycles are going if you can isolate the
> workload to just the balance. Otherwise you may end up with noisy
> data.

My balance run is now working away since 19th of January:
 "885 out of about 3492 chunks balanced (996 considered),  75% left"

So this will take several more WEEKS to finish. Is there really nothing
anyone here wants me to do or analyze to help finding the root cause of
this? I mean with this kind of performance there is no way a RAID6 can
be used in production. Not because the code is not stable or
functioning, but because regular maintenance like replacing a drive or
growing an array takes WEEKS in which another maintenance procedure
could be necessary or, much worse, another drive might have failed.

What I'm saying is: Such a slow RAID6 balance renders the redundancy
unusable because drives might fail quicker than the potential rebuild
(read "balance").



Regards

Christian
