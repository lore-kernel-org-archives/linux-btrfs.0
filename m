Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from crane.lixil.net ([71.19.157.101]:49113 "EHLO crane.lixil.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755312Ab3HXAMx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Aug 2013 20:12:53 -0400
Received: from webmail.lixil.net (crane.lixil.net [71.19.157.101])
	(Authenticated sender: mrjoel@lixil.net)
	by crane.lixil.net (Postfix) with ESMTPSA id 0978A142CA7
	for <linux-btrfs@vger.kernel.org>; Sat, 24 Aug 2013 00:05:53 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Fri, 23 Aug 2013 18:05:52 -0600
From: Joel Johnson <mrjoel@lixil.net>
To: linux-btrfs@vger.kernel.org
Subject: Help interpreting RAID1 space allocation
Message-ID: <25d36b2410416c9a767766fb9be313b6@lixil.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've created a test volume and copied a bulk of data to it, however the 
results of the space allocation are confusing at best. I've tried to 
capture the history of events leading up to the current state. This is 
all on a Debian Wheezy system using a 3.10.5 kernel package 
(linux-image-3.10-2-amd64) and btrfs tools v0.20-rc1 (Debian package 
0.19+20130315-5). The host uses an Intel Atom 330 processor, and runs 
the 64-bit kernel with a 32-bit userland.

I initially created the volume as RAID1 data, then removed (hotplugged 
out from under the system) one of the drives while empty as a test. I 
then unmounted and remounted it with the degraded option and copied a 
small amount of data. Once verifying that the space was used, I 
hotplugged the second original drive, which was detected and added back 
to the volume (showing up in a filesystem show instead of missing). I 
then tried to copy over more data than a RAID1 should be expected to 
hold (~650GB onto 2 x 500GB disks in RAID1), got out of space reported 
as expected. I then deleted all data from the volume (did not recreate 
the filesystem), and copied just over 300GB of data onto the volume, 
which is the current state.

Only as I was typing this up did I notice that the mount options still 
show degraded from the original mount. I expected that once the second 
drive was readded, since it showed up as part of the volume 
automatically (I assume because the UUIDs matched?), however since all 
data appears to have been written to the first drive, I am led to 
believe that the second drive was present but not readded, even though 
it reappeared as devid 2 in the listing.

If the above is correct, then I have two questions that I haven't found 
any documentation on:

1. What is the expectation on hot-adding a failed drive, is an explicit 
'device add' or 'replace' expected/required? In my case it appeared to 
be auto-added, but that may have been spurious or misleading. I'd 
consider that if an explicit readd is required, that the device not be 
listed at all, however I would be much more interested to see hotplug of 
a previously missing device (with older modifications from the same 
volume) be readded and synced automatically.

2. If initially mounted as degraded, once a new drive is added, is a 
remount required? I'd hope not, but since the mount flag can't be 
changed later on, what is the best way to confirm health of the volume? 
Until this issue I'd assumed using 'filesystem show'. Since the mount 
flag is at mount time only, degraded seems to mean "be degraded if 
needed" instead of a positive indicator that the volume is indeed 
degraded"



$ mount | grep btrfs
/dev/sdc on /mnt/new-store type btrfs (rw,relatime,degraded,space_cache)

$ du -hsx /mnt/new-store
305G    /mnt/new-store

$ df -h | grep new-store
/dev/sdc                         932G  307G  160G  66% /mnt/new-store

$ btrfs fi show /dev/sdc
Label: 'new-store'  uuid: 14e6e9c7-b249-40ff-8be1-78fc8b26b53d
Total devices 2 FS bytes used 540.00KB
devid    2 size 465.76GB used 2.01GB path /dev/sdd
devid    1 size 465.76GB used 453.03GB path /dev/sdc

$ btrfs fi df /mnt/new-store
Data, RAID1: total=1.00GB, used=997.21MB
Data: total=450.01GB, used=303.18GB
System, RAID1: total=8.00MB, used=56.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=1.00GB, used=617.14MB
Metadata: total=1.01GB, used=0.00

I may be missing or mis-remembering some of the order of events leading 
to the current state, however the space usage numbers don't reflect 
anything close to what I would expect.

On the data used on sdc I've assumed that's old from when I filled the 
volume and hasn't been reclaimed by a balance or other operation. 
However, the "used=997.21MB" from fi df, as well as the "FS bytes used 
540.00KB" from fi show seem suspect based on what

Thanks for help understanding the space allocation and usage patterns, 
I've tried to put pieces together based on man pages, wiki and other 
postings, but can't seem to reconcile what I think I should be seeing 
based on that reading with what I'm actually seeing.

Joel
