Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:33348 "EHLO
	mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983AbbKCCBi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Nov 2015 21:01:38 -0500
Received: by qkdl128 with SMTP id l128so1135640qkd.0
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Nov 2015 18:01:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5623A943.2030304@googlemail.com>
References: <CAGwxe4j7J5ztPk-OyeOuX2YH6SO3G9_h6VU_1wWMdP4rHpqiew@mail.gmail.com>
 <5623A943.2030304@googlemail.com>
From: Tobias Holst <tobby@tobby.eu>
Date: Tue, 3 Nov 2015 03:01:18 +0100
Message-ID: <CAGwxe4gogBG8_F6W0iAA7H02jyQOnjm+dYSL74-rpWEgDTUZsg@mail.gmail.com>
Subject: Re: "free_raid_bio" crash on RAID6
To: Philip Seeger <p0h0i0l0i0p@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

No, I never figured this out... After a while of waiting for answers I
just started over and took the data from my backup.

> Did you try removing the bad drive and did the system keep crashing anyway?

As you can see in my first mail the drive was already removed when
this error started to happen ("some devices missing"). ;)

Regards,
Tobias


2015-10-18 16:14 GMT+02:00 Philip Seeger <p0h0i0l0i0p@gmail.com>:
> Hi Tobias
>
> On 07/20/2015 06:20 PM, Tobias Holst wrote:
>>
>> My btrfs-RAID6 seems to be broken again :(
>>
>> When reading from it I get several of these:
>> [  176.349943] BTRFS info (device dm-4): csum failed ino 1287707
>> extent 21274957705216 csum 2830458701 wanted 426660650 mirror 2
>>
>> then followed by a "free_raid_bio"-crash:
>>
>> [  176.349961] ------------[ cut here ]------------
>> [  176.349981] WARNING: CPU: 6 PID: 110 at
>> /home/kernel/COD/linux/fs/btrfs/raid56.c:831
>> __free_raid_bio+0xfc/0x130 [btrfs]()
>> ...
>
>
> It's been 3 months now, have you ever figured this out? Do you know if the
> bug has been identified and fixed or have you filed a bugzilla report?
>
>> One drive is broken, so at the moment it is mounted with "-O
>> defaults,ro,degraded,recovery,compress=lzo,space_cache,subvol=raid".
>
>
> Did you try removing the bad drive and did the system keep crashing anyway?
>
>
>
> Philip
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
