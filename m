From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Subject: Re: Understanding DF, etc.
Date: Sat, 14 May 2011 10:01:29 +0200
Message-ID: <1305360089.3767.1.camel@tethys>
References: <BlnToEqD1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BlnToEqD1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Helmut,

Le vendredi 13 mai 2011 =C3=A0 21:50 +0200, Helmut Hullen a =C3=A9crit =
:
> That may depend on the "mkfs.btrfs" options - which options have you =
=20
> set?

Well, actually none, except for -L ;-)

> What tells
>         df -t btrfs
>         btrfs filesystem show=20

root@tethys:~# df -t btrfs
Sys. de fichiers           1K-blocs   Utilis=C3=A9    Dispo. Uti% Mont=C3=
=A9 sur
/dev/mapper/VG1-TETHYS
                     152735744  78383976  71999272  53% /
/dev/mapper/VG1-TETHYS
                     152735744  78383976  71999272  53% /tmp
/dev/mapper/VG1-TETHYS
                     152735744  78383976  71999272  53% /home
/dev/mapper/VG1-TETHYS
                     152735744  78383976  71999272  53% /var
/dev/sda2               392192     26772    193660  13% /boot

root@tethys:~# btrfs filesystem show
failed to read /dev/sr0
Label: 'TETHYS_BOOT'  uuid: b6b9e7ef-5aae-4c49-8b5a-39d6eec1d7d7
	Total devices 1 FS bytes used 25.76MB
	devid    1 size 383.00MB used 240.50MB path /dev/sda2

Label: 'TETHYS'  uuid: 82c61fc2-8f8c-4cce-9d0d-ed446f671062
	Total devices 1 FS bytes used 74.11GB
	devid    1 size 145.66GB used 77.54GB path /dev/dm-1

Btrfs Btrfs v0.19


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
