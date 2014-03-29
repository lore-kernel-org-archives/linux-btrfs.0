Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:62405 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaC2XZa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Mar 2014 19:25:30 -0400
Received: by mail-pd0-f182.google.com with SMTP id y10so6334367pdj.41
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Mar 2014 16:25:30 -0700 (PDT)
Received: from localhost.localdomain ([72.235.164.16])
        by mx.google.com with ESMTPSA id pv4sm33753648pbb.55.2014.03.29.16.25.28
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sat, 29 Mar 2014 16:25:29 -0700 (PDT)
Message-ID: <53375669.4070605@hawaii.edu>
Date: Sat, 29 Mar 2014 13:25:29 -1000
From: jon <jmoroney@hawaii.edu>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Potential rebalance bug plus some questions
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

First off I've got a couple of questions that I posed over on the 
fedoraforum
http://www.forums.fedoraforum.org/showthread.php?t=298142

"I'm in the process of building a btrfs storage server (mostly for 
evaluation) and I'm trying to understand the COW system. As I understand 
it no data is over written when file X is changed ot file Y is created, 
but what happens when you get to the end of your disk?
Say you write files X1, X2, ... Xn which fills up your disk. You then 
delete X1 through Xn-1, does the disk space actually free up? How does 
this affect the 30 second snapshot mechanism and all the roll back stuff?

Second, the raid functionality works at the filesystem block level 
rather than the device block level. Ok cool, so "raid 1" is creating two 
copies of every block and sticking each copy on a different device 
instead of block mirroring over multipul devices. So you can have a 
"raid 1" in 3, 5, or n disks. If I understand that correctly then you 
should be able to lose a single disk out of a raid 1 and still have all 
your data where lossing two disks may kill off data. Is that right? Is 
there a good rundown on "raid" levels in btrfs somewhere?"

If anyone could field those I would be very thankful. Second, I've got a 
centOS 6 box with the current epel kernel and btrfs progs (3.12) on 
which I'm playing with the raid1 setup. Using four disks, I created an 
array
mkfs.btrfs -d raid1 -m raid1 /dev/sd[b-e]
mounted via uuid and rebooted. At this point all was well
Next I simulated a disk failure by pulling the power on the disk sdb and 
I was still able to get at my data. Great.
Plugged sdb back in and it came up as /dev/sdg, ok whatever. Next I did 
a rebalance of the array which is what I *think* killed it. The 
rebalance went on, I saw many I/O errors, but I dismissed them as they 
were all about sdb.
After the rebalance I removed /dev/sdb from the pool, added /dev/sdg and 
rebooted.
On the reboot the pool failed to mount at all. dmesg showed something 
like "btrfs open_ctree failure" (sorry, don't have access to the box atm).

So tl;dr I think there may be an issue with the balance command when a 
disk is offline.

Jon
