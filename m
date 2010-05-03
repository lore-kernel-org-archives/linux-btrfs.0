From: "Sebastian 'gonX' Jensen" <gonx@overclocked.net>
Subject: Re: How to expand a BTRFS partition... backwards
Date: Mon, 3 May 2010 05:15:22 +0200
Message-ID: <v2u8a48dc7a1005022015zb1084c73y439fe4c228e28161@mail.gmail.com>
References: <j2v8a48dc7a1005012232pa765876fscc41e97b940333de@mail.gmail.com>
	 <j2tfc5ef2e01005021409u75d9a45fk2002e2f0f440dde5@mail.gmail.com>
	 <y2q8a48dc7a1005021718j3c6256f9n31ada79603893d1d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Mike Fleetwood <mike.fleetwood@googlemail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <y2q8a48dc7a1005021718j3c6256f9n31ada79603893d1d@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 2 May 2010 23:09, Mike Fleetwood <mike.fleetwood@googlemail.com> wro=
te:
> On 2 May 2010 06:32, Sebastian 'gonX' Jensen <gonx@overclocked.net> w=
rote:
>> Hey guys,
>>
>> I kinda figured out the syntax for resizing BTRFS arrays, but is it
>> possible to use free space that is behind the current BTRFS partitio=
n?
>> I kinda figure it's not, but ideally I'd like it so that there is no
>> unused disk space on the disk.
>>
>> My partition setup looks something like this:
>>
>> Partition 1: 100MB (used)
>> Partition 2: 256MB (not used, this is what I want to use)
>> Partition 3: 200GB (used, for BTRFS)
>> Partition 4: 50GB (not used, but this will be expanded to the curren=
t
>> BTRFS partition)
>>
>> Also as a last note (just in case I've misunderstood something), to
>> resize properly, you should first delete the partition using a
>> partition editor like fdisk, then recreate a new partition with the
>> same start cylinders as the original setup, but with bigger/later en=
d
>> cylinders than the original setup, right? Then e.g. btrfsctl -r +45G=
 /
>> What if I have a RAID-0 array (which I do), which uses the RAID-0
>> routine by BTRFS (and not mdraid or dmraid). Should I then do a
>> "btrfsctl -R +(size*disks)G /" or btrfsctl -R +(size of all disks)G
>> /"?
>>
>> Regards,
>> Sebastian J.
>
> File systems grow (and shrink) at the end, not by moving the
> beginning. =C2=A0However, you can achieve what you are after in this =
case
> as the source partition 3 is smaller that the partition 2 before it.
> Simply copy the BTRFS from partition 3 to partition 2 and then grow
> partition 2 as required.
>
> Detailed steps are like this:
>
> 1) Unmount BTRFS.
> # umount /mntpoint
> 2) Copy BTRFS.
> # dd if=3D/dev/sda3 of=3D/dev/sda2 bs=3D1M
> 3) Re-partition disk.
> # fdisk /dev/sda
> Record start of partition 2 and size of partition =C2=A03.
> Delete partitions 2, 3 and 4.
> Re-create partition 2 from previous start and of size >=3D old partit=
ion 3 size.
> 4) Mount the BTRFS.
> # mount /dev/sda2 /mntpoint
> 5) Grow the BTRFS to fill the larger partition 2.
> # btrfs filesystem resize max /mntpoint
> 6) Update /etc/fstab if needed.
> (If refer to file systems by device like /dev/sda3 rather than UUID=3D=
 or LABEL=3D).
>
> Complexities to be aware of:
> 1) If BTRFS is your root (/) file system:
> 1.1) Boot from a live or rescue CD or USB key.
> 1.2) Update boot loader for new root (/) file system location if
> needed. (If using /dev rather than UUID=3D or LABEL=3D).
> 2) Fdisk (and every other tool) will report that the kernel was unabl=
e
> to re-read the updated partition table if any partitions are mounted
> from it. =C2=A0Unmount all partitions and run 'partprobe' (or other
> command) or reboot.
>
> Mike
>

=46irstly, I'm resending this. I forgot to add linux-btrfs to the recip=
ients list.

Secondly, thanks Mike! I figured I'd have to go through a lot of hoops
to make that work.
Suffice to say, that isn't really possible in my case, considering I
only have a small 256MB partition in front of the 200GB partition.

A have a different question now - can you really have differently
sized partitions spread out on a RAID-0 array? e.g. 2x 200GB and 3x
250GB? That's what I was trying to do, but the drives are getting
remove now.

I'm having an issue with increasing the size though, it seems only to
be doing this on the first drive of the array.

root@m ~ # btrfsctl -r max /
ioctl:: Invalid argument
root@m ~ # btrfs-show
Label: none  uuid: 405f0d0b-ee4d-4426-9826-d2580d0c8d6c
	Total devices 4 FS bytes used 443.41GB
	devid    3 size 189.59GB used 163.00GB path /dev/sda3
	devid    4 size 189.59GB used 163.00GB path /dev/sdc3
	devid    5 size 189.59GB used 92.00GB path /dev/sdd3
	devid    1 size 232.55GB used 181.01GB path /dev/sde3
Btrfs Btrfs v0.19

BTW the reason why /dev/sdd3 has less used than the other drives is
because I'm planning to remove it from the array, but it crashed while
doing it last time - I assume it's because there isn't enough space.
This isn't important though, I just want to get sda3 and sdc3 to get
their sizes increased in btrfs.

As you can see, my drives are already repartitioned, and they still
seem to mount fine:
root@m ~ # fdisk -l /dev/sd{a..e}
Disk /dev/sda: 250.1 GB, 250059350016 bytes
255 heads, 63 sectors/track, 30401 cylinders
/dev/sda1   *           1          12       96358+  fd  Linux raid auto=
detect
/dev/sda2              13          43      249007+  83  Linux
/dev/sda3              44       30401   243850635   83  Linux

Disk /dev/sdc: 250.1 GB, 250059350016 bytes
255 heads, 63 sectors/track, 30401 cylinders
/dev/sdc1   *           1          12       96358+  fd  Linux raid auto=
detect
/dev/sdc2              13          43      249007+  83  Linux
/dev/sdc3              44       30401   243850635   83  Linux

Disk /dev/sdd: 203.9 GB, 203927027200 bytes
255 heads, 63 sectors/track, 24792 cylinders
/dev/sdd1   *           1          12       96358+  fd  Linux raid auto=
detect
/dev/sdd3              44       24792   198796342+  83  Linux

Disk /dev/sde: 250.1 GB, 250058268160 bytes
255 heads, 63 sectors/track, 30401 cylinders
/dev/sde1   *           1          12       96358+  fd  Linux raid auto=
detect
/dev/sde2              13          43      249007+  83  Linux
/dev/sde3              44       30401   243850635   83  Linux

Any help on this one, or a possible bug report?

Regards,
Sebastian J.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
