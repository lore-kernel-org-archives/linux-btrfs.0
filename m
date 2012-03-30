From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: btrfs bugs on statfs on ro device
Date: Fri, 30 Mar 2012 17:23:41 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1203301722090.8371@frira.zrqbmnf.qr>
References: <alpine.LNX.2.01.1203301709510.16756@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.01.1203301709510.16756@frira.zrqbmnf.qr>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 2012-03-30 17:13, Jan Engelhardt wrote:

>Attempting to run `df` on a read-only btrfs crashes the kernel:
>  # losetup -r -o $[313344*512] /dev/loop4 wholedisk.img
>  # mount -o ro /dev/loop4 /mnt
>device fsid 4ba1fa38-d62b-4940-9825-7e6cceb7fcc8 devid 1 transid 4333 /dev/loop4
>  # df
>kernel BUG at [openSUSE 12.1 Rescue CD kernel] /home/abuild/rpmbuild/BUILD/kernel-default-3.1.0/linux-3.1/fs/btrfs/super.c:984!
> 983:   nr_devices = fs_info->fs_devices->rw_devices;
>>984:   BUG_ON(!nr_devices);

Turns out this was addressed in later stable kernels of theirs (which 
rescue cds unfortunately seldom get).
