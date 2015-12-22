Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:36058 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932293AbbLVTMU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Dec 2015 14:12:20 -0500
Received: by mail-ob0-f176.google.com with SMTP id ba1so59218252obb.3
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Dec 2015 11:12:20 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 22 Dec 2015 12:12:19 -0700
Message-ID: <CAD=LdFREn-jTEXTHw_Q+zbnva3dSWtb_aKcYS+6paidBjH7U8A@mail.gmail.com>
Subject: Loss of connection to Half of the drives
From: Dave S <bigdave.schulz@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Everyone,

I've been testing btrfs and have been simulating typical real world
failure scenarios and have encountered one that I am having trouble
recovering from without resorting to btrfs restore.

If anyone has any advice it'd be much appreciated.  Thanks.

Some background:

I have 2 separate disk drawers (on 2 different SAS controllers) and
I'm using 10 disks on each drawer in a 20 disk btrfs raid10
configuration -- metadata is the default.

The scenario that I'm testing is to start a heavy write to the
filesystem then pull one of the SAS cables so that half of the disks
suddenly disappear from the system.  Let's face it.  This is something
that can happen in a real system.  One power supply shorts out and
trips the breaker... Power fails on the non-UPS powersupply and the
UPS powersupply fails when it suddenly has to handle the entire
load... etc.

I suppose what I would expect to happen is that the filesystem would
lock up to prevent metadata problems like split-brain.  Granted,
writes could continue writing to segments on unaffected disks.
Wouldn't the generation numbers allow btrfs to sort out which is old
and which is new at mount time resolving with a simple balance
operation?

When I try to mount, it gives the following:
# mount LABEL=scratch2 /scratch2
mount: wrong fs type, bad option, bad superblock on /dev/sdal,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.

When I try a btrfs rescue super-recover, I get the baffling fsid
mismatch and a segfault:
# ./btrfs rescue super-recover /dev/sdc
Make sure this is a btrfs disk otherwise the tool will destroy other
fs, Are you sure? [y/N]: y
parent transid verify failed on 20971520 wanted 8 found 4
parent transid verify failed on 20971520 wanted 8 found 4
parent transid verify failed on 20971520 wanted 8 found 4
parent transid verify failed on 20971520 wanted 8 found 4
Ignoring transid failure
fsid mismatch, want=bff1bc57-d5aa-48f0-ae2d-6c130b49e87b,
have=1a5d52ef-882f-4f33-8463-4d8647878626
Couldn't read tree root
Failed to recover bad superblocks
Segmentation fault


I get the above with both the CentOS7 RPM installed btrfs-tools and
the devel version I compiled (mkfs was done with version 3.19.1):

Installed:3.19.1
Devel: 4.3.1

# ./btrfs rescue super-recover /dev/sdc
Make sure this is a btrfs disk otherwise the tool will destroy other
fs, Are you sure? [y/N]: y
parent transid verify failed on 20971520 wanted 8 found 4
parent transid verify failed on 20971520 wanted 8 found 4
parent transid verify failed on 20971520 wanted 8 found 4
parent transid verify failed on 20971520 wanted 8 found 4
Ignoring transid failure
fsid mismatch, want=bff1bc57-d5aa-48f0-ae2d-6c130b49e87b,
have=1a5d52ef-882f-4f33-8463-4d8647878626
Couldn't read tree root
Failed to recover bad superblocks
Segmentation fault

To ensure it wasn't picking up a fsid from an old test I dd'd out the
3 superblock locations on each disk and re-ran the test.  Same
results.

One curiosity is that the write that is happening when I pull the SAS
cable continues uninterrupted -- I have left it for a few minutes and
it doesn't seem to stop.  At this point, I stop the write, unmount the
FS, poweroff the host, reconnect the cable, and boot back up.  Now I
can't mount the FS.

I've tried this a few times with different "repair" commands.  None
seem to clear up the metadata disagreement.  I've tried various
combinations of:
btrfs check
btrfs-zero-log
btrfs rescue chunk-reciver <- finishes successfully but still can't mount
btrfs rescue super-recover < - see above


The info requested from the wiki page (Note that the drives removed by
the SAS cable pull are the /dev/sda? ones):

# uname -a
Linux ceph2 3.10.0-229.el7.x86_64 #1 SMP Fri Mar 6 11:36:42 UTC 2015
x86_64 x86_64 x86_64 GNU/Linux

