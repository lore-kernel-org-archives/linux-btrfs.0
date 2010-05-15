From: "Sebastian 'gonX' Jensen" <gonx@overclocked.net>
Subject: Re: Mounting raid without a btrfsctl scan
Date: Sat, 15 May 2010 18:47:22 +0200
Message-ID: <AANLkTilwCv-RZvdyVyX9ymamEIXUY0P1cozI0R0Aqa07@mail.gmail.com>
References: <4BEE817A.7060604@gmx.com> <201005151636.08437.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: kreijack@libero.it, linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201005151636.08437.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On 15 May 2010 16:36, Goffredo Baroncelli <kreijack@gmail.com> wrote:
> On Saturday 15 May 2010, Matt Brown wrote:
>> Hi,
> Hi Matt,
Hey guys, first of all, apologize for the double post for Goffredo, I
forgot to add linux-btrfs to my recipient list.

>>
>> Would it be possible and feasible to support mounting btrfs
>> raid/multi-device filesystems without having to run 'btrfsctl -a'?
>>
>> Currently, as you may know, if a one wants to attach a btrfs raid
>> filesystem to a system (usb, hotswap, reboot, etc), the user or prog=
ram
>> has to run:
>>
>> btrfsctl -a (or similar)
>> mount /dev/sdb1 /mount/point
>>
>> While this works, it will require patching of various subsystems
>> involved with managing disks, such as udev, mkinitrd, dracut, hal, a=
nd
>> others. Each one will have to know to scan, then mount.
>
> In a my previous post ([RFC] btrfs, udev and btrfs - 16/April 2010), =
I
> suggested a solution for this kind of problem. I a Debian/Ubuntu syst=
em it is
> not necessary to patch anything, it is only required to put some file=
s in the
> initramfs-tool configure directories.
>
> IIRC, also the md (RAID) subsystem require a scan from the user space=
 to find
> and activate the volumes. I think also dm (LVM) subsystem requires th=
e same.
>

md does not require a scan from userspace with at least both RAID-0
and RAID-1. There's a setting in the kernel config you can set, which
will automatically detect all RAID drives with the FD partition flag
set. DM may however be true.

I think the idea of this, is to avoid having initramfs deal with this?
To be honest that's the only thing I use it for now, and it slows my
boot time by about 5 seconds.

>>
>> For example, I have a system that has a btrfs raid1 as root. However=
, I
>> had to patch the boot loader (dracut) so during boot it would scan j=
ust
>> before mounting the root filesystem.
>>
>> I filed a bug with dracut, but the more I think of it, the more it s=
eems
>> that either mount.btrfs should be taking care of this, or another pa=
rt
>> of btrfs.
>
> If it would be mount.btrfs to perform the scan, that means a scan for=
 every
> mounting. I think that is better to separate the two function. The sc=
an has to
> be performed a device discovery time, and not a the mounting time.

Would it not be possible to have a cache of sorts for btrfs that check
each device/partition based on an UUID and drive serial number (hdparm
should have this) every time a mount with selected devices is done?
e.g:
/dev/sda1 is attempted to be mounted. This drive is not in the btrfs
drive cache, and will then be probed for btrfs RAID arrays. The cache
should eventually be volatile, but could also be on a certain place on
the partition, e.g. together with metadata for a cache of all btrfs
drives used.

Anybody not with me?

>
>
>>
>> Any thoughts or plans on the matter?
>>
>> Thanks,
>> Matt
>
> BR
> Goffredo

Regards,
Sebastian J.

>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrf=
s" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
>
>
> --
> gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATi=
nwind.it>
> Key fingerprint =3D 4769 7E51 5293 D36C 814E =C2=A0C054 BF04 F161 3DC=
5 0512
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
