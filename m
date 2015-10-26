Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.70.57.6] ([195.70.57.6]:45212 "EHLO icts.hu"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753936AbbJZLdR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Oct 2015 07:33:17 -0400
Received: from [10.168.1.103] (91.82.3.223.pool.invitel.hu [91.82.3.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by icts.hu (Postfix) with ESMTPSA id 910F41D0A1F6
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2015 12:23:29 +0100 (CET)
To: linux-btrfs@vger.kernel.org
From: =?UTF-8?B?U3phbG1hIEzDoXN6bMOz?= <dblaci@dblaci.hu>
Subject: random i/o error without error in dmesg
Message-ID: <562E0D31.2080003@dblaci.hu>
Date: Mon, 26 Oct 2015 12:23:29 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have this error for a time, It's not easy to reproduce, i write 
everything i know at the moment.

I maintain some servers running xen (4.5.1) and gentoo dom0 with recent 
kernels (3.18.*, 4.1.6, 4.2.3, 4.2.4). I use gentoo-sources patchset.
Running xen domu s, for www and mysql.
I have mysql servers in domu with high load (lots of read write). These 
systems are identical in term of configuration and kernel.

Sometimes I got mysql errors randomly (sometimes more than one at a day, 
sometimes one at a week), but it is more frequent on high load.

The mysql errors are because the file cannot be read from the 
filesystem. If i try to run md5sum on it it shows io error.

At this point mysql stop && umount && mount && mysql start solves the 
problem.

calling
echo 3 > /proc/sys/vm/drop_caches
sometimes solves the io error, but not every time. The problem rarely 
randomly fixed without remount.

The problem seems to have no connection to the dom0 kernel and the xen 
version. I have this problem for example on these dom0 -s:

kernel: 3.19.3  xen 4.5.0
kernel: 4.2.3 xen 4.5.1

The problem seems to have started with the kernel 4.0 series, but I am 
not sure. In the summer the load was low, and the problem occured very 
rarely.

In this case of io error:
btrfs scrub finds no error.
no memory or hdd/ssd hardware error (smart, memtest, etc) (not only one 
physical server is affected) and no errors in dmesg at all.
tried different kernel configs, but I don't think I have anything 
extraordinary.
I use deadline scheduler.
I use these mount options:

/dev/xvdb1 on /mnt/mysql_naplo_b2 type btrfs 
(rw,noatime,compress=zlib,nossd,noacl,space_cache,subvolid=5,subvol=/)

I tried to reformat the filesystem with recent btrfs-progs: (and olders 
before)
btrfs-progs v4.2.2
I use default mkfs options (skinny extents)
After format the problem was disappeared for some days. (it seems 
correlation with the age of the filesystem?)
I do manual defragment on the filesystem with a script simply 
recursively check "filefrag" for count the fragmentation and defrag if 
it is more than 50 and the file is larger than 64kbyte. (this sometimes 
lowers the frequency of the problem)
The files unreadable are usually small files, for example:

filefrag:
/mnt/mysql_naplo_b2/mozanaplo_boly_altisk_2015/n_helyettesites.MYD: 2 
extents found
ls -l:
-rw-rw---- 1 mysql mysql 8092 okt   22 08.24 
/mnt/mysql_naplo_b2/mozanaplo_boly_altisk_2015/n_helyettesites.MYD

There is no error in dmesg, no io errors, no kernel panic, etc at all.

The (virtual) servers has 3-4GB of memory, and I use a 2GB tmpfs for the 
temporary tables (this way the physical memory usage is somewhat hectic).

The filesystem has no snapshots, but sometimes (for rebuilding 
replication) I take on, and delete it. (but the problem happens on 
filesystems with no snapshot created ever)

I did not try downgrading the kernel (for 3.18), but I always try to 
upgrade.

I guess this problem has some connection to the memory usage (but there 
is no out of memory).

I am able to try any debug mode if you suggest one, but it's not 
reproducable, it happens randomly. I think there should be some errors 
in the dmesg if I encounter io errors, but I am not sure if this error 
has direct connection for btrfs at all. I didn't try other filesystems. 
The problem was occured with kernel versions: 4.0.1, 4.0.4, 4.1.6, 
4.2.1, 4.2.3, 4.2.4.

I checked the bugzilla, and google for similar problem, but I couldn't 
find any similar.

This problem sometimes (i think it is the same) happen on a www server 
too, with apache log files (they are fragmented heavily), but very 
rarely. I don't have any problem with this configuration on other 
servers even mysql servers with lower load.

I welcome any suggestion:

László Szalma
