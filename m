From: CACook@quantum-sci.com
Subject: Cannot Create Partition
Date: Sun, 23 Jan 2011 10:07:54 -0800
Message-ID: <201101231007.55046.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


On /dev/sda I have sda1 which is my / bootable filesystem for Debian formatted ext4.  This is 256MB on a 2TB drive.

I want to set up the rest of the drive as BTRFS for various functions, and I presume that I first have to create a partition using fdisk for this?  Since my first part is ext4?  So I:
# fdisk /dev/sda
WARNING: GPT (GUID Partition Table) detected on '/dev/sda'! The util fdisk doesn't support GPT. Use GNU Parted.
WARNING: DOS-compatible mode is deprecated. It's strongly recommended to
         switch off the mode (command 'c') and change display units to
         sectors (command 'u').
Command (m for help): p
Disk /dev/sda: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000
   Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1      243202  1953514583+  ee  GPT
Command (m for help): n
Command action
   e   extended
   p   primary partition (1-4)
p
Partition number (1-4): 2
No free sectors available
Command (m for help):
-------------------------------------------------
Whaa?

Maybe it's possible that I just mkfs.btrfs /dev/sda and it will set up -only- the remaining space, but I'm afraid that this may destroy my OS.

Also, what if I want to set up the whole drive as BTRFS?  Could this be bootable, and can the canned Debian kernel load the BTRFS driver for boot at install?  Or would I boot to the CD, mkfs.btrfs the drive, then install Debian?  Anyone tried this?


