Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50787 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751435AbeA0Gst (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 Jan 2018 01:48:49 -0500
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: degraded permanent mount option
From: Christophe Yayon <cyayon@nbux.org>
In-Reply-To: <8607255b-98e7-5623-6f62-75d6f7cf23db@gmail.com>
Date: Sat, 27 Jan 2018 07:48:47 +0100
Cc: "Majordomo vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-Id: <569AC15F-174E-4C78-8FE5-6CE9E0BED479@yayon.me>
References: <1516975360.4083556.1249069832.1B287A04@webmail.messagingengine.com> <5d342036-0de0-9bf7-3e9e-4885b62d8100@gmail.com> <1516978054.4103196.1249114200.76EC1546@webmail.messagingengine.com> <84c23047-522d-2529-5b16-d07ed8c28fc6@gmail.com> <1517035210.1252874.1249880112.19FABD13@webmail.messagingengine.com> <8607255b-98e7-5623-6f62-75d6f7cf23db@gmail.com>
To: Andrei Borzenkov <arvidjaar@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I think you are right, i do not see any systemd message when degraded option is missing and have to remount manually with degraded.

It seems it is better to use mdadm for raid and btrfs over it as i understand. Even in recent kernel ?
I hav me to do some bench and compare...

Thanks

--
Christophe Yayon

> On 27 Jan 2018, at 07:43, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
> 
> 27.01.2018 09:40, Christophe Yayon пишет:
>> Hi, 
>> 
>> I am using archlinux with kernel 4.14, there is btrfs module in initrd.
>> In fstab root is mounted via UUID. As far as I know the UUID is the same
>> for all devices in raid array.
>> The system boot with no problem with degraded and only 1/2 root device.
> 
> Then your initramfs does not use systemd.
> 
>> --
>>  Christophe Yayon
>>  cyayon-list@nbux.org
>> 
>> 
>> 
>>> On Sat, Jan 27, 2018, at 06:50, Andrei Borzenkov wrote:
>>> 26.01.2018 17:47, Christophe Yayon пишет:
>>>> Hi Austin,
>>>> 
>>>> Thanks for your answer. It was my opinion too as the "degraded"
>>>> seems to be flagged as "Mostly OK" on btrfs wiki status page. I am
>>>> running Archlinux with recent kernel on all my servers (because of
>>>> use of btrfs as my main filesystem, i need a recent kernel).> >
>>>> Your idea to add a separate entry in grub.cfg with
>>>> rootflags=degraded is attractive, i will do this...> >
>>>> Just a last question, i thank that it was necessary to add
>>>> "degraded" option in grub.cfg AND fstab to allow boot in degraded
>>>> mode. I am not sure that only grub.cfg is sufficient...> > Yesterday, i have done some test and boot a a system with only 1 of
>>>> 2 drive in my root raid1 array. No problem with systemd,>
>>> Are you using systemd in your initramfs (whatever
>>> implementation you are> using)? I just tested with dracut using systemd dracut module and it
>>> does not work - it hangs forever waiting for device. Of course,
>>> there is> no way to abort it and go into command line ...
>>> 
>>> Oh, wait - what device names are you using? I'm using mount by
>>> UUID and> this is where the problem starts - /dev/disk/by-uuid/xxx will
>>> not appear> unless all devices have been seen once ...
>>> 
>>> ... and it still does not work even if I change it to root=/dev/sda1
>>> explicitly because sda1 will *not* be announced as "present" to
>>> systemd> until all devices have been seen once ...
>>> 
>>> So no, it does not work with systemd *in initramfs*. Absolutely.
>> 
>> 
> 

