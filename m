Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:43292 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753178AbaECXQ3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 3 May 2014 19:16:29 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Help with space
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <4C789231-1BA0-4415-B557-E87A32CCEBFC@colorremedies.com>
Date: Sat, 3 May 2014 17:16:28 -0600
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-Id: <016C5B70-C1A6-4526-9994-75DB0D56DCAB@colorremedies.com>
References: <CAAmRLYx1L=o7a2PMSAiJbr7qH_JiuYG2-ncHG-mHLyLcM3Z-GQ@mail.gmail.com> <2809235.lZD2oazSeA@xev> <pan$e723c$9c5c686c$f2068dd4$dd71b519@cox.net> <201405021148.07577.russell@coker.com.au> <pan$b29aa$ed2c5b17$e83ea42c$5e85b880@cox.net> <286235B8-24FE-4935-AC13-DB98F1358E32@colorremedies.com> <536519E2.6070807@gmail.com> <4C789231-1BA0-4415-B557-E87A32CCEBFC@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 3, 2014, at 1:09 PM, Chris Murphy <lists@colorremedies.com> wrote:

> 
> On May 3, 2014, at 10:31 AM, Austin S Hemmelgarn <ahferroin7@gmail.com> wrote:
> 
>> On 05/02/2014 03:21 PM, Chris Murphy wrote:
>>> 
>>> Btrfs raid1 with 3+ devices is unique as far as I can tell. It is
>>> something like raid1 (2 copies) + linear/concat. But that
>>> allocation is round robin. I don't read code but based on how a 3
>>> disk raid1 volume grows VDI files as it's filled it looks like 1GB
>>> chunks are copied like this
>> Actually, MD RAID10 can be configured to work almost the same with an
>> odd number of disks, except it uses (much) smaller chunks, and it does
>> more intelligent striping of reads.
> 
> The efficiency of storage depends on the file system placed on top. Btrfs will allocate space exclusively for metadata, and it's possible much of that space either won't or can't be used. So ext4 or XFS on md probably is more efficient in that regard; but then Btrfs also has compression options so this clouds the efficiency analysis.
> 
> For striping of reads, there is a note in man 4 md about the layout with respect to raid10: "The 'far' arrangement can give sequential read performance equal to that of a RAID0 array, but at the cost of reduced write performance." The default layout for raid10 is near 2. I think either the read performance is a wash with defaults, and md reads are better while writes are worse with the far layout.
> 
> I'm not sure how Btrfs performs reads with multiple devices.


Also, for unequal sized devices, for example 12G,6G,6G, Btrfs raid1 is OK with this and efficiently uses the space, whereas md does not in raid10. First it complains when creating, asking if I want to continue anyway, and then it 



Second it ends up with *less* usable space than if it had 3x 6GB drives.

12G,6G,6G md raid10
# mdadm -C /dev/md0 -n 3 -l raid10 --assume-clean /dev/sd[bcd]
mdadm: largest drive (/dev/sdb) exceeds size (6283264K) by more than 1%.
# mdadm -D /dev/md0 (partial)
     Array Size : 9424896 (8.99 GiB 9.65 GB)
  Used Dev Size : 6283264 (5.99 GiB 6.43 GB)

# df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/md0        9.0G   33M  9.0G   1% /mnt

12G,6G,6G btrfs raid1

# mkfs.btrfs -d raid1 -m raid1 /dev/sd[bcd]
# df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdb         24G  1.3M   12G   1% /mnt


For performance workloads, this is probably a pathological configuration since it depends on disproportionate reading almost no matter what. But for those who happen to have uneven devices available, and favor space usage efficiency over performance, it's a nice capability.


Chris Murphy