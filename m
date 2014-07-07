Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52859 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbaGGNiv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Jul 2014 09:38:51 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi2so16021878wib.17
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Jul 2014 06:38:49 -0700 (PDT)
Received: from [192.168.2.3] (p4FF78E2A.dip0.t-ipconnect.de. [79.247.142.42])
        by mx.google.com with ESMTPSA id de6sm8669542wjc.16.2014.07.07.06.38.46
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 07 Jul 2014 06:38:47 -0700 (PDT)
Message-ID: <53BAA2E5.2090801@lianse.eu>
Date: Mon, 07 Jul 2014 15:38:45 +0200
From: =?UTF-8?B?QW5kcsOpLVNlYmFzdGlhbiBMaWViZQ==?= <andre@lianse.eu>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: mount time of multi-disk arrays
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello List,

can anyone tell me how much time is acceptable and assumable for a
multi-disk btrfs array with classical hard disk drives to mount?

I'm having a bit of trouble with my current systemd setup, because it
couldn't mount my btrfs raid anymore after adding the 5th drive. With
the 4 drive setup it failed to mount once in a few times. Now it fails
everytime because the default timeout of 1m 30s is reached and mount is
aborted.
My last 10 manual mounts took between 1m57s and 2m12s to finish.

My hardware setup contains a
- Intel Core i7 4770
- Kernel 3.15.2-1-ARCH
- 32GB RAM
- dev 1-4 are 4TB Seagate ST4000DM000 (5900rpm)
- dev 5 is a 4TB Wstern Digital WDC WD40EFRX (5400rpm)

Thanks in advance

André-Sebastian Liebe
--------------------------------------------------------------------------------------------------

# btrfs fi sh
Label: 'apc01_pool0'  uuid: 066141c6-16ca-4a30-b55c-e606b90ad0fb
        Total devices 5 FS bytes used 14.21TiB
        devid    1 size 3.64TiB used 2.86TiB path /dev/sdd
        devid    2 size 3.64TiB used 2.86TiB path /dev/sdc
        devid    3 size 3.64TiB used 2.86TiB path /dev/sdf
        devid    4 size 3.64TiB used 2.86TiB path /dev/sde
        devid    5 size 3.64TiB used 2.88TiB path /dev/sdb

Btrfs v3.14.2-dirty

# btrfs fi df /data/pool0/
Data, single: total=14.28TiB, used=14.19TiB
System, RAID1: total=8.00MiB, used=1.54MiB
Metadata, RAID1: total=26.00GiB, used=20.20GiB
unknown, single: total=512.00MiB, used=0.00


