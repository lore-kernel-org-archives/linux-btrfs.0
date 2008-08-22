From: Paul Schyska <pschyska@googlemail.com>
Subject: Mount btrfs from initramfs as /
Date: Fri, 22 Aug 2008 14:52:43 +0000 (UTC)
Message-ID: <loom.20080822T144041-753@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

i recently tried copy my ubuntu intrepid installation to a btrfs file s=
ystem.
This is what I did:
- Download 0.16 tarballs of kernel and progs, build them and install th=
em
Note: I was unable to build the hg trunk. I am using a 2.6.27-rc1 kerne=
l build
with reiser4 patches. The error i got is:=20
/home/pschyska/btrfs/kernel-unstable/extent_io.c: In function
=E2=80=98read_extent_buffer_pages=E2=80=99:
/home/pschyska/btrfs/kernel-unstable/extent_io.c:2942: error: implicit
declaration of function =E2=80=98trylock_page=E2=80=99
However, I was able to build 0.16 release tarballs.
- Next, I copied btrfs.ko to :/lib/modules/2.6.27-rc1-reiser4/kernel/fs=
 and ran
depmod.
- I create an btrfs fs with mkfs.btrfs /dev/sd/lib/modules/2.6.27-rc1-r=
eiser4/a3
and added it to fstab
- After reboot, the btrfs fs was mounted and writable
- I booted into btrfs 0.16 enabled beta of sysresccd and
cp -a /mnt/sda3/* /mnt/sda4
- I modified fstab on /mnt/sda4/etc/fstab to mount the btrfs volume as =
/
- I modified grub/menu.lst accordingly (root=3D/dev/sda3) and update-gr=
ub
- i update etc/initrams-tools/modules to include btrfs and crc32_le and=
 ran
update-initramfs

Unfortunately, i get the error similar to "could not find /dev/sda3" an=
d after a
while drop to busybox (or whatever its called) when booting. In the bus=
ybox
shell i can=20
mount /dev/sda3 /tmp and /tmp shows my btrfs file system
Also, /proc/cmdline shows correct root=3D/dev/sda3
/proc/modules include btrfs and crc32_le.

Am I missing something?
P.S.: I dont have an UUID symlink for /dev/sda3, as I don't know how to=
 find out
the UUID of the new volume. Thats why I didn't specify UUID in fstab bu=
t
/dev/sda3 device.

thank you very much for your help!

P.P.S.: I used a similar process with cp -a from livecd to move my ubun=
tu from
an ext3 volume to reiser4 initially. So it should work!

Best regards,

Paul

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
