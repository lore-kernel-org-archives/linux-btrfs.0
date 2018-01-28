Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f176.google.com ([74.125.82.176]:45801 "EHLO
        mail-ot0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752145AbeA1UCK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Jan 2018 15:02:10 -0500
Received: by mail-ot0-f176.google.com with SMTP id r4so4687561oti.12
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Jan 2018 12:02:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180128003910.GA31699@polanet.pl>
References: <1516978054.4103196.1249114200.76EC1546@webmail.messagingengine.com>
 <84c23047-522d-2529-5b16-d07ed8c28fc6@gmail.com> <1517035210.1252874.1249880112.19FABD13@webmail.messagingengine.com>
 <8607255b-98e7-5623-6f62-75d6f7cf23db@gmail.com> <569AC15F-174E-4C78-8FE5-6CE9E0BED479@yayon.me>
 <E23AAC7C-6CAA-4290-9CF1-19285DB31D05@yayon.me> <111ca301-f631-694d-93eb-b73a790f57d4@gmail.com>
 <20180127110619.GA10472@polanet.pl> <20180127132641.mhmdhpokqrahgd4n@angband.pl>
 <pan$49d38$869e8d62$c0063169$584b8866@cox.net> <20180128003910.GA31699@polanet.pl>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 28 Jan 2018 13:02:08 -0700
Message-ID: <CAJCQCtSo12iFeyg3DSWNmOwtXHHk_sdg_MDJUrAM+Q1oaOJcAA@mail.gmail.com>
Subject: Re: degraded permanent mount option
To: Tomasz Pala <gotar@polanet.pl>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 27, 2018 at 5:39 PM, Tomasz Pala <gotar@polanet.pl> wrote:
> On Sat, Jan 27, 2018 at 15:22:38 +0000, Duncan wrote:
>
>>> manages to mount degraded btrfs without problems.  They just don't try
>>> to outsmart the kernel.
>>
>> No kidding.
>>
>> All systemd has to do is leave the mount alone that the kernel has
>> already done, instead of insisting it knows what's going on better than
>> the kernel does, and immediately umounting it.
>
> Tell me please, if you mount -o degraded btrfs - what would
> BTRFS_IOC_DEVICES_READY return?


case BTRFS_IOC_DEVICES_READY:
    ret = btrfs_scan_one_device(vol->name, FMODE_READ,
                    &btrfs_fs_type, &fs_devices);
    if (ret)
        break;
    ret = !(fs_devices->num_devices == fs_devices->total_devices);
    break;


All it cares about is whether the number of devices found is the same
as the number of devices any of that volume's supers claim make up
that volume. That's it.


>
> This is not "outsmarting" nor "knowing better", on the contrary, this is "FOLLOWING the
> kernel-returned data". The umounting case is simply a bug in btrfs.ko
> that should change to READY state *if* someone has tried and apparently
> succeeded mounting the not-ready volume.


Nope. That is not what the ioctl does.


-- 
Chris Murphy
