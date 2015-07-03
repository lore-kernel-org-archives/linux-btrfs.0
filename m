Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:35141 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280AbbGCR2g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jul 2015 13:28:36 -0400
Received: by obbop1 with SMTP id op1so72901702obb.2
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jul 2015 10:28:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG+QAKW1ZH_6AN3CSmXxiQr9xmR_ha=erfruSHxvKYKH6w3WiA@mail.gmail.com>
References: <CAG+QAKX1eSmarBn+YXq5dkZ0zTWsSDM6cfwTtDg-43-nTRSXWQ@mail.gmail.com>
	<CAC=t97Dy57JMBZ-exzCytMMUUhrV_zh7W9L+fQR_G_LOqfhWhA@mail.gmail.com>
	<CAG+QAKWZ-jTGkK7btiHziDf9LhW31QUSFbJ9DpLy1xqmk7vUCQ@mail.gmail.com>
	<CAG+QAKW1ZH_6AN3CSmXxiQr9xmR_ha=erfruSHxvKYKH6w3WiA@mail.gmail.com>
Date: Fri, 3 Jul 2015 10:28:36 -0700
Message-ID: <CAG+QAKUuwVSr8wibFi3zdwu1gR72YEjXEV1JFK126juWzDFvDg@mail.gmail.com>
Subject: Re: btrfs full, but not full, can't rebalance
From: Rich Rauenzahn <rrauenza@gmail.com>
To: Donald Pearson <donaldwhpearson@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm still seeing periodic issues here.  The filesystem will go "full"
occasionally even though there appears to be plenty of space.  Running
another rebalance seems to fix it ... but I don't see why the system
thinks it needs to be rebalanced.

# while ! btrfs balance start /; do btrfs fi show /; btrfs fi df / ; done
ERROR: error during balancing '/' - No space left on device
There may be more info in syslog - try dmesg | tail
Label: 'centos7'  uuid: 35f0ce3f-0902-47a3-8ad8-86179d1f3e3a
        Total devices 2 FS bytes used 17.06GiB
        devid    1 size 111.11GiB used 22.03GiB path /dev/sdf3
        devid    2 size 111.11GiB used 22.03GiB path /dev/sdg3

Btrfs v3.16.2
Data, RAID1: total=18.00GiB, used=16.36GiB
System, RAID1: total=32.00MiB, used=16.00KiB
Metadata, RAID1: total=4.00GiB, used=711.34MiB
GlobalReserve, single: total=240.00MiB, used=128.00KiB
ERROR: error during balancing '/' - No space left on device
There may be more info in syslog - try dmesg | tail
Label: 'centos7'  uuid: 35f0ce3f-0902-47a3-8ad8-86179d1f3e3a
        Total devices 2 FS bytes used 17.06GiB
        devid    1 size 111.11GiB used 25.06GiB path /dev/sdf3
        devid    2 size 111.11GiB used 25.06GiB path /dev/sdg3

Btrfs v3.16.2
Data, RAID1: total=17.00GiB, used=16.36GiB
System, RAID1: total=64.00MiB, used=16.00KiB
Metadata, RAID1: total=8.00GiB, used=711.67MiB
GlobalReserve, single: total=240.00MiB, used=144.00KiB
[...]

For now, this is going into a cron job ...

Rich
