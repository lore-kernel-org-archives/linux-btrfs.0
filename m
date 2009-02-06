From: Yan Zheng <yanzheng@21cn.com>
Subject: Re: How do I correctly mount a multidevice volume via fstab?
Date: Sat, 7 Feb 2009 02:19:02 +0800
Message-ID: <3d0408630902061019h423d2b06vb444d9d2b54138ef@mail.gmail.com>
References: <loom.20090206T174848-929@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Thomas Kuther <gimpel@sonnenkinder.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20090206T174848-929@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

2009/2/7 Thomas Kuther <gimpel@sonnenkinder.org>:
> Hi all,
>
> I am using a single volume across two devices sdb7 and sda1, initially
> created on sdb7, and added sda1 using btrfs-vol later. The fstab entry:
>
> /dev/disk/by-id/scsi-SATA_ST31000333AS_9TE12DSC-part7
>  /mnt/btrfs btrfs defaults 1 2
>
> Now after boot I get:
> ----
> device fsid c4822885057410c-d2d65a83c2f15fb4 devid 1
>  transid 73034 /dev/sdb7
> btrfs: failed to read chunk tree on sdb7
> ----
>
> So I have to run btrfsctl -a first, then mounting works. Can this be done
> via fstab?

you can add 'device=/dev/xxx' to the mount options field.

for example:
/dev/disk/by-id/scsi-SATA_ST31000333AS_9TE12DSC-part7 /mnt/btrfs btrfs
device=/dev/disk/by-id/scsi-SATA_ST31000333AS_9TE12DSC-part1 1 2

Regards
Yan Zheng
