Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:53883 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756043Ab3AFQ0q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 6 Jan 2013 11:26:46 -0500
Message-ID: <50E9A5D1.4050704@inwind.it>
Date: Sun, 06 Jan 2013 17:26:57 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: "linux-btrfs@vger.kernel.org list" <linux-btrfs@vger.kernel.org>
Subject: Re: BUG btrfs fi show displays stale btrfs volume
References: <96FA5245-87A9-43C4-9B56-C0F4ADB9D975@colorremedies.com>
In-Reply-To: <96FA5245-87A9-43C4-9B56-C0F4ADB9D975@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris
On 01/06/2013 12:21 AM, Chris Murphy wrote:
> I've filed this bug under util-linux, because I think wipefs isn't deleting all btrfs metadata it could. But ultimately it appears to be a btrfs bug because nothing else sees the stale volume.
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=889888#c15
> 
> btrfs-progs-0.20.rc1.20121017git92d9eec-1.fc18.x86_64
> e2fs-progs-1.42.5-1.fc18.x86_64
> kernel 3.7.1-2
> 
> Brand new 80GB virtual disk, so it's completely zero'd.
> 
> 1. fdisk to create one partition, all defaults.
> 2. Format that sda1 with mkfs.btrfs -L first.
> 3. btrfs fi show displays "first" labeled volume.
> 4. wipefs -a /dev/sda1 and it finds btrfs metadata, ostensibly removes it.
> 5. btrfs fi show does NOT show "first" anymore.
> 6. fdisk /dev/sda again, delete the one partition; create a new partition 500MB and a second one for remaining space.
> 7. btrfs fi show still does not show "first".
> 8. mkfs.ext4 /dev/sda1
> 9. btrfs fi show NOW SHOWS "first" on sda1!
> 10. Reboot
> 11. btrfs fi show still shows "first" on sda1, size 80GB.
> 
> Tentative conclusions:
> 
> A. wipefs isn't deleting all btrfs metadata it could. 
True
> 
> B. mkfs.ext4 is refreshing stale btrfs metadata in a way that causes btrfs fi show to see.
True

Btrfs stores several copies of the superblock (IIRC three). During the
scan it searches for a valid superblock. If the first is wrong, checks
the second and so on...
It stops the search when one of the following conditions is true:
1) the superblock "magic" field is zero (typically when a disk is removed)
2) the superblock is valid
3) there is no other superblock.

I think that wipefs zeros the "magic" field on the first superblock. So
the btrfs scan process ends at the first superblock.

When the disk is used again, it is possible that the first superblock is
overwritten and the "magic" field is not zero any more. So in case of
further scan by btrfs, the first superblock is ignored and the check is
performed to the second one and the third one, which could be valid, if
nobody zeroed its "magic" field.

I think that wipefs should be improved to reset to zero also the other
superblocks.

I will start to update the wiki; then I will give a look to wipefs to
improve it.

BR
G.Baroncelli
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
