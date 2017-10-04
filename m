Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:63560 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751115AbdJDBi0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Oct 2017 21:38:26 -0400
Subject: Re: Can't mount array with super_total_bytes mismatch with fs_devices
 total_rw_bytes
To: Asif Youssuff <yoasif@gmail.com>, linux-btrfs@vger.kernel.org
References: <f561678d-17f0-f06e-b781-3445a59e0349@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <9dc8fe6e-bda5-2b19-b616-ab64696f2102@gmx.com>
Date: Wed, 4 Oct 2017 09:38:16 +0800
MIME-Version: 1.0
In-Reply-To: <f561678d-17f0-f06e-b781-3445a59e0349@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年10月04日 07:32, Asif Youssuff wrote:
> Hi,
> 
> My power went out at my home, and I'm now having trouble mounting my array.
> 
> I'm mounting with the 'recovery' option in fstab.
> 
> When mounting, dmesg output shows:
> 
> [210017.281912] BTRFS info (device sdb): disk space caching is enabled
> [210017.281915] BTRFS info (device sdb): has skinny extents
> [210017.402084] BTRFS error (device sdb): super_total_bytes 92017859088384
> mismatch with fs_devices total_rw_bytes 92017859094528

One of your device size is not aligned to 4K.
Which is fine, but recently enhanced validation checker does not allow it.
(Which should be a regression, and there is some other WARN_ON related 
to it)

> [210017.402126] BTRFS error (device sdb): failed to read chunk tree: -22
> [210017.461473] BTRFS error (device sdb): open_ctree failed
> 
> I've tried a few steps --
> 
> btrfs-chunk-recover, super-recover and I have run a btrfs check --repair 
> on two of the disks in the array (this takes a very long time, so I'm 
> hoping I don't have to run this on all of the disks).
> 
> I had run into this problem once before in the past, and I'm not sure 
> how I recovered from it; I may have simply rolled back the booted kernel 
> to escape the extra checks around this mismatch.
> 
> I'm at a loss for ideas and am running a btrfs-image so I can also 
> report an issue -- I'm not sure whether 'btrfs-image -c9 -t4 /dev/sdo 
> btrfs.image' is  the right command to run if it is a multi-device array.
> 
> Any ideas would be helpful, and I am happy to provide further information.
> 
> root@ubuntu-server:~#   uname -a
> Linux ubuntu-server 4.14.0-041400rc2-generic #201709242031 SMP Mon Sep 
> 25 00:33:13 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux

You can rollback to an earlier kernel to mount the fs.

And manually find and resize the device with unaligned size:

# btrfs fi show -b
And check each device for its size:
Label: none  uuid: 839ddcfa-5701-4437-aff3-bcb2a26ae6dd
	Total devices 1 FS bytes used 397312
	devid    1 size <<10737418240>> used 2172649472 path /dev/mapper/data-btrfs

If it's not align, round it down to 4K, and resize it using devid:

# btrfs fi resize <devid>:<rounded_size> <mount_point>

All device must be rounded. And the command should finish almost in no time.

Then check if latest kernel can mount it.

I think it can be made as part of "btrfs check" to fix it.
(Although it should be handled by kernel well)

Thanks,
Qu

> 
> root@ubuntu-server:~#   btrfs --version
> btrfs-progs v4.13.1
> 
> root@ubuntu-server:~#   btrfs fi show
> Label: none  uuid: 48ed8a66-731d-499b-829e-dd07dd7260cc
> Total devices 13 FS bytes used 40.73TiB
> devid    4 size 5.46TiB used 5.42TiB path /dev/sdo
> devid    5 size 5.46TiB used 5.42TiB path /dev/sdn
> devid    7 size 5.46TiB used 5.42TiB path /dev/sdc
> devid    9 size 5.46TiB used 5.42TiB path /dev/sdk
> devid   10 size 5.46TiB used 5.42TiB path /dev/sdj
> devid   11 size 7.28TiB used 7.24TiB path /dev/sdd
> devid   12 size 5.46TiB used 5.42TiB path /dev/sdm
> devid   14 size 7.28TiB used 7.24TiB path /dev/sdh
> devid   15 size 7.28TiB used 7.24TiB path /dev/sdb
> devid   17 size 7.28TiB used 5.77TiB path /dev/sdl
> devid   18 size 7.28TiB used 7.24TiB path /dev/sdf
> devid   20 size 7.28TiB used 7.24TiB path /dev/sdi
> devid   21 size 7.28TiB used 7.24TiB path /dev/sdg
> 
> Thanks,
> Asif
