Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f179.google.com ([209.85.220.179]:35726 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbaJMRWo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Oct 2014 13:22:44 -0400
Received: by mail-vc0-f179.google.com with SMTP id im17so6078042vcb.24
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Oct 2014 10:22:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <543A61EE.7070200@prnet.org>
References: <543450DC.90504@prnet.org>
	<1412714780.2374.0@mail.thefacebook.com>
	<543A61EE.7070200@prnet.org>
Date: Mon, 13 Oct 2014 13:22:43 -0400
Message-ID: <CAGfcS_k7Y2-j3moyFw3j0gzb6Xuj-AutfjvZzEnpMem-z0KPRA@mail.gmail.com>
Subject: Re: btrfs send and kernel 3.17
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: David Arendt <admin@prnet.org>
Cc: Chris Mason <clm@fb.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 12, 2014 at 7:11 AM, David Arendt <admin@prnet.org> wrote:
> This weekend I finally had time to try btrfs send again on the newly
> created fs. Now I am running into another problem:
>
> btrfs send returns: ERROR: send ioctl failed with -12: Cannot allocate
> memory
>
> In dmesg I see only the following output:
>
> parent transid verify failed on 21325004800 wanted 2620 found 8325
>

I'm not using send at all, but I've been running into parent transid
verify failed messages where the wanted is way smaller than the found
when trying to balance a raid1 after adding a new drive.  Originally I
had gotten a BUG, and after reboot the drive finished balancing
(interestingly enough without moving any chunks to the new drive -
just consolidating everything on the old drives), and then when I try
to do another balance I get:
[ 4426.987177] BTRFS info (device sdc2): relocating block group
10367073779712 flags 17
[ 4446.287998] BTRFS info (device sdc2): found 13 extents
[ 4451.330887] parent transid verify failed on 10063286579200 wanted
987432 found 993678
[ 4451.350663] parent transid verify failed on 10063286579200 wanted
987432 found 993678

The btrfs program itself outputs:
btrfs balance start -v /data
Dumping filters: flags 0x7, state 0x0, force is off
  DATA (flags 0x0): balancing
  METADATA (flags 0x0): balancing
  SYSTEM (flags 0x0): balancing
ERROR: error during balancing '/data' - Cannot allocate memory
There may be more info in syslog - try dmesg | tail

This is also on 3.17.  This may be completely unrelated, but it seemed
similar enough to be worth mentioning.

The filesystem otherwise seems to work fine, other than the new drive
not having any data on it:
Label: 'datafs'  uuid: cd074207-9bc3-402d-bee8-6a8c77d56959
        Total devices 6 FS bytes used 2.16TiB
        devid    1 size 2.73TiB used 2.40TiB path /dev/sdc2
        devid    2 size 931.32GiB used 695.03GiB path /dev/sda2
        devid    3 size 931.32GiB used 700.00GiB path /dev/sdb2
        devid    4 size 931.32GiB used 700.00GiB path /dev/sdd2
        devid    5 size 931.32GiB used 699.00GiB path /dev/sde2
        devid    6 size 2.73TiB used 0.00 path /dev/sdf2

This is btrfs-progs-3.16.2.

--
Rich
