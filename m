Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from datenkhaos.de ([81.89.99.198]:35266 "EHLO datenkhaos.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbaIMVX0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Sep 2014 17:23:26 -0400
Date: Sat, 13 Sep 2014 23:23:20 +0200
From: Johannes Hirte <johannes.hirte@datenkhaos.de>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: "xavier.gnata@gmail.com" <xavier.gnata@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: "Btrfs: device_list_add() should not update list when mounted"
 breaks subvol mount
Message-ID: <20140913232320.64fd189c@datenkhaos.de>
In-Reply-To: <20140913195525.333f93a4@datenkhaos.de>
References: <20140911002241.201bc6c2@datenkhaos.de>
	<54110AEC.6040301@oracle.com>
	<54135AE7.40400@gmail.com>
	<5413D7E5.6080905@oracle.com>
	<20140913195525.333f93a4@datenkhaos.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 13 Sep 2014 19:55:25 +0200
Johannes Hirte <johannes.hirte@datenkhaos.de> wrote:

> On Sat, 13 Sep 2014 13:36:37 +0800
> Anand Jain <Anand.Jain@oracle.com> wrote:
> 
> > Xavier, Johannes,
> > 
> >      The quickest workaround for you will be to try to match
> >   the device path as in the btrfs fi show -m </mnt> output to
> >   your probably fstab/mnttab entry.
> 
> Doesn't work here. I don't even get a path with the affected kernels.
> I'll get:
> 
> Label: none  uuid: 02edbd6b-f044-4800-b21e-ca8982c2c2e5
>         Total devices 1 FS bytes used 270.10GiB
>         *** Some devices missing
> 
> Btrfs v3.16
> 
> with a working kernel:
> 
> Label: none  uuid: 02edbd6b-f044-4800-b21e-ca8982c2c2e5
>         Total devices 1 FS bytes used 270.10GiB
>         devid    1 size 293.89GiB used 289.06GiB path /dev/sda1
> 
> Btrfs v3.16
> 
> Filesystem layout is:
> 
> subvolid 0 contains only the different subvolumes
> 
> ID 257 gen 414674 top level 5 path rootfs
> ID 269 gen 414615 top level 5 path home-USER1
> ID 317 gen 411498 top level 5 path home-USER2
> ID 363 gen 410939 top level 5 path home-USER3
> ID 382 gen 315844 top level 5 path home-USER4
> ID 933 gen 410514 top level 5 path home-USER5
> ID 995 gen 315756 top level 5 path homefs-USER6
> 
> subvol rootfs (ID 257) is set to the default subvolume, mounted at
> start. Grub commandline is like following:
> 
> root=/dev/sda1 ro rootflags=subvol=rootfs,inode_cache,autodefrag
> 
> It doesn't matter, if the subvol parameter is set. I've tried with,
> without and with subvolid=0 parameter. Everytime the same result.
> 
> 
> And now I was able to reproduce on a second machine. The main
> difference between the affected and the unaffected systems is
> initramfs. On the affected systems, I don't use one. On the working
> systems, the rootfs is mounted via initramfs before. I'll test, if an
> initramfs will solve the issue. Seems likely, cause if I put the disk
> of an affected system into a working system and mount it there,
> everything works.

Of course, with the initramfs it works. Content of the init-script:

#!/bin/sh

mount -t devtmpfs devtmpfs /dev
mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t tmpfs tmpfs /run
sleep 3  # wait for kernel msgs to quiet

echo "loading initrd"

btrfs dev scan
sleep 5

mount -o ro,subvol=rootfs,inode_cache,autodefrag /dev/sda1 /newroot

if [[ -x /newroot/sbin/init ]]; then
        umount /sys /proc
        exec switch_root /newroot /sbin/init
fi

#rescue shell
exec sh
