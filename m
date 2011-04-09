From: "Helmut Hullen" <Hullen@t-online.de>
Subject: wrong values in "df" and "btrfs filesystem df"
Date: 09 Apr 2011 08:25:00 +0200
Message-ID: <BjW+GU4y1uB@helmut.hullen.de>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, linux-btrfs,

First I create an array of 2 disks with

  mkfs.btrfs -d raid0 -m raid1 /dev/sdb1 /dev/sdd1

and mount it at /srv/MM.

Then I fill it with about 1,6 TByte.
And then I add /dev/sde1 via

  btrfs device add /dev/sde1 /srv/MM
  btrfs filesystem balance /srv/MM
    (it run about 20 hours)

Then I work on it, copy some new files, delete some old files - all  
works well. Only

  df /srv/MM
  btrfs filesystem df /srv/MM

show some completely wrong values:

# df /srv/MM

Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sdd1            5846053400 1593436456 2898463184  36% /srv/MM

# btrfs filesystem df /srv/MM

Data, RAID0: total=1.67TB, used=1.48TB
System, RAID1: total=16.00MB, used=112.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=3.75GB, used=2.26GB

# btrfs-show

Label: MMedia  uuid: 120b036a-883f-46aa-bd9a-cb6a1897c8d2
	Total devices 3 FS bytes used 1.48TB
	devid    3 size 1.81TB used 573.76GB path /dev/sdb1
	devid    2 size 1.81TB used 573.77GB path /dev/sde1
	devid    1 size 1.82TB used 570.01GB path /dev/sdd1

Btrfs Btrfs v0.19

------------------------------------------------

"df" shows an "Available" value which isn't related to any real value.  
The sum of "used" and "Available" is far away from the really existent  
disk space. When I copy additional files to "/srv/MM" then "used" still  
shows the right value, and the sum grows (slowly) to the max. available  
space.

In "btrfs filesystem df /srv/MM" the line

  Data, RAID0: total=1.67TB, used=1.48TB

shows a "total" value which isn't related to any existent value; maybe  
it still shows the used space before adding the third partition.
This (wrong) value seems not to change.

Kernel 2.6.38.1
btrfs from november 2010

Viele Gruesse!
Helmut
