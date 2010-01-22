From: Thomas Kupper <thomas@kupper.org>
Subject: Re: mount command not honoring rootflags passed
Date: Fri, 22 Jan 2010 10:06:32 +0100
Message-ID: <6F0F6C78-26BD-44CC-911A-1DECC31EABA7@kupper.org>
References: <D31BF6EF-2E01-434F-BA36-B3939DC5F9EE@kupper.org> <23a15591001220059y4d3c41c0k1ade5c4da358cb66@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Leszek Ciesielski <skolima@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <23a15591001220059y4d3c41c0k1ade5c4da358cb66@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


On 22 Jan 2010, at 09:59, Leszek Ciesielski wrote:

> On Fri, Jan 22, 2010 at 12:55 AM, Thomas Kupper <thomas@kupper.org> wrote:
>> Using btrfs as the root filesystem on my Ubuntu 9.10 powered laptop I discoverd that mount is not showing the actual passed rootflags= but shows what is put in the /etc/fstab.
>> 
>> First of all, I'm not sure if that is an intended behavior and if not, if it's a problem of mount or btrfs.
>> 
>> Example:
>> Following Goffredo's example there's a subvolume called rootfs which is - surprisingly ;) - the root of the linux. The corresponding line in fstab is
>> 
>> $ cat /etc/fstab
>> [...]
>> # / was on /dev/sda3 during installation
>> UUID=<some-scary-UUID>   /   btrfs   subvol=rootfs   0   1
>> 
>> $ mount
>> [...]
>> /dev/sda3 on / type btrfs (rw,subvol=rootfs)
>> 
>> I create a snapshot of the rootfs called rootfs-snap-001 and create it in the / of the btrfs volume itself. Not modifying grub2, I just edit grub on the go. While booting I edit the /linux-kernel... entry and replace rootflags=subvol=rootfs with rootflags=subvol=rootfs-snap-001. That boots up just fine but the mount output still is
>> 
>> $ mount
>> [...]
>> /dev/sda3 on / type btrfs (rw,subvol=rootfs)
>> 
>> ... and /etc/mtab is indeed
>> 
>> $ cat /etc/mtab
>> [...]
>> /dev/sda3 / btrfs rw,subvol=rootfs 0 0
>> 
>> shouldn't mount and /etc/mtab reflect the parameters in use?
>> 
> 
> No. The same thing happens with whatever filesystem you use for rootfs.

Thanks for the clarification. How do I see then what subvolume is mounted as root? Assume I play around with lots of snapshots and wonder with what snapshot I booted. Sure, I should know but sometimes I want to make sure I did boot the right one before deleting an other snapshot.