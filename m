Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:34716 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158AbcA0Qer (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jan 2016 11:34:47 -0500
Received: by mail-ig0-f174.google.com with SMTP id ik10so84679189igb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jan 2016 08:34:46 -0800 (PST)
Subject: Re: btrfs-progs 4.4 re-balance of RAID6 is very slow / limited to one
 cpu core?
To: Christian Rohmann <crohmann@netcologne.de>,
        Chris Murphy <lists@colorremedies.com>
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
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56A8F18E.3070400@gmail.com>
Date: Wed, 27 Jan 2016 11:34:22 -0500
MIME-Version: 1.0
In-Reply-To: <56A88452.6020306@netcologne.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-01-27 03:48, Christian Rohmann wrote:
>
>
> On 01/26/2016 09:20 PM, Chris Murphy wrote:
>> nyway,
>> it seems reasonable to try a balance without the filters to see if
>> that's a factor, because those filters are brand new in btrfs-progs
>> 4.4. Granted, I'd expect they've been tested by upstream developers,
>> but I don't know if there's an fstest for balance with these specific
>> filters yet.
>
> I have another box with 8 disks RAID6 on which I simply did a balance
> with no newly added drives. Same issue ... VERY slow running balance
> with IO nowhere near 100% utilization and many many days of runtime to
> finish.
Hmm, I did some automated testing in a couple of VM's last night, and I 
have to agree, this _really_ needs to get optimized.  Using the same 
data-set on otherwise identical VM's, I saw an average 28x slowdown 
(best case was 16x, worst was almost 100x) for balancing a RAID6 set 
versus a RAID1 set.  While the parity computations add to the time, 
there is absolutely no way that just that can explain why this is taking 
so long.  The closest comparison using MD or DM RAID is probably a full 
verification of the array, and the greatest difference there that I've 
seen is around 10x.
