Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f51.google.com ([209.85.192.51]:34873 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbcABJbe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Jan 2016 04:31:34 -0500
Received: by mail-qg0-f51.google.com with SMTP id o11so225330773qge.2
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Jan 2016 01:31:34 -0800 (PST)
MIME-Version: 1.0
Reply-To: matianfu@gmail.com
In-Reply-To: <20160101122342.GA1586@carfax.org.uk>
References: <CAEgruXuFNsumiyBXrWwiu47WVuukSHLynMJHN7e3E1cYWn3QnQ@mail.gmail.com>
	<20160101122342.GA1586@carfax.org.uk>
Date: Sat, 2 Jan 2016 17:31:33 +0800
Message-ID: <CAEgruXtDcFJn2bC6JLE9Bfz0s4od03ur1FZimH_JVoOf982OQg@mail.gmail.com>
Subject: Re: how btrfs uses devid?
From: UGlee <matianfu@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, UGlee <matianfu@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you very much, sir.

Could you confirm that devid and UUID_SUB will never be changed at any
circumstances for a given device, unless it is reformatted by
mkfs.btrfs?

2016-01-01 20:23 GMT+08:00 Hugo Mills <hugo@carfax.org.uk>:
> On Fri, Jan 01, 2016 at 08:16:28PM +0800, UGlee wrote:
>> Dear all:
>>
>> If a btrfs device is missing, the command tool tells user the devid of
>> the missing devices.
>>
>> I understand that each device (disk) in a btrfs volume has been
>> assigned a uuid (UUID_SUB field in udevadm info output). If the device
>> is missing, it's hard to tell user to input such uuid string in
>> command line. So devid is for convenience.
>
>> In our product, we want to record all disk information of a volume in
>> a file. If a disk is missing, not because it's broken, but because the
>> user has so many disks and in some cases they may put back the wrong
>> one. In this scenario, we can provide the disk information (such as
>> serial number) to user and help them to check if they did something
>> wrong.
>>
>> My question is: is the devid just an alias to sub uuid? for a given
>> disk device, it is never changed during any btrfs operation, including
>> add, remove, balance and replace? or it may be changed, and when?
>
>    Actually, devid is the ID that the FS uses internally in the device
> tree to identify them. It's not just a convenience -- it's the
> "official" identifier for the device within the filesystem.
>
>> One more question just for curiosity. I checked the source code of
>> btrfs-progs briefly. It seems that there is no data structure in
>> superblock recording all sub-uuids or all devids for the volume, so
>> how does btrfs figure out the missing devid? since they are not always
>> sequential integers, for example, after one device is removed, the
>> devid is simply removed and the devid of other device is not
>> re-numbered.
>
>    The devices that should be there (identified by devid) are listed
> in the device tree. If one of those doesn't match up with a
> currently-known device for that filesystem (as determined by btrfs dev
> scan), then it's missing.
>
>    Hugo.
>
> --
> Hugo Mills             | I gave up smoking, drinking and sex once. It was the
> hugo@... carfax.org.uk | scariest 20 minutes of my life.
> http://carfax.org.uk/  |
> PGP: E2AB1DE4          |
