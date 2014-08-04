Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:45514 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaHDXBS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Aug 2014 19:01:18 -0400
Received: by mail-oa0-f50.google.com with SMTP id g18so95027oah.9
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Aug 2014 16:01:18 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 4 Aug 2014 16:01:17 -0700
Message-ID: <CADw2B2PA-_PKvWduHPcObdXtxMO3ttyBkqtNB=p=GX4oH5dt_A@mail.gmail.com>
Subject: btrfs and iostat - how do I measure the live performance of my btrsf filesystems?
From: "G. Richard Bellamy" <rbellamy@pteradigm.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I apologize if this has already been addressed, regardless of whether
or not it's a n00b question, I'm stumped and am looking for some
guidance.

Is iostat a viable measure of btrfs performance?
I've got the following environment:
---------------------------------------------------------------------
2014-08-04 11:56:10
root@a i ~ # uname -a
Linux a 3.14.15-1-lts #1 SMP Thu Jul 31 22:42:44 UTC 2014 x86_64 GNU/Linux
2014-08-04 13:05:44
root@a i ~ # btrfs --version
Btrfs v3.14.2-dirty
2014-08-04 13:05:44
root@a i ~ # btrfs fi show
Label: 'system'  uuid: 06acfd0f-314d-457f-ba00-f96bf5b94a02
Total devices 2 FS bytes used 20.68GiB
devid    1 size 476.94GiB used 30.03GiB path /dev/sda
devid    2 size 476.94GiB used 30.03GiB path /dev/sdb

Label: 'data'  uuid: 10cc711b-8c8c-457c-91b1-d8ea4ef4e8d8
Total devices 4 FS bytes used 1.02TiB
devid    1 size 558.91GiB used 558.91GiB path /dev/sdc
devid    2 size 558.91GiB used 558.89GiB path /dev/sdd
devid    3 size 558.91GiB used 558.89GiB path /dev/sde
devid    4 size 558.91GiB used 558.89GiB path /dev/sdf

Btrfs v3.14.2-dirty
---------------------------------------------------------------------
Here's my iostat output:
---------------------------------------------------------------------
2014-08-04 13:26:39
root@a i ~ # iostat
Linux 3.14.15-1-lts (eanna) 08/04/2014 _x86_64_ (24 CPU)

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           6.93    0.34    2.82    0.40    0.00   89.50

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sdb              22.40        38.75       540.65     836356   11668224
sda              22.41        40.32       540.65     870084   11668224
sdg               0.02         0.14         0.00       2987         24
sdc              17.42       232.10       368.66    5009076    7956248
sdd              16.64       196.53       357.23    4241392    7709640
sdf              16.30       196.35       367.01    4237644    7920700
sde              17.12       232.16       355.58    5010384    7674092
sdh               0.01         0.22         0.00       4820          0

How do I boil those numbers down to something meaningful, so I can get
an idea of the throughput in situ?

Presumably the answer is based on the normal read/write arithmetic
associated with RAID:
* raid1 read is nx (no lower than 1x), write is 1x
* raid10 read is nx (no lower than (n/spans)x), write is (n/spans)x

But as a practical matter, how does one go from the formulae to iostat
output to a metric? For instance:
Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sdb              22.40        38.75       540.65     836356   11668224
sda              22.41        40.32       540.65     870084   11668224

Do I take this to mean that for my raid1 read throughput is possibly
38.75 + 40.32 = 79.07 kB_read/s, and write is (540.65 + 540.65)/2 =
540.65 kB_write/s?

Though raid5&6 are yet to be fully baked, I imagine the answer for
those levels can become quite complex.

Thanks for your time,
-rb
