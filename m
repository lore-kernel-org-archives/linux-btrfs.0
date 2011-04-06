From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: cloning single-device btrfs file system onto multi-device one
Date: 06 Apr 2011 08:30:00 +0200
Message-ID: <BjKsrdvD1uB@helmut.hullen.de>
References: <BANLkTimQaPNm22kN8g2ha+XrOP3uyBUE-Q@mail.gmail.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTimQaPNm22kN8g2ha+XrOP3uyBUE-Q@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Evert,

Du meintest am 05.04.11:

>> I then did a btrfs fi balance again and let it run through. However
>> here is what I get:
>>
>> $ df -h /mnt
>> Filesystem =A0 =A0 =A0 =A0 =A0 =A0Size =A0Used Avail Use% Mounted on
>> /dev/sdb =A0 =A0 =A0 =A0 =A0 =A0 =A08.2T =A03.5T =A03.2T =A053% /mnt
>>
>> Only 3.2T left. How would I reclaim the missing space?
>>
>> $ sudo btrfs fi show
>> Label: none =A0uuid: ...
>> =A0 =A0 =A0 =A0Total devices 3 FS bytes used 3.43TB
>> =A0 =A0 =A0 =A0devid =A0 =A04 size 2.73TB used 1.17TB path /dev/sdc
>> =A0 =A0 =A0 =A0devid =A0 =A03 size 2.73TB used 1.17TB path /dev/sdb
>> =A0 =A0 =A0 =A0devid =A0 =A02 size 2.70TB used 1.14TB path /dev/sda4
>> $ sudo btrfs fi df /mnt
>> Data, RAID0: total=3D3.41TB, used=3D3.41TB
>> System, RAID1: total=3D16.00MB, used=3D232.00KB
>> Metadata, RAID1: total=3D35.25GB, used=3D20.55GB
>>
>> So that kind of worked but that is of little use to me as 2TB
>> kind of disappeared under my feet in the process.

> From my limited understanding, btrfs will write metadata in raid1 by
> default. So, this could be where your 2TB has gone.

> I am assuming you used raid0 for the three new disks?

No - take a look at the (shown) output of "btrfs fi df /mnt". "DATA" is=
 RAID0.

Viele Gruesse!
Helmut
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
