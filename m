Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:35391 "EHLO
	mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbcCZBVV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 21:21:21 -0400
Received: by mail-io0-f196.google.com with SMTP id 124so13907387iov.2
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 18:21:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQcX+U1cWz1j3Re5E-=ruPBY+zj0SFqB1jDibgeQniSVw@mail.gmail.com>
References: <CAAafysGTQucscr-8sTuT2c4BpdAovq0w9UbehRYDrSH71CLF-A@mail.gmail.com>
	<CAPmG0jbXcqfB1jG7WFriMhicdsoZ+pbD_uUBu7v9YiD-ey=jDw@mail.gmail.com>
	<CAAafysEhGJi5jYxHooV4h1tD3pqnc-brbB9k4prS9yK0P5PGdg@mail.gmail.com>
	<CAAafysEuE0CXZ2fyY2ybnff3=XLEdGirCU9BJf9mhLE0xFTTrQ@mail.gmail.com>
	<CAJCQCtQcX+U1cWz1j3Re5E-=ruPBY+zj0SFqB1jDibgeQniSVw@mail.gmail.com>
Date: Fri, 25 Mar 2016 21:21:20 -0400
Message-ID: <CAAafysE+5tS=k9GFoKyqwK6dJtR4g3Eqairt1cGatCfCxooXeg@mail.gmail.com>
Subject: Re: RAID Assembly with Missing Empty Drive
From: John Marrett <johnf@zioncluster.ca>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris,

> Quite honestly I don't understand how Btrfs raid1 volume with two
> missing devices even permits you to mount it degraded,rw in the first
> place.

I think you missed my previous post, it's simple, I patched the kernel
to bypass the check for missing devices with rw mounts, I did this
because one of my missing devices has no data on it, it's actually
confirmed by my mounting as you can see here:

ubuntu@btrfs-recovery:~$ sudo btrfs filesystem show
Label: none  uuid: 67b4821f-16e0-436d-b521-e4ab2c7d3ab7
    Total devices 7 FS bytes used 5.47TiB
    devid    1 size 1.81TiB used 1.71TiB path /dev/sde
    devid    2 size 1.81TiB used 1.71TiB path /dev/sda
    devid    3 size 1.82TiB used 1.72TiB path /dev/sdc
    devid    4 size 1.82TiB used 1.72TiB path /dev/sdd
    devid    5 size 2.73TiB used 2.62TiB path /dev/sdf
    devid    6 size 2.73TiB used 2.62TiB path
    devid    7 size 2.73TiB used 0.00 path

> Anyway, maybe it's possible there's no dual missing metadata chunks,
> although I find it hard to believe.

Considering the above do you still think that I may have missing metadata?

> Because there are two devices missing, I doubt this matters, but I
> think you're better off using 'btrfs replace' for this rather than
> 'device add' followed by 'device remove'. The two catches with

I'll try btrfs replace for the second device (with data) after
removing the first.

Do you think my chances are better moving data off the array in read only mode?

-JohnF
