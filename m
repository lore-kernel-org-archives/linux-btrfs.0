Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nmsh1.e.nsc.no ([193.213.121.72]:54406 "EHLO nmsh1.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbcEWTKj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 May 2016 15:10:39 -0400
Subject: Re: btrfs filesystem usage - Wrong Unallocated indications - RAID10
To: Marco Lorenzo Crociani <marcoc@prismatelecomtesting.com>,
        linux-btrfs@vger.kernel.org
References: <574306CC.3070906@prismatelecomtesting.com>
From: Zoiled <zoiled@online.no>
Message-ID: <574350A0.80101@online.no>
Date: Mon, 23 May 2016 20:49:04 +0200
MIME-Version: 1.0
In-Reply-To: <574306CC.3070906@prismatelecomtesting.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marco Lorenzo Crociani wrote:
> Hi,
> as I wrote today in IRCI experienced an issue with 'btrfs filesystem 
> usage'.
> I have a 4 partitions RAID10 btrfs filesystem almost full.
> 'btrfs filesystem usage' reports wrong "Unallocated" indications.
>
> Linux 4.5.3
> btrfs-progs v4.5.3
>
>
> # btrfs fi usage /data/
>
> Overall:
>     Device size:          13.93TiB
>     Device allocated:          13.77TiB
>     Device unallocated:         167.54GiB
>     Device missing:             0.00B
>     Used:              13.44TiB
>     Free (estimated):         244.39GiB    (min: 244.39GiB)
>     Data ratio:                  2.00
>     Metadata ratio:              2.00
>     Global reserve:         512.00MiB    (used: 0.00B)
>
> Data,single: Size:8.00MiB, Used:0.00B
>    /dev/sda4       8.00MiB
>
> Data,RAID10: Size:6.87TiB, Used:6.71TiB
>    /dev/sda4       1.72TiB
>    /dev/sdb3       1.72TiB
>    /dev/sdc3       1.72TiB
>    /dev/sdd3       1.72TiB
>
> Metadata,single: Size:8.00MiB, Used:0.00B
>    /dev/sda4       8.00MiB
>
> Metadata,RAID10: Size:19.00GiB, Used:14.15GiB
>    /dev/sda4       4.75GiB
>    /dev/sdb3       4.75GiB
>    /dev/sdc3       4.75GiB
>    /dev/sdd3       4.75GiB
>
> System,single: Size:4.00MiB, Used:0.00B
>    /dev/sda4       4.00MiB
>
> System,RAID10: Size:16.00MiB, Used:768.00KiB
>    /dev/sda4       4.00MiB
>    /dev/sdb3       4.00MiB
>    /dev/sdc3       4.00MiB
>    /dev/sdd3       4.00MiB
>
> Unallocated:
>    /dev/sda4       1.76TiB
>    /dev/sdb3       1.76TiB
>    /dev/sdc3       1.76TiB
>    /dev/sdd3       1.76TiB
>
> ---------------------------------------------------------------------------------- 
>
> # btrfs fi show /data/
> Label: 'data'  uuid: df6639d5-3ef2-4ff6-a871-9ede440e2dae
>     Total devices 4 FS bytes used 6.72TiB
>     devid    1 size 3.48TiB used 3.44TiB path /dev/sda4
>     devid    2 size 3.48TiB used 3.44TiB path /dev/sdb3
>     devid    3 size 3.48TiB used 3.44TiB path /dev/sdc3
>     devid    4 size 3.48TiB used 3.44TiB path /dev/sdd3
>
> ---------------------------------------------------------------------------------- 
>
> # btrfs fi df /data/
> Data, RAID10: total=6.87TiB, used=6.71TiB
> Data, single: total=8.00MiB, used=0.00B
> System, RAID10: total=16.00MiB, used=768.00KiB
> System, single: total=4.00MiB, used=0.00B
> Metadata, RAID10: total=19.00GiB, used=14.15GiB
> Metadata, single: total=8.00MiB, used=0.00B
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
> ---------------------------------------------------------------------------------- 
>
> # df -h
> /dev/sda4                     7,0T  6,8T    245G  97% /data
>
> Regards,
>
For what it's worth...  I have a 8 disk (7x 300GB + 1x 500GB) data 
raid10, metadata raid1 setup and I get the following output of btrfs...

Label: 'xxyyzz'  uuid: 12345678-9abc-def1-2345-6789abcdef01
         Total devices 8 FS bytes used 1.05TiB
         devid    1 size 268.05GiB used 265.94GiB path /dev/sda1
         devid    2 size 279.40GiB used 277.22GiB path /dev/sdb
         devid    3 size 279.40GiB used 277.32GiB path /dev/sdc
         devid    4 size 279.40GiB used 278.73GiB path /dev/sdd
         devid    5 size 279.40GiB used 277.72GiB path /dev/sde
         devid    6 size 279.40GiB used 278.61GiB path /dev/sdf
         devid    7 size 279.40GiB used 278.82GiB path /dev/sdg
         devid    8 size 465.76GiB used 230.99GiB path /dev/sdh

# btrfs filesystem usage -T /
Overall:
     Device size:                   2.35TiB
     Device allocated:              2.11TiB
     Device unallocated:          244.83GiB
     Device missing:                  0.00B
     Used:                          2.11TiB
     Free (estimated):            122.57GiB      (min: 122.57GiB)
     Data ratio:                       2.00
     Metadata ratio:                   2.00
     Global reserve:              512.00MiB      (used: 0.00B)

              Data       Data      Metadata System
Id Path      RAID1      RAID10    RAID1    RAID1 Unallocated
-- --------- ---------- --------- -------- --------- -----------
  1 /dev/sda1          - 132.97GiB        -         - 135.08GiB
  2 /dev/sdb           - 138.61GiB        -         - 140.79GiB
  3 /dev/sdc           - 138.66GiB        -         - 140.74GiB
  4 /dev/sdd           - 138.87GiB  1.00GiB         - 139.53GiB
  5 /dev/sde     1.00GiB 137.86GiB  1.00GiB         - 139.53GiB
  6 /dev/sdf           - 138.81GiB  1.00GiB         - 139.59GiB
  7 /dev/sdg     1.00GiB 138.38GiB  1.00GiB  64.00MiB 138.96GiB
  8 /dev/sdh           - 113.46GiB  4.00GiB  64.00MiB 348.24GiB
-- --------- ---------- --------- -------- --------- -----------
    Total        1.00GiB   1.05TiB  4.00GiB  64.00MiB 1.29TiB
Used      1007.30MiB   1.05TiB  1.66GiB 400.00KiB

What I don't get is... how can I have 244.8 GB unallocated when the 
table below clearly shows that there is as much as 1.29TiB 
unallocated.... does not appear to make sense to me at least...
