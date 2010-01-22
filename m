From: Leszek Ciesielski <skolima@gmail.com>
Subject: Re: mount command not honoring rootflags passed
Date: Fri, 22 Jan 2010 10:17:22 +0100
Message-ID: <23a15591001220117n69ffb37ch1f6ead22964d1361@mail.gmail.com>
References: <D31BF6EF-2E01-434F-BA36-B3939DC5F9EE@kupper.org>
	 <23a15591001220059y4d3c41c0k1ade5c4da358cb66@mail.gmail.com>
	 <6F0F6C78-26BD-44CC-911A-1DECC31EABA7@kupper.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Thomas Kupper <thomas@kupper.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <6F0F6C78-26BD-44CC-911A-1DECC31EABA7@kupper.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 22, 2010 at 10:06 AM, Thomas Kupper <thomas@kupper.org> wro=
te:
>
> On 22 Jan 2010, at 09:59, Leszek Ciesielski wrote:
>
>> On Fri, Jan 22, 2010 at 12:55 AM, Thomas Kupper <thomas@kupper.org> =
wrote:
>>> Using btrfs as the root filesystem on my Ubuntu 9.10 powered laptop=
 I discoverd that mount is not showing the actual passed rootflags=3D b=
ut shows what is put in the /etc/fstab.
>>>
>>> First of all, I'm not sure if that is an intended behavior and if n=
ot, if it's a problem of mount or btrfs.
>>>
>>> Example:
>>> Following Goffredo's example there's a subvolume called rootfs whic=
h is - surprisingly ;) - the root of the linux. The corresponding line =
in fstab is
>>>
>>> $ cat /etc/fstab
>>> [...]
>>> # / was on /dev/sda3 during installation
>>> UUID=3D<some-scary-UUID> =A0 / =A0 btrfs =A0 subvol=3Drootfs =A0 0 =
=A0 1
>>>
>>> $ mount
>>> [...]
>>> /dev/sda3 on / type btrfs (rw,subvol=3Drootfs)
>>>
>>> I create a snapshot of the rootfs called rootfs-snap-001 and create=
 it in the / of the btrfs volume itself. Not modifying grub2, I just ed=
it grub on the go. While booting I edit the /linux-kernel... entry and =
replace rootflags=3Dsubvol=3Drootfs with rootflags=3Dsubvol=3Drootfs-sn=
ap-001. That boots up just fine but the mount output still is
>>>
>>> $ mount
>>> [...]
>>> /dev/sda3 on / type btrfs (rw,subvol=3Drootfs)
>>>
>>> ... and /etc/mtab is indeed
>>>
>>> $ cat /etc/mtab
>>> [...]
>>> /dev/sda3 / btrfs rw,subvol=3Drootfs 0 0
>>>
>>> shouldn't mount and /etc/mtab reflect the parameters in use?
>>>
>>
>> No. The same thing happens with whatever filesystem you use for root=
fs.
>
> Thanks for the clarification. How do I see then what subvolume is mou=
nted as root? Assume I play around with lots of snapshots and wonder wi=
th what snapshot I booted. Sure, I should know but sometimes I want to =
make sure I did boot the right one before deleting an other snapshot.

azazel ~ # cat /proc/cmdline
root=3D/dev/sda3 rootfstype=3Dext4
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
