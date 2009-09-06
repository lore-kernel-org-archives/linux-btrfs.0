From: Marcus <smurca@googlemail.com>
Subject: Discrepant st_rdev and st_dev stats in btrfs block and fs device ids
Date: Sun, 6 Sep 2009 16:51:55 +0100
Message-ID: <7a83c8e0909060851w70305142oc775b28bcd1ef093@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I think I found a btrfs 0.19 problem when used in an lvm2 volume;
btrfs is returning a st_dev stat from the mounted filesystem / that is
different from the lvm2 blockdevice st_rdev stat in
/dev/mapper/vg0-os0.

This btrfs behavior is different from ext4, where the st_dev and
st_rdev stats match (http://pastebin.com/m64e90a8e or a summary
below). Because of that, in grub2, 'grub-probe -t device / ' fails
with ' grub-probe: error: cannot find a device for /. ' , and so
update-grub2 fails causing cascading problems all around.

Can anyone repeat this? Any ideas why this could be happening? Is this =
expected?

Thanks,
Marcus
--
# uname -a
Linux frog 2.6.31-9-generic #29-Ubuntu SMP Sun Aug 30 17:39:23 UTC
2009 i686 GNU/Linux

# btrfs-show
Label: none=A0 uuid: c5bffbe1-6968-4eee-a800-8346df56459a
=A0=A0=A0 Total devices 1 FS bytes used 2.15GB
=A0=A0=A0 devid=A0=A0=A0 1 size 10.00GB used 10.00GB path /dev/mapper/v=
g0-os0
Btrfs Btrfs v0.19

# mount
/dev/mapper/vg0-os0 on / type btrfs (rw,errors=3Dremount-ro)
/dev/mapper/vg0-os0 on /tmp/os0 type btrfs (rw)
/dev/mapper/vg0-os1 on /tmp/os1 type ext4 (rw)


stat.st_rdev for /dev/mapper/vg0-os0:64512
stat.st_rdev for /dev/mapper/vg0-os1:64513
stat.st_dev for /:16
stat.st_dev for /tmp/os0:16
stat.st_dev for /tmp/os1:64513

--
PS:
Btw, in case someone else comes across this problem, a quick
workaround for grub2 is to modify /usr/sbin/grub-mkconfig so that
GRUB_DEVICE points directly to your btrfs lvm2 block device:

# diff grub-mkconfig.orig grub-mkconfig
1122c122
< GRUB_DEVICE=3D"`${grub_probe} --target=3Ddevice /`"
---
> GRUB_DEVICE=3D"/dev/mapper/vg0-os0"
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
