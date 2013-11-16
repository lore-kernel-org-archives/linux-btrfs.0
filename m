Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:40093 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab3KPUhI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Nov 2013 15:37:08 -0500
Received: by mail-ea0-f172.google.com with SMTP id h11so1639676eaj.31
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Nov 2013 12:37:06 -0800 (PST)
Received: from [192.168.2.102] (cpe-62-84-228-88.dynamic.amis.net. [62.84.228.88])
        by mx.google.com with ESMTPSA id z2sm20080404eee.7.2013.11.16.12.37.05
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sat, 16 Nov 2013 12:37:05 -0800 (PST)
Message-ID: <5287D775.1090105@gmail.com>
Date: Sat, 16 Nov 2013 21:37:09 +0100
From: =?UTF-8?B?RGVqYW4gUmliacSN?= <dejan.ribic@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs resize partition problem
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Originaly I had two seperate ext4 partitions for rootand home, thenI 
recently converted my root ext4 partition to btrfs primarily because of 
snapshots, I also created a subvolume for /var/cache/pacman/pkg because 
I didn't want the packages in snapshots and that worked out great, I 
have been running this setup without problems for two weeks now, but it 
got me thinking why do I even have a seperate partition for home, so I 
created a backup of my /home/stayerc directory and deleted the ext4 
partition, but when I tried to resize btrfs partition using latest 
gparted live cd, an error happened(details are on the bottom of email). 
I would really apreciated any help.

Cheers,

Dejan

PS: Please Cc to me I am not subscribed

save-details from gparted:
---------------------------------------------
GParted 0.16.1 --enable-libparted-dmraid
Libparted 2.3
Move /dev/sda8 to the left and grow it from 20.95 GiB to 41.90 GiB 
  00:01:19    ( ERROR )
calibrate /dev/sda8  00:00:00    ( SUCCESS )
path: /dev/sda8
start: 1190326272
end: 1234257919
size: 43931648 (20.95 GiB)
check file system on /dev/sda8 for errors and (if possible) fix them 
  00:01:19    ( ERROR )
btrfsck /dev/sda8
Checking filesystem on /dev/sda8
UUID: 5f32176b-fa13-4af2-a5d9-ffbc558bdb13
free space inode generation (0) did not match free space cache 
generation (1122)
free space inode generation (0) did not match free space cache 
generation (1122)
free space inode generation (0) did not match free space cache 
generation (1122)
free space inode generation (0) did not match free space cache 
generation (1122)
free space inode generation (0) did not match free space cache 
generation (1109)
found 3430820721 bytes used err is 19
total csum bytes: 7677820
total tree bytes: 569364480
total fs tree bytes: 529350656
total extent tree bytes: 29700096
btree space waste bytes: 161755833
file data blocks allocated: 38304477184
referenced 16981073920
Btrfs v0.20-rc1
checking extents
checking free space cache
checking fs roots
checking csums
There are no extents for csum range 0-69632
Csum exists for 0-69632 but there is no extent record
There are no extents for csum range 1121083392-1121087488
Csum exists for 1121083392-1121087488 but there is no extent record
There are no extents for csum range 1121099776-1121103872
Csum exists for 1121099776-1127346176 but there is no extent record
There are no extents for csum range 1127489536-1127493632
Csum exists for 1127489536-1127538688 but there is no extent record
There are no extents for csum range 1127550976-1127555072
Csum exists for 1127550976-1404313600 but there is no extent record
There are no extents for csum range 1404358656-1404362752
Csum exists for 1404358656-1404362752 but there is no extent record
There are no extents for csum range 1404375040-1404379136
Csum exists for 1404375040-1592889344 but there is no extent record
There are no extents for csum range 1954291712-1954295808
Csum exists for 1954291712-1970950144 but there is no extent record
There are no extents for csum range 1971093504-1971097600
Csum exists for 1971093504-2020798464 but there is no extent record
There are no extents for csum range 2021244928-2021249024
Csum exists for 2021244928-2021253120 but there is no extent record
There are no extents for csum range 2021699584-2021703680
Csum exists for 2021699584-2022080512 but there is no extent record
There are no extents for csum range 2022526976-2022531072
Csum exists for 2022526976-2277900288 but there is no extent record
There are no extents for csum range 2277912576-2277916672
Csum exists for 2277912576-2277916672 but there is no extent record
There are no extents for csum range 2277928960-2277933056
Csum exists for 2277928960-2277933056 but there is no extent record
There are no extents for csum range 2277945344-2277949440
Csum exists for 2277945344-2277949440 but there is no extent record
There are no extents for csum range 2277961728-2277965824
Csum exists for 2277961728-2277969920 but there is no extent record
There are no extents for csum range 2277982208-2277986304
Csum exists for 2277982208-2277986304 but there is no extent record
There are no extents for csum range 2277998592-2278002688
Csum exists for 2277998592-2278014976 but there is no extent record
There are no extents for csum range 2278027264-2278031360
Csum exists for 2278027264-2392010752 but there is no extent record
========================================

