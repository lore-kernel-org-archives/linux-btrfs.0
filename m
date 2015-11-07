Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:47895 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbbKGWQQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 Nov 2015 17:16:16 -0500
Received: from mfilter21-d.gandi.net (mfilter21-d.gandi.net [217.70.178.149])
	by relay3-d.mail.gandi.net (Postfix) with ESMTP id 65C15A80AF
	for <linux-btrfs@vger.kernel.org>; Sat,  7 Nov 2015 23:16:14 +0100 (CET)
Received: from relay3-d.mail.gandi.net ([IPv6:::ffff:217.70.183.195])
	by mfilter21-d.gandi.net (mfilter21-d.gandi.net [::ffff:10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id TU68RssdR0es for <linux-btrfs@vger.kernel.org>;
	Sat,  7 Nov 2015 23:16:12 +0100 (CET)
Received: from zimbra.grelot.net (zimbra.grelot.net [213.251.185.52])
	(Authenticated sender: frederic@grelot.net)
	by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id E9010A80AB
	for <linux-btrfs@vger.kernel.org>; Sat,  7 Nov 2015 23:16:12 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by zimbra.grelot.net (Postfix) with ESMTP id 5E7511A1CFD
	for <linux-btrfs@vger.kernel.org>; Sat,  7 Nov 2015 23:20:36 +0100 (CET)
Received: from zimbra.grelot.net ([127.0.0.1])
	by localhost (zimbra.grelot.net [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id 0lBumTYRfc17 for <linux-btrfs@vger.kernel.org>;
	Sat,  7 Nov 2015 23:20:35 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by zimbra.grelot.net (Postfix) with ESMTP id 5C6181A1943
	for <linux-btrfs@vger.kernel.org>; Sat,  7 Nov 2015 23:20:35 +0100 (CET)
Received: from zimbra.grelot.net ([127.0.0.1])
	by localhost (zimbra.grelot.net [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ezQFZcA0jFsl for <linux-btrfs@vger.kernel.org>;
	Sat,  7 Nov 2015 23:20:35 +0100 (CET)
Received: from zimbra.grelot.net (zimbra.grelot.net [192.168.122.2])
	by zimbra.grelot.net (Postfix) with ESMTP id EED3B1A192F
	for <linux-btrfs@vger.kernel.org>; Sat,  7 Nov 2015 23:20:34 +0100 (CET)
Date: Sat, 7 Nov 2015 23:20:34 +0100 (CET)
From: =?utf-8?B?RnLDqWTDqXJpYw==?= <fredericg_99@yahoo.fr>
Reply-To: =?utf-8?B?RnLDqWTDqXJpYw==?= <fredericg_99@yahoo.fr>
To: linux-btrfs@vger.kernel.org
Message-ID: <1088210322.2591.1446934834083.JavaMail.zimbra@grelot.net>
Subject: cannot mount btrfs volume read/write (+task blocked backtrace)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all, 

I am trying to mount a btrfs filesystem, and I have been told on freenode/#btrfs to try the mailing list for more precise advice.
My setup is as follow : one debian server (stretch,  4.2.0-1-amd64 #1 SMP Debian 4.2.3-2 (2015-10-14) x86_64) with 5 disks running in a btrfs raid6 volume.
root@nas:~# btrfs --version
btrfs-progs v4.1.2
root@nas:~#   btrfs fi show
Label: none  uuid: 0d56cb74-65f9-4f4e-9c51-74ea286f3f79
	Total devices 5 FS bytes used 2.66TiB
	devid    3 size 931.51GiB used 320.29GiB path /dev/sda1
	devid    5 size 2.73TiB used 1.76TiB path /dev/sdb1
	devid    6 size 2.73TiB used 1.76TiB path /dev/sde1
	devid    7 size 2.73TiB used 1.76TiB path /dev/sdf1
	devid    8 size 2.73TiB used 609.50GiB path /dev/sdd1

btrfs-progs v4.1.2
root@nas:~#   btrfs fi df /raid
Data, RAID6: total=2.66TiB, used=2.66TiB
System, RAID6: total=64.00MiB, used=416.00KiB
Metadata, RAID6: total=10.00GiB, used=8.13GiB
GlobalReserve, single: total=512.00MiB, used=544.00KiB


As you can guess, device 8 is pretty new. Device 3 is to be removed. I already issued a "btrfs dev del" on it (and the data was balanced to dev 8), but had to interrupt it (I'm not proud of that, but the server had to be turned off).
I had few hitches with this volume recently : the btrfs dev del was interrupted, and one of the SATA cable was defective (I saw that recently, it is now replaced). I ran a scrub which had not had enough time to complete. I can not say for sure that it is not waiting for resuming...
The volume has several snapshots (about 20 or 30, I activated snapper 1 month ago), and I just enabled qgroups in order to monitor snapshot disk usage. I know that the qgroups quotas are not updated yet : because of the bad cable, the latest "btrfs dev del" started to have errors, and I could not do anything but kill the server. If I remember correctly, the disk with the bad cable was devid 5 (/dev/sdb1).
I enabled qgroups during the "btrfs dev del" process.

Now, I can mount the volume with no problem in read-only (so my backups are up-to-date!)
If I try to mount it RW, I get the following errors in dmesg :
steps :
mount -o ro,recover,nospace_cache,clear_cache,skip_balance
(time is 28s in dmesg)
mount -o remount,rw,recover,nospace_cache,clear_cache,skip_balance
(time 83s)
dmesg :
[   28.920176] BTRFS info (device sda1): enabling auto recovery
[   28.920183] BTRFS info (device sda1): force clearing of disk cache
[   28.920187] BTRFS info (device sda1): disabling disk space caching
[   28.920190] BTRFS: has skinny extents
[   29.551170] BTRFS: bdev /dev/sdb1 errs: wr 0, rd 0, flush 0, corrupt 3434, gen 0
[   83.483314] BTRFS info (device sda1): disabling disk space caching
[   83.483323] BTRFS info (device sda1): enabling auto recovery
[   83.483326] BTRFS info (device sda1): enabling auto recovery
[  360.188189] INFO: task btrfs-transacti:1100 blocked for more than 120 seconds.
[  360.188209]       Tainted: G        W       4.2.0-1-amd64 #1
[  360.188214] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  360.188221] btrfs-transacti D ffffffff8109a1c0     0  1100      2 0x00000000
[  360.188226]  ffff8800d857eec0 0000000000000046 ffff8800cb947e20 ffff88011abecd40
[  360.188229]  0000000000000246 ffff8800cb948000 ffff880119dc8000 ffff8800cb947e20
[  360.188231]  ffff88011ae83d58 ffff8800d8d72d48 ffff8800d8d72da8 ffffffff8154acaf
[  360.188233] Call Trace:
[  360.188239]  [<ffffffff8154acaf>] ? schedule+0x2f/0x70
[  360.188265]  [<ffffffffa022c0bf>] ? btrfs_commit_transaction+0x3ef/0xa90 [btrfs]
[  360.188269]  [<ffffffff810a9ad0>] ? wait_woken+0x80/0x80
[  360.188281]  [<ffffffffa0227654>] ? transaction_kthread+0x224/0x240 [btrfs]
[  360.188293]  [<ffffffffa0227430>] ? btrfs_cleanup_transaction+0x510/0x510 [btrfs]
[  360.188296]  [<ffffffff8108aa41>] ? kthread+0xc1/0xe0
[  360.188298]  [<ffffffff8108a980>] ? kthread_create_on_node+0x170/0x170
[  360.188301]  [<ffffffff8154ea1f>] ? ret_from_fork+0x3f/0x70
[  360.188303]  [<ffffffff8108a980>] ? kthread_create_on_node+0x170/0x170
[  480.188185] INFO: task btrfs-transacti:1100 blocked for more than 120 seconds.
[...]

As you can see, I get an error at boot+360s (6 minutes)
The error repeats every two minutes, and stopped at boot+28minutes.
However, the "mount" process was still active, and I stopped it (in order to try something else) more than 3 hours later. No message appeared after this one (t+28m).
I also tried to mount RO, umount, then mount RW (with the same option), but with no success : I got the same message+backtrace at boot+4 minutes

Following an advice on #btrfs, I am currently running a btrfs check --readonly, but it takes a pretty long time. However, may the check fix the problem or not, the backtrace may be of interest for you...
I'll update the mailing-list after the btrfs-check result

Goulou.
