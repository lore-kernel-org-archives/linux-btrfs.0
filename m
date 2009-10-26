From: Nuutti Kotivuori <naked@iki.fi>
Subject: Oops and somewhat borked filesystem after btrfs-convert and image removal
Date: Mon, 26 Oct 2009 21:09:06 +0200
Message-ID: <87k4yi6kh9.fsf@kiiro.naked.iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I managed to get an oops and a somewhat borked btrfs filesystem after
using btrfs-convert and then removing the image file. I will explain the
full sequence of actions below (as I remember it):

 - In the beginning, I have an ext3 filesystem that I'd like to convert
   to btrfs

 - I run btrfs-convert on the filesystem, forgetting to do fsck before
   it - however, I have done a full fsck recently on the filesystem, and
   it was cleanly unmounted (no journal replay necessary)

 - Conversion runs smoothly

 - I boot the newly converted filesystem as a root filesystem for my
   computer, and everything looks good. "df" reports proper free space.

 - I mount the subvolume with the ext2 filesystem under /mnt, while
   having the btrfs main volume as my root filesystem:

     mount -t btrfs -o subvol=ext2_saved /dev/mapper/perspire-root /mnt

 - I remove the image file from the subvolume:

     rm /mnt/image

 - At this time, during or immediately after the removal, I get a
   notification of a kernel oops, which is here:

     http://www.kerneloops.org/submitresult.php?number=823167

 - I unmount the subvolume:

     umount /mnt

 - I reboot the computer, after which I check "df":

     /dev/mapper/perspire-root 7245824 -73786976294826385180 -4575460 100% /

   (Sizes in 1K-blocks, used space being the hugely negative number, and
   available being the somewhat less huge number.)

 - Btrfsck reports:

     root 5 inode 453339 errors 2
     root 5 inode 453343 errors 2
     root 5 inode 453347 errors 2
     root 5 inode 453356 errors 2
     root 5 inode 466532 errors 2
     root 5 inode 466537 errors 2
     root 5 inode 466540 errors 2
     root 5 inode 466544 errors 2
     found 5867835392 bytes used err is 1
     total csum bytes: 5477992
     total tree bytes: 258371584
     total fs tree bytes: 228814848
     btree space waste bytes: 71477071
     file data blocks allocated: 8317644800
      referenced 5582884864
     Btrfs Btrfs v0.19

 - Otherwise the filesystem seems to be in perfect working order, no
   problems that I can see. I have been using it for several days after
   the incident now.

Then, useful info:

 - Kernel: 2.6.31-trunk-686 (debian experimental)
 - Btrfs utilities: 0.19-5 (debian package)
 - Hardware: Acer Aspire One, with 8 Gb SSD

Please let me know if you have any further questions, or want the
btrfs-debug-tree output of the filesystem or something similar. I will
not be reading the list, so please e-mail me directly as well.

Also, I am wondering, how am I supposed to fix this situation? I see
conflicting info if btrfsck can be run on a mounted filesystem (I did
run it on a mounted filesystem above, as can be seen) - but is it
supposed to be able to fix this kind of corruption?

(In this case, the data on the drive is not crucial, I can fix it by
reinstalling or just copying files out and in, but that's obviously not
good enough solution for a stable release.)

-- Naked
