Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:38312 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbcCBUen (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Mar 2016 15:34:43 -0500
Received: by mail-ig0-f180.google.com with SMTP id y8so3146043igp.1
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Mar 2016 12:34:43 -0800 (PST)
Received: from orf-v6.ssec.wisc.edu (orf-v6.ssec.wisc.edu. [2607:f388:1090:0:6600:6aff:fe6a:3374])
        by smtp.googlemail.com with ESMTPSA id 203sm15355843ioo.30.2016.03.02.12.34.41
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Wed, 02 Mar 2016 12:34:41 -0800 (PST)
Message-ID: <1456950881.15729.2.camel@gmail.com>
Subject: duplicate automounts with btrfs RAID1
From: Leigh Orf <leigh.orf@gmail.com>
To: linux-btrfs@vger.kernel.org
Date: Wed, 02 Mar 2016 14:34:41 -0600
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Not entirely sure this is a btrfs issue, but here is my problem. I've
had this issue with recent Fedora and CentOS distros.

I created a btrfs RAID 1 pair with two identical USB external drives,
following the instructions found online:

mkfs.btrfs -m raid1 -d raid1 /dev/sdc1 /dev/sdd1

Then I mount it as /ext1:

% df |grep sdc
/dev/sdc1      9767539112 1280   9765383552   1% /ext1

The problem? Over time, /dev/sdc1 keeps getting mounted under a
different mount point, these accrue a couple per day:

% mount|grep sdc
/dev/sdc1 on /ext1 type btrfs (rw,relatime,space_cache)
/dev/sdc1 on /run/media/fred/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxx38fd1 type
btrfs (rw,nosuid,nodev,relatime,space_cache)
/dev/sdc1 on /run/media/fred/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxx38fd11 type
btrfs (rw,nosuid,nodev,relatime,space_cache)
/dev/sdc1 on /run/media/fred/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxx38fd12 type
btrfs (rw,nosuid,nodev,relatime,space_cache)
/dev/sdc1 on /run/media/fred/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxx38fd13 type
btrfs (rw,nosuid,nodev,relatime,space_cache)
/dev/sdc1 on /run/media/fred/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxx38fd14 type
btrfs (rw,nosuid,nodev,relatime,space_cache)
/dev/sdc1 on /run/media/fred/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxx38fd15 type
btrfs (rw,nosuid,nodev,relatime,space_cache)
/dev/sdc1 on /run/media/fred/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxx38fd16 type
btrfs (rw,nosuid,nodev,relatime,space_cache)
/dev/sdc1 on /run/media/fred/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxx38fd17 type
btrfs (rw,nosuid,nodev,relatime,space_cache)
/dev/sdc1 on /run/media/fred/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxx38fd18 type
btrfs (rw,nosuid,nodev,relatime,space_cache)
/dev/sdc1 on /run/media/fred/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxx38fd19 type
btrfs (rw,nosuid,nodev,relatime,space_cache)

It's as if the OS keeps "discovering a new disk" and mounting it
under /run/media (where things like external drives, thumb drives etc.
automount).

Here is info about my setup (up to date CentOS 7.2):

% cat /etc/system-release
CentOS Linux release 7.2.1511 (Core) 
% uname -a
Linux xxx.xxx.xxx.edu 3.10.0-123.20.1.el7.x86_64 #1 SMP Thu Jan 29
18:05:33 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
% btrfs --version
btrfs-progs v3.19.1
% btrfs fi show
Label: none  uuid: d9706351-609b-4c6e-9f37-7058bb038fd1
	Total devices 2 FS bytes used 640.00KiB
	devid    1 size 4.55TiB used 2.03GiB path /dev/sdc1
	devid    2 size 4.55TiB used 2.01GiB path /dev/sdd1

btrfs-progs v3.19.1
% btrfs fi df /ext1
Data, RAID1: total=1.00GiB, used=512.00KiB
Data, single: total=8.00MiB, used=0.00B
System, RAID1: total=8.00MiB, used=16.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, RAID1: total=1.00GiB, used=112.00KiB
Metadata, single: total=8.00MiB, used=0.00B

Periodically I manually unmount these duplicates, but they come back.
I'd like a solution that doesn't involve disabling automount all
together.

Thanks for any pointers, and apologies if this issue is unrelated to the
btrfs project.

Leigh

--
Leigh Orf
Associate Scientist
Cooperative Institute for Meteorological Satellite Studies
University of Wisconsin - Madison

