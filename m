Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:36629 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405Ab3GQNex (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jul 2013 09:34:53 -0400
Received: by mail-la0-f44.google.com with SMTP id er20so1523403lab.3
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jul 2013 06:34:51 -0700 (PDT)
Received: from mail-lb0-x22b.google.com (mail-lb0-x22b.google.com [2a00:1450:4010:c04::22b])
        by mx.google.com with ESMTPSA id p20sm2790010lbb.17.2013.07.17.06.34.50
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Wed, 17 Jul 2013 06:34:50 -0700 (PDT)
Received: by mail-lb0-f171.google.com with SMTP id 13so1591498lba.30
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jul 2013 06:34:50 -0700 (PDT)
MIME-Version: 1.0
From: Dan van der Ster <dan@vanderster.com>
Date: Wed, 17 Jul 2013 15:34:09 +0200
Message-ID: <CABZ+qqnM4g9H1d4dCw9Ao3Kj7tKGJ7M1_oPkGjFKcheMrD=HMQ@mail.gmail.com>
Subject: unfinished convert to raid6, enospc
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
Two days ago I decided to throw caution to the wind and convert my
raid1 array to raid6, for the space and redundancy benefits. I did

# btrfs fi balance start -dconvert=raid6 /media/btrfs

Eventually today the balance finished, but the conversion to raid6 was
incomplete:

# btrfs fi df /media/btrfs
Data, RAID1: total=693.00GB, used=690.47GB
Data, RAID6: total=6.36TB, used=4.35TB
System, RAID1: total=32.00MB, used=1008.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=8.00GB, used=6.04GB

A recent btrfs balance status (before finishing) said:

# btrfs balance status /media/btrfs
Balance on '/media/btrfs' is running
4289 out of about 5208 chunks balanced (4988 considered),  18% left

and at the end I have:

[164935.053643] btrfs: 693 enospc errors during balance

Here is the array:

# btrfs fi show /dev/sdb
Label: none  uuid: 743135d0-d1f5-4695-9f32-e682537749cf
Total devices 7 FS bytes used 5.04TB
devid    2 size 2.73TB used 2.73TB path /dev/sdh
devid    1 size 2.73TB used 2.73TB path /dev/sdg
devid    5 size 1.36TB used 1.31TB path /dev/sde
devid    6 size 1.36TB used 1.31TB path /dev/sdf
devid    4 size 1.82TB used 1.82TB path /dev/sdd
devid    3 size 1.82TB used 1.82TB path /dev/sdc
devid    7 size 1.82TB used 1.82TB path /dev/sdb


I'm running latest stable, plus the patch "free csums when we're done
scrubbing an extent" (otherwise I get OOM when scrubbing).

# uname -a
Linux dvanders-webserver 3.10.1+ #1 SMP Mon Jul 15 17:07:19 CEST 2013
x86_64 x86_64 x86_64 GNU/Linux

I still have plenty of free space:

# df -h /media/btrfs
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdd         14T  5.8T  2.2T  74% /media/btrfs

Any idea how I can get out of this? Thanks!
--
Dan van der Ster
