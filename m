From: =?UTF-8?B?SmFyaSBTZXBww6Rsw6Q=?= <lihamakaroonilaatikko@gmail.com>
Subject: Fixing raid1 boot
Date: Wed, 11 Aug 2010 14:21:03 +0300
Message-ID: <4C62879F.5040205@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


I have av machine which has btrfs raid1 root which I cannot boot
anymore. The problem seems to be related to "verify_parent_transid"
messages already discussed on this mailing list. However, there is no
actual help yet available to my case.

Disks
/dev/sda1 and /dev/sdb1 as /boot, 100Mb, ext3, manually mirrored
/dev/sda6 and /dev/sda6 as /, 50Gb, btrfs raid1
/dev/sda7 and /dev/sdb7 as /mnt/share, 543Gb, btrfs raid1

Boot fails and starts to loop with errors "parent transid verify failed=
 on".

However, I was able to boot from usb stick and mount the partitions wit=
h
"mount UUID=3D... <mount point> -o degraded". After unmounting the UUID
identified partitions I was also able to mount them without the "-o
degraded". Also btrfs-show shows raid devices as _not_degraded_. The
initrd+vmlinuz in use have been able to boot the / and /mnt/share befor=
e
but one boot caused by power failure corrupted something. I also can
mount /dev/sd[ab][67] directly but

I tried to use "btrfs-vol -r /dev/sd[ab][67]" with various combinations
without any luck.

btrfsck /dev/sda6 or /dev/sdb6 gives
 leaf parent key incorrect <number>
 bad block <number>

btrfsck /dev/sda7 or /dev/sdb7 gives no errors.

Any help on how to fix this boot appreciated. Especially

* How can I be sure that raid1 mirror is ok?
* Is there a way to fix any fs errors? Btrfsck does not fix just
  reports?

And yes, I know btrfs is experimental but I decided to try it anyway. I=
t
worked nicely for a week and only two problems are this recovery from
failures and hacking mkinitrd to run "btrfs device scan" which enables
boot from btrfs raid1 root partition.

Jari
--=20
*** Jari Sepp=C3=A4l=C3=A4
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
