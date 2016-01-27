Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34417 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753616AbcA0IAX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jan 2016 03:00:23 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aOL1Y-0008Td-6c
	for linux-btrfs@vger.kernel.org; Wed, 27 Jan 2016 09:00:20 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jan 2016 09:00:20 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jan 2016 09:00:20 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: uknown issues - different sha256 hash - files corruption
Date: Wed, 27 Jan 2016 08:00:13 +0000 (UTC)
Message-ID: <pan$ab6fe$d4b3b2a5$57f2c41c$32fa0154@cox.net>
References: <CAAcrkYJRzvmwdVVYLJ_+LAob=tGQrW3=R7hDfbU_jE3kaD+Kxw@mail.gmail.com>
	<CAA7pwKNoYVUYT6QzGQxiz6jW9zEPvp6DjRxBPun6Z+SpDcuUjg@mail.gmail.com>
	<CAAcrkY+3w--OGYWwben+KYohdqwBBryDn8REJ6tiBk4jM3Tp9w@mail.gmail.com>
	<CAA7pwKP6KXHHkp4pALjbxqOFT2ve5T8r0RNcbmdVWXqLmveDgg@mail.gmail.com>
	<CAAcrkYJKoooUWOOsbqXot=U4voe+V_8iMf1NODbjUqMdn6g0Hg@mail.gmail.com>
	<CAPmG0jahDyaHhh1dZxS_L=0C27R_4GWtZeaGTrL50Gze4BRtKg@mail.gmail.com>
	<CAAcrkYKpSsC+H0BCM9pk=-S6VBF_qPKXMFswoGsVSUzRdTrKBg@mail.gmail.com>
	<CAA7pwKM+OZoF7v3Xq=J=KSpidsGsY4hi6TxxkSAKZAJRODCDSg@mail.gmail.com>
	<CAAcrkYJZnrFZKaEQQi6p48KHcGhkQh0LB_eC7xGAcNgFeLfTHA@mail.gmail.com>
	<pan$63dba$aa63be34$a52be773$95f4b6bc@cox.net>
	<CAAcrkYJPW74DYsa-2JES6u=6OuJknZxs2nvo5fc94JTPUyNnRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

John Smith posted on Tue, 26 Jan 2016 18:41:34 +0100 as excerpted:

> not sure if i have proper skill to do that LVM/ext4 test. I found this -
> https://www.phoronix.com/scan.php?page=news_item&px=Linux-4-EXT4-RAID-
Issue-Found
> 
> Maybe there is some connection?

I doubt it as you're doing lvm, not mdraid.  Plus that should be fixed on 
at least current kernels.

As for how to do the test, just sha256sum the devices themselves (/dev/
whatever, obviously as root, obviously in binary mode), instead of the 
files on top of the filesystem.  Make sure the filesystem either isn't 
mounted or is mounted read-only while taking the hash of its device, so 
the content doesn't change mid-hash or between runs.

The devices are obviously going to be quite large, terabyte scale I 
guess, compared to 100-200 GiB files, so it'll probably take some time to 
get a full hash.

First you'd want to hash the lvm logical volume device, the one that the 
filesystem is on.  Hash it two or three times and see if it's the same 
each time, or different.  If it's different, then you know that the 
problem is below that level.  If it's the same, then the problem is above 
that level, probably in ext4.

If the lvm logical volume hashes come out different, then try the same 
thing on the raw physical devices, /dev/sda or whatever, that make up the 
logical volume.  If the lvm logical device hashes come out different but 
the component physical device hashes come out the same, the problem's in 
the lvm level.  If the physical device hashes come out different also, 
then the problem is below lvm, in either the device drivers, or the 
hardware/firmware itself.

I don't run lvm here so I can't give you a specific example of that, and 
I have my physical devices partitioned, so the example below uses one of 
them, not the unpartitioned device (which I could do but some of the 
partitions are mounted so I don't want to try it), but here's what I just 
ran here, for a device partition that contains a filesystem I know isn't 
mounted at the moment.  Again, as root, thus the # prompt indicating root:

# sha256sum -b /dev/sda7
34169009f1dbdf93bd60e2f466b10c98323de695d5d10eb42cab7879b08a0adf
 */dev/sda7
# sha256sum -b /dev/sda7
34169009f1dbdf93bd60e2f466b10c98323de695d5d10eb42cab7879b08a0adf
 */dev/sda7
# 

As you can see, in my case, the two hashes came out the same.  I expected 
that of course, and would have been getting real worried right about now 
if they hadn't.

As it happens I have reasonably fast SSDs, and that partition was only 24 
GiB in size, so it didn't take a horribly long time.  Tho it still took 
some time.  I actually reran it with # time sha256sum ... to see exactly 
how long it took, and time said it took 2 minutes, 59.637 seconds, real 
wall time, 2:50 user time and 9.2 seconds system time, so basically 100% 
of one core doing the sha256 sum calculation the whole time, probably 
single-core CPU bound, not SSD thruput bound.  That's 8 GiB/min or about 
136 MiB/sec, thruput (yeah, definitely single-core CPU bound as the SSD's 
rated 600-ish MiB/sec, basically topping out the SATA3 600 bandwidth), on 
my amd fx6100 (6-core bulldozer1) CPU, slightly upclocked to 3.6 GHz.  
With a similar performing CPU, a 1 TB device should take about two hours 
to hash.

I guess it'll probably take rather longer on that cubox cpu, and that 
it'll be cpu-bound even on spinning rust, there.  You have the size of 
the files you tested, so if you have the time it took and the size of the 
devices, I guess you can do the math to figure out about how long the 
full device test is likely to take, but we're definitely looking at 
hours...

You could try sha1sum instead of sha256sum.  It should be faster, and 
we're just taking hashes here so cryptographic strength isn't an issue.  
An sha1 run on the same partition as above timed to 1 minute 51 seconds, 
real wall time, here, so much faster.

md5sum should be even faster, 1 minute 30 seconds on that partition, 
twice the speed of sha256sum, here.  Obviously it's no longer trusted for 
cryptographic checksums, but for quick corruptions checks, as here, it 
should be fine.  Depending on the cpu and speed of the devices, 
particularly on spinning rust md5sum may well bottleneck on the speed of 
the disks rather than the speed of the cpu.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

