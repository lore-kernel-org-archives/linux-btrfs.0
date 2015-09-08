Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:36008 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbbIHUNq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Sep 2015 16:13:46 -0400
Received: by wicgb1 with SMTP id gb1so91849233wic.1
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Sep 2015 13:13:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSOmfAOfdXXWKJ0noD_PJ=smpETLQ=C5ND-QGOserr6TQ@mail.gmail.com>
References: <CAA85sZv5V_YGnHaYfDKJ8L9=Nmg0XNRoxK9NLZER_jKZ7TUdnA@mail.gmail.com>
 <20150908193405.GN23944@carfax.org.uk> <CAA85sZu9xJOHMr0rs7hvzvBZwBWN7RvCb3bt4dYM7_6D2qyh7Q@mail.gmail.com>
 <CAA85sZvJdOyUhZqFy4bWEPbKfM7k9gKU4vui9k+rRDmnWvPSxQ@mail.gmail.com>
 <CAA85sZtUJCDQ2=7KNFapZXPXb8SseiLCBvJVBDkoUa_7Ah8idQ@mail.gmail.com> <CAJCQCtSOmfAOfdXXWKJ0noD_PJ=smpETLQ=C5ND-QGOserr6TQ@mail.gmail.com>
From: Ian Kumlien <ian.kumlien@gmail.com>
Date: Tue, 8 Sep 2015 22:13:25 +0200
Message-ID: <CAA85sZueV2NuTeUdvWjEJKc8L1u6h7Tbdne0vPtd75zxshPBgw@mail.gmail.com>
Subject: Re: [btrfs tools] ability to fail a device...
To: Chris Murphy <lists@colorremedies.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8 September 2015 at 22:08, Chris Murphy <lists@colorremedies.com> wrote:
> On Tue, Sep 8, 2015 at 2:00 PM, Ian Kumlien <ian.kumlien@gmail.com> wrote:

[--8<--]

>> Someone thought they were done too early, only one disk => read only
>> mount. But, readonly mount => no balance.
>>
>> I think something is wrong....
>>
>> btrfs balance start -dconvert=single -mconvert=single /mnt/disk/
>> ERROR: error during balancing '/mnt/disk/' - Read-only file system
>>
>> btrfs dev delete missing /mnt/disk/
>> ERROR: error removing the device 'missing' - Read-only file system
>>
>> Any mount without ro becomes:
>> [  507.236652] BTRFS info (device sda2): allowing degraded mounts
>> [  507.236655] BTRFS info (device sda2): disk space caching is enabled
>> [  507.325365] BTRFS: bdev (null) errs: wr 2036894, rd 2031380, flush
>> 705, corrupt 0, gen 0
>> [  510.983321] BTRFS: too many missing devices, writeable mount is not allowed
>> [  511.006241] BTRFS: open_ctree failed
>>
>> And one of them has to give! ;)
>
>
> You've run into this:
> https://bugzilla.kernel.org/show_bug.cgi?id=92641

Ah, I thought it might not be known - I'm currently copying the files
since a read only mount is "good enough" for that

-o degraded should allow readwrite *IF* the data can be written to....
My question is also, would this keep me from "adding devices"?
I mean, it did seem like a catch 22 earlier, but that would really
make a mess of things...

> --
> Chris Murphy
