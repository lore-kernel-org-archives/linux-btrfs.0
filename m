Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 60-241-247-214.static.tpgi.com.au ([60.241.247.214]:42931 "EHLO
	ns1.allsupp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbbL1CO1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Dec 2015 21:14:27 -0500
Subject: Re: How to change BTRFS filesystem UUID
To: Hugo Mills <hugo@carfax.org.uk>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
References: <567FF63E.3010106@ganomi.com>
 <20151227144535.GJ1586@carfax.org.uk> <5680034D.7030509@ganomi.com>
 <1451257299.6320.3.camel@scientia.net> <20151227231303.GL1586@carfax.org.uk>
From: Jiri Kanicky <j@ganomi.com>
Message-ID: <56809AC4.2080209@ganomi.com>
Date: Mon, 28 Dec 2015 13:13:24 +1100
MIME-Version: 1.0
In-Reply-To: <20151227231303.GL1586@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Thanks for the detailed information. The data were not corrupted, so I 
could copy them to a new BTRFS partition.

Here is what happened exactly.

VM with BTRFS filesystem running on XenServer. The VM disk is a VHD 
stored on NFS storage. NFS storage ran out of space, and I found the 
BTRFS in RO mode. I could not remount it as RW after increasing the 
storage space. I rebooted the VM and the VM was not able to boot 
anymore. There were many lines during boot reporting "btrfs open_ctree 
failed" and the boot ended up in dracut mode.

I booted from CD and find out that I can mount the BTRFS filesystem and 
all data are there.

I created a new disk with BTRFS filesystem, copied all the data on it, 
and that new disk booted fine. (I actually used a disk from my template, 
so that is where the same BTRFS UUID comes from. But this was not the 
real issue. I copied the data on EXT4 disk first and then to the new 
disk to avoid having same BTRFS UUIDs. I will try changing the UUIDs as 
suggested later.)

In summary, I think that BTRFS was not able to recover from the scenario 
explained above. VMs with EXT4 could boot normally.

Regards,
Jiri


On 28/12/2015 10:13 AM, Hugo Mills wrote:
> On Mon, Dec 28, 2015 at 12:01:39AM +0100, Christoph Anton Mitterer wrote:
>> On Mon, 2015-12-28 at 02:27 +1100, Jiri Kanicky wrote:
>>> Thanks for the reply. Looks like I will have o use some newer
>>> distro.
>> As it was already said... btrfs may even corrupt your filesystem if
>> colliding UUIDs are "seen".
>>
>> At least to me it's currently unclear what "seen" exactly means...
>> actually trying a mount, or already when just a device with colliding
>> IDs appear.
>     The damage happens on (or after) mount. Until that point there's no
> danger.
>
>     The OS (usually udev) will run btfs dev scan when a new block
> device is detected, and it tells the kernel that there's a btrfs
> filesystem with a particular UUID on a particular block device.
>
>     The kernel uses this information to decide which devices to include
> when it assembles a filesystem. If you have two devices where there
> should be only one (particularly if the data on the two was similar
> but has now diverged), then the kernel can end up writing to one or
> other device arbitrarily, possibly having read state from the other
> one, and things screw up rather fast.
>
>     Hugo.
>
>> So whenever you do your recovery works, make sure that there's never a
>> moment where more than one btrfs block device appears with the same
>> UUID.
>> Even when it's just for some seconds it may already cause corruption.
>>
>>
>> Cheers,
>> Chris.
>
>

