Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40120 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101Ab2LDTuD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Dec 2012 14:50:03 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1TfyVJ-00035T-6M
	for linux-btrfs@vger.kernel.org; Tue, 04 Dec 2012 20:50:10 +0100
Received: from 216.77.154.39 ([216.77.154.39])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Dec 2012 20:50:05 +0100
Received: from thorn.roby by 216.77.154.39 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Dec 2012 20:50:05 +0100
To: linux-btrfs@vger.kernel.org
From: Thorn Roby <thorn.roby@harlandfs.com>
Subject: Mounted compress-force=zlib, compresses when files copied in, but not when written directly by application
Date: Tue, 4 Dec 2012 19:44:16 +0000 (UTC)
Message-ID: <loom.20121204T201625-335@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am trying to use a btrfs filesystem (Oracle Linux 6.3 X86_64, UEK kernel)  
with data RAID0 and metadata RAID1, mounted as follows:

/dev/sda3 on /data type btrfs (rw,noatime,compress-force=zlib,noacl)

dmesg shows 

btrfs: force zlib compression
btrfs: disk space caching is enabled

My application is MongoDB, which creates a series of 2GB datafiles, possibly 
using sparse allocation (at least I know it does on XFS), which reports the 
following for each datafile:

Tue Dec  4 12:05:26.538 [FileAllocator] allocating new datafile 
/data/db/lfs/lfs.19, filling with zeroes...
Tue Dec  4 12:05:26.544 [FileAllocator] done allocating datafile 
/data/db/lfs/lfs.19, size: 2047MB,  took 0.006 secs

If I create a new filesystem and mount it with compress-force=zlib, then rsync a 
number of these 2GB files containing MongoDB data from another system, I get 
roughly 4:1 compression. I also notices that CPU usage remains at 100% and the 
rsync speed is roughly 70% of network speed. If I do the same thing using LZO, I 
see low CPU usage, transmission speed is 100% of network speed and compression 
is about 2:1. These results are what I expect.

However, if I run the mongodb process directly on the machine, using compress-
force=zlib (haven't tried LZO yet) with the same mount options, and load data 
into the database from another system via database inserts, there is no evidence 
of compression. This is consistently verified by the output of df, btrfs fi df 
and an internal report from the database which shows row count and average row 
size (560 bytes). I also see low CPU usage (however this is not conclusive since 
the file write rate from the database process is roughly 10 times slower than a 
direct write using rsync). 

[root@eng-mongodb-t1 lfs]# btrfs fi df /data
Data, RAID0: total=37.95GB, used=33.84GB
Data: total=8.00MB, used=0.00
System, RAID1: total=8.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=1.00GB, used=45.35MB
Metadata: total=8.00MB, used=0.00

[root@eng-mongodb-t1 lfs]# df -h
/dev/sda3              40G   34G  4.2G  90% /data

I tried chattr -c on the database directory but it doesn't appear to be 
supported in Oracle Linux (nor was it necessary in the case where I rsyncd the 
files and saw the expected compression).
Filesystem type is: 9123683e
File size of lfs.18 is 2146435072 (524032 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0  9182208               2 
   1       2  9706240  9182209      1 
   2       3  9182211  9706240  14348 
   3   14351  9706241  9196558      1 
   4   14352  9196560  9706241  28126 
   5   42478  9224686          481554 eof
lfs.18: 5 extents found


Is there something about the (possible) initial sparse allocation followed by 
zero-filling that might be disabling compression as the datafile is later 
overwritten by the database process, despite the compress-force flag?

filefrag -v shows this, but I'm still not sure how to interpret it:

Filesystem type is: 9123683e
File size of lfs.18 is 2146435072 (524032 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0  9182208               2 
   1       2  9706240  9182209      1 
   2       3  9182211  9706240  14348 
   3   14351  9706241  9196558      1 
   4   14352  9196560  9706241  28126 
   5   42478  9224686          481554 eof
lfs.18: 5 extents found









