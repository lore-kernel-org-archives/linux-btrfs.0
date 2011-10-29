From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: Find RAID level, Change RAID level.
Date: 29 Oct 2011 22:10:00 +0200
Message-ID: <Bwm7ykHD1uB@helmut.hullen.de>
References: <CACCfv7oD=u3dyz38Q32+ehi0gG_-TZes-E6WMD3YVETDexbpNA@mail.gmail.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CACCfv7oD=u3dyz38Q32+ehi0gG_-TZes-E6WMD3YVETDexbpNA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Jordan,

Du meintest am 30.10.11:

>>>>> I was wondering is it possible to find the RAID level currently
>>>>> in use by a btrfs volume, also can I change the data & metadata
>>>>> (or either) RAID levels after creation.

>>>> =A0 To see the RAID levels, use
>>>>
>>>> btrfs fi df /path/to/filesystem


I've just run that command on my system:

Data, RAID0: total=3D3.81TB, used=3D3.71TB
System, RAID1: total=3D16.00MB, used=3D244.00KB
System: total=3D4.00MB, used=3D0.00
Metadata, RAID1: total=3D16.25GB, used=3D4.78GB


And that shows what I have defined via "mkfs.btrfs": "... --data raid0 =
=20
--metadata raid1"

What tells your system?

What do you want to be installed?

Viele Gruesse!
Helmut
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
