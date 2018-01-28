Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:47303 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752895AbeA1Wjt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Jan 2018 17:39:49 -0500
Date: Sun, 28 Jan 2018 23:39:47 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: degraded permanent mount option
Message-ID: <20180128223946.GA26726@polanet.pl>
References: <1517035210.1252874.1249880112.19FABD13@webmail.messagingengine.com>
 <8607255b-98e7-5623-6f62-75d6f7cf23db@gmail.com>
 <569AC15F-174E-4C78-8FE5-6CE9E0BED479@yayon.me>
 <E23AAC7C-6CAA-4290-9CF1-19285DB31D05@yayon.me>
 <111ca301-f631-694d-93eb-b73a790f57d4@gmail.com>
 <20180127110619.GA10472@polanet.pl>
 <20180127132641.mhmdhpokqrahgd4n@angband.pl>
 <pan$49d38$869e8d62$c0063169$584b8866@cox.net>
 <20180128003910.GA31699@polanet.pl>
 <CAJCQCtSo12iFeyg3DSWNmOwtXHHk_sdg_MDJUrAM+Q1oaOJcAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <CAJCQCtSo12iFeyg3DSWNmOwtXHHk_sdg_MDJUrAM+Q1oaOJcAA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 28, 2018 at 13:02:08 -0700, Chris Murphy wrote:

>> Tell me please, if you mount -o degraded btrfs - what would
>> BTRFS_IOC_DEVICES_READY return?
> 
> case BTRFS_IOC_DEVICES_READY:
>     ret = btrfs_scan_one_device(vol->name, FMODE_READ,
>                     &btrfs_fs_type, &fs_devices);
>     if (ret)
>         break;
>     ret = !(fs_devices->num_devices == fs_devices->total_devices);
>     break;
> 
> 
> All it cares about is whether the number of devices found is the same
> as the number of devices any of that volume's supers claim make up
> that volume. That's it.
>
>> This is not "outsmarting" nor "knowing better", on the contrary, this is "FOLLOWING the
>> kernel-returned data". The umounting case is simply a bug in btrfs.ko
>> that should change to READY state *if* someone has tried and apparently
>> succeeded mounting the not-ready volume.
> 
> Nope. That is not what the ioctl does.

So who is to blame for creating utterly useless code? Userspace
shouldn't depend on some stats (as number of devices is nothing more
than that), but overall _availability_.

I do not care if there are 2, 5 or 100 devices. I do care if there is
ENOUGH devices to run regular (including N-way mirroring and hot spares)
and if not - if there is ENOUGH devices to run degraded. Having ALL the
devices is just the edge case.

-- 
Tomasz Pala <gotar@pld-linux.org>
