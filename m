From: Jordan Windsor <jordanw2@gmail.com>
Subject: Re: Find RAID level, Change RAID level.
Date: Mon, 31 Oct 2011 00:10:34 +1030
Message-ID: <CACCfv7onURQQGGtY63kcirrxFtW4w-K8x0uqb_TPExoJc96row@mail.gmail.com>
References: <CACCfv7oD=u3dyz38Q32+ehi0gG_-TZes-E6WMD3YVETDexbpNA@mail.gmail.com>
	<Bwm7ykHD1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: helmut@hullen.de, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Bwm7ykHD1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 30, 2011 at 6:40 AM, Helmut Hullen <Hullen@t-online.de> wro=
te:
> Hallo, Jordan,
>
> Du meintest am 30.10.11:
>
>>>>>> I was wondering is it possible to find the RAID level currently
>>>>>> in use by a btrfs volume, also can I change the data & metadata
>>>>>> (or either) RAID levels after creation.
>
>>>>> =A0 To see the RAID levels, use
>>>>>
>>>>> btrfs fi df /path/to/filesystem
>
>
> I've just run that command on my system:
>
> Data, RAID0: total=3D3.81TB, used=3D3.71TB
> System, RAID1: total=3D16.00MB, used=3D244.00KB
> System: total=3D4.00MB, used=3D0.00
> Metadata, RAID1: total=3D16.25GB, used=3D4.78GB
>
>
> And that shows what I have defined via "mkfs.btrfs": "... --data raid=
0
> --metadata raid1"
>
> What tells your system?
>
> What do you want to be installed?
>
> Viele Gruesse!
> Helmut
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Thanks, It currently shows this:

Data: total=3D195.01GB, used=3D193.93GB
System, DUP: total=3D8.00MB, used=3D28.00KB
System: total=3D4.00MB, used=3D0.00
Metadata, DUP: total=3D1.75GB, used=3D385.41MB
Metadata: total=3D8.00MB, used=3D0.00

I didn't specify any RAID levels during creation. I'd like to have a
RAID0 installation across two hard drives.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
