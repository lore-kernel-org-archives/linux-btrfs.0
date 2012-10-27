Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:33727
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758808Ab2J0SZ2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Oct 2012 14:25:28 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: device delete, error removing device
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <50899269.8080208@gmail.com>
Date: Sat, 27 Oct 2012 12:25:25 -0600
Message-Id: <6FC0FD8D-EC25-41DF-BF07-04648A2D0E87@colorremedies.com>
References: <D297D796-B7E9-4A65-AD72-EC394AD32D4C@colorremedies.com> <4D1258FC-36CB-4C7B-AE7F-AFCC73E6AEC4@colorremedies.com> <20121022091904.GY25498@carfax.org.uk> <B2B2C037-F5C8-4A75-A0D8-6C0AACDFAF4E@colorremedies.com> <20121022171809.GA25498@carfax.org.uk> <20121023075721.GB391@yeono.kjorling.se> <5086DDAE.3050708@gmail.com> <442D159A-4A4E-4A50-B1DB-0E6E12FA6F5C@colorremedies.com> <5086E9D6.4070201@inwind.it> <3443D67F-6CCE-48BF-A1DB-12473BE95EE8@colorremedies.com> <5087174A.2060405@inwind.it> <1BE15E02-3DBE-42AB-8900-D82C11BCD1B7@colorremedies.com> <50882E38.4000408@gmail.com> <D0E7C142-9FAE-4233-BA2E-BB1EB341FD93@colorremedies.com> <50885E0D.9040701@gmail.com> <2E8E9E76-5B11-4DDF-A3E8-ECE4350384AA@colorremedies.com> <50899269.8080208@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

3.6.3-3.fc18.x86_64.debug
btrfs-progs-0.20.rc1.20121017git91d9eec-1.fc18.x86_64

I'm getting a very different result with this kernel compared to 3.6.2, when I do the same thing. I fill the btrfs volume to 97% full again, no errors. Add a device of the *same* size, and then device delete.

In this case, the 'device delete' command hangs, no recovery, and dmesg from another shell reports the file system is forced read only. The debug kernel produces quite a bit more information so I'll post that here:

http://pastebin.com/8d1b6eCn


Label: 'filltest'  uuid: c0a4c7d7-7a23-4ce3-bafe-20cb92156562
	Total devices 3 FS bytes used 13.84GB
	devid    3 size 8.00GB used 19.00MB path /dev/sdd
	devid    2 size 8.00GB used 8.00GB path /dev/sdc
	devid    1 size 8.00GB used 8.00GB path /dev/sdb


[root@f18v ~]# btrfs fi df /mnt
Data, RAID0: total=13.95GB, used=13.82GB
Data: total=8.00MB, used=0.00
System, RAID1: total=8.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=1.02GB, used=19.09MB
Metadata: total=8.00MB, used=0.00

Two minutes later I get more from dmesg since btrfs is blocked:

http://pastebin.com/BznS3dF0

The volume can't be unmounted and the stuck process can't be killed. So I reboot. Mounting it produces:

[   45.540143] device label filltest devid 1 transid 17 /dev/sdb
[   45.545417] btrfs: disk space caching is enabled
[   45.566326] btrfs: free space inode generation (0) did not match free space cache generation (1858)
[   45.598677] btrfs: free space inode generation (0) did not match free space cache generation (1832)
[   45.794886] btrfs: unlinked 1 orphans

Otherwise the file system seems fine. And

btrfs balance start -dconvert=single /mnt

Does eventually unwind the problem.

If the scenario allows adding a 4th device to this situation, it's faster because the balance isn't required. Thus deleting the (hypothetically troublesome) device occurs more quickly while also not requiring significant write capability to it.


Chris Murphy

