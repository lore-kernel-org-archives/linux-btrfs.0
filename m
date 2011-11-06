From: Chuck Burns <break19@gmail.com>
Subject: grub-1.99 and btrfs-only
Date: Sat, 05 Nov 2011 21:02:53 -0500
Message-ID: <1485076.Kk29g2Lexo@funbeast>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I have a btrfs-only system, using grub2 (1.99), and have /boot on btrfs as 
well...

When I first boot, grub first complains it cannot find files, then apparently 
successfully finds them, loading the menu..

After I select the option I want, grub again complains of unable to find a file, 
and seconds later begins to properly boot..

This is my boot.cfg
---
set timeout=5

  insmod gpt
  insmod btrfs
  set root=(hd0,gpt3)
  search --no-floppy --fs-uuid --set a549b032-017c-4a96-ae28-5dffe61cff1d
if loadfont /boot/grub/unifont.pf2; then
   set gfxmode=1680x1050
   insmod gfxterm
   insmod vbe
   terminal_output gfxterm
fi

set menu_color_normal=cyan/black
set menu_color_highlight=black/cyan

menuentry "Linux 3.1.0" {
  insmod gpt
  insmod btrfs
  set root=(hd0,gpt3)
  search --no-floppy --fs-uuid --set a549b032-017c-4a96-ae28-5dffe61cff1d
  linux /boot/bzImage-3.1.0 root=/dev/sda3 rootfstype=btrfs
  initrd /boot/initframfs-3.1.0
  set gfxpayload=keep
}
set default=0
---

These are my current subvolumes:
# btrfs sub list /
ID 256 top level 5 path mainroot
ID 257 top level 5 path home

I have sub 256 set as default, and then home is mounted onto mainroot.

I'm assuming that since I have my boot inside that subvolume, that is why 
grub, at first, has issues locating the files, but then manages to find it.

My question is this: Is anyone aware of any grub.cfg magic I can use to 
specify a specific subvolume to look for /boot/grub ? my plan is to eventually 
move boot into it's -own- subvolume, and create more subvolumes for different 
distros.

