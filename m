Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from m.nv-systems.net ([176.9.99.115]:43183 "EHLO m.nv-systems.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbbBVW3W (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Feb 2015 17:29:22 -0500
Received: from [192.168.7.22] (p5DCBE468.dip0.t-ipconnect.de [93.203.228.104])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by m.nv-systems.net (Postfix) with ESMTPSA id BAED61980ACD
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Feb 2015 23:20:50 +0100 (CET)
Message-ID: <54EA5648.9030908@nv-systems.net>
Date: Sun, 22 Feb 2015 23:20:56 +0100
From: Gerald Hopf <gerald.hopf@nv-systems.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: RAID5 issues - 1) slow write speed 2) slow scrub (using kernel 3.19)
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

now that RAID5 support is coming along nicely with Kernel 3.19 I decided 
it's time to switch from XFS to btrfs for my storage server. And yes, I 
do have backups.

I'm using 5x WD 4TB RED Drives connected to the Intel SATA Controller 
(Intel H87 Chipset). I'm running Kernel 3.19 and created the btrfs using 
btrfs-progs v3.19-rc2. The 5 disks are not used directly, I have 5x 
dm-crypt in between the disk and btrfs. Also, my CPU does of course have 
AES-NI capability so that this should not be a bottleneck.
After creating the btrfs filesystem, it has been filled sequentially 
with data using rsync from the backup (about 12TB), and most of those 
12TB is occupied by files that are pretty large (3-25GB). I have run 
"btrfs fi defrag /mountpoint/" and "btrfs fi bal start -dusage=10 
-musage=10 -v /mountpoint/".

I'm mostly happy! There are two minor issues and two bigger issues though:

Minor issue 1: df -h
####################
reports 5x 4TB = 19TB as total space even though one of the 5 disks is 
for parity and it should therefore be 4x 4TB (I'm not using compression 
of course). I know df -h doesn't show the correct value in btrfs, but it 
would be nice if it at least tried to show a value that COULD 
theoretically be correct by accounting for the parity drive.

Minor issue 2: btrfs fi usage
#############################
complains about "WARNING: RAID56 detected, not implemented" 3x and 
doesn't show what it is supposed to show.

Bigger issue 1: SLOW btrfs write speed
######################################
Creating a 100GB file using "dd if=/dev/zero of=/mountpoint/test.file 
bs=1M count=100000", the average speed I get is about 100MB/s.
While the file is written, "top" shows high "wa = waiting for I/O" 
numbers between 20% and 90%.
What I find even more astounding is that in "atop" I can see that while 
the individual drives are being written to at about ~25MB/s they are 
also being read from at >8MB/s. This simultaneous reading of at least 
one third the amount that is written to the disk is surprising to me and 
I would guess this is what is limiting my RAID5 write speeds by causing 
the disks to perform lots of questionable head movements across the platter!

I really fail to see why creating a 100GB file containing zeroes should 
make btrfs read more than 30GB data from the disks.
By the way: Read speeds are totally fine. About 380MB/s from the very 
same file that was so slow to create.

Bigger issue 2: SLOW btrfs scrub
################################
Scrub is really slow. With iotop or atop I can see that btrfs scrub uses 
about 15-30MB/s for each disk.
I was told to run "iostat -dkxz 1". One of the disks "sdc" has usually 
higher values in the "await" field, but not always. The other drives 
have high values there too, just not as often. I'm pretty sure that the 
disk sdc is not in any way "slower" or "defective" so I guess for some 
reason the scrub reads more from this disk? Side note: absolutely 
nothing else is accessing those disks, btrfs scrub can use 100% of their 
I/O capabilities.

In iostat, apart from the high "await" field, what seems interesting to 
me is "avgrq-sz", which shows (for all 5 disks) values between 100 and 
200. This field is described as "average size (in sectors) of the 
requests that were issued to the device". I guess my sector size is 
512b, so the average request to the drive is only 50-100KB. Even if the 
sector size were 4K, the average request size would still be 
ridiculously small.

At best the combined read speed while scrubbing is 100MB/s. It probably 
is less than this on average.
With mdraid 5 I was doing weekly checks (echo check > 
/sys/block/mdXXX/md/sync_action), and from the logs I know that it took 
(always!) 10.5 hours to check those very same 5x4TB disks. This averages 
at a read speed of 529MB/s (including parity disk) or 423MB/s (excluding 
parity).

Btrfs scrub on my raid 5 is therefor at least five times slower 
(probably a bit more) than the old mdraid check, making weekly scrubs 
impossible.

My guess is that for whatever reason those small reads during scrub are 
not at all linear, thereby causing significantly degraded performance on 
a disk that has limited IOPS (everything that is not a SSD).

Summary
#######
It would be nice if over time the (somewhat) new btrfs raid5 code could 
be optimized more. Currently it seems either nobody is really using 
RAID5 or nobody is using it on something other than SSDs.

Thanks for listening,
Gerald

PS: I'm not complaining! I knew what I was getting into when creating a 
btrfs RAID 5 at this point in time and I can (for now) live with the 
limitations described above. But I think feedback on what works and what 
doesn't work as it should is probably a good idea. And maybe, just maybe 
then those things will get fixed or improved over time.

