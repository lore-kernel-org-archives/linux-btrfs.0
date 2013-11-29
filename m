Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:50314 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756107Ab3K2OIw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Nov 2013 09:08:52 -0500
Received: by mail-wg0-f52.google.com with SMTP id x13so9433515wgg.19
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Nov 2013 06:08:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1385726351.1297.11.camel@mako.sharkbay.at>
References: <1385726351.1297.11.camel@mako.sharkbay.at>
Date: Fri, 29 Nov 2013 22:08:51 +0800
Message-ID: <CAP9B-Qmx=UR1eVi-qDeDrrw05H8Cw=J6Or2OsfDL1nU2ii80=A@mail.gmail.com>
Subject: Re: [BUG] btrfs-progs: btrfs send does not work inside mounted non
 root subvolume
From: Shilong Wang <wangshilong1991@gmail.com>
To: Thomas Scheiblauer <tom@sharkbay.at>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Thomas,

2013/11/29 Thomas Scheiblauer <tom@sharkbay.at>:
> When operating from inside a mounted btrfs subvolume which is not the
> root subvolume "btrfs send" exits with the error:
> ERROR: open <subvolume path> failed. No such file or directory
>
> Steps to reproduce:
>      1. mkfs.btrfs /dev/sda1
>      2. mount /dev/sda1 /mnt
>      3. btrfs subvolume create /mnt/foo
>      4. umount /mnt
>      5. mount -o subvol=foo /dev/sda1 /mnt
>      6. btrfs subvolume snapshot -r /mnt /mnt/snap
>      7. btrfs send /mnt/snap > /dev/null
> -> ERROR: open foo/snap failed. No such file or directory

The problem is that we will try to use btrfs internal path(foo/snap)
to open the sub-volume, this is not right here, i will send a patch for this,
thanks for reporting.

Thanks,
Wang
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
