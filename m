From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: Understanding DF, etc.
Date: 15 May 2011 18:48:00 +0200
Message-ID: <BlvXPDeD1uB@helmut.hullen.de>
References: <1305360089.3767.1.camel@tethys>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1305360089.3767.1.camel@tethys>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Sw=E2mi,

Du meintest am 14.05.11:

>>> # btrfs fi df /
>>> Data: total=3D74.01GB, used=3D72.77GB
>>> System, DUP: total=3D8.00MB, used=3D16.00KB
>>> System: total=3D4.00MB, used=3D0.00
>>> Metadata, DUP: total=3D1.75GB, used=3D657.48MB
>>> Metadata: total=3D8.00MB, used=3D0.00

>>         btrfs filesystem show

> root@tethys:~# df -t btrfs
> Sys. de fichiers           1K-blocs   Utilis=E9    Dispo. Uti% Mont=E9
> sur /dev/mapper/VG1-TETHYS
>                      152735744  78383976  71999272  53% /
> /dev/mapper/VG1-TETHYS
>                      152735744  78383976  71999272  53% /tmp
> /dev/mapper/VG1-TETHYS
>                      152735744  78383976  71999272  53% /home
> /dev/mapper/VG1-TETHYS
>                      152735744  78383976  71999272  53% /var
> /dev/sda2               392192     26772    193660  13% /boot

> root@tethys:~# btrfs filesystem show
> failed to read /dev/sr0
> Label: 'TETHYS_BOOT'  uuid: b6b9e7ef-5aae-4c49-8b5a-39d6eec1d7d7
> 	Total devices 1 FS bytes used 25.76MB
> 	devid    1 size 383.00MB used 240.50MB path /dev/sda2

> Label: 'TETHYS'  uuid: 82c61fc2-8f8c-4cce-9d0d-ed446f671062
> 	Total devices 1 FS bytes used 74.11GB
> 	devid    1 size 145.66GB used 77.54GB path /dev/dm-1


Ok - just for your information the messages of my system, created with

   mkfs.btrfs -d raid0 -m raid1 ...

# btrfs filesystem show
Label: 'MMedia'  uuid: 120b036a-883f-46aa-bd9a-cb6a1897c8d2
	Total devices 3 FS bytes used 1.68TB
	devid    2 size 1.81TB used 603.02GB path /dev/sdb1
	devid    1 size 1.82TB used 599.51GB path /dev/sde1
	devid    3 size 1.81TB used 603.01GB path /dev/sdc1

Btrfs Btrfs v0.19

# btrfs filesystem df /srv/MM
Data, RAID0: total=3D1.75TB, used=3D1.67TB
System, RAID1: total=3D16.00MB, used=3D116.00KB
System: total=3D4.00MB, used=3D0.00
Metadata, RAID1: total=3D4.25GB, used=3D2.53GB

# df -t btrfs
=46ilesystem    Type   1K-blocks      Used Available Use% Mounted on
/dev/sdb1    btrfs   5846053400 1803934240 2718410984  40% /srv/MM

----------------------------------------

I don't know what's the meaning of the type "DUP" (instead of "RAID0" o=
r =20
"RAID1" in my example).

In your case "btrfs filesystem df" seems to show something about specia=
l =20
informations and their need of space but nothing about used space or =20
available space.

Some weeks ago there has been a thread about the informations of "df", =
=20
"btrfs filesystem df" and "btrfs filesystem show"; most times there may=
 =20
be shown the "at least available space".


Viele Gruesse!
Helmut
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
