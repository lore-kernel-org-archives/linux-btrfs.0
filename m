From: Thomas Kuther <gimpel@sonnenkinder.org>
Subject: Re: How do I correctly mount a multidevice volume via fstab?
Date: Fri, 6 Feb 2009 19:17:15 +0000 (UTC)
Message-ID: <loom.20090206T191551-121@post.gmane.org>
References: <loom.20090206T174848-929@post.gmane.org> <3d0408630902061019h423d2b06vb444d9d2b54138ef@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Yan Zheng <yanzheng <at> 21cn.com> writes:

> > So I have to run btrfsctl -a first, then mounting works. Can this be done
> > via fstab?
> 
> you can add 'device=/dev/xxx' to the mount options field.
> 
> for example:
> /dev/disk/by-id/scsi-SATA_ST31000333AS_9TE12DSC-part7 /mnt/btrfs btrfs
> device=/dev/disk/by-id/scsi-SATA_ST31000333AS_9TE12DSC-part1 1 2
> 
> Regards
> Yan Zheng

Ah nice, that easy.

Thank you!

Best,
Thomas

