From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: Oops and somewhat borked filesystem after btrfs-convert and image
	removal
Date: Tue, 27 Oct 2009 10:23:18 +0800
Message-ID: <3d0408630910261923l70810a4bm99c719919c7cc99e@mail.gmail.com>
References: <87k4yi6kh9.fsf@kiiro.naked.iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Nuutti Kotivuori <naked@iki.fi>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <87k4yi6kh9.fsf@kiiro.naked.iki.fi>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 27, 2009 at 3:09 AM, Nuutti Kotivuori <naked@iki.fi> wrote:
> Hello,
>
> I managed to get an oops and a somewhat borked btrfs filesystem after
> using btrfs-convert and then removing the image file. I will explain =
the
> full sequence of actions below (as I remember it):
>
> =A0- In the beginning, I have an ext3 filesystem that I'd like to con=
vert
> =A0 to btrfs
>
> =A0- I run btrfs-convert on the filesystem, forgetting to do fsck bef=
ore
> =A0 it - however, I have done a full fsck recently on the filesystem,=
 and
> =A0 it was cleanly unmounted (no journal replay necessary)
>
> =A0- Conversion runs smoothly
>
> =A0- I boot the newly converted filesystem as a root filesystem for m=
y
> =A0 computer, and everything looks good. "df" reports proper free spa=
ce.
>
> =A0- I mount the subvolume with the ext2 filesystem under /mnt, while
> =A0 having the btrfs main volume as my root filesystem:
>
> =A0 =A0 mount -t btrfs -o subvol=3Dext2_saved /dev/mapper/perspire-ro=
ot /mnt
>
> =A0- I remove the image file from the subvolume:
>
> =A0 =A0 rm /mnt/image
>
> =A0- At this time, during or immediately after the removal, I get a
> =A0 notification of a kernel oops, which is here:
>
> =A0 =A0 http://www.kerneloops.org/submitresult.php?number=3D823167

This is a known bug in btrfs kernel driver, it's fixed in 2.6.32-rcX.

>
> =A0- I unmount the subvolume:
>
> =A0 =A0 umount /mnt
>
> =A0- I reboot the computer, after which I check "df":
>
> =A0 =A0 /dev/mapper/perspire-root 7245824 -73786976294826385180 -4575=
460 100% /

This is a known bug in btrfs-progs 0.19, it's fixed in btrfs-progs-unta=
ble tree.

>
> =A0 (Sizes in 1K-blocks, used space being the hugely negative number,=
 and
> =A0 available being the somewhat less huge number.)
>
> =A0- Btrfsck reports:
>
> =A0 =A0 root 5 inode 453339 errors 2
> =A0 =A0 root 5 inode 453343 errors 2
> =A0 =A0 root 5 inode 453347 errors 2
> =A0 =A0 root 5 inode 453356 errors 2
> =A0 =A0 root 5 inode 466532 errors 2
> =A0 =A0 root 5 inode 466537 errors 2
> =A0 =A0 root 5 inode 466540 errors 2
> =A0 =A0 root 5 inode 466544 errors 2
> =A0 =A0 found 5867835392 bytes used err is 1
> =A0 =A0 total csum bytes: 5477992
> =A0 =A0 total tree bytes: 258371584
> =A0 =A0 total fs tree bytes: 228814848
> =A0 =A0 btree space waste bytes: 71477071
> =A0 =A0 file data blocks allocated: 8317644800
> =A0 =A0 =A0referenced 5582884864
> =A0 =A0 Btrfs Btrfs v0.19

These errors are not critical. Some inodes' link counts are zero,
but they aren't marked as orphan inodes. I have no idea how this
can happen. Did you run btrfsck on mounted FS?

>
> =A0- Otherwise the filesystem seems to be in perfect working order, n=
o
> =A0 problems that I can see. I have been using it for several days af=
ter
> =A0 the incident now.
>
> Then, useful info:
>
> =A0- Kernel: 2.6.31-trunk-686 (debian experimental)
> =A0- Btrfs utilities: 0.19-5 (debian package)
> =A0- Hardware: Acer Aspire One, with 8 Gb SSD
>
> Please let me know if you have any further questions, or want the
> btrfs-debug-tree output of the filesystem or something similar. I wil=
l
> not be reading the list, so please e-mail me directly as well.
>
> Also, I am wondering, how am I supposed to fix this situation? I see
> conflicting info if btrfsck can be run on a mounted filesystem (I did
> run it on a mounted filesystem above, as can be seen) - but is it
> supposed to be able to fix this kind of corruption?
>
> (In this case, the data on the drive is not crucial, I can fix it by
> reinstalling or just copying files out and in, but that's obviously n=
ot
> good enough solution for a stable release.)

Copying files out and in is the simplest and safest solution.
Sorry for the inconvenience.

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
