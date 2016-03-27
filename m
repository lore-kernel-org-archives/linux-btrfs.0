Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f193.google.com ([209.85.213.193]:35433 "EHLO
	mail-ig0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbcC0MPD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Mar 2016 08:15:03 -0400
Received: by mail-ig0-f193.google.com with SMTP id ww10so6608975igb.2
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Mar 2016 05:15:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQzu2X16L_jp7k-Sy8=+ScCekoHEACajcATX_-vMvDwUA@mail.gmail.com>
References: <CAAafysGTQucscr-8sTuT2c4BpdAovq0w9UbehRYDrSH71CLF-A@mail.gmail.com>
	<CAPmG0jbXcqfB1jG7WFriMhicdsoZ+pbD_uUBu7v9YiD-ey=jDw@mail.gmail.com>
	<CAAafysEhGJi5jYxHooV4h1tD3pqnc-brbB9k4prS9yK0P5PGdg@mail.gmail.com>
	<CAAafysEuE0CXZ2fyY2ybnff3=XLEdGirCU9BJf9mhLE0xFTTrQ@mail.gmail.com>
	<CAJCQCtQcX+U1cWz1j3Re5E-=ruPBY+zj0SFqB1jDibgeQniSVw@mail.gmail.com>
	<CAAafysE+5tS=k9GFoKyqwK6dJtR4g3Eqairt1cGatCfCxooXeg@mail.gmail.com>
	<CAJCQCtTURu4OJbTfpKzQGAz4g32yaxToPaE9r8+xWt19AYJUig@mail.gmail.com>
	<CAAafysFa8XZgKvKXQqcnZYR8DLbFe3STQA3Y++Wb71PPdf+iuw@mail.gmail.com>
	<CAJCQCtQwc4FDcTPq2mfN7wfUNp9QWEq+XTJA+FEyY4hWrHvHQQ@mail.gmail.com>
	<CAAafysHw3ws3HVgyfN6YVwFN5pru_kuajKev6sQN6+_uprGiRQ@mail.gmail.com>
	<CAJCQCtQzu2X16L_jp7k-Sy8=+ScCekoHEACajcATX_-vMvDwUA@mail.gmail.com>
Date: Sun, 27 Mar 2016 08:15:01 -0400
Message-ID: <CAAafysGfah-O+CaX0eHKvzsyR52zCW5c6PExajOz16J8XpLzGQ@mail.gmail.com>
Subject: Re: RAID Assembly with Missing Empty Drive
From: John Marrett <johnf@zioncluster.ca>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> I was looking under btrfs device, sorry about that. I do have the
>> command. I tried replace and it seemed more promising than the last
>> attempt, it wrote enough data to the new drive to overflow and break
>> my overlay. I'm trying it without the overlay on the destination
>> device, I'll report back later with the results.

It looks like replace worked!

I got the following final output:

ubuntu@btrfs-recovery:~$ sudo btrfs replace status /mnt
Started on 26.Mar 20:59:12, finished on 27.Mar 05:20:01, 0 write errs,
0 uncorr. read errs

The filesystem appears in good health, no more missing devices:

ubuntu@btrfs-recovery:~$ sudo btrfs filesystem show
Label: none  uuid: 67b4821f-16e0-436d-b521-e4ab2c7d3ab7
    Total devices 6 FS bytes used 5.47TiB
    devid    1 size 1.81TiB used 1.71TiB path /dev/sdb
    devid    2 size 1.81TiB used 1.71TiB path /dev/sde
    devid    3 size 1.82TiB used 1.72TiB path /dev/sdd
    devid    4 size 1.82TiB used 1.72TiB path /dev/sdc
    devid    5 size 2.73TiB used 2.62TiB path /dev/sda
    devid    6 size 2.73TiB used 2.62TiB path /dev/sdf

btrfs-progs v4.0

However the dmesg output shows some errors despite the 0 uncorr. read
errs reported above:

[112178.006315] BTRFS: checksum error at logical 8576298061824 on dev /dev/sda,
sector 4333289864, root 259, inode 10017264, offset 32444416, length 4096, links
 1 (path: mythtv/store/4663_20150809180500.mpg)
[112178.006327] btrfs_dev_stat_print_on_error: 5 callbacks suppressed
[112178.006330] BTRFS: bdev /dev/sda errs: wr 0, rd 5002, flush 0, corrupt 16, g
en 0

And the underlying file does appear to be damaged:

ubuntu@btrfs-recovery:/mnt/@home/mythtv$ dd
if=store/4663_20150809180500.mpg of=/dev/null
dd: error reading ‘store/4663_20150809180500.mpg’: Input/output error
63368+0 records in
63368+0 records out
32444416 bytes (32 MB) copied, 1.08476 s, 29.9 MB/s

Here's some dmesg output when accessing a damaged file:

[140789.642357] BTRFS warning (device sdc): csum failed ino 10017264
off 32854016 csum 2566472073 expected csum 1193787476
[140789.642503] BTRFS warning (device sdc): csum failed ino 10017264
off 32919552 csum 2566472073 expected csum 2825707817
[140789.645768] BTRFS warning (device sdc): csum failed ino 10017264
off 32509952 csum 2566472073 expected csum 834024150

I can also see that one device has had a few errors; this is the
device that was ddrescued and recorded some errors before being
ddrescued:

[/dev/sda].write_io_errs   0
[/dev/sda].read_io_errs    5002
[/dev/sda].flush_io_errs   0
[/dev/sda].corruption_errs 153
[/dev/sda].generation_errs 0

> If you do want to use a newer one, I'd build against kernel.org, just
> because the developers only use that base. And use 4.4.6 or 4.5.

At this point I could remove the overlays and recover the filesystem
permanently, however I'm also deeply indebted to the btrfs community
and want to give anything I can back. I've built (but not installed ;)
) a straight kernel.org 4.5 w/my missing device check patch applied.
Is there any interest or value in attempting to switch to this kernel,
add/delete a device and see if I experience the same errors as before
I tried replace? What information should I gather if I do this?

-JohnF
