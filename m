Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:50451 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327Ab2JRLaN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Oct 2012 07:30:13 -0400
Received: by mail-ia0-f174.google.com with SMTP id y32so6231482iag.19
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Oct 2012 04:30:11 -0700 (PDT)
MIME-Version: 1.0
From: Marguerite Su <i@marguerite.su>
Date: Thu, 18 Oct 2012 19:29:50 +0800
Message-ID: <CAK0PdAk3+wPR_MerCNFgCvCC01c1RJ31=Z=G9=hT5eyYfn=iNg@mail.gmail.com>
Subject: initramfs take a long time to load[135s]
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, all,

I ran into a situation that no useful information can be found over
the internet...

I'm using 3.6.2 + btrfs git compiled using dkms, and I have a 300GB
btrfs /home and 50GB btrfs /:

Disk /dev/sda: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders, total 1953525168 sectors
Units = 扇区 of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x0004746f

   设备 Boot      Start         End      Blocks   Id  System
/dev/sda1            2048     4208639     2103296   82  Linux swap / Solaris
/dev/sda2   *     4209030     5237189      514080   83  Linux
/dev/sda3         5237190  1748723444   871743127+   5  Extended
/dev/sda4      1748723712  1953523711   102400000    7  HPFS/NTFS/exFAT
/dev/sda5       109081413   724724279   307821433+  83  Linux
/dev/sda6         5237316   109081349    51922017   83  Linux
/dev/sda7       808615936  1748721663   470052864   83  Linux

At first, it was NetworkManager that took 80000ms to load( a btrfs
only problem),
after some debugging. I added comment="systemd.automount" to my btrfs partition.
then the only problem left is that kernel+userspace took 135s to
initialize then -.mount
and all other systemd service can continue:

/dev/disk/by-id/ata-SAMSUNG_HN-M101MBB_S2R8J9BB808817-part1 swap
          swap       defaults              0 0
UUID=9b9aa9d9-760e-445c-a0ab-68e102d9f02e /                    btrfs
   defaults,comment=systemd.automount              1 1
/dev/disk/by-id/ata-SAMSUNG_HN-M101MBB_S2R8J9BB808817-part2 /boot
          ext4       acl,user_xattr        1 2
UUID=559dec06-4fd0-47c1-97b8-cc4fa6153fa0 /home                btrfs
    defaults,comment=systemd.automount              1 2
/dev/disk/by-id/ata-SAMSUNG_HN-M101MBB_S2R8J9BB808817-part4 /windows/C
          ntfs-3g
users,gid=users,comment=systemd.automount,fmask=133,dmask=022,locale=zh_TW.UTF-8
0 0
proc                 /proc                proc       defaults              0 0
sysfs                /sys                 sysfs      noauto                0 0
debugfs              /sys/kernel/debug    debugfs    noauto                0 0
usbfs                /proc/bus/usb        usbfs      noauto                0 0
devpts               /dev/pts             devpts     mode=0620,gid=5       0 0

systemd-analyze blame | head
 44638ms systemd-logind.service
 40928ms syslog.service
 14567ms network.service
 13093ms network-remotefs.service
 13022ms NetworkManager.service
  9809ms systemd-modules-load.service
  3835ms systemd-vconsole-setup.service
  3450ms localnet.service
  2977ms udev-root-symlink.service
  2443ms sys-kernel-security.mount

plot: http://paste.opensuse.org/84499659

And Frederic said it seemed to be a known bug that need to clear_cache
for 3.4+ kernel.

I did. but the problem still exist.

The original bug report is here:
https://bugzilla.novell.com/show_bug.cgi?id=776563

So anyone can help me debugging this?

Thanks

Marguerite
