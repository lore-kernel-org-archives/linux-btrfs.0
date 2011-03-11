From: Wenyi Liu <qingshenlwy@gmail.com>
Subject: Re: Raid1 resync
Date: Fri, 11 Mar 2011 22:41:25 +0800
Message-ID: <AANLkTi=55pb-o+sFhO4Apgz=QZ3p46DGc8YUcqH+G0F1@mail.gmail.com>
References: <201103111405.49352.libor.klepac@bcom.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: =?UTF-8?B?TGlib3IgS2xlcMOhxI0=?= <libor.klepac@bcom.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201103111405.49352.libor.klepac@bcom.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Libor:
    Maybe, you can attach your oops at first.

---
Best Regards,
Liu Wenyi

2011/3/11 Libor Klep=C3=A1=C4=8D <libor.klepac@bcom.cz>
>
> Hi,
> before my ssd crashed, my /home partion was sitting on md raid1 consi=
sting of
> partition on disk and iScsi LUN in network, it was created with bitma=
ps and
> iscsi lun was set writemostly.
> So when i came to work, i fired up iscsi, added lun to raid and parti=
al resync
> went ahead.
> Before leaving work, i failed iscsci disk and kicked it from raid.
> I would like to use something like this with btrfs, without mdraid be=
low it.
>
> Is it somehow posible?
> 1) I can't go below 2 devices.
> 2) Does btrfs support resync only of changed blocks like mdraid with =
bitmaps?
>
> Thanks
> Libor
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
