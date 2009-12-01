From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: Re: Unable to mount loopback devices in RAID mode
Date: Tue, 01 Dec 2009 14:56:50 +0900
Message-ID: <4B14B022.4080102@jp.fujitsu.com>
References: <200911192026.04694.lists-receive@programmierforen.de> <20091130042851.GG25509@jsoft.dyndns.org> <4B13C408.10606@hp.com> <200911302025.22773.lists-receive@programmierforen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: jowens@hp.com, linux-btrfs@vger.kernel.org
To: lists-receive@programmierforen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200911302025.22773.lists-receive@programmierforen.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

It seems to me this error is caused by device control policy
of btrfs, not mkfs.

This error occures not only on loopback devices, but also
on normal block devices (with one difference in procedure).

# mkfs.btrfs -m raid1 -d raid1 /dev/hdc1 /dev/hdc2
# reboot (<- This is a difference.)
  (after reboot)
# mount -t btrfs /dev/hdc1 /mnt/
mount: wrong fs type, bad option, bad superblock on /dev/hdc1,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

Otherwise, when you do losetup before mkfs, it works even if
loopback devices.

# dd ~~~ (create files)
# losetup /dev/loop1 img1
# losetup /dev/loop2 img2
# mkfs.btrfs -m raid1 -d raid1 /dev/loop1 /dev/loop2
# mount -t btrfs /dev/loop1 /mnt/ (-> OK)

Btrfs collects block device information when mount or mkfs
(device_list_add in volumes.c), and know devid-device relation
by collected information. So, if we make filesystem on plain
file, btrfs cannot know devid-device relation. As a result,
btrfs cannot know which is 'devid=n', and mount fails. Same as
this, if collected relation is cleared by shutdown, mount fails.

If we need to mount a filesystem without fail(cf, /etc/fstab line),
we should specify 'device' options for every devices(except mount
target device) like this.

# mount -t btrfs -o device=/dev/loop2,device=/dev/loop3,
  device=/dev/loop4 /dev/loop1 /mnt/
   (when a filesystem is constructed by /dev/loop[1-4])

Regards,
taruisi

Andi Drebes wrote:
> Hi!
> 
>> So I do not understand why it does not work correctly for
>> him to mount either device.  Maybe this problem is not
>> what I see in my testing (using 32) with disk partitions
>> instead of loop.
>>
>> With partitions, I only see the mount problem on raid0,
>> not on raid1.
> Without having looked at the code:
> It seems as if this is a problem in mkfs. The first time, I mount the fresh image I have to search the correct device. After having mounted it at least once, I can use both devices interchangeably:
> 
> $ dd if=/dev/zero of=raid1_0.img bs=1M count=500
> $ dd if=/dev/zero of=raid1_1.img bs=1M count=500
> $ mkfs.btrfs -m raid1 -d raid1 raid1_0.img raid1_1.img
> $ losetup /dev/loop0 raid1_0.img
> $ losetup /dev/loop1 raid1_1.img
> $ mount -t btrfs /dev/loop0 /mnt/btrfs
> mount: wrong fs type, bad option, bad superblock on /dev/loop0,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so
> $ mount -t btrfs /dev/loop1 /mnt/btrfs
> #OK
> $ umount /mnt/btrfs
> $ mount -t btrfs -o ro /dev/loop0 /mnt/btrfs
> #OK
> $ umount /mnt/btrfs
> $ mount -t btrfs -o ro /dev/loop1 /mnt/btrfs
> #OK
> 
> So my guess is, that there's something wrong with mkfs.
> 
> 	Cheers,
> 		Andi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
taruisi