# btrfs fi show
Label: 'scratch2'  uuid: bff1bc57-d5aa-48f0-ae2d-6c130b49e87b
Total devices 20 FS bytes used 30.78GiB
devid    1 size 931.51GiB used 5.02GiB path /dev/sdc
devid    2 size 931.51GiB used 5.00GiB path /dev/sdd
devid    3 size 931.51GiB used 5.00GiB path /dev/sde
devid    4 size 931.51GiB used 5.00GiB path /dev/sdf
devid    5 size 931.51GiB used 5.00GiB path /dev/sdg
devid    6 size 931.51GiB used 5.00GiB path /dev/sdh
devid    7 size 931.51GiB used 5.00GiB path /dev/sdi
devid    8 size 931.51GiB used 5.00GiB path /dev/sdj
devid    9 size 931.51GiB used 5.00GiB path /dev/sdk
devid   10 size 931.51GiB used 5.00GiB path /dev/sdl
devid   11 size 931.51GiB used 3.00GiB path /dev/sdag
devid   12 size 931.51GiB used 3.00GiB path /dev/sdah
devid   13 size 931.51GiB used 3.00GiB path /dev/sdai
devid   14 size 931.51GiB used 3.00GiB path /dev/sdaj
devid   15 size 931.51GiB used 3.00GiB path /dev/sdak
devid   16 size 931.51GiB used 3.00GiB path /dev/sdal
devid   17 size 931.51GiB used 4.00GiB path /dev/sdam
devid   18 size 931.51GiB used 4.00GiB path /dev/sdan
devid   19 size 931.51GiB used 3.01GiB path /dev/sdao
devid   20 size 931.51GiB used 3.01GiB path /dev/sdap

btrfs-progs v3.19.1

# dmesg|grep -i btrfs
[   15.938327] Btrfs loaded
[   15.938826] BTRFS: device label scratch2 devid 15 transid 7 /dev/sdak
[   15.939138] BTRFS: device label scratch2 devid 14 transid 7 /dev/sdaj
[   15.939163] BTRFS: device label scratch2 devid 11 transid 7 /dev/sdag
[   15.939960] BTRFS: device label scratch2 devid 19 transid 7 /dev/sdao
[   15.940056] BTRFS: device label scratch2 devid 18 transid 7 /dev/sdan
[   15.941805] BTRFS: device label scratch2 devid 4 transid 9 /dev/sdf
[   15.944312] BTRFS: device label scratch2 devid 10 transid 9 /dev/sdl
[   15.952288] BTRFS: device label scratch2 devid 7 transid 9 /dev/sdi
[   15.962451] BTRFS: device label scratch2 devid 2 transid 9 /dev/sdd
[   15.962995] BTRFS: device label scratch2 devid 3 transid 9 /dev/sde
[   15.963431] BTRFS: device label scratch2 devid 13 transid 7 /dev/sdai
[   15.974559] BTRFS: device label scratch2 devid 5 transid 9 /dev/sdg
[   15.979969] BTRFS: device label scratch2 devid 16 transid 7 /dev/sdal
[   15.981962] BTRFS: device label scratch2 devid 8 transid 9 /dev/sdj
[   15.988912] BTRFS: device label scratch2 devid 1 transid 9 /dev/sdc
[   15.998077] BTRFS: device label scratch2 devid 20 transid 7 /dev/sdap
[   16.001058] BTRFS: device label scratch2 devid 12 transid 7 /dev/sdah
[   16.008946] BTRFS: device label scratch2 devid 9 transid 9 /dev/sdk
[   16.010560] BTRFS: device label scratch2 devid 17 transid 7 /dev/sdam
[   16.011840] BTRFS: device label scratch2 devid 6 transid 9 /dev/sdh
[  120.971556] BTRFS info (device sdh): disk space caching is enabled
[  120.971560] BTRFS: has skinny extents
[  120.974091] BTRFS: failed to read chunk root on sdh
[  120.982591] BTRFS: open_ctree failed
[  142.749246] btrfs[2551]: segfault at 100108 ip 000000000044c503 sp
00007fff8f261290 error 6 in btrfs[400000+83000]
[  190.570074] btrfs[2614]: segfault at 100108 ip 000000000044c503 sp
00007fff8f11aef0 error 6 in btrfs[400000+83000]
[  215.734281] btrfs[2656]: segfault at 100108 ip 000000000044f5a3 sp
00007fff4cfd23e0 error 6 in btrfs[400000+88000]
[ 2545.896233] btrfs[4576]: segfault at 100108 ip 000000000044c503 sp
00007ffffc919400 error 6 in btrfs[400000+83000]
[ 3000.106228] BTRFS info (device sdh): disk space caching is enabled
[ 3000.106233] BTRFS: has skinny extents
[ 3000.148162] BTRFS: failed to read chunk root on sdh
[ 3000.168649] BTRFS: open_ctree failed
[ 3071.430479] btrfs[4701]: segfault at 100108 ip 000000000046e06a sp
00007fff44539688 error 6 in btrfs[400000+c7000]
[ 3147.025032] btrfs[4755]: segfault at 100108 ip 000000000044c503 sp
00007fffa79bbf40 error 6 in btrfs[400000+83000]


Sincerely
-Dave
