Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:35795 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbaLFJRs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 6 Dec 2014 04:17:48 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Sat, 06 Dec 2014 10:17:45 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, chris@colorremedies.com
Subject: Re: btrfs device delete missing - Input/output error
In-Reply-To: <CAJCQCtSGy5MBVC4hQUgHBtSy+6kNOap_0Mfb7f9G4HJH9AmtUQ@mail.gmail.com>
References: <3146bf116f41e590e8ce4fdb610def31@admin.virtall.com>
 <CAJCQCtRh7HU9yd-pxgXzXebVcjukQh6Lyhzfcd6bBJppyCxChQ@mail.gmail.com>
 <88e897a70d1ac64a5b6b2c4b2e9e49d5@admin.virtall.com>
 <CAJCQCtSGy5MBVC4hQUgHBtSy+6kNOap_0Mfb7f9G4HJH9AmtUQ@mail.gmail.com>
Message-ID: <1225b43cd030194ef1ee3db419aa7a5e@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-12-06 05:57, Chris Murphy wrote:

>> Right - so we're getting these:
>> 
>> # parted /dev/sdb u s p
>> Model: ATA ST3000DM001-9YN1 (scsi)
>> Disk /dev/sdb: 5860533168s
>> Sector size (logical/physical): 512B/4096B
> 
> OK it's a 4096 byte physical sector drive so you have to use the
> bs=4096 command with the proper seek value (which is based on the bs
> value).

Yep.
So here is what I did:

# echo 2262535088 / 8|bc    # (512 * 8 = 4096)
282816886


* verify if it's this place

# dd if=/dev/sdb of=/dev/null bs=4096 count=1 skip=282816886
dd: reading `/dev/sdb': Input/output error
0+0 records in
0+0 records out
0 bytes (0 B) copied, 2.83002 s, 0.0 kB/s


* overwrite it:

dd if=/dev/zero of=/dev/sdb bs=4096 count=1 seek=282816886
1+0 records in
1+0 records out
4096 bytes (4.1 kB) copied, 3.0277e-05 s, 135 MB/s


* try to read it:

# dd if=/dev/sdb of=/dev/null bs=4096 count=1 skip=282816886
1+0 records in
1+0 records out
4096 bytes (4.1 kB) copied, 2.6204e-05 s, 156 MB/s


* try to read with the old skip value (repeat for 2262535088 - 
2262535095, or use a different count value - this is where we were 
getting the errors, it's also 8 * 512):

dd if=/dev/sdb of=/dev/null count=1 skip=2262535088
...
dd if=/dev/sdb of=/dev/null count=1 skip=2262535095


* Unfortunately this is still an error for btrfs, because the checksum 
does not match:

# time btrfs device delete missing /home
ERROR: error removing the device 'missing' - Input/output error

# dmesg -c
[84200.109774] BTRFS info (device sda4): relocating block group 
1375492636672 flags 17
[84203.635559] BTRFS info (device sda4): csum failed ino 261 off 
384262144 csum 2566472073 expected csum 4193010590
[84203.650980] BTRFS info (device sda4): csum failed ino 261 off 
384262144 csum 2566472073 expected csum 4193010590
[84203.651444] BTRFS info (device sda4): csum failed ino 261 off 
384262144 csum 2566472073 expected csum 4193010590


* remounting with nodatacow (nodatasum) does not help (since it's for 
new data)

* let's find the inode printing the error - turned out to be a directory 
- so created a new one, moved the data from the "corrupt one", removed 
the directory with that inode:

# find /home -mount -inum 261
/home/backup/ma-int/weekly


* repeat for any other found:

# dmesg -c
[85197.300494] BTRFS info (device sda4): relocating block group 
1375492636672 flags 17
[85200.448713] BTRFS info (device sda4): csum failed ino 267 off 
384262144 csum 2566472073 expected csum 4193010590
[85200.472581] BTRFS info (device sda4): csum failed ino 267 off 
384262144 csum 2566472073 expected csum 4193010590
[85200.473551] BTRFS info (device sda4): csum failed ino 267 off 
384262144 csum 2566472073 expected csum 4193010590


* unfortunately it never ends - let's say we have 
/home/backup/ma-int/weekly, which we "fixed" with:

mkdir /home/backup/ma-int/weekly.tmp
mv /home/backup/ma-int/weekly/* /home/backup/ma-int/weekly.tmp
rmdir /home/backup/ma-int/weekly

After we run again btrfs device delete missing /home, the newly created 
directory eventually (/home/backup/ma-int/weekly.tmp) is being detected 
as "csum failed ino ...".


-- 
Tomasz Chmielewski
http://www.sslrack.com

