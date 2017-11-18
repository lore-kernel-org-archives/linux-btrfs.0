Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-eopbgr40069.outbound.protection.outlook.com ([40.107.4.69]:46352
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1760764AbdKRTL5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 18 Nov 2017 14:11:57 -0500
Subject: Re: 4.14 balance: kernel BUG at
 /home/kernel/COD/linux/fs/btrfs/ctree.c:1856!
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
To: Roman Mamedov <rm@romanrm.net>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <e01cb2f95b44b7648855a4fe5070fd10@wpkg.org>
 <5000f429-8b4b-b4ea-5e38-89f7c91af6f3@mendix.com>
 <20171118144037.0fa8ad4b@natsu>
 <2cbd136b-4fa7-fcee-7472-0941efa97047@mendix.com>
Message-ID: <60361a2c-e479-1aea-cfdc-5807d1fd962d@mendix.com>
Date: Sat, 18 Nov 2017 20:11:48 +0100
MIME-Version: 1.0
In-Reply-To: <2cbd136b-4fa7-fcee-7472-0941efa97047@mendix.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/18/2017 12:48 PM, Hans van Kranenburg wrote:
> 
> So, who wants to help?
> 
> 1. Find a test system that you can crash.
> 2. Create a test filesystem with some data.
> 3. Run with 4.14? (makes the most sense I think)
> 4. Continuously feed the data to balance and send everything to /dev/null
> 5. Collect stack traces and borken filesystem images.

I moved it to a ramdisk:

-# modprobe brd rd_nr=1 rd_size=4194304
-# mkfs.btrfs -m single -d single /dev/ram0
-# mount -o noatime /dev/ram0 /btrfs
-# cd /btrfs
-# btrfs sub create moo
-# rsync -av /usr/ moo/
-# btrfs sub snap -r moo/ moo-ro

Now remove part of the files, yolo style
-# rm $(find moo -type f | shuf | head -n 5000)
Put them back, so we have some differences for incremental send
-# rsync -av /usr/ moo/
-# btrfs sub snap -r moo/ moo-ro2

Now again:

-# while true; do btrfs balance start --full-balance /btrfs; done
and
-# while true; do btrfs send --no-data /btrfs/moo-ro/ | wc -c;
   btrfs send --no-data -p /btrfs/moo-ro/ /btrfs/moo-ro4/ |wc -c;
   date; done

Now I got rid of the disk traffic, and kernel cpu time goes to >300%.

The error seen before is easily triggered. It happens both on normal and
on incremental send. It happens both when using --no-data and when not
using that option. send aborts with "ERROR: send ioctl failed with -5:
Input/output error", and dmesg shows:

[...]
[17094.578876] BTRFS error (device ram0): did not find backref in
send_root. inode=28151, offset=0, disk_byte=8769369178112 found
extent=8769369178112
[17328.368458] BTRFS error (device ram0): did not find backref in
send_root. inode=23264, offset=0, disk_byte=8902861979648 found
extent=8902861979648
[17352.779099] BTRFS error (device ram0): did not find backref in
send_root. inode=17392, offset=0, disk_byte=8917230010368 found
extent=8917230010368
[18012.009357] BTRFS error (device ram0): did not find backref in
send_root. inode=29245, offset=0, disk_byte=9295300538368 found
extent=9295300538368
[18193.218649] BTRFS error (device ram0): did not find backref in
send_root. inode=16437, offset=0, disk_byte=9400309366784 found
extent=9400309366784
[18604.697898] BTRFS error (device ram0): did not find backref in
send_root. inode=24508, offset=0, disk_byte=9635165790208 found
extent=9635165790208
[18621.053722] BTRFS error (device ram0): did not find backref in
send_root. inode=10039, offset=0, disk_byte=9644150468608 found
extent=9644150468608
[19039.051399] BTRFS error (device ram0): did not find backref in
send_root. inode=29411, offset=0, disk_byte=9883807432704 found
extent=9883807432704
[19373.297701] BTRFS error (device ram0): did not find backref in
send_root. inode=7946, offset=0, disk_byte=10074868215808 found
extent=10074868215808
[19573.432255] BTRFS error (device ram0): did not find backref in
send_root. inode=26743, offset=0, disk_byte=10190374899712 found
extent=10190374899712
[19682.305240] BTRFS error (device ram0): did not find backref in
send_root. inode=24823, offset=0, disk_byte=10252750929920 found
extent=10252750929920
[20012.420346] BTRFS error (device ram0): did not find backref in
send_root. inode=25763, offset=0, disk_byte=10441684029440 found
extent=10441684029440
[20430.100411] BTRFS error (device ram0): did not find backref in
send_root. inode=14572, offset=0, disk_byte=10680836050944 found
extent=10680836050944
[21328.821766] BTRFS error (device ram0): did not find backref in
send_root. inode=11756, offset=0, disk_byte=11195322470400 found
extent=11195322470400
[...]

After a few hours I have a long list of those, but that's all so far. No
other big explosions.

So, if anyone has an idea of what to try next? Maybe it needs more than
1 block group each for data and metadata? Maybe speeding it up (with a
small amount of data and the ramdisk) does not increase the chance of
triggering something, but just decreases it?

Welcome to the world of trying to reproduce errors... :D

-- 
Hans van Kranenburg
