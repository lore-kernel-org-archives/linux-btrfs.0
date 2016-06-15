Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:35697 "EHLO
	mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbcFOJ65 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jun 2016 05:58:57 -0400
Received: by mail-lf0-f66.google.com with SMTP id w130so1213673lfd.2
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jun 2016 02:58:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALy3tB3YaTAYrZLhA7X0CTCUNLm7JCAyVX0WSdp1K48TNfFAUA@mail.gmail.com>
References: <CALy3tB3YaTAYrZLhA7X0CTCUNLm7JCAyVX0WSdp1K48TNfFAUA@mail.gmail.com>
From: Nisse Karlsson <nisse@xcorp.at>
Date: Wed, 15 Jun 2016 11:58:36 +0200
Message-ID: <CALy3tB28Kx6aHTj+B-g68foh2bKSb0cnPcy7D-QQw3WPb9Wz4Q@mail.gmail.com>
Subject: Re: Balance fails with unallocated diskspace
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I'm having some problems with balancing and I've filed a bug at
bugzilla (https://bugzilla.kernel.org/show_bug.cgi?id=120121), but it
could also be that I've missed something even after more than a couple
of hours reading forums and mailing lists.

If someone could point me in the right direction that would be very
much appreciated.

I tried to migrate from raid1 to raid10  (btrfs balance start /files
-mconvert=raid10 -dconvert=raid10)

This failed after about 1TB with enosp errors.

I have since then managed to migrate all metadata back to raid1 but my
data is still a mix.

I've tried "balance -dusage=50" with all values from 0 to 100, also
with -dprofiles=raid1 and -dprofiles=raid10. I've also tried balance
-dconvert=raid1 (with and without -dprofiles=raid10) but I always get
enosp errors.
I've also added a small usb-drive(/dev/sdh below) to get some space
but it still gives the same error.

Since I have about 1.5TB unallocated space it's my understanding that
this shouldn't be a problem, or am I completely wrong?

The output from btrfs filesystem usage /files

Overall:
    Device size:  18.20TiB
    Device allocated:  16.67TiB
    Device unallocated:   1.53TiB
    Device missing:     0.00B
    Used:  16.67TiB
    Free (estimated): 781.62GiB (min: 781.62GiB)
    Data ratio:      2.00
    Metadata ratio:      2.00
    Global reserve: 512.00MiB (used: 0.00B)

Data,RAID1: Size:7.21TiB, Used:7.21TiB
   /dev/sdb   3.23TiB
   /dev/sdc   3.24TiB
   /dev/sdd   1.89TiB
   /dev/sde   2.32TiB
   /dev/sdf   1.42TiB
   /dev/sdg   2.33TiB

Data,RAID10: Size:1.11TiB, Used:1.11TiB
   /dev/sdb 190.05GiB
   /dev/sdc 189.34GiB
   /dev/sdd 190.05GiB
   /dev/sde 190.05GiB
   /dev/sdf 188.92GiB
   /dev/sdg 189.41GiB
   /dev/sdh   2.48GiB

Metadata,RAID1: Size:10.19GiB, Used:9.35GiB
   /dev/sdb   4.47GiB
   /dev/sdc   3.58GiB
   /dev/sdd   5.19GiB
   /dev/sde   3.07GiB
   /dev/sdf   1.34GiB
   /dev/sdg   2.72GiB

System,RAID1: Size:32.00MiB, Used:1.41MiB
   /dev/sdc  32.00MiB
   /dev/sdd  32.00MiB

Unallocated:
   /dev/sdb 222.50GiB
   /dev/sdc 219.07GiB
   /dev/sdd   1.56TiB
   /dev/sde 221.40GiB
   /dev/sdf 219.75GiB
   /dev/sdg 219.39GiB
   /dev/sdh   4.97GiB

Regards,
Nisse
>>
>>
