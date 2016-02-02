Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpcmd02102.aruba.it ([62.149.158.102]:10100 "EHLO
	smtpcmd02102.aruba.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348AbcBBOXt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Feb 2016 09:23:49 -0500
To: linux-btrfs@vger.kernel.org
From: Marco Lorenzo Crociani <marcoc@prismatelecomtesting.com>
Subject: Wrong df Avail space on three disk RAID1 when empty
Message-ID: <56B0BA48.6070603@prismatelecomtesting.com>
Date: Tue, 2 Feb 2016 15:16:40 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
df on btrfs RAID1 fs on 3 disks  (they are RAID0 hardware, two disk, 
arrays but its not important right?) show wrong avail space when empty

# uname -a
Linux kvm4.prisma 4.4.0-2.el7.elrepo.x86_64 #1 SMP Tue Jan 26 13:06:01 
EST 2016 x86_64 x86_64 x86_64 GNU/Linux

# btrfs --version
btrfs-progs v4.4

#   btrfs fi show
Label: 'data'  uuid: 4421464d-479c-44c4-9f01-8df0f7d05bd2
         Total devices 3 FS bytes used 640.00KiB
         devid    1 size 7.28TiB used 2.00GiB path /dev/sdb
         devid    2 size 7.28TiB used 2.01GiB path /dev/sdc
         devid    3 size 7.28TiB used 2.01GiB path /dev/sdd

# btrfs fi df /data
Data, RAID1: total=1.00GiB, used=512.00KiB
System, RAID1: total=8.00MiB, used=16.00KiB
Metadata, RAID1: total=2.00GiB, used=112.00KiB
GlobalReserve, single: total=16.00MiB, used=0.00B


I expect to get from df -h some like
Filesystem            Size  Used Avail Use% Mounted on
/dev/sdb                       11T   17M    11T   1% /data
but I get:
Filesystem            Size  Used Avail Use% Mounted on
/dev/sdb                       11T   17M    7,3T   1% /data


If I fill the fs

# ls -laht
totale 11T
-rw-r--r--.  1 root root 921G  1 feb 16.17 prova10
drwxr-xr-x.  1 root root  134  1 feb 15.23 .
-rw-r--r--.  1 root root 1,0T  1 feb 14.00 prova9
-rw-r--r--.  1 root root 1,0T  1 feb 13.07 prova8
-rw-r--r--.  1 root root 1,0T  1 feb 12.20 prova7
-rw-r--r--.  1 root root 1,0T 28 gen 21.50 prova6
-rw-r--r--.  1 root root 1,0T 28 gen 21.08 prova5
-rw-r--r--.  1 root root 1,0T 28 gen 20.28 prova4
-rw-r--r--.  1 root root 1,0T 28 gen 19.50 prova3
-rw-r--r--.  1 root root 1,0T 28 gen 19.13 prova2
-rw-r--r--.  1 root root 1,0T 28 gen 18.37 prova1
-rw-r--r--.  1 root root 1,0T 28 gen 18.02 prova0
dr-xr-xr-x. 18 root root 4,0K 28 gen 15.30 ..

I get:

Filesystem            Size  Used Avail Use% Mounted on
/dev/sdb                       11T   11T    256K 100% /data

# btrfs fi df /data/
Data, RAID1: total=10.90TiB, used=10.90TiB
System, RAID1: total=8.00MiB, used=1.50MiB
Metadata, RAID1: total=13.00GiB, used=11.24GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

-- 
Marco Crociani
Prisma Telecom Testing S.r.l.
via Petrocchi, 4  20127 MILANO  ITALY
Phone:  +39 02 26113507
Fax:  +39 02 26113597
e-mail:  marcoc@prismatelecomtesting.com
web:  http://www.prismatelecomtesting.com

