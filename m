From: "Sebastian 'gonX' Jensen" <gonx@overclocked.net>
Subject: Re: Mounting raid without a btrfsctl scan
Date: Sun, 16 May 2010 02:41:11 +0200
Message-ID: <AANLkTinRVuk_uJBLsBD0ANdKkEHs-9zz4Tor_0xi7oCI@mail.gmail.com>
References: <4BEE817A.7060604@gmx.com> <201005151636.08437.kreijack@libero.it>
	 <AANLkTilwCv-RZvdyVyX9ymamEIXUY0P1cozI0R0Aqa07@mail.gmail.com>
	 <20100516000257.GB651@mother.pipebreaker.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Tomasz Torcz <tomek@pipebreaker.pl>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100516000257.GB651@mother.pipebreaker.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On 16 May 2010 02:02, Tomasz Torcz <tomek@pipebreaker.pl> wrote:
> On Sat, May 15, 2010 at 06:47:22PM +0200, Sebastian 'gonX' Jensen wro=
te:
>> >> Would it be possible and feasible to support mounting btrfs
>> >> raid/multi-device filesystems without having to run 'btrfsctl -a'=
?
>> >>
>> >> Currently, as you may know, if a one wants to attach a btrfs raid
>> >> filesystem to a system (usb, hotswap, reboot, etc), the user or p=
rogram
>> >> has to run:
>> >>
>> >> btrfsctl -a (or similar)
>> >> mount /dev/sdb1 /mount/point
>> >>
>> >> While this works, it will require patching of various subsystems
>> >> involved with managing disks, such as udev, mkinitrd, dracut, hal=
, and
>> >> others. Each one will have to know to scan, then mount.
>> >
>> > In a my previous post ([RFC] btrfs, udev and btrfs - 16/April 2010=
), I
>> > suggested a solution for this kind of problem. I a Debian/Ubuntu s=
ystem it is
>> > not necessary to patch anything, it is only required to put some f=
iles in the
>> > initramfs-tool configure directories.
>> >
>> > IIRC, also the md (RAID) subsystem require a scan from the user sp=
ace to find
>> > and activate the volumes. I think also dm (LVM) subsystem requires=
 the same.
>> >
>>
>> md does not require a scan from userspace with at least both RAID-0
>> and RAID-1. There's a setting in the kernel config you can set, whic=
h
>> will automatically detect all RAID drives with the FD partition flag
>> set. DM may however be true.
>
>
> =C2=A0MD will only detect RAID on MS-DOS partitions (seldom used when=
 RAIDing
> whole devices, not possible to use with devices >2 TiB) and metadata
> 0.90, which is not default. Userspace probing is general way kernel
> subsystem are going, it is more flexible.
> =C2=A0And dracut already has btrfs module.
>

You're right, only metadata 0.9 is supported with autodetection
kernel-side. I had forgotten about that.

On a more related note, I agree that userspace probing is a lot more
flexible, but for mounting root partitions it is also extremely
inconvenient. I don't know if I mentioned it before, but my system
spends at least 6 seconds in the initramfs before passing control over
to my distributions initscripts. Part of it is obviously because of
btrfs having to spend approximately 3 seconds probing for devices (I
have a decent amount of devices). However, btrfs does not have that
many functions yet. Would it be possible to at least have partial
functionality kernel side, so that an initramfs is not required for
mounting RAID devices?

> --
> Tomasz Torcz =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0,,If you=
 try to upissue this patchset I shall be seeking
> xmpp: zdzichubg@chrome.pl =C2=A0 an IP-routable hand grenade.'' -- An=
drew Morton (LKML)
>
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
