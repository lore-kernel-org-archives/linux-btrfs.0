Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:55126 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbbBHXJe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Feb 2015 18:09:34 -0500
Received: by mail-lb0-f173.google.com with SMTP id p9so26691743lbv.4
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Feb 2015 15:09:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANcfdL2aSfE5uwgwt1KYGRsucF_wTGSyEVT=LfX+COd2gywJ+A@mail.gmail.com>
References: <CANcfdL0x_LTSnyL1FP8vVV4=MaFrewT4pd0MZgu3qzxOviXDgg@mail.gmail.com>
 <CAJCQCtT+8+02KkYOcRUOhscj3AP0av8PpNmsK526hvJY=3ucRw@mail.gmail.com>
 <CANcfdL0twe-pi4f1ZVNG=m82gQTKc5QL3pcodY6diJ6uLj2Q9A@mail.gmail.com>
 <CAJCQCtSJ+kgxKb-gGnuOCFEVBsr2UP0aUWg_M60Ts_OQaSL8oQ@mail.gmail.com> <CANcfdL2aSfE5uwgwt1KYGRsucF_wTGSyEVT=LfX+COd2gywJ+A@mail.gmail.com>
From: constantine <costas.magnuse@gmail.com>
Date: Sun, 8 Feb 2015 23:09:12 +0000
Message-ID: <CANcfdL3qEG8HPDzRE8z8rEuuBpkcbMF4ZjV0oQrH9sZ8FSpxXg@mail.gmail.com>
Subject: Re: Replacing a (or two?) failed drive(s) in RAID-1 btrfs filesystem
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

By the way, /dev/sdc just completed the extended offline test without
any error... I feel so confused,....
constantine


On Sun, Feb 8, 2015 at 11:04 PM, constantine <costas.magnuse@gmail.com> wrote:
> Thank you very much for your help. I do not have any recovery backup
> and I need these data :(
>
> Before my problems begun I was running btrfs-scrub in a weekly basis
> and I only got 17 uncorrectable errors for this array, concerning
> files that I do not care of, so I ignored them. I clearly should not.
> I'll probably need your help again, in which case I will let you know.
>
> I get:
> # for letter in i d c g a b; do smartctl -l scterc /dev/sd$letter; done
> smartctl 6.3 2014-07-26 r3976 [x86_64-linux-3.19.0-1-mainline] (local build)
> Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org
>
> SCT Error Recovery Control command not supported
>
> smartctl 6.3 2014-07-26 r3976 [x86_64-linux-3.19.0-1-mainline] (local build)
> Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org
>
> SCT Error Recovery Control command not supported
>
> smartctl 6.3 2014-07-26 r3976 [x86_64-linux-3.19.0-1-mainline] (local build)
> Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org
>
> SCT Error Recovery Control command not supported
>
> smartctl 6.3 2014-07-26 r3976 [x86_64-linux-3.19.0-1-mainline] (local build)
> Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org
>
> SCT Error Recovery Control command not supported
>
> smartctl 6.3 2014-07-26 r3976 [x86_64-linux-3.19.0-1-mainline] (local build)
> Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org
>
> SCT Error Recovery Control:
>            Read:     70 (7.0 seconds)
>           Write:     70 (7.0 seconds)
>
> smartctl 6.3 2014-07-26 r3976 [x86_64-linux-3.19.0-1-mainline] (local build)
> Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org
>
> SCT Error Recovery Control:
>            Read:     70 (7.0 seconds)
>           Write:     70 (7.0 seconds)
>
> -----> only the last two are WD RED drives.
>
> # for letter in i d c g a b; do cat /sys/block/sd$letter/device/timeout; done
> 30
> 30
> 30
> 30
> 30
> 30
>
>
>
> On Sun, Feb 8, 2015 at 10:43 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> If you don't have a current backup, make one now.
>
> The only way I can think of making a backup with my current available
> hardware is removing my one WD Red 6TB from the array and copying
> every file on this removed disk.
> Can I remove the /dev/sdb without letting any of the data enter the
> soon-to-fail /dev/sdc1?
>
>> Just make sure you
>> don't overwrite any previous backup data in case you need it. Any
>> files that don't pass checksum will not be copied, these will be
>> recorded in dmesg. If you have those files backedup, you're done with
>> this volume.
>>
>> If not, first upgrade to btrfs-progs 3.18.2, then do btrfs check
>> --repair --init-csum-tree to delete and recreate the csum tree, and
>> then doing another incremental. Be clear with labeling these
>> incremental backups. Later you can diff them, and if any files don't
>> match between them, manually inspect to find out which one is the good
>> one. I'd say 50/50 chance the init-csum-tree won't work because it
>> looks like sdc1 always produces bad data. It's entirely possible the
>> repair goes badly, and the filesystem becomes read-only at which point
>> no more changes will be possible. To get files off that fail csum
>> (again, they're listed in dmesg), you'll have to use btrfs restore on
>> the unmount volume to extract them. This may be tedious.
>>
>>
>>
>>
>> --
>> Chris Murphy
