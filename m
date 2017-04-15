Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:33298 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756045AbdDOS53 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Apr 2017 14:57:29 -0400
Subject: Re: remount and conflicting ssd options?
To: Chris Murphy <chris@colorremedies.com>,
        Adam Borowski <kilobyte@angband.pl>
References: <CAJCQCtTU6M1c-B1thYtTBidyEpM9AWPMSPU=NGxj3QHnqTM7+A@mail.gmail.com>
 <20170415183156.mmgm6t4rygm2mt3j@angband.pl>
 <CAJCQCtR3ZcyauCnJhDNp6rSFvnRWcNy2UsWJsbPJEyR+4tsiEA@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <fc14dfa1-fc06-ab7b-82f6-ef8f77c268f5@mendix.com>
Date: Sat, 15 Apr 2017 20:57:27 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtR3ZcyauCnJhDNp6rSFvnRWcNy2UsWJsbPJEyR+4tsiEA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/15/2017 08:41 PM, Chris Murphy wrote:
> On Sat, Apr 15, 2017 at 12:31 PM, Adam Borowski <kilobyte@angband.pl> wrote:
>> On Sat, Apr 15, 2017 at 12:17:25PM -0600, Chris Murphy wrote:
>>> I don't understand this:
>>>
>>> /dev/mmcblk0p3 on / type btrfs
>>> (rw,noatime,seclabel,compress=zlib,nossd,ssd_spread,space_cache,commit=150,subvolid=260,subvol=/root)
>>>
>>> The fstab uses ssd_spread. It looks like during startup the initial
>>> option is ssd via autodetection and then at switchroot time, when it
>>> goes ro to rw, the fstab options are applied and it becomes
>>> ssd_spread. Fine.
>>>
>>> Then later I tried
>>>
>>> mount -o remount,ssd
>>>
>>> To go back to regular ssd option, but nothing happens, mount still
>>> shows ssd_spread.
>>
>> ssd_spread implies ssd.

Well, not really. ssd_spread also triggers ssd to be set to enabled, but
they're two different flags, and they're being tested separately in the
code. (!)

> 
> OK so it's possible to remount from ssd to ssd_spread but not back to
> ssd? If I trust the mount output, it's only possible to transition
> from ssd to ssd_spread, but not from ssd_spread to ssd.

That's correct. That's a bug. I think it needs a full umount to get it away.

>>
>>> And then if I do
>>>
>>> mount -o remount,nossd
>>>
>>> I get the above mount output with nossd,ssd_spread options which would
>>> seem to be a contradiction. At least it's confusing. So... now what?

As far as I understand now, this will mean that both nossd and
ssd_spread is active, which means that writes need a size + 0 (data) or
size + 64kiB (metadata) amount of free space to go in, and at the same
time it does not allow the write to be split up in multiple extents? :o

>>>
>>> kernel 4.10.8-200.fc25.x86_64
>>
>> Already fixed in mainline.  You need linus/master from literally today if
>> your time zone is between +1 and +3 (inclusively), adjust by one day
>> accordingly if not.
>>
>> Or cherry-pick 951e79663.
> 
> OK thanks.
> 
> Is this just fixing a mount bug? Or also with kernel messaging? I see
> the enabling of ssd and spread, but I don't see a kernel message when
> unsetting them. For the kernel messaging to be consistent, it'd need
> to always report a message when allocation strategy is being changed.

+1

I still haven't tested the patch myself yet, but I would definitely
expect that you should see the "not using ssd allocation scheme" appearing.

-- 
Hans van Kranenburg
