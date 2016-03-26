Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:35534 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbcCZUmz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Mar 2016 16:42:55 -0400
Received: by mail-ig0-f175.google.com with SMTP id cl4so30735693igb.0
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Mar 2016 13:42:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAafysFa8XZgKvKXQqcnZYR8DLbFe3STQA3Y++Wb71PPdf+iuw@mail.gmail.com>
References: <CAAafysGTQucscr-8sTuT2c4BpdAovq0w9UbehRYDrSH71CLF-A@mail.gmail.com>
	<CAPmG0jbXcqfB1jG7WFriMhicdsoZ+pbD_uUBu7v9YiD-ey=jDw@mail.gmail.com>
	<CAAafysEhGJi5jYxHooV4h1tD3pqnc-brbB9k4prS9yK0P5PGdg@mail.gmail.com>
	<CAAafysEuE0CXZ2fyY2ybnff3=XLEdGirCU9BJf9mhLE0xFTTrQ@mail.gmail.com>
	<CAJCQCtQcX+U1cWz1j3Re5E-=ruPBY+zj0SFqB1jDibgeQniSVw@mail.gmail.com>
	<CAAafysE+5tS=k9GFoKyqwK6dJtR4g3Eqairt1cGatCfCxooXeg@mail.gmail.com>
	<CAJCQCtTURu4OJbTfpKzQGAz4g32yaxToPaE9r8+xWt19AYJUig@mail.gmail.com>
	<CAAafysFa8XZgKvKXQqcnZYR8DLbFe3STQA3Y++Wb71PPdf+iuw@mail.gmail.com>
Date: Sat, 26 Mar 2016 14:42:54 -0600
Message-ID: <CAJCQCtQwc4FDcTPq2mfN7wfUNp9QWEq+XTJA+FEyY4hWrHvHQQ@mail.gmail.com>
Subject: Re: RAID Assembly with Missing Empty Drive
From: Chris Murphy <lists@colorremedies.com>
To: John Marrett <johnf@zioncluster.ca>
Cc: Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 26, 2016 at 6:15 AM, John Marrett <johnf@zioncluster.ca> wrote:
> Chris,
>
>> Post 'btrfs fi usage' for the fileystem. That may give some insight
>> what's expected to be on all the missing drives.
>
> Here's the information, I believe that the missing we see in most
> entries is the failed and absent drive, only the unallocated shows two
> missing entries, the 2.73 TB is the missing but empty device. I don't
> know if there's a way to prove it however.
>
> ubuntu@btrfs-recovery:~$ sudo btrfs fi usage /mnt
> Overall:
>     Device size:          15.45TiB
>     Device allocated:          12.12TiB
>     Device unallocated:           3.33TiB
>     Device missing:           5.46TiB
>     Used:              10.93TiB
>     Free (estimated):           2.25TiB    (min: 2.25TiB)
>     Data ratio:                  2.00
>     Metadata ratio:              2.00
>     Global reserve:         512.00MiB    (used: 0.00B)
>
> Data,RAID1: Size:6.04TiB, Used:5.46TiB
>    /dev/sda       2.61TiB
>    /dev/sdb       1.71TiB
>    /dev/sdc       1.72TiB
>    /dev/sdd       1.72TiB
>    /dev/sdf       1.71TiB
>    missing       2.61TiB
>
> Metadata,RAID1: Size:14.00GiB, Used:11.59GiB
>    /dev/sda       8.00GiB
>    /dev/sdb       2.00GiB
>    /dev/sdc       3.00GiB
>    /dev/sdd       4.00GiB
>    /dev/sdf       3.00GiB
>    missing       8.00GiB
>
> System,RAID1: Size:32.00MiB, Used:880.00KiB
>    /dev/sda      32.00MiB
>    missing      32.00MiB
>
> Unallocated:
>    /dev/sda     111.49GiB
>    /dev/sdb      98.02GiB
>    /dev/sdc      98.02GiB
>    /dev/sdd      98.02GiB
>    /dev/sdf      98.02GiB
>    missing     111.49GiB
>    missing       2.73TiB
>
> I tried to remove missing, first remove missing only removes the
> 2.73TiB missing entry seen above. All the other missing entries
> remain.

Well off hand it seems like the missing 2.73TB has nothing on it at
all, and doesn't need to be counted as missing. The other missing is
counted, and should have all of its data replicated elsewhere. But
then you're running into csum errors. So something still isn't right,
we just don't understand what it is.


> I can't "replace", it's not a valid command on my btrfs tools version;
> I upgraded btrfs this morning in order to have the btrfs fi usage
> command.

Btrfs replace has been around for a while. 'man btrfs replace' the
command takes the form 'btrfs replace start' plus three required
pieces of information. You should be able to infer the missing devid
using 'btrfs show' looks like it's 6.



> ubuntu@btrfs-recovery:~$ sudo btrfs version
> btrfs-progs v4.0
> ubuntu@btrfs-recovery:~$ dpkg -l | grep btrfs
> ii  btrfs-tools                        4.0-2
>  amd64        Checksumming Copy on Write Filesystem utilities

I would use something newer, but btrfs replace is in 4.0. But I also
don't see in this thread what kernel version you're using.



-- 
Chris Murphy
