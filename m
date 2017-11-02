Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-sy3aus01on0083.outbound.protection.outlook.com ([104.47.117.83]:12064
        "EHLO AUS01-SY3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932244AbdKBP4x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Nov 2017 11:56:53 -0400
From: Ben Hooper <ben@ayrton.com.au>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: "1i5t5.duncan@cox.net" <1i5t5.duncan@cox.net>
Subject: Re: Error During Balancing - No Space Left on Device
Date: Thu, 2 Nov 2017 15:56:49 +0000
Message-ID: <0AFCDDD0-82C7-42D1-AE87-EFE152BA4173@networkinsanity.com>
References: <8E856F12-DA15-4396-8B5D-B2609D1461BE@networkinsanity.com>
In-Reply-To: <8E856F12-DA15-4396-8B5D-B2609D1461BE@networkinsanity.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan, 

Thanks for the reply (apologies, I am not subscribed to the list). 

I compiled 4.14.0-rc7 and tried balance again with increasing amounts of dusage but it errored out again at dusage=60 with enospc. Will try downgrading to 4.9.x and try again.

# uname -a
Linux nas 4.14.0-rc7+ #1 SMP Thu Nov 2 00:35:35 HKT 2017 x86_64 x86_64 x86_64 GNU/Linux
 
# dmesg | grep enospc
[ 6989.220434] BTRFS info (device sdm): 8 enospc errors during balance

Cheers,

Ben


> On 2 Nov 2017, at 12:18 am, Ben Hooper <ben@ayrton.com.au> wrote:
> 
> Hello,
> 
> I am trying to upgrade capacity on by btrfs filesystem by replacing smaller disks with larger ones. I added 2x8TB drives to the existing RAID10 but am not seeing the expected increase in space and am experiencing enospc errors during balance. This array has been extended several times but this is the first time I have seen any issues.
> 
> Looking at the list archives, it seems that some others have had similar problems. Has anyone found a solution or any recommendations?
> 
> Thanks,
> 
> Ben
> 
> Cannot remove device, no space left on device
> https://marc.info/?l=linux-btrfs&m=150684414519356&w=2
> 
> how to run balance successfully (No space left on device)?
> https://marc.info/?l=linux-btrfs&m=150566058009527&w=2
> 
> 
> # btrfs balance start -v -dusage=0 /data
> Dumping filters: flags 0x1, state 0x0, force is off
>  DATA (flags 0x2): balancing, usage=0
> ERROR: error during balancing '/data': No space left on device
> There may be more info in syslog - try dmesg | tail
> 
> # dmesg | tail
> [49518.949915] BTRFS info (device sdg): relocating block group 241419042029568 flags data|raid10
> [49519.899061] BTRFS info (device sdg): relocating block group 241419041767424 flags data|raid10
> [49521.448691] BTRFS info (device sdg): relocating block group 241419041505280 flags data|raid10
> [49522.136725] BTRFS info (device sdg): relocating block group 241419041243136 flags data|raid10
> [49522.877266] BTRFS info (device sdg): relocating block group 241419040980992 flags data|raid10
> [49524.702461] BTRFS info (device sdg): relocating block group 241419040718848 flags data|raid10
> [49525.068713] BTRFS info (device sdg): relocating block group 241419040456704 flags data|raid10
> [49525.656543] BTRFS info (device sdg): relocating block group 241419040194560 flags data|raid10
> [49549.168836] BTRFS info (device sdg): relocating block group 241419039932416 flags data|raid10
> [49622.578101] BTRFS info (device sdg): 1 enospc errors during balance
> 
> 
> # btrfs --version
> btrfs-progs v4.13.3
> 
> # uname -a
> Linux nas 4.13.9-1.el7.elrepo.x86_64 #1 SMP Sun Oct 22 10:02:34 EDT 2017 x86_64 x86_64 x86_64 GNU/Linux
> 
> # btrfs filesystem df /data
> Data, RAID10: total=59.79TiB, used=59.77TiB
> System, RAID10: total=176.00MiB, used=133.80MiB
> Metadata, RAID10: total=97.69GiB, used=96.47GiB
> GlobalReserve, single: total=512.00MiB, used=16.00KiB
> 
> # df -h | grep data
> /dev/sdj                      67T   60T  269G 100% /data
> 
> 
> # btrfs filesystem show /data
> Label: 'data'  uuid: 3742056f-7ff0-4ce1-9131-ab2cfd7b8736
>        Total devices 24 FS bytes used 59.87TiB
>        devid    2 size 1.82TiB used 1.82TiB path /dev/sdj
>        devid    3 size 1.82TiB used 1.70TiB path /dev/sdk
>        devid    5 size 3.64TiB used 3.64TiB path /dev/sdo
>        devid    7 size 2.73TiB used 2.73TiB path /dev/sdr
>        devid   11 size 3.64TiB used 3.64TiB path /dev/sdm
>        devid   12 size 3.64TiB used 3.64TiB path /dev/sdn
>        devid   13 size 3.64TiB used 3.64TiB path /dev/sdp
>        devid   14 size 3.64TiB used 3.64TiB path /dev/sdq
>        devid   15 size 3.64TiB used 3.64TiB path /dev/sdw
>        devid   16 size 3.64TiB used 3.64TiB path /dev/sdx
>        devid   17 size 7.28TiB used 7.28TiB path /dev/sdv
>        devid   18 size 7.28TiB used 7.28TiB path /dev/sdu
>        devid   19 size 7.28TiB used 7.28TiB path /dev/sds
>        devid   20 size 7.28TiB used 7.28TiB path /dev/sdt
>        devid   21 size 7.28TiB used 7.28TiB path /dev/sdc
>        devid   22 size 7.28TiB used 7.28TiB path /dev/sdd
>        devid   23 size 7.28TiB used 7.28TiB path /dev/sdf
>        devid   24 size 7.28TiB used 7.27TiB path /dev/sde
>        devid   25 size 7.28TiB used 7.28TiB path /dev/sdl
>        devid   26 size 7.28TiB used 7.28TiB path /dev/sdh
>        devid   27 size 7.28TiB used 7.28TiB path /dev/sdi
>        devid   28 size 7.28TiB used 6.86TiB path /dev/sda
>        devid   29 size 7.28TiB used 586.88GiB path /dev/sdg
>        devid   30 size 7.28TiB used 586.88GiB path /dev/sdb
> 
> 
> # btrfs device usage /data
> /dev/sda, ID: 28
>   Device size:             7.28TiB
>   Device slack:              0.00B
>   Data,RAID10:             1.16TiB
>   Data,RAID10:           447.48GiB
>   Data,RAID10:           687.27GiB
>   Data,RAID10:             8.00GiB
>   Data,RAID10:           371.32GiB
>   Data,RAID10:           173.51GiB
>   Data,RAID10:           144.21GiB
>   Data,RAID10:            14.36GiB
>   Data,RAID10:           437.67GiB
>   Data,RAID10:            36.90GiB
>   Data,RAID10:            80.34MiB
>   Metadata,RAID10:        99.00MiB
>   Metadata,RAID10:         4.41MiB
>   Metadata,RAID10:         2.03GiB
>   Metadata,RAID10:        56.06MiB
>   Metadata,RAID10:         1.42GiB
>   Metadata,RAID10:         1.06MiB
>   Metadata,RAID10:       200.31MiB
>   Metadata,RAID10:       104.00MiB
>   Metadata,RAID10:       121.81MiB
>   System,RAID10:           8.00MiB
>   Unallocated:             3.84TiB
> 
> /dev/sdb, ID: 30
>   Device size:             7.28TiB
>   Device slack:              0.00B
>   Data,RAID10:            12.42GiB
>   Data,RAID10:           166.26GiB
>   Data,RAID10:           655.50MiB
>   Data,RAID10:           107.53MiB
>   Data,RAID10:           361.59MiB
>   Data,RAID10:            27.49GiB
>   Data,RAID10:             9.51GiB
>   Data,RAID10:            80.34MiB
>   Data,RAID10:            21.52GiB
>   Data,RAID10:             6.01GiB
>   Data,RAID10:            48.73GiB
>   Metadata,RAID10:       104.00MiB
>   Metadata,RAID10:        94.75MiB
>   Metadata,RAID10:        32.00KiB
>   Metadata,RAID10:       121.81MiB
>   Unallocated:             6.99TiB
> 
> /dev/sdc, ID: 21
>   Device size:             7.28TiB
>   Device slack:              0.00B
>   Data,RAID10:             1.61TiB
>   Data,RAID10:           223.12GiB
>   Data,RAID10:           254.82GiB
>   Data,RAID10:           677.37GiB
>   Data,RAID10:           113.25GiB
>   Data,RAID10:           328.06GiB
>   Data,RAID10:             1.82GiB
>   Data,RAID10:            13.57GiB
>   Data,RAID10:           435.91GiB
>   Data,RAID10:            28.16GiB
>   Data,RAID10:            80.34MiB
>   Metadata,RAID10:        99.00MiB
>   Metadata,RAID10:         4.41MiB
>   Metadata,RAID10:         2.03GiB
>   Metadata,RAID10:        56.06MiB
>   Metadata,RAID10:         1.42GiB
>   Metadata,RAID10:         1.06MiB
>   Metadata,RAID10:       128.00MiB
>   Metadata,RAID10:       104.00MiB
>   System,RAID10:           8.00MiB
>   Unallocated:             3.64TiB
> 
> /dev/sdd, ID: 22
>   Device size:             7.28TiB
>   Device slack:              0.00B
>   Data,RAID10:             1.61TiB
>   Data,RAID10:           223.13GiB
>   Data,RAID10:           253.89GiB
>   Data,RAID10:           676.93GiB
>   Data,RAID10:           108.80GiB
>   Data,RAID10:           333.68GiB
>   Data,RAID10:             1.07GiB
>   Data,RAID10:            13.58GiB
>   Data,RAID10:           436.84GiB
>   Data,RAID10:            28.16GiB
>   Data,RAID10:            80.34MiB
>   Metadata,RAID10:        98.12MiB
>   Metadata,RAID10:         4.41MiB
>   Metadata,RAID10:         2.03GiB
>   Metadata,RAID10:        56.06MiB
>   Metadata,RAID10:         1.42GiB
>   Metadata,RAID10:         1.06MiB
>   Metadata,RAID10:       128.00MiB
>   Metadata,RAID10:       104.00MiB
>   System,RAID10:           8.00MiB
>   Unallocated:             3.64TiB
> 
> /dev/sde, ID: 24
>   Device size:             7.28TiB
>   Device slack:              0.00B
>   Data,RAID10:             1.61TiB
>   Data,RAID10:           223.12GiB
>   Data,RAID10:           256.53GiB
>   Data,RAID10:           684.66GiB
>   Data,RAID10:            94.81GiB
>   Data,RAID10:           342.01GiB
>   Data,RAID10:             5.54GiB
>   Data,RAID10:            13.58GiB
>   Data,RAID10:           437.63GiB
>   Data,RAID10:            16.96GiB
>   Data,RAID10:            80.34MiB
>   Metadata,RAID10:        99.00MiB
>   Metadata,RAID10:         4.41MiB
>   Metadata,RAID10:         2.03GiB
>   Metadata,RAID10:        56.06MiB
>   Metadata,RAID10:         1.42GiB
>   Metadata,RAID10:         1.06MiB
>   Metadata,RAID10:       128.00MiB
>   System,RAID10:           8.00MiB
>   Unallocated:             3.64TiB
> 
> /dev/sdf, ID: 23
>   Device size:             7.28TiB
>   Device slack:              0.00B
>   Data,RAID10:             1.61TiB
>   Data,RAID10:           223.13GiB
>   Data,RAID10:           251.77GiB
>   Data,RAID10:           677.52GiB
>   Data,RAID10:            80.12GiB
>   Data,RAID10:           347.13GiB
>   Data,RAID10:             7.98GiB
>   Data,RAID10:            13.59GiB
>   Data,RAID10:           437.67GiB
>   Data,RAID10:            36.90GiB
>   Data,RAID10:            80.34MiB
>   Metadata,RAID10:        99.00MiB
>   Metadata,RAID10:         4.41MiB
>   Metadata,RAID10:         2.03GiB
>   Metadata,RAID10:        56.06MiB
>   Metadata,RAID10:         1.42GiB
>   Metadata,RAID10:         1.06MiB
>   Metadata,RAID10:       128.00MiB
>   Metadata,RAID10:       104.00MiB
>   System,RAID10:           8.00MiB
>   Unallocated:             3.64TiB
> 
> /dev/sdg, ID: 29
>   Device size:             7.28TiB
>   Device slack:              0.00B
>   Data,RAID10:            12.42GiB
>   Data,RAID10:           166.26GiB
>   Data,RAID10:           655.50MiB
>   Data,RAID10:           107.53MiB
>   Data,RAID10:           361.59MiB
>   Data,RAID10:            27.49GiB
>   Data,RAID10:             9.51GiB
>   Data,RAID10:            80.34MiB
>   Data,RAID10:            21.52GiB
>   Data,RAID10:             6.01GiB
>   Data,RAID10:            48.73GiB
>   Metadata,RAID10:       104.00MiB
>   Metadata,RAID10:        94.75MiB
>   Metadata,RAID10:        32.00KiB
>   Metadata,RAID10:       121.81MiB
>   Unallocated:             6.99TiB
> 
> /dev/sdh, ID: 26
>   Device size:             7.28TiB
>   Device slack:              0.00B
>   Data,RAID10:           334.81GiB
>   Data,RAID10:             1.11TiB
>   Data,RAID10:           447.48GiB
>   Data,RAID10:           679.58GiB
>   Data,RAID10:           349.80GiB
>   Data,RAID10:           173.51GiB
>   Data,RAID10:           144.19GiB
>   Data,RAID10:            13.94GiB
>   Data,RAID10:           428.25GiB
>   Data,RAID10:            10.06GiB
>   Data,RAID10:            80.34MiB
>   Metadata,RAID10:        99.00MiB
>   Metadata,RAID10:         4.41MiB
>   Metadata,RAID10:         2.03GiB
>   Metadata,RAID10:        56.06MiB
>   Metadata,RAID10:         1.42GiB
>   Metadata,RAID10:         1.06MiB
>   Metadata,RAID10:       200.31MiB
>   System,RAID10:           8.00MiB
>   Unallocated:             3.64TiB
> 
> /dev/sdi, ID: 27
>   Device size:             7.28TiB
>   Device slack:              0.00B
>   Data,RAID10:           334.81GiB
>   Data,RAID10:             1.11TiB
>   Data,RAID10:           447.43GiB
>   Data,RAID10:           679.59GiB
>   Data,RAID10:           349.80GiB
>   Data,RAID10:           173.51GiB
>   Data,RAID10:           144.20GiB
>   Data,RAID10:            13.97GiB
>   Data,RAID10:           428.25GiB
>   Data,RAID10:            10.06GiB
>   Data,RAID10:            80.34MiB
>   Metadata,RAID10:        99.00MiB
>   Metadata,RAID10:         4.41MiB
>   Metadata,RAID10:         2.03GiB
>   Metadata,RAID10:        56.06MiB
>   Metadata,RAID10:         1.42GiB
>   Metadata,RAID10:         1.06MiB
>   Metadata,RAID10:       200.31MiB
>   System,RAID10:           8.00MiB
>   Unallocated:             3.64TiB
> 
> /dev/sdj, ID: 2
>   Device size:             1.82TiB
>   Device slack:            3.50KiB
>   Data,RAID10:            98.56GiB
>   Data,RAID10:           635.93GiB
>   Data,RAID10:           150.94GiB
>   Data,RAID10:            11.37GiB
>   Data,RAID10:            80.34MiB
>   Data,RAID10:             2.00GiB
>   Data,RAID10:             8.26GiB
>   Data,RAID10:             3.64GiB
>   Data,RAID10:            20.66GiB
>   Metadata,RAID10:        51.00MiB
>   Metadata,RAID10:        32.00KiB
>   System,RAID10:           8.00MiB
>   Unallocated:           931.52GiB
> 
> /dev/sdk, ID: 3
>   Device size:             1.82TiB
>   Device slack:            3.50KiB
>   Data,RAID10:            99.87GiB
>   Data,RAID10:           564.02GiB
>   Data,RAID10:           148.58GiB
>   Data,RAID10:             7.15GiB
>   Data,RAID10:            71.91MiB
>   Data,RAID10:            80.34MiB
>   Data,RAID10:            48.70GiB
>   Data,RAID10:           755.44MiB
>   Data,RAID10:           299.34MiB
>   Data,RAID10:             1.50MiB
>   Data,RAID10:             3.34MiB
>   Metadata,RAID10:         4.25MiB
>   Metadata,RAID10:       121.81MiB
>   System,RAID10:           8.00MiB
>   Unallocated:           993.38GiB
> 
> /dev/sdl, ID: 25
>   Device size:             7.28TiB
>   Device slack:              0.00B
>   Data,RAID10:           334.81GiB
>   Data,RAID10:             1.11TiB
>   Data,RAID10:           447.48GiB
>   Data,RAID10:           679.56GiB
>   Data,RAID10:           349.80GiB
>   Data,RAID10:           173.51GiB
>   Data,RAID10:           144.20GiB
>   Data,RAID10:            13.88GiB
>   Data,RAID10:           428.26GiB
>   Data,RAID10:            10.12GiB
>   Data,RAID10:            80.34MiB
>   Metadata,RAID10:        99.00MiB
>   Metadata,RAID10:         4.41MiB
>   Metadata,RAID10:         2.03GiB
>   Metadata,RAID10:        56.06MiB
>   Metadata,RAID10:         1.42GiB
>   Metadata,RAID10:         1.06MiB
>   Metadata,RAID10:       200.31MiB
>   System,RAID10:           8.00MiB
>   Unallocated:             3.64TiB
> 
> /dev/sdm, ID: 11
>   Device size:             3.64TiB
>   Device slack:              0.00B
>   Data,RAID10:           314.68GiB
>   Data,RAID10:           145.99GiB
>   Data,RAID10:            99.09MiB
>   Data,RAID10:           402.87GiB
>   Data,RAID10:           677.46GiB
>   Data,RAID10:           173.08GiB
>   Data,RAID10:           143.39GiB
>   Data,RAID10:           810.34MiB
>   Data,RAID10:            80.34MiB
>   Metadata,RAID10:         2.84GiB
>   Metadata,RAID10:        99.00MiB
>   Metadata,RAID10:         4.41MiB
>   Metadata,RAID10:         1.63GiB
>   System,RAID10:           8.00MiB
>   Unallocated:             1.82TiB
> 
> /dev/sdn, ID: 12
>   Device size:             3.64TiB
>   Device slack:              0.00B
>   Data,RAID10:           314.79GiB
>   Data,RAID10:           145.98GiB
>   Data,RAID10:            36.97MiB
>   Data,RAID10:           401.44GiB
>   Data,RAID10:           677.21GiB
>   Data,RAID10:           718.41MiB
>   Data,RAID10:           173.43GiB
>   Data,RAID10:           143.81GiB
>   Data,RAID10:             1.04GiB
>   Data,RAID10:            80.34MiB
>   Metadata,RAID10:         2.84GiB
>   Metadata,RAID10:        99.00MiB
>   Metadata,RAID10:         4.41MiB
>   Metadata,RAID10:         1.54GiB
>   Metadata,RAID10:         1.06MiB
>   Metadata,RAID10:        96.00KiB
>   System,RAID10:           8.00MiB
>   Unallocated:             1.82TiB
> 
> /dev/sdo, ID: 5
>   Device size:             3.64TiB
>   Device slack:              0.00B
>   Data,RAID10:           314.80GiB
>   Data,RAID10:           146.28GiB
>   Data,RAID10:            40.91MiB
>   Data,RAID10:           256.00KiB
>   Data,RAID10:           402.16GiB
>   Data,RAID10:           677.12GiB
>   Data,RAID10:           173.32GiB
>   Data,RAID10:           143.70GiB
>   Data,RAID10:           920.22MiB
>   Data,RAID10:            80.34MiB
>   Metadata,RAID10:         2.84GiB
>   Metadata,RAID10:        99.00MiB
>   Metadata,RAID10:         4.41MiB
>   Metadata,RAID10:         1.66GiB
>   System,RAID10:           8.00MiB
>   Unallocated:             1.82TiB
> 
> /dev/sdp, ID: 13
>   Device size:             3.64TiB
>   Device slack:              0.00B
>   Data,RAID10:           314.78GiB
>   Data,RAID10:           146.04GiB
>   Data,RAID10:            22.66MiB
>   Data,RAID10:           402.35GiB
>   Data,RAID10:           676.72GiB
>   Data,RAID10:           222.78MiB
>   Data,RAID10:           173.39GiB
>   Data,RAID10:           143.56GiB
>   Data,RAID10:             1.02GiB
>   Data,RAID10:            80.34MiB
>   Metadata,RAID10:         2.84GiB
>   Metadata,RAID10:        99.00MiB
>   Metadata,RAID10:         4.41MiB
>   Metadata,RAID10:         1.82GiB
>   Metadata,RAID10:        55.94MiB
>   Metadata,RAID10:         1.06MiB
>   System,RAID10:           8.00MiB
>   Unallocated:             1.82TiB
> 
> /dev/sdq, ID: 14
>   Device size:             3.64TiB
>   Device slack:              0.00B
>   Data,RAID10:           314.70GiB
>   Data,RAID10:           145.88GiB
>   Data,RAID10:            39.69MiB
>   Data,RAID10:           402.59GiB
>   Data,RAID10:           677.36GiB
>   Data,RAID10:           173.28GiB
>   Data,RAID10:           143.65GiB
>   Data,RAID10:           942.38MiB
>   Data,RAID10:            80.34MiB
>   Metadata,RAID10:         2.84GiB
>   Metadata,RAID10:        99.00MiB
>   Metadata,RAID10:         4.41MiB
>   Metadata,RAID10:         1.57GiB
>   Metadata,RAID10:         1.06MiB
>   Metadata,RAID10:        32.00KiB
>   System,RAID10:           8.00MiB
>   Unallocated:             1.82TiB
> 
> /dev/sdr, ID: 7
>   Device size:             2.73TiB
>   Device slack:              0.00B
>   Data,RAID10:           314.71GiB
>   Data,RAID10:           120.72GiB
>   Data,RAID10:           674.68GiB
>   Data,RAID10:            56.00MiB
>   Data,RAID10:           171.74GiB
>   Data,RAID10:           112.30GiB
>   Data,RAID10:             6.44MiB
>   Data,RAID10:            57.94MiB
>   Data,RAID10:            80.34MiB
>   Data,RAID10:           320.00KiB
>   Metadata,RAID10:         2.84GiB
>   Metadata,RAID10:        53.12MiB
>   Metadata,RAID10:         4.41MiB
>   System,RAID10:           8.00MiB
>   Unallocated:             1.36TiB
> 
> /dev/sds, ID: 19
>   Device size:             7.28TiB
>   Device slack:              0.00B
>   Data,RAID10:           752.17GiB
>   Data,RAID10:           198.48GiB
>   Data,RAID10:           159.09GiB
>   Data,RAID10:             9.28GiB
>   Data,RAID10:             1.11TiB
>   Data,RAID10:           447.43GiB
>   Data,RAID10:           682.66GiB
>   Data,RAID10:           173.51GiB
>   Data,RAID10:           144.20GiB
>   Data,RAID10:            13.98GiB
>   Data,RAID10:            80.34MiB
>   Metadata,RAID10:         4.26GiB
>   Metadata,RAID10:         1.00GiB
>   Metadata,RAID10:        99.00MiB
>   Metadata,RAID10:         4.41MiB
>   Metadata,RAID10:         2.03GiB
>   Metadata,RAID10:        56.06MiB
>   Metadata,RAID10:         1.06MiB
>   Metadata,RAID10:        72.31MiB
>   Metadata,RAID10:       104.00MiB
>   System,RAID10:           8.00MiB
>   Unallocated:             3.64TiB
> 
> /dev/sdt, ID: 20
>   Device size:             7.28TiB
>   Device slack:              0.00B
>   Data,RAID10:           752.17GiB
>   Data,RAID10:           198.90GiB
>   Data,RAID10:           159.09GiB
>   Data,RAID10:             8.84GiB
>   Data,RAID10:             1.11TiB
>   Data,RAID10:           447.43GiB
>   Data,RAID10:           682.64GiB
>   Data,RAID10:           173.51GiB
>   Data,RAID10:           144.20GiB
>   Data,RAID10:            14.01GiB
>   Data,RAID10:            80.34MiB
>   Metadata,RAID10:         4.26GiB
>   Metadata,RAID10:         1.00GiB
>   Metadata,RAID10:        99.00MiB
>   Metadata,RAID10:         4.41MiB
>   Metadata,RAID10:         2.03GiB
>   Metadata,RAID10:        56.06MiB
>   Metadata,RAID10:         1.06MiB
>   Metadata,RAID10:        72.31MiB
>   Metadata,RAID10:       104.00MiB
>   System,RAID10:           8.00MiB
>   Unallocated:             3.64TiB
> 
> /dev/sdu, ID: 18
>   Device size:             7.28TiB
>   Device slack:              0.00B
>   Data,RAID10:           752.25GiB
>   Data,RAID10:           197.90GiB
>   Data,RAID10:           159.11GiB
>   Data,RAID10:             9.80GiB
>   Data,RAID10:             1.11TiB
>   Data,RAID10:           447.43GiB
>   Data,RAID10:           682.66GiB
>   Data,RAID10:           173.51GiB
>   Data,RAID10:           144.17GiB
>   Data,RAID10:            13.98GiB
>   Data,RAID10:            80.34MiB
>   Metadata,RAID10:         4.26GiB
>   Metadata,RAID10:         1.00GiB
>   Metadata,RAID10:        99.00MiB
>   Metadata,RAID10:         4.41MiB
>   Metadata,RAID10:         2.03GiB
>   Metadata,RAID10:        56.06MiB
>   Metadata,RAID10:         1.06MiB
>   Metadata,RAID10:        72.31MiB
>   Metadata,RAID10:       104.00MiB
>   System,RAID10:           8.00MiB
>   Unallocated:             3.64TiB
> 
> /dev/sdv, ID: 17
>   Device size:             7.28TiB
>   Device slack:              0.00B
>   Data,RAID10:           752.18GiB
>   Data,RAID10:           198.17GiB
>   Data,RAID10:           159.09GiB
>   Data,RAID10:             9.63GiB
>   Data,RAID10:             1.11TiB
>   Data,RAID10:           447.45GiB
>   Data,RAID10:           682.59GiB
>   Data,RAID10:           173.51GiB
>   Data,RAID10:           144.20GiB
>   Data,RAID10:            13.99GiB
>   Data,RAID10:            80.34MiB
>   Metadata,RAID10:         4.26GiB
>   Metadata,RAID10:         1.00GiB
>   Metadata,RAID10:        99.00MiB
>   Metadata,RAID10:         4.41MiB
>   Metadata,RAID10:         2.03GiB
>   Metadata,RAID10:        56.06MiB
>   Metadata,RAID10:         1.06MiB
>   Metadata,RAID10:        72.31MiB
>   Metadata,RAID10:       104.00MiB
>   System,RAID10:           8.00MiB
>   Unallocated:             3.64TiB
> 
> /dev/sdw, ID: 15
>   Device size:             3.64TiB
>   Device slack:              0.00B
>   Data,RAID10:           315.83GiB
>   Data,RAID10:           136.75GiB
>   Data,RAID10:           109.34MiB
>   Data,RAID10:             8.84GiB
>   Data,RAID10:           402.50GiB
>   Data,RAID10:           676.22GiB
>   Data,RAID10:           173.32GiB
>   Data,RAID10:           143.54GiB
>   Data,RAID10:           984.22MiB
>   Data,RAID10:            80.34MiB
>   Metadata,RAID10:         2.84GiB
>   Metadata,RAID10:        99.00MiB
>   Metadata,RAID10:         4.41MiB
>   Metadata,RAID10:         1.91GiB
>   System,RAID10:           8.00MiB
>   Unallocated:             1.82TiB
> 
> /dev/sdx, ID: 16
>   Device size:             3.64TiB
>   Device slack:              0.00B
>   Data,RAID10:           317.18GiB
>   Data,RAID10:           144.33GiB
>   Data,RAID10:           110.44MiB
>   Data,RAID10:             8.84GiB
>   Data,RAID10:           390.79GiB
>   Data,RAID10:           677.60GiB
>   Data,RAID10:           173.41GiB
>   Data,RAID10:           143.58GiB
>   Data,RAID10:             2.05GiB
>   Data,RAID10:            80.34MiB
>   Metadata,RAID10:         2.84GiB
>   Metadata,RAID10:        99.00MiB
>   Metadata,RAID10:         4.41MiB
>   Metadata,RAID10:         2.03GiB
>   Metadata,RAID10:        56.06MiB
>   Metadata,RAID10:         1.06MiB
>   System,RAID10:           8.00MiB
>   Unallocated:             1.82TiB
> 
> 
> 
> 
> 

