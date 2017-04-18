Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:35750 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752757AbdDRLbo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Apr 2017 07:31:44 -0400
Received: by mail-io0-f177.google.com with SMTP id r16so183468341ioi.2
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Apr 2017 04:31:44 -0700 (PDT)
Subject: Re: Btrfs/SSD
To: Chris Murphy <lists@colorremedies.com>
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
 <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com>
 <CAJCQCtS=xqcWMqiRxC_uoqTRUaW6aMwayoqjtMqq6XhcCJNVRg@mail.gmail.com>
 <8f046fa5-a458-9db8-b616-907afd34383b@gmail.com>
 <CAJCQCtTCd7BEwQN4k9n0Jm6ZQTnCS738ctEUnKDb2eENhe21Sg@mail.gmail.com>
 <18a01a39-9c2d-8a7a-7fba-1cd150976605@gmail.com>
 <CAJCQCtQn8kOrQBXc=xX8MbZnFnLQjECvEuc1zx0=5cAvGNLrJg@mail.gmail.com>
Cc: Imran Geriskovan <imran.geriskovan@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <82484ebd-12e2-c3fe-2ae7-a4cfb3711f10@gmail.com>
Date: Tue, 18 Apr 2017 07:31:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQn8kOrQBXc=xX8MbZnFnLQjECvEuc1zx0=5cAvGNLrJg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-04-17 15:39, Chris Murphy wrote:
> On Mon, Apr 17, 2017 at 1:26 PM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2017-04-17 14:34, Chris Murphy wrote:
>
>>> Nope. The first paragraph applies to NVMe machine with ssd mount
>>> option. Few fragments.
>>>
>>> The second paragraph applies to SD Card machine with ssd_spread mount
>>> option. Many fragments.
>>
>> Ah, apologies for my misunderstanding.
>>>
>>>
>>> These are different versions of systemd-journald so I can't completely
>>> rule out a difference in write behavior.
>>
>> There have only been a couple of changes in the write patterns that I know
>> of, but I would double check that the values for Seal and Compress in the
>> journald.conf file are the same, as I know for a fact that changing those
>> does change the write patterns (not much, but they do change).
>
> Same, unchanged defaults on both systems.
>
> #Storage=auto
> #Compress=yes
> #Seal=yes
> #SplitMode=uid
> #SyncIntervalSec=5m
> #RateLimitIntervalSec=30s
> #RateLimitBurst=1000
>
>
> The sync interval sec is curious. 5 minutes? Umm, I'm seeing nearly
> constant hits every 2-5 seconds on the journal file; using filefrag.
> I'm sure there's a better way to trace a single file being
> read/written to than this, but...
AIUI, the sync interval is like BTRFS's commit interval, the journal 
file is guaranteed to be 100% consistent at least once every 
<SyncIntervalSec> seconds.

As far as tracing, I think it's possible to do some kind of filtering 
with btrace so you just see a specific file, but I'm not certain.
>
>
>>>>> It's almost like we need these things to not fsync at all, and just
>>>>> rely on the filesystem commit time...
>>>>
>>>>
>>>> Essentially yes, but that causes all kinds of other problems.
>>>
>>>
>>> Drat.
>>>
>> Admittedly most of the problems are use-case specific (you can't afford to
>> lose transactions in a financial database  for example, so it functionally
>> has to call fsync after each transaction), but most of it stems from the
>> fact that BTRFS is doing a lot of the same stuff that much of the 'problem'
>> software is doing itself internally.
>>
>
> Seems like the old way of doing things, and the staleness of the
> internet, have colluded to create a lot of nervousness and misuse of
> fsync. The very fact Btrfs needs a log tree to deal with fsync's in a
> semi-sane way...
Except that BTRFS is somewhat unusual.  Prior to this, the only 
'mainstream' filesystem that provided most of these features was ZFS, 
and that does a good enough job that this doesn't matter.

For something like a database though, where you need ACID guarantees, 
you pretty much have to have COW semantics internally, and you have to 
force things to stable storage after each transaction that actually 
modifies data.  Looking at it another way, most database storage formats 
are essentially record-oriented filesystems (as opposed to 
block-oriented filesystems that most people think of).  This is part of 
why you see such similar access patterns in databases and VM disk images 
(even if the VM isn't running database software), they are essentially 
doing the same things at a low level.
