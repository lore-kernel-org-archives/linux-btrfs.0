From: Leonidas Spyropoulos <artafinde@gmail.com>
Subject: Re: mount problem
Date: Wed, 12 Jan 2011 01:38:41 +0000
Message-ID: <AANLkTik3qNugqgA6sPw-+DYgOVXMm+=Q4i-mJVFSbz=m@mail.gmail.com>
References: <AANLkTi=JL3q2GV94j_wv5QN1pHbRouvn7D3pu_MUj1XW@mail.gmail.com>
	<4D2CFA57.1080405@jp.fujitsu.com>
	<AANLkTikNMvfPJ9VNVax6cG3LH6UVSsr-qPZUN5ZqB8Ah@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikNMvfPJ9VNVax6cG3LH6UVSsr-qPZUN5ZqB8Ah@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 12 January 2011 00:58, Leonidas Spyropoulos <artafinde@gmail.com> wr=
ote:
> 2011/1/12 Tsutomu Itoh <t-itoh@jp.fujitsu.com>:
>> (2011/01/12 9:25), Leonidas Spyropoulos wrote:
>>> Hey all,
>>>
>>> I have a weird error with my RAID 0 btrfs partition.
>>> Information for the partitions follow:
>>>
>>> # btrfs filesystem show
>>> failed to read /dev/sr0
>>> Label: none =A0uuid: 1882b025-58e4-4287-98a3-9b772af0ad76
>>> =A0 =A0 =A0 Total devices 2 FS bytes used 108.16GB
>>> =A0 =A0 =A0 devid =A0 =A02 size 74.53GB used 55.26GB path /dev/sdd2
>>> =A0 =A0 =A0 devid =A0 =A03 size 74.53GB used 55.26GB path /dev/sde2
>>>
>>> Btrfs v0.19-35-g1b444cd
>>>
>>> # btrfs device scan
>>> Scanning for Btrfs filesystems
>>> failed to read /dev/sr0
>>>
>>> # cat /etc/fstab | grep btrfs
>>> /dev/disk/by-uuid/1882b025-58e4-4287-98a3-9b772af0ad76 =A0 =A0 =A0 =
=A0/media/data
>>> =A0 =A0 =A0 btrfs =A0 rw,user 0 0
>>>
>>> # blkid
>>> /dev/sdd2: UUID=3D"1882b025-58e4-4287-98a3-9b772af0ad76"
>>> UUID_SUB=3D"468b49fa-a0b6-4e11-a312-ef0cafd2890a" TYPE=3D"btrfs"
>>> /dev/sde2: UUID=3D"1882b025-58e4-4287-98a3-9b772af0ad76"
>>> UUID_SUB=3D"cf534558-a317-4259-808b-d950a155fb5d" TYPE=3D"btrfs"
>>>
>>> Although I have the config within fstab it doesn't mount on bootup =
with error:
>>> mount: wrong fs type, bad option, bad superblock on /dev/sde2,
>>> =A0 =A0 =A0 =A0missing codepage or helper program, or other error
>>> =A0 =A0 =A0 =A0In some cases useful info is found in syslog - try
>>> =A0 =A0 =A0 =A0dmesg | tail =A0or so
>>>
>>> Kernel messages:
>>> device fsid 8742e45825b08218-76adf02a779ba398 devid 3 transid 4778 =
/dev/sde2
>>> btrfs: failed to read the system array on sde2
>>
>> Please see Problem_FAQ in btrfs wiki.
>> (https://btrfs.wiki.kernel.org/index.php/Problem_FAQ)
>>
>> Thanks,
>> Itoh
>>
>>>
>>> No matter how many times I try with sudo mount -a or sudo mount
>>> /media/data I got the same error.
>>>
>>> Now the weird stuff:
>>> If I do a blkid and fdisk -l I can then mount normally the partitio=
n.
>>> Any ideas?
>>>
>>> Kernel info: Linux woofy 2.6.36-ARCH #1 SMP PREEMPT Sat Jan 8 14:15=
:27
>>> CET 2011 x86_64 Dual Core AMD Opteron(tm) Processor 165 AuthenticAM=
D
>>> GNU/Linux
>>> btrfs-progs: Latest from git
>>> I don't know which revision/patch Arch stock kernel has of btrfs.
>>>
>>>
>>> Thanks,
>>> Leonidas
>>>
>>
>>
>
> Hey cwillu and Itoh,
>
> Thanks both for the answers, so as I can see I have 2 options:
> Either find the startup scripts of Arch Linux and run the scan comman=
d
> before parsing fstab (this should be in /etc/rc.conf ?)
> OR
> edit fstab with parameters the correct devices like:
> =A0/dev/disk/by-uuid/1882b025-58e4-4287-98a3-9b772af0ad76 =A0/media/d=
ata
> btrfs =A0 device=3D/dev/sde2,device=3D/dev/sdd2,rw,user 0 0
>
> I think though that the devices names are randomly chosen in startup
> from udev, right?
> (this is the reason I use uuids)
> so effectivly i have just an option.
>
> Thanks,
> Leonidas
>
> --
> Caution: breathing may be hazardous to your health.
>

I searched around and after consulting with #archlinux irc channel the
best way to do that is to add a hook in mkinitcpio.

This tool already has a btrfs hook current version so simply add it
before filesystem hook and recreate the initramfs

=46or my stock kernel: mkinitcpio -p kernel26

Worked fine.

Thanks
Leonidas
--=20
Caution: breathing may be hazardous to your health.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
