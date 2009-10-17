From: Zhu Yanhai <zhu.yanhai@gmail.com>
Subject: Re: btrfs on small (embedded) systems
Date: Sat, 17 Oct 2009 13:56:39 +0800
Message-ID: <977a2be20910162256k786d7975i52de239680e589d3@mail.gmail.com>
References: <4AC0B077.6080809@wpkg.org> <977a2be20910162254m6beaa89ey20d29b5efc9b5f45@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <977a2be20910162254m6beaa89ey20d29b5efc9b5f45@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

And because Moblin is supposed to run on netbooks, MID and cellphones
(with Intel's future moorestown chipset), hopefully we will see btrfs
running in MID and cellphones in 2010.

2009/10/17 Zhu Yanhai <zhu.yanhai@gmail.com>:
> Intel's Moblin (Moblie linux, www.moblin.org) has used btrfs as
> default root filesystem, unless
> the users choose other filesystems in the installer.
>
>
> 2009/9/28 Tomasz Chmielewski <mangoo@wpkg.org>:
>> FYI - I've been using btrfs with 2.6.31.1 kernel for a few days as a=
 rootfs
>> on a small mips system (ASUS WL-500gP - 32 MB RAM, 266 MHz CPU).
>>
>> btrfs filesystem is placed on a USB-stick connected to the device (i=
nternal
>> flash only contains the kernel).
>>
>>
>> My main motivation for using btrfs on this small system was compress=
ion this
>> filesystem offers - flash storage is still prohibitively expensive w=
hen
>> compared to traditional hard disks (i.e. 32 GB USB-stick costs as mu=
ch as a
>> 1 TB HDD).
>>
>>
>> So far, everything looks fine, although I didn't try to stress it mu=
ch (or
>> use snapshots and/or make the filesystem full).
>>
>>
>> Certainly one thing I'm missing in btrfs is the ability to use swapf=
iles -
>> is it planned one day (or perhaps some serious surgery in MM would b=
e needed
>> first)?
>>
>>
>> --
>> Tomasz Chmielewski
>> http://wpkg.org
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrf=
s" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
