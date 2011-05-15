From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: Understanding DF, etc.
Date: 15 May 2011 19:28:00 +0200
Message-ID: <BlvXUBvD1uB@helmut.hullen.de>
References: <20110515170352.GA8927@carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110515170352.GA8927@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 15.05.11:

>>>>> # btrfs fi df /
>>>>> Data: total=3D74.01GB, used=3D72.77GB
>>>>> System, DUP: total=3D8.00MB, used=3D16.00KB
>>>>> System: total=3D4.00MB, used=3D0.00
>>>>> Metadata, DUP: total=3D1.75GB, used=3D657.48MB
>>>>> Metadata: total=3D8.00MB, used=3D0.00

>> I don't know what's the meaning of the type "DUP" (instead of
>> "RAID0" or "RAID1" in my example).

>    DUP is a form of RAID-1 for single disks. Like RAID-1, it stores
> two copies of the data, but where RAID-1 guarantees that the two
> copies will be on different devices, DUP stores both copies on the
> same device. btrfs uses DUP by default for metadata on single-device
> filesystems, so that if part of the FS metadata is damaged (by, say,
> unrecoverable bad blocks), there's still a good copy.

>    If you add another disk to the filesystem and balance, the DUP
> chunks are automatically converted to RAID-1.

Sounds very interesting!

In this special case: does that mean that

> root@tethys:~# df -t btrfs
> Sys. de fichiers           1K-blocs   Utilis=E9    Dispo. Uti% Mont=E9
> sur /dev/mapper/VG1-TETHYS
>                      152735744  78383976  71999272  53% /
> /dev/mapper/VG1-TETHYS
>                      152735744  78383976  71999272  53% /tmp

shows that that device with brutto 150 GByte is nearly full with its 78=
 =20
GByte (or 73 GByte) data because it uses this kind of RAID1?

Viele Gruesse!
Helmut
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
