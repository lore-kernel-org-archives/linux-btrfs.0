Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:32791 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750726AbdGGRkG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Jul 2017 13:40:06 -0400
Received: by mail-wr0-f177.google.com with SMTP id r103so56453064wrb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Jul 2017 10:40:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <74c792e3-d8f6-fb09-c6ee-62dfdf59650c@gmail.com>
References: <CAJCQCtR+dJr8H2co41LB0hEUZCFSnkixeyv46ccdureMiBVTWg@mail.gmail.com>
 <74c792e3-d8f6-fb09-c6ee-62dfdf59650c@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 7 Jul 2017 11:40:04 -0600
Message-ID: <CAJCQCtTnfLiiURTzLre-ZYY5xQBjFf2Qrz02gqGvh6BbaF2=KQ@mail.gmail.com>
Subject: Re: btrfs device ready purpose
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 7, 2017 at 10:59 AM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
> 07.07.2017 19:42, Chris Murphy пишет:
>> I'm digging through piles of list emails and not really finding an
>> answer to this. Maybe it's Friday and I'm just confused...
>>
>>
>> [root@f26s ~]# btrfs device ready /dev/sda1
>> [root@f26s ~]# echo $?
>> 0
>> [root@f26s ~]# btrfs device ready /dev/mapper/vg-1
>> [root@f26s ~]# echo $?
>> 0
>>
>>
>> /dev/sda1 is a single device btrfs and it is present, 'btrfs fi show' finds it.
>> /dev/mapper/vg-1 is one member of a two device Btrfs volume, the
>> missing device is /dev/mapper/vg-2 and 'btrfs fi show' sees 1 but not
>> 2 and says a device is missing.
>>
>> And yet the ready command completes and the exit code is the same, and
>> I just don't understand the purpose of this command. The man page says
>> "wait" but I don't see any waiting, so at the very least we probably
>> need to come up with a more descriptive man page description.
>>
>
> Here on Ubuntu 16.04.2 man page says
>
>        ready <device>
>            Check device to see if it has all of it’s devices in cache
> for mounting.

4.11 man page says for 'btrfs device ready'
Wait until all devices of a multiple-device filesystem are scanned and
registered within the kernel module.

Not sure when it was updated.


>
> Nothing about "wait".
>
> btrfs device ready is only useful during startup. The only check it does
> - whether kernel knows about all devices or not. It is really intended
> to be used from udev rule to delay attempt to mount filesystem until all
> devices have been seen. And it is only useful with systemd as it is the
> only program that actually pays attention to it.

OK that make sense. I'm just not used to the convention where a user
space tool does literally nothing for the user, and also has a man
page entry as if it is for users. And I get that developers are users
too, it just seems like an odd convention but whatever.

-- 
Chris Murphy
