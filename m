Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:47360 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933502Ab2JWW33 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Oct 2012 18:29:29 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: device delete, error removing device
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <5087174A.2060405@inwind.it>
Date: Tue, 23 Oct 2012 16:29:27 -0600
Message-Id: <1BE15E02-3DBE-42AB-8900-D82C11BCD1B7@colorremedies.com>
References: <D297D796-B7E9-4A65-AD72-EC394AD32D4C@colorremedies.com> <4D1258FC-36CB-4C7B-AE7F-AFCC73E6AEC4@colorremedies.com> <20121022091904.GY25498@carfax.org.uk> <B2B2C037-F5C8-4A75-A0D8-6C0AACDFAF4E@colorremedies.com> <20121022171809.GA25498@carfax.org.uk> <20121023075721.GB391@yeono.kjorling.se> <5086DDAE.3050708@gmail.com> <442D159A-4A4E-4A50-B1DB-0E6E12FA6F5C@colorremedies.com> <5086E9D6.4070201@inwind.it> <3443D67F-6CCE-48BF-A1DB-12473BE95EE8@colorremedies.com> <5087174A.2060405@inwind.it>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 23, 2012, at 4:16 PM, Goffredo Baroncelli <kreijack@inwind.it> wrote:
> 
> 
> $ sudo /mnt/home-ghigo/btrfs/btrfs-progs/btrfs fi sh
> Label: 'test1'  uuid: 7ba72d6f-d226-4e8c-9a9c-92a7fd89cd99
> 	Total devices 4 FS bytes used 7.01GB
> 	devid    4 size 12.00GB used 3.21GB path /dev/vdf
> 	devid    3 size 3.00GB used 2.53GB path /dev/vdd
> 	devid    2 size 3.00GB used 2.95GB path /dev/vdc
> 	*** Some devices missing
> 
> Which is what you are reporting.

Yes. However I can reproduce this much more easily as:

[root@f18v ~]# mkfs.btrfs /dev/sd[bc]
[root@f18v ~]# mount /dev/sdb /mnt
[root@f18v ~]# btrfs device add /dev/sdd /mnt
[root@f18v ~]# btrfs device delete /dev/sdb /mnt
[root@f18v ~]# btrfs fi show

Label: none  uuid: 0daeada5-98c0-4a9a-8d0c-5a9dcfde2972
	Total devices 3 FS bytes used 796.00KB
	devid    3 size 80.00GB used 6.06GB path /dev/sdd
	devid    2 size 80.00GB used 6.06GB path /dev/sdc
	*** Some devices missing

> 4) If I touch the filesystem (eg creating a file or unmount the
> filesystem) then the superblocks are update and the I get

Confirmed.

> Conclusion:
> - I was not able to reproduce your problem about removing the device. I
> was able to remove the device after filling the filesystem and adding a
> new device.

dd if=/dev/zero of=/mnt/btrfs1/bigfile bs=1M count=$((7*1024))

I think it needs to be bigger. I was at a bit over 8GB file size for a 9GB file system (3x 3GB drives). There was about 300MB of free space left according to df -h, which was for the whole volume, i.e. maybe around 100MB free space per device, and hence possibly not enough room to budge unless I added yet another drive. Then it was able to back out.

Chris Murphy