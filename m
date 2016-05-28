Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:34078 "EHLO
	mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbcE1Uw1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 May 2016 16:52:27 -0400
Received: by mail-lf0-f68.google.com with SMTP id 65so11277355lfq.1
        for <linux-btrfs@vger.kernel.org>; Sat, 28 May 2016 13:52:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEtw4r2aknnz=+FCGq2ysSQT3K3ZHmZqnbPpyvr+C7QD6TyEAQ@mail.gmail.com>
References: <CAEtw4r2aknnz=+FCGq2ysSQT3K3ZHmZqnbPpyvr+C7QD6TyEAQ@mail.gmail.com>
Date: Sat, 28 May 2016 22:52:25 +0200
Message-ID: <CAGGqMYS_SLn9RY8Gtgf5nkwyXnOr57ehtYSH=HugiEeA8D_chw@mail.gmail.com>
Subject: Re: Resize doesnt work as expected
From: Alexander Fougner <fougner89@gmail.com>
To: Peter Becker <floyd.net@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-05-28 22:32 GMT+02:00 Peter Becker <floyd.net@gmail.com>:
> Hello, i have found a small issue but i doesn't know if this is intended.
>
> Starting with a RAID 1 setup with 3 x 4GB devices.
> If you replace one of this devices with a 2GB device and run "resize
> max" nothing happens.

>From manpages:
"The devid can be found in the output of btrfs filesystem show and
defaults to 1 if not specified."

> Only if you resize with the device-ID the additional GB will be usable.
> Loop at this demo:
> (its my first try with  loopback devices :))
>
>
> [ -f /tmp_resize ] && rm -f /tmp_resize
>
> mkdir /tmp_resize
> dd if=/dev/zero of=/tmp_resize/btrfs-vol1.img bs=1G count=1
> dd if=/dev/zero of=/tmp_resize/btrfs-vol2.img bs=1G count=1
> dd if=/dev/zero of=/tmp_resize/btrfs-vol3.img bs=1G count=1
> dd if=/dev/zero of=/tmp_resize/btrfs-vol4.img bs=1G count=1
> dd if=/dev/zero of=/tmp_resize/btrfs-vol5.img bs=2G count=1
>
> losetup /dev/loop1 /tmp_resize/btrfs-vol1.img
> losetup /dev/loop2 /tmp_resize/btrfs-vol2.img
> losetup /dev/loop3 /tmp_resize/btrfs-vol3.img
> losetup /dev/loop4 /tmp_resize/btrfs-vol4.img
> losetup /dev/loop5 /tmp_resize/btrfs-vol5.img
>
> mkfs.btrfs -d raid1 /dev/loop1 /dev/loop2 /dev/loop3 /dev/loop4
>
> btrfs filesystem show /dev/loop2
>
> mkdir /media/test
>
> mount /dev/loop3 /media/test
>
> echo "Vorher"
> btrfs fi sh
>
> echo "Replace 1G device with 2G device"
> btrfs repl start /dev/loop4 /dev/loop5 /media/test
>
> echo "After replace, still 1GB usable"
> btrfs fi sh
>
> echo "Resize"
> btrfs fi res max /media/test

There is an invisible 1:max there which is why it doesnt resize the
newly replaced device.
>
> echo "After resize, still 1GB usable !!!!"
> btrfs fi sh
>
> echo "Resize with device id"
> btrfs fi res 4:max /media/test
>
> echo "!!! now 2GB usable !!!!"
> btrfs fi sh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
