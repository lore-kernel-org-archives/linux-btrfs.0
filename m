Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:56313 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbaIONBU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 09:01:20 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mx02.posteo.de (Postfix) with ESMTP id 2700E25A2137
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Sep 2014 15:01:18 +0200 (CEST)
Received: from posteo.de ([10.125.125.178]) (using TLS)
	by localhost (amavis1.posteo.de [10.125.125.165]) (amavisd-new, port 10026)
	with ESMTPS id Ed8pc0pVnKvQ for <linux-btrfs@vger.kernel.org>;
	Mon, 15 Sep 2014 15:01:17 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by mail.posteo.de (Postfix) with ESMTPSA id DE8D02C010C
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Sep 2014 15:01:17 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 15 Sep 2014 15:01:17 +0200
From: krichter@posteo.de
To: <linux-btrfs@vger.kernel.org>
Subject: segmentation fault in btrfsck
Message-ID: <a7d2bda9a8beb0f8c066324a9c736cfc@posteo.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi together,
When I invoke `btrfsck --init-extent-tree /dev/sda12`, the process runs 
for ~30 to 60 minutes with 100 % usage of one CPU core and then fails 
with return code 139 without any feedback - an unexperienced user might 
expect the program to have succeeded if he_she doesn't check `echo $?`. 
In `dmesg`, I found

     [ 5972.236772] btrfsck[8263]: segfault at 7fffb88c5ff8 ip 
00007f542a8990f8 sp 00007fffb88c5fd0 error 6 in 
libc-2.17.so[7f542a818000+1bd000]

Is that an error of `btrfsck` or is the libc errornous? I tried both 
Ubuntu 13.10 and 14.04 with both Linux 3.16.2 from 
http://kernel.ubuntu.com/~kernel-ppa/mainline/ and from kernel archives 
(installed .deb packages created with `make deb-pkg`. Error is 
constantly reproducable. Is it possible to fix it? I'm trying to make a 
650 GB btrfs partition mountable again with btrfs-progs 3.16 after 
`btrfs filesystem resize` failed. How could I work around the 
segmentation fault? Is it normal that `btrfsck` takes so long?

Infos according to 
https://btrfs.wiki.kernel.org/index.php/Btrfs_mailing_list

     $ uname -a
     Linux richter-lenovo-IdeaPad-Z500 3.16.2 #4 SMP Mon Sep 8 00:54:41 
CEST 2014 x86_64 x86_64 x86_64 GNU/Linux
     $ btrfs --version
     Btrfs v3.16
     $ sudo btrfs fi show
     Label: none  uuid: 5e999111-7efe-4818-b9e8-a950ad6d3296
	    Total devices 1 FS bytes used 27.35GiB
	    devid    1 size 37.91GiB used 29.29GiB path /dev/sda18

     Label: none  uuid: bfbb7b09-856b-4cbe-9821-3db14b322bd4
	    Total devices 1 FS bytes used 1.80TiB
	    devid    1 size 4.55TiB used 1.81TiB path /dev/sdc1

     Label: none  uuid: 95a0f5cd-0aed-49e1-9914-1e346ea1a3d6
	    Total devices 1 FS bytes used 3.60GiB
	    devid    1 size 29.54GiB used 6.04GiB path /dev/sda15

     Label: none  uuid: 32a15b4a-0351-4ed1-a950-f50a5591d84b
	    Total devices 1 FS bytes used 50.86GiB
	    devid    1 size 63.76GiB used 59.04GiB path /dev/sda14

     Label: 'DATA'  uuid: 5b08b6ff-34d2-42b7-965e-fd415a2b2874
	    Total devices 1 FS bytes used 2.93GiB
	    devid    1 size 650.08GiB used 582.95GiB path /dev/sda12

     Label: none  uuid: c64f7bde-047d-473d-aee3-a5def8294197
	    Total devices 1 FS bytes used 15.25GiB
	    devid    1 size 24.37GiB used 20.29GiB path /dev/sda9

     Btrfs v3.16

dmesg.log attached

-Kalle
