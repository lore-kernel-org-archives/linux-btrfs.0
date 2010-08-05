From: Leonidas Spyropoulos <artafinde@gmail.com>
Subject: Raid0 with btrfs
Date: Thu, 5 Aug 2010 15:15:22 +0100
Message-ID: <AANLkTimS=bgDsbk9jdcPqW-88eQnq+qss1m2mZBfAif2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I want to make a btrfs raid0 on 2 partitions of my pc.
Until now I am using the mdadm tools to make a software raid of the 2
partitions /dev/sde2, /dev/sdd2
and then mkfs.etx4 the newly created /dev/md0 device.
>From performance point of view is it better to keep the configuration of mdadm
and just format the /dev/md0 device as btrfs OR
delete the raid device and format the 2 partitions /dev/sde2 /dev/sdd2
as a btrfs with 2 devices?
mkfs.btrfs /dev/sde2 /dev/sdd2

On a sidenote:
If I decide to go for raid5 which is not supported currently from mkfs
I have to use the mdadm tool anyway, right?

-- 
Caution: breathing may be hazardous to your health.
