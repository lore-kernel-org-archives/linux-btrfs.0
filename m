Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:39264 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752934AbeA2AAs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Jan 2018 19:00:48 -0500
Received: by mail-oi0-f44.google.com with SMTP id j188so2432849oib.6
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Jan 2018 16:00:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180128223946.GA26726@polanet.pl>
References: <1517035210.1252874.1249880112.19FABD13@webmail.messagingengine.com>
 <8607255b-98e7-5623-6f62-75d6f7cf23db@gmail.com> <569AC15F-174E-4C78-8FE5-6CE9E0BED479@yayon.me>
 <E23AAC7C-6CAA-4290-9CF1-19285DB31D05@yayon.me> <111ca301-f631-694d-93eb-b73a790f57d4@gmail.com>
 <20180127110619.GA10472@polanet.pl> <20180127132641.mhmdhpokqrahgd4n@angband.pl>
 <pan$49d38$869e8d62$c0063169$584b8866@cox.net> <20180128003910.GA31699@polanet.pl>
 <CAJCQCtSo12iFeyg3DSWNmOwtXHHk_sdg_MDJUrAM+Q1oaOJcAA@mail.gmail.com> <20180128223946.GA26726@polanet.pl>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 28 Jan 2018 17:00:46 -0700
Message-ID: <CAJCQCtQi+Lks6SxrGkyQ1xF-_mJM2bDYMiBnQXt6hk7qikuwWA@mail.gmail.com>
Subject: Re: degraded permanent mount option
To: Tomasz Pala <gotar@polanet.pl>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 28, 2018 at 3:39 PM, Tomasz Pala <gotar@polanet.pl> wrote:
> On Sun, Jan 28, 2018 at 13:02:08 -0700, Chris Murphy wrote:
>
>>> Tell me please, if you mount -o degraded btrfs - what would
>>> BTRFS_IOC_DEVICES_READY return?
>>
>> case BTRFS_IOC_DEVICES_READY:
>>     ret = btrfs_scan_one_device(vol->name, FMODE_READ,
>>                     &btrfs_fs_type, &fs_devices);
>>     if (ret)
>>         break;
>>     ret = !(fs_devices->num_devices == fs_devices->total_devices);
>>     break;
>>
>>
>> All it cares about is whether the number of devices found is the same
>> as the number of devices any of that volume's supers claim make up
>> that volume. That's it.
>>
>>> This is not "outsmarting" nor "knowing better", on the contrary, this is "FOLLOWING the
>>> kernel-returned data". The umounting case is simply a bug in btrfs.ko
>>> that should change to READY state *if* someone has tried and apparently
>>> succeeded mounting the not-ready volume.
>>
>> Nope. That is not what the ioctl does.
>
> So who is to blame for creating utterly useless code? Userspace
> shouldn't depend on some stats (as number of devices is nothing more
> than that), but overall _availability_.

There's quite a lot missing. Btrfs doesn't even really have a degraded
state concept. It has a degraded mount option, but this is not a
state. e.g. if you have a normally mounted volume, and a drive dies or
vanishes, there's no way for the user to know the array is degraded.
They can only infer that it's degraded by a.) metric f tons of
read/write errors to a bdev b.) the application layer isn't pissed off
about it; or in lieu of a. they see via 'btrfs fi show' that a device
is missing. Likewise, when a device is failing to read and write,
Btrfs doesn't consider it faulty and boot it out of the array, it just
keeps on trying, the spew of which can cause disk contention of those
errors are written to a log on spinning rust.

Anyway, the fact many state features are missing doesn't mean the
necessary information to do the right thing is missing.



> I do not care if there are 2, 5 or 100 devices. I do care if there is
> ENOUGH devices to run regular (including N-way mirroring and hot spares)
> and if not - if there is ENOUGH devices to run degraded. Having ALL the
> devices is just the edge case.

systemd can't possibly need to know more information than a person
does in the exact same situation in order to do the right thing. No
human would wait 10 minutes, let alone literally the heat death of the
planet for "all devices have appeared" but systemd will. And it does
that by its own choice, its own policy. That's the complaint. It's
choosing to do something a person wouldn't do, given identical
available information. There's nothing the kernel is doing that's
telling systemd to wait for goddamn ever.



-- 
Chris Murphy
