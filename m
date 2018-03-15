Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.55]:36202 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752762AbeCOUcx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Mar 2018 16:32:53 -0400
Reply-To: waxhead@dirtcellar.net
Subject: Re: Crashes running btrfs scrub
To: Mike Stevens <michael.stevens@bayer.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <06b1fdb0d1884406a2d4c2e8be75e289@MOXDE7.na.bayer.cnb>
From: waxhead <waxhead@dirtcellar.net>
Message-ID: <5389894b-5553-27b8-f9b3-4f6938bd75dd@dirtcellar.net>
Date: Thu, 15 Mar 2018 21:32:50 +0100
MIME-Version: 1.0
In-Reply-To: <06b1fdb0d1884406a2d4c2e8be75e289@MOXDE7.na.bayer.cnb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mike Stevens wrote:
> First, the required information
>   
> ~ $ uname -a
> Linux auswscs9903 3.10.0-693.21.1.el7.x86_64 #1 SMP Wed Mar 7 19:03:37 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux
>   ~ $ btrfs --version
> btrfs-progs v4.9.1
>   ~ $ sudo btrfs fi show
> Label: none  uuid: 77afc2bb-f7a8-4ce9-9047-c031f7571150
>          Total devices 34 FS bytes used 89.06TiB
>          devid    1 size 5.46TiB used 4.72TiB path /dev/sdb
>          devid    2 size 5.46TiB used 4.72TiB path /dev/sda
>          devid    3 size 5.46TiB used 4.72TiB path /dev/sdx
>          devid    4 size 5.46TiB used 4.72TiB path /dev/sdt
>          devid    5 size 5.46TiB used 4.72TiB path /dev/sdz
>          devid    6 size 5.46TiB used 4.72TiB path /dev/sdv
>          devid    7 size 5.46TiB used 4.72TiB path /dev/sdab
>          devid    8 size 5.46TiB used 4.72TiB path /dev/sdw
>          devid    9 size 5.46TiB used 4.72TiB path /dev/sdad
>          devid   10 size 5.46TiB used 4.72TiB path /dev/sdaa
>          devid   11 size 5.46TiB used 4.72TiB path /dev/sdr
>          devid   12 size 5.46TiB used 4.72TiB path /dev/sdy
>          devid   13 size 5.46TiB used 4.72TiB path /dev/sdj
>          devid   14 size 5.46TiB used 4.72TiB path /dev/sdaf
>          devid   15 size 5.46TiB used 4.72TiB path /dev/sdag
>          devid   16 size 5.46TiB used 4.72TiB path /dev/sdh
>          devid   17 size 5.46TiB used 4.72TiB path /dev/sdu
>          devid   18 size 5.46TiB used 4.72TiB path /dev/sdac
>          devid   19 size 5.46TiB used 4.72TiB path /dev/sdk
>          devid   20 size 5.46TiB used 4.72TiB path /dev/sdah
>          devid   21 size 5.46TiB used 4.72TiB path /dev/sdp
>          devid   22 size 5.46TiB used 4.72TiB path /dev/sdae
>          devid   23 size 5.46TiB used 4.72TiB path /dev/sdc
>          devid   24 size 5.46TiB used 4.72TiB path /dev/sdl
>          devid   25 size 5.46TiB used 4.72TiB path /dev/sdo
>          devid   26 size 5.46TiB used 4.72TiB path /dev/sdd
>          devid   27 size 5.46TiB used 4.72TiB path /dev/sdi
>          devid   28 size 5.46TiB used 4.72TiB path /dev/sdn
>          devid   29 size 5.46TiB used 4.72TiB path /dev/sds
>          devid   30 size 5.46TiB used 4.72TiB path /dev/sdm
>          devid   31 size 5.46TiB used 4.72TiB path /dev/sdf
>          devid   32 size 5.46TiB used 4.72TiB path /dev/sdq
>          devid   33 size 5.46TiB used 4.72TiB path /dev/sdg
>          devid   34 size 5.46TiB used 4.72TiB path /dev/sde
> 
>   ~ $ sudo btrfs fi df /gpfs_backups
> Data, RAID6: total=150.82TiB, used=88.88TiB
> System, RAID6: total=512.00MiB, used=19.08MiB
> Metadata, RAID6: total=191.00GiB, used=187.38GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
That's a hell of a filesystem. RAID5 and RAID5 is unstable and should 
not be used for anything but throw away data. You will be happy that you 
value you data enough to have backups.... because all sensible sysadmins 
do have backups correct?! (Do read just about any of Duncan's replies - 
he describes this better than me).

Also if you are running kernel ***3.10*** that is nearly antique in 
btrfs terms. As a word of advise, try a more recent kernel (there have 
been lots of patches to raid5/6 since kernel 4.9) and if you ever get 
the filesystem running again then *at least* rebalance the metadata to 
raid1 as quickly as possible as the raid1 profile is (unlike raid5 or 
raid6) working really well.

PS! I'm not a BTRFS dev so don't run away just yet. Someone else may 
magically help you recover, Best of luck!

- Waxhead
