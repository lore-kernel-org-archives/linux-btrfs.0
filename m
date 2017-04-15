Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.161.182]:34560 "EHLO
        mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751616AbdDOSlQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Apr 2017 14:41:16 -0400
Received: by mail-yw0-f182.google.com with SMTP id k13so44607304ywk.1
        for <linux-btrfs@vger.kernel.org>; Sat, 15 Apr 2017 11:41:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170415183156.mmgm6t4rygm2mt3j@angband.pl>
References: <CAJCQCtTU6M1c-B1thYtTBidyEpM9AWPMSPU=NGxj3QHnqTM7+A@mail.gmail.com>
 <20170415183156.mmgm6t4rygm2mt3j@angband.pl>
From: Chris Murphy <chris@colorremedies.com>
Date: Sat, 15 Apr 2017 12:41:14 -0600
Message-ID: <CAJCQCtR3ZcyauCnJhDNp6rSFvnRWcNy2UsWJsbPJEyR+4tsiEA@mail.gmail.com>
Subject: Re: remount and conflicting ssd options?
To: Adam Borowski <kilobyte@angband.pl>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 15, 2017 at 12:31 PM, Adam Borowski <kilobyte@angband.pl> wrote:
> On Sat, Apr 15, 2017 at 12:17:25PM -0600, Chris Murphy wrote:
>> I don't understand this:
>>
>> /dev/mmcblk0p3 on / type btrfs
>> (rw,noatime,seclabel,compress=zlib,nossd,ssd_spread,space_cache,commit=150,subvolid=260,subvol=/root)
>>
>> The fstab uses ssd_spread. It looks like during startup the initial
>> option is ssd via autodetection and then at switchroot time, when it
>> goes ro to rw, the fstab options are applied and it becomes
>> ssd_spread. Fine.
>>
>> Then later I tried
>>
>> mount -o remount,ssd
>>
>> To go back to regular ssd option, but nothing happens, mount still
>> shows ssd_spread.
>
> ssd_spread implies ssd.

OK so it's possible to remount from ssd to ssd_spread but not back to
ssd? If I trust the mount output, it's only possible to transition
from ssd to ssd_spread, but not from ssd_spread to ssd.


>
>> And then if I do
>>
>> mount -o remount,nossd
>>
>> I get the above mount output with nossd,ssd_spread options which would
>> seem to be a contradiction. At least it's confusing. So... now what?
>>
>> kernel 4.10.8-200.fc25.x86_64
>
> Already fixed in mainline.  You need linus/master from literally today if
> your time zone is between +1 and +3 (inclusively), adjust by one day
> accordingly if not.
>
> Or cherry-pick 951e79663.

OK thanks.

Is this just fixing a mount bug? Or also with kernel messaging? I see
the enabling of ssd and spread, but I don't see a kernel message when
unsetting them. For the kernel messaging to be consistent, it'd need
to always report a message when allocation strategy is being changed.

-- 
Chris Murphy
