From: "Helmut Hullen" <Hullen@t-online.de>
Subject: btrfs still looks for not existing devices
Date: 14 Oct 2011 15:51:00 +0200
Message-ID: <BvpREOmi1uB@helmut.hullen.de>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, linux-btrfs,

I've just compiled kernel 3.9.04 and run

        btrfs filesystem show

On my system (Slackware 13.37, self made, without "udev") it still shows  
a lot of non existent devices (I have shortened the list ...):

# btrfs fi show

failed to read /dev/hdb4
failed to read /dev/scd9
failed to read /dev/hda6
failed to read /dev/hda
failed to read /dev/sde
failed to read /dev/hdd3
failed to read /dev/sdl6
failed to read /dev/hdc9
failed to read /dev/sdg9
failed to read /dev/lmscd
failed to read /dev/scd1
failed to read /dev/hdd7
failed to read /dev/sdj6
failed to read /dev/scd5
failed to read /dev/sdg3
failed to read /dev/sda5
failed to read /dev/sr0
failed to read /dev/hda9
failed to read /dev/sde3
failed to read /dev/sda6
failed to read /dev/sdh9
failed to read /dev/hda8
failed to read /dev/sdg6
failed to read /dev/sdj3
failed to read /dev/fd1
failed to read /dev/hdd2
failed to read /dev/scd2
failed to read /dev/sdi9
failed to read /dev/sdk8
failed to read /dev/sdk6
failed to read /dev/sdh2
failed to read /dev/sdf3
failed to read /dev/scd7
failed to read /dev/sdi
failed to read /dev/cloop1
failed to read /dev/sdl7
failed to read /dev/hdd9
failed to read /dev/sdk5
failed to read /dev/sde2
failed to read /dev/sdj9
failed to read /dev/sdd9
failed to read /dev/hdb5
failed to read /dev/hdc8
failed to read /dev/sdi2
failed to read /dev/sdk1
failed to read /dev/sdh4
failed to read /dev/sdf2
failed to read /dev/sdc5
failed to read /dev/sdc8
failed to read /dev/fd0
failed to read /dev/hdc5
failed to read /dev/sde1
failed to read /dev/hdc1
failed to read /dev/sdc9
failed to read /dev/hda1
failed to read /dev/sdi6
failed to read /dev/sdh
failed to read /dev/sdd7
failed to read /dev/hdb9
failed to read /dev/sdg8
failed to read /dev/sdh3
failed to read /dev/sr6
failed to read /dev/sdb9
failed to read /dev/hdb8
failed to read /dev/hdd5
failed to read /dev/hda2
failed to read /dev/sdf8
failed to read /dev/sr8
failed to read /dev/sdh6
failed to read /dev/sdj4
failed to read /dev/sdl
failed to read /dev/sdf4
failed to read /dev/sde9
failed to read /dev/hdb2
failed to read /dev/sdl4
failed to read /dev/hda3
failed to read /dev/sde5
failed to read /dev/sda9
failed to read /dev/sdi7
failed to read /dev/sdj7
failed to read /dev/sde6
failed to read /dev/sde7
failed to read /dev/hdd
failed to read /dev/sdf9
failed to read /dev/sdk4
failed to read /dev/sdi3
failed to read /dev/sdd4
failed to read /dev/hda5
failed to read /dev/sdl9
failed to read /dev/hdc7
failed to read /dev/hdd6
failed to read /dev/sr5
failed to read /dev/sr7
failed to read /dev/sdb5
failed to read /dev/sdb4
failed to read /dev/sdh1
failed to read /dev/hdc2
failed to read /dev/hdd1
failed to read /dev/hdc3
failed to read /dev/sr3
failed to read /dev/scd6
failed to read /dev/hdc4
failed to read /dev/sdc3
failed to read /dev/sdl8
failed to read /dev/sr1
failed to read /dev/hdb1
failed to read /dev/sdl5
failed to read /dev/hdb7
failed to read /dev/hdc
failed to read /dev/sdj8
failed to read /dev/sr2
failed to read /dev/hdb3
failed to read /dev/sdd8
failed to read /dev/sdk9
failed to read /dev/sdi1
failed to read /dev/sdl1
failed to read /dev/sr4
failed to read /dev/sdj5
failed to read /dev/sr9
failed to read /dev/hdb
failed to read /dev/sda7
failed to read /dev/sdf6
failed to read /dev/sdf5
failed to read /dev/sdc7
failed to read /dev/sdi8
failed to read /dev/scd0
failed to read /dev/hdc6
failed to read /dev/sdk2
failed to read /dev/sdg4
failed to read /dev/hdd8
failed to read /dev/sdj2
failed to read /dev/sdk
failed to read /dev/sdd6
failed to read /dev/sda8
failed to read /dev/sdk7
failed to read /dev/scd3
failed to read /dev/scd4
failed to read /dev/hda7
failed to read /dev/sdk3
failed to read /dev/sdc6
failed to read /dev/sdj
failed to read /dev/sdj1
failed to read /dev/sdh5
failed to read /dev/sdd3
failed to read /dev/sdb6
failed to read /dev/sdg5
failed to read /dev/sdg7
failed to read /dev/sdb3
failed to read /dev/sdi5
failed to read /dev/sdc4
failed to read /dev/sdi4
failed to read /dev/sdd5
failed to read /dev/sdh7
failed to read /dev/sdb7
failed to read /dev/sde8
failed to read /dev/cloop
failed to read /dev/sdf7
failed to read /dev/sdl3
failed to read /dev/hda4
failed to read /dev/hdd4
failed to read /dev/sdh8
failed to read /dev/sdl2
failed to read /dev/sdb8
failed to read /dev/hdb6
failed to read /dev/scd8
failed to read /dev/sde4
Label: 'MMedia'  uuid: 120b036a-883f-46aa-bd9a-cb6a1897c8d2
	Total devices 3 FS bytes used 3.72TB
	devid    1 size 1.82TB used 1.27TB path /dev/sdg1
	devid    2 size 1.81TB used 1.26TB path /dev/sdb1
	devid    3 size 1.81TB used 1.27TB path /dev/sdc1

Btrfs Btrfs v0.19

--------------------------------------------------

# cat /proc/partitions

major minor  #blocks  name

   8        0  293036184 sda
   8        1   10490413 sda1
   8        2    2104515 sda2
   8        3   10490445 sda3
   8        4  269948227 sda4
   8       16 1953514584 sdb
   8       17 1948684468 sdb1
   8       18    4827532 sdb2
   8       32 1953514584 sdc
   8       33 1947881218 sdc1
   8       34    5630782 sdc2
   8       48 1465138584 sdd
   8       49 1460308468 sdd1
   8       50    4827532 sdd2
   8       96 1953514584 sdg
   8       97 1949487718 sdg1
   8       98    4024282 sdg2
   8       80   15613920 sdf
   8       81   15609888 sdf1

------------------------------------------------------


Can I hope that this nasty behaviour gets fixed some day? I won't use  
"udev" just to fix it.

Viele Gruesse!
Helmut
