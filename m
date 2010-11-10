From: Oliver =?UTF-8?Q?Ve=C4=8Dernik?= <ov@vecernik.at>
Subject: migrating drives (device delete)
Date: Wed, 10 Nov 2010 12:04:36 +0100
Message-ID: <1289387076.20690.28.camel@jeezo>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

running on Ubuntu server 10.10 (2.6.35-22-server) I've got a 160GB disk
for / (/boot is on another partition with ext2).  I added another 750GB
drive with the following command:

# btrfs device add /dev/sdb2 /
# btrfs device balance /

As far as I can see it is a RAID 0 and now full:

# sudo btrfs filesystem show 
Label: none  uuid: cd4fd4c1-0632-4cbe-bf3b-ba7a9acda1e0
        Total devices 2 FS bytes used 291.62GB
        devid    2 size 696.77GB used 146.63GB path /dev/sdb2
        devid    1 size 147.19GB used 146.64GB path /dev/sda2

Now I want to remove the smaller drive:

# mount -t btrfs -o remount,degraded /dev/sda2 /
# mount | grep /dev/sda2
/dev/sda2 on / type btrfs (rw,degraded)
# btrfs device delete /dev/sda2 /
ERROR: error removing the device '/dev/sda2'

Do I have to move the data first to /dev/sdb2 (how?) and then
delete /dev/sda2? Is there a better way to handle a situation like this?

Thanks!

-- 
Regards,
Oliver



