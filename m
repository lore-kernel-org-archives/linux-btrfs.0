Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.161.179]:33291 "EHLO
        mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752807AbdDQTj1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Apr 2017 15:39:27 -0400
Received: by mail-yw0-f179.google.com with SMTP id l189so60236071ywb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Apr 2017 12:39:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <18a01a39-9c2d-8a7a-7fba-1cd150976605@gmail.com>
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
 <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com> <CAJCQCtS=xqcWMqiRxC_uoqTRUaW6aMwayoqjtMqq6XhcCJNVRg@mail.gmail.com>
 <8f046fa5-a458-9db8-b616-907afd34383b@gmail.com> <CAJCQCtTCd7BEwQN4k9n0Jm6ZQTnCS738ctEUnKDb2eENhe21Sg@mail.gmail.com>
 <18a01a39-9c2d-8a7a-7fba-1cd150976605@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 17 Apr 2017 13:39:26 -0600
Message-ID: <CAJCQCtQn8kOrQBXc=xX8MbZnFnLQjECvEuc1zx0=5cAvGNLrJg@mail.gmail.com>
Subject: Re: Btrfs/SSD
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Imran Geriskovan <imran.geriskovan@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 17, 2017 at 1:26 PM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2017-04-17 14:34, Chris Murphy wrote:

>> Nope. The first paragraph applies to NVMe machine with ssd mount
>> option. Few fragments.
>>
>> The second paragraph applies to SD Card machine with ssd_spread mount
>> option. Many fragments.
>
> Ah, apologies for my misunderstanding.
>>
>>
>> These are different versions of systemd-journald so I can't completely
>> rule out a difference in write behavior.
>
> There have only been a couple of changes in the write patterns that I know
> of, but I would double check that the values for Seal and Compress in the
> journald.conf file are the same, as I know for a fact that changing those
> does change the write patterns (not much, but they do change).

Same, unchanged defaults on both systems.

#Storage=auto
#Compress=yes
#Seal=yes
#SplitMode=uid
#SyncIntervalSec=5m
#RateLimitIntervalSec=30s
#RateLimitBurst=1000


The sync interval sec is curious. 5 minutes? Umm, I'm seeing nearly
constant hits every 2-5 seconds on the journal file; using filefrag.
I'm sure there's a better way to trace a single file being
read/written to than this, but...


>>>> It's almost like we need these things to not fsync at all, and just
>>>> rely on the filesystem commit time...
>>>
>>>
>>> Essentially yes, but that causes all kinds of other problems.
>>
>>
>> Drat.
>>
> Admittedly most of the problems are use-case specific (you can't afford to
> lose transactions in a financial database  for example, so it functionally
> has to call fsync after each transaction), but most of it stems from the
> fact that BTRFS is doing a lot of the same stuff that much of the 'problem'
> software is doing itself internally.
>

Seems like the old way of doing things, and the staleness of the
internet, have colluded to create a lot of nervousness and misuse of
fsync. The very fact Btrfs needs a log tree to deal with fsync's in a
semi-sane way...


-- 
Chris Murphy
