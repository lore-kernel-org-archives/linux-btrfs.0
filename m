From: RK <rkasl@computer.org>
Subject: Re: RAID-10 arrays built with btrfs & md report 2x difference in
 	available size?
Date: Sun, 24 Jan 2010 07:01:35 -0500
Message-ID: <4B5C369F.3020106@computer.org>
References: <c67eed301001232131n2a7f88acx857df19ea95371a4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <c67eed301001232131n2a7f88acx857df19ea95371a4@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

.. I have the same puzzlement?

0bo0 wrote:
> I created a btrfs RAID-10 array across 4-drives,
>
>  mkfs.btrfs -L TEST -m raid10 -d raid10 /dev/sda /dev/sdb /dev/sdc /dev/sdd
>  btrfs-show
>  	Label: TEST  uuid: 2ac85206-2d88-47d7-a1e7-a93d80b199f8
>  	        Total devices 4 FS bytes used 28.00KB
>  	        devid    1 size 931.51GB used 2.03GB path /dev/sda
>  	        devid    2 size 931.51GB used 2.01GB path /dev/sdb
>  	        devid    4 size 931.51GB used 2.01GB path /dev/sdd
>  	        devid    3 size 931.51GB used 2.01GB path /dev/sdc
>
> @ mount,
>
>  mount /dev/sda /mnt
>  df -H | grep /dev/sda
> 	/dev/sda               4.1T    29k   4.1T   1% /mnt
>
> for RAID-10 across 4-drives, shouldn't the reported/available size be
> 1/2x4TB ~ 2TB?
>
> e.g., using mdadm to build a RAID-10 array across the same drives,
>
>  mdadm -v --create /dev/md0 --level=raid10 --raid-devices=4 /dev/sd[abcd]1
>  pvcreate     /dev/md0
> pvs
>   PV         VG   Fmt  Attr PSize   PFree
>   /dev/md0        lvm2 --   1.82T 1.82T
>
> is the difference in available array space real, an artifact, or a
> misunderstanding on my part?
>
> thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

