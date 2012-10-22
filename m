Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:50183 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751079Ab2JVQmV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Oct 2012 12:42:21 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: device delete, error removing device
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20121022091904.GY25498@carfax.org.uk>
Date: Mon, 22 Oct 2012 10:42:18 -0600
Message-Id: <B2B2C037-F5C8-4A75-A0D8-6C0AACDFAF4E@colorremedies.com>
References: <D297D796-B7E9-4A65-AD72-EC394AD32D4C@colorremedies.com> <4D1258FC-36CB-4C7B-AE7F-AFCC73E6AEC4@colorremedies.com> <20121022091904.GY25498@carfax.org.uk>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Thanks for the response Hugo,

On Oct 22, 2012, at 3:19 AM, Hugo Mills <hugo@carfax.org.uk> wrote:

>   I'm not entirely sure what's going on here(*), but it looks like an
> awkward interaction between the unequal sizes of the devices, the fact
> that three of them are very small, and the RAID-0/RAID-1 on
> data/metadata respectively.

I'm fine accepting the devices are very small and the original file system was packed completely full: to the point this is effectively sabotage. 

The idea was merely to test how a full (I was aiming more for 90%, not 97%, oops) volume handles being migrated to a replacement disk, which I think for a typical user would be larger not the same, knowing in advance that not all of the space on the new disk is usable. And I was doing it at a one order magnitude reduced scale for space consideration.


>   You can't relocate any of the data chunks, because RAID-0 requires
> at least two chunks, and all your data chunks are more than 50% full,
> so it can't put one 0.55 GiB chunk on the big disk and one 0.55 GiB
> chunk on the remaining space on the small disk, which is the only way
> it could proceed.

Interesting. So the way "device delete" moves extents is not at all similar to how LVM pvmove moves extents, which is unidirectional (away from the device being demoted). My, seemingly flawed, expectation was that "device delete" would cause extents on the deleted device to be moved to the newly added disk.

If I add yet another 12GB virtual disk, sdf, and then attempt a delete, it works, no errors. Result:
[root@f18v ~]# btrfs device delete /dev/sdb /mnt
[root@f18v ~]# btrfs fi show
failed to read /dev/sr0
Label: none  uuid: 6e96a96e-3357-4f23-b064-0f0713366d45
	Total devices 5 FS bytes used 7.52GB
	devid    5 size 12.00GB used 4.17GB path /dev/sdf
	devid    4 size 12.00GB used 4.62GB path /dev/sde
	devid    3 size 3.00GB used 2.68GB path /dev/sdd
	devid    2 size 3.00GB used 2.68GB path /dev/sdc
	*** Some devices missing

However, I think that last line is a bug. When I

[root@f18v ~]# btrfs device delete missing /mnt

I get

[ 2152.257163] btrfs: no missing devices found to remove

So they're missing but not missing?

> btrfs balance start -dconvert=single /mountpoint


Yeah that's perhaps a better starting point for many regular Joe users setting up a multiple device btrfs volume, in particular where different sized disks can be anticipated.


Chris Murphy