From: Leszek Ciesielski <skolima@gmail.com>
Subject: Re: mount command not honoring rootflags passed
Date: Fri, 22 Jan 2010 10:40:33 +0100
Message-ID: <23a15591001220140p2975a064ne0e29f12b8c5a4af@mail.gmail.com>
References: <D31BF6EF-2E01-434F-BA36-B3939DC5F9EE@kupper.org>
	 <23a15591001220059y4d3c41c0k1ade5c4da358cb66@mail.gmail.com>
	 <6F0F6C78-26BD-44CC-911A-1DECC31EABA7@kupper.org>
	 <23a15591001220117n69ffb37ch1f6ead22964d1361@mail.gmail.com>
	 <81D051DA-822A-46A5-8F24-64BAF3C3B6A4@kupper.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Thomas Kupper <thomas@kupper.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <81D051DA-822A-46A5-8F24-64BAF3C3B6A4@kupper.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 22, 2010 at 10:30 AM, Thomas Kupper <thomas@kupper.org> wro=
te:
>
> On 22 Jan 2010, at 10:17, Leszek Ciesielski wrote:
>
>> On Fri, Jan 22, 2010 at 10:06 AM, Thomas Kupper <thomas@kupper.org> =
wrote:
>>>
>>> On 22 Jan 2010, at 09:59, Leszek Ciesielski wrote:
>>>
>>>> On Fri, Jan 22, 2010 at 12:55 AM, Thomas Kupper <thomas@kupper.org=
> wrote:
>>>>> Using btrfs as the root filesystem on my Ubuntu 9.10 powered lapt=
op I discoverd that mount is not showing the actual passed rootflags=3D=
 but shows what is put in the /etc/fstab.
>>>>>
>>>>> First of all, I'm not sure if that is an intended behavior and if=
 not, if it's a problem of mount or btrfs.
>>>>>
>>>>> Example:
>>>>> Following Goffredo's example there's a subvolume called rootfs wh=
ich is - surprisingly ;) - the root of the linux. The corresponding lin=
e in fstab is
>>>>>
>>>>> $ cat /etc/fstab
>>>>> [...]
>>>>> # / was on /dev/sda3 during installation
>>>>> UUID=3D<some-scary-UUID> =A0 / =A0 btrfs =A0 subvol=3Drootfs =A0 =
0 =A0 1
>>>>>
>>>>> $ mount
>>>>> [...]
>>>>> /dev/sda3 on / type btrfs (rw,subvol=3Drootfs)
>>>>>
>>>>> I create a snapshot of the rootfs called rootfs-snap-001 and crea=
te it in the / of the btrfs volume itself. Not modifying grub2, I just =
edit grub on the go. While booting I edit the /linux-kernel... entry an=
d replace rootflags=3Dsubvol=3Drootfs with rootflags=3Dsubvol=3Drootfs-=
snap-001. That boots up just fine but the mount output still is
>>>>>
>>>>> $ mount
>>>>> [...]
>>>>> /dev/sda3 on / type btrfs (rw,subvol=3Drootfs)
>>>>>
>>>>> ... and /etc/mtab is indeed
>>>>>
>>>>> $ cat /etc/mtab
>>>>> [...]
>>>>> /dev/sda3 / btrfs rw,subvol=3Drootfs 0 0
>>>>>
>>>>> shouldn't mount and /etc/mtab reflect the parameters in use?
>>>>>
>>>>
>>>> No. The same thing happens with whatever filesystem you use for ro=
otfs.
>>>
>>> Thanks for the clarification. How do I see then what subvolume is m=
ounted as root? Assume I play around with lots of snapshots and wonder =
with what snapshot I booted. Sure, I should know but sometimes I want t=
o make sure I did boot the right one before deleting an other snapshot.
>>
>> azazel ~ # cat /proc/cmdline
>> root=3D/dev/sda3 rootfstype=3Dext4
>
> Again, thanks alot. That does the trick.
>
> Maybe a bit of a pain in the a$#: Is there a specific reason the moun=
t utility doesn't show the actual mount options in use? Wouldn't one - =
I certainly do - expect /etc/mtab or mount to show how a certain partit=
ion is mounted? Not really a btrfs issue, I'm aware.

Doesn't 'cat /proc/mounts' show the actually used mount options?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
