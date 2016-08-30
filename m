Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:23204 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751702AbcH3IUw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Aug 2016 04:20:52 -0400
Subject: Re: btrfs and systemd
To: Timofey Titovets <nefelim4ag@gmail.com>
References: <47ee55de-a77b-185a-1a01-b8b39899b188@profihost.ag>
 <0fa90a35-587e-7bfc-9418-ea8416b8f02e@cn.fujitsu.com>
 <f3a27bf7-fecd-e295-991a-8b69c3b92f12@profihost.ag>
 <CAGqmi75sBZot6unB9eV_EgD7pmf0xTMkO0p6KDyY61axp98KPQ@mail.gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <35e3f39c-f037-2be2-2839-00cc84db600e@profihost.ag>
Date: Tue, 30 Aug 2016 10:20:47 +0200
MIME-Version: 1.0
In-Reply-To: <CAGqmi75sBZot6unB9eV_EgD7pmf0xTMkO0p6KDyY61axp98KPQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 29.08.2016 um 13:33 schrieb Timofey Titovets:
> Do you try: nofail,noauto,x-systemd.automount ?

sure this fails too as it has the same timeout in systemd.

Mr. Poettering has recommanded me todo the following:
# mkdir -p /etc/systemd/system/$(systemd-escape --suffix=mount -p
/foo/bar/baz).d/
# cat > /etc/systemd/system/$(systemd-escape --suffix=mount -p
/foo/bar/baz).d/timeout.conf <<EOF
[Mount]
TimeoutSec=2h
EOF

he has also accepted my wish to make this configurable through fstab.

Stefan

> 2016-08-29 9:28 GMT+03:00 Stefan Priebe - Profihost AG <s.priebe@profihost.ag>:
>> Hi Qu,
>>
>> Am 29.08.2016 um 03:48 schrieb Qu Wenruo:
>>>
>>>
>>> At 08/29/2016 04:15 AM, Stefan Priebe - Profihost AG wrote:
>>>> Hi,
>>>>
>>>> i'm trying to get my 60TB btrfs volume to mount with systemd at boot.
>>>> But this always fails with: "mounting timed out. Stopping." after 90s.
>>>
>>> 60TB is quite large, and under most case it will already cause mount
>>> speed problem.
>>>
>>> In our test environment, filling a fs with 16K small files to 2T (just
>>> 128K files)will already slow the mount process to 10s.
>>>
>>> For larger fs, or more specifically, large extent tree, will slow the
>>> mount process obviously.
>>>
>>> The root fix will need a rework of extent tree.
>>> AFAIK Josef is working on the rework.
>>>
>>> So the btrfs fix will need some time.
>>
>> thanks but i've no problem with the long mount time (in my case 6
>> minutes) i'm just wondering how to live with it with systemd. As it
>> always cancels the mount process after 90s and i see no fstab option to
>> change this.
>>
>> Greets,
>> Stefan
>>
>>>
>>> Thanks,
>>> Qu
>>>>
>>>> I can't find any fstab setting for systemd to higher this timeout.
>>>> There's just  the x-systemd.device-timeout but this controls how long to
>>>> wait for the device and not for the mount command.
>>>>
>>>> Is there any solution for big btrfs volumes and systemd?
>>>>
>>>> Greets,
>>>> Stefan
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>>
>>>
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
