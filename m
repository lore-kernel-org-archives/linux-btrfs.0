Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48756 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbeITFW6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Sep 2018 01:22:58 -0400
Subject: Re: cannot mount btrfs as root
To: "Zbigniew 'zibi' Jarosik" <zibi@nora.pl>, linux-btrfs@vger.kernel.org
References: <CAOc3t=v+ZTN7wZRSZO0afx5BVJYzrorD3HWoWkeJyUoUZ2KoTg@mail.gmail.com>
From: anand.jain@oracle.com
Message-ID: <ca1fc1b9-43d3-5def-c8ba-f308448d3042@oracle.com>
Date: Thu, 20 Sep 2018 07:42:28 +0800
MIME-Version: 1.0
In-Reply-To: <CAOc3t=v+ZTN7wZRSZO0afx5BVJYzrorD3HWoWkeJyUoUZ2KoTg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/19/2018 09:19 PM, Zbigniew 'zibi' Jarosik wrote:
> Hi!
> 
> I can't mount my RAID1 set as rootfs, but as normal mount to running
> system works normally. It was working normal, than some day it died.
> 
> When booted to rootfs as
> root=UUID=98c94774-d93a-400e-a275-58cc3ac2a58a rootflags=subvol=@root
> i got:
> 
> BTRFS error (device bcache2): devid 5 uuid
> dd09f810-717e-4f2f-97ab-26469d5adca5 is missing
> BTRFS error (device bcache2): failed to read the system array: -2
> BTRFS error (device bcache2): open_ctree failed
> mount: mounting /dev/bcache2 on /root failed: Invalid argument


Having the '-o degraded' mount option will make this successful but 
looks like the other disk is slow to be identified as you were able to 
mount after boot.

Thanks, Anand

> and (initramfs) prompt.
> 
> Bcache devices are registered and populated in /dev.
> 
> When I boot exacly the same kernel and initrd, but rootfs is on
> pendrive ( root=/dev/sda2 ) than mount dataset to subdir ( mount UUID=
> 98c94774-d93a-400e-a275-58cc3ac2a58a  /data ) - works flawlessly.
> 
> Thanks in advance for any ideas.
> 
> Some system info:
> 
> /dev/sdb1: UUID="780cc211-2408-4594-83df-379ee23d6ed8" TYPE="bcache"
> PARTLABEL="Linux filesystem"
> PARTUUID="ef83f1b4-b55c-4deb-8037-69ff16909222"
> /dev/sdc1: UUID="80a1b115-8a1f-41f7-b65b-dd4fdaf400f1" TYPE="bcache"
> PARTLABEL="Linux filesystem"
> PARTUUID="1f920d16-af68-440b-891c-5ff61c3057ca"
> /dev/sdd1: UUID="a40e80dc-f7e2-4a9c-9bfe-81489a1261ca" TYPE="bcache"
> PARTLABEL="Linux filesystem"
> PARTUUID="4b68c314-f029-402a-b332-b0b9109ad51d"
> /dev/bcache0: UUID="98c94774-d93a-400e-a275-58cc3ac2a58a"
> UUID_SUB="dd09f810-717e-4f2f-97ab-26469d5adca5" TYPE="btrfs"
> /dev/bcache1: UUID="98c94774-d93a-400e-a275-58cc3ac2a58a"
> UUID_SUB="8469962d-f9ee-4b5f-b4d5-4a62190c0d8f" TYPE="btrfs"
> /dev/bcache2: UUID="98c94774-d93a-400e-a275-58cc3ac2a58a"
> UUID_SUB="516f2bd1-3fcc-42fd-87ad-5d5fa2f84b5f" TYPE="btrfs"
> 
> Linux hp1 4.17.11-ldkb #2 SMP Thu Aug 2 09:24:58 CEST 2018 x86_64 GNU/Linux
> btrfs-progs v4.7.3
> Label: none  uuid: 98c94774-d93a-400e-a275-58cc3ac2a58a
>          Total devices 3 FS bytes used 3.21TiB
>          devid    3 size 2.73TiB used 2.07TiB path /dev/bcache2
>          devid    4 size 2.73TiB used 2.18TiB path /dev/bcache1
>          devid    5 size 2.73TiB used 2.18TiB path /dev/bcache0
> Data, RAID1: total=3.20TiB, used=3.20TiB
> System, RAID1: total=32.00MiB, used=480.00KiB
> Metadata, RAID1: total=12.00GiB, used=10.81GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> 
