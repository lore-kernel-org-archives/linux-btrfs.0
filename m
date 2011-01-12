From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: Re: mount problem
Date: Wed, 12 Jan 2011 09:48:23 +0900
Message-ID: <4D2CFA57.1080405@jp.fujitsu.com>
References: <AANLkTi=JL3q2GV94j_wv5QN1pHbRouvn7D3pu_MUj1XW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: linux-btrfs@vger.kernel.org
To: Leonidas Spyropoulos <artafinde@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=JL3q2GV94j_wv5QN1pHbRouvn7D3pu_MUj1XW@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

(2011/01/12 9:25), Leonidas Spyropoulos wrote:
> Hey all,
> 
> I have a weird error with my RAID 0 btrfs partition.
> Information for the partitions follow:
> 
> # btrfs filesystem show
> failed to read /dev/sr0
> Label: none  uuid: 1882b025-58e4-4287-98a3-9b772af0ad76
> 	Total devices 2 FS bytes used 108.16GB
> 	devid    2 size 74.53GB used 55.26GB path /dev/sdd2
> 	devid    3 size 74.53GB used 55.26GB path /dev/sde2
> 
> Btrfs v0.19-35-g1b444cd
> 
> # btrfs device scan
> Scanning for Btrfs filesystems
> failed to read /dev/sr0
> 
> # cat /etc/fstab | grep btrfs
> /dev/disk/by-uuid/1882b025-58e4-4287-98a3-9b772af0ad76 	/media/data
> 	btrfs 	rw,user 0 0
> 
> # blkid
> /dev/sdd2: UUID="1882b025-58e4-4287-98a3-9b772af0ad76"
> UUID_SUB="468b49fa-a0b6-4e11-a312-ef0cafd2890a" TYPE="btrfs"
> /dev/sde2: UUID="1882b025-58e4-4287-98a3-9b772af0ad76"
> UUID_SUB="cf534558-a317-4259-808b-d950a155fb5d" TYPE="btrfs"
> 
> Although I have the config within fstab it doesn't mount on bootup with error:
> mount: wrong fs type, bad option, bad superblock on /dev/sde2,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so
> 
> Kernel messages:
> device fsid 8742e45825b08218-76adf02a779ba398 devid 3 transid 4778 /dev/sde2
> btrfs: failed to read the system array on sde2

Please see Problem_FAQ in btrfs wiki.
(https://btrfs.wiki.kernel.org/index.php/Problem_FAQ)

Thanks,
Itoh

> 
> No matter how many times I try with sudo mount -a or sudo mount
> /media/data I got the same error.
> 
> Now the weird stuff:
> If I do a blkid and fdisk -l I can then mount normally the partition.
> Any ideas?
> 
> Kernel info: Linux woofy 2.6.36-ARCH #1 SMP PREEMPT Sat Jan 8 14:15:27
> CET 2011 x86_64 Dual Core AMD Opteron(tm) Processor 165 AuthenticAMD
> GNU/Linux
> btrfs-progs: Latest from git
> I don't know which revision/patch Arch stock kernel has of btrfs.
> 
> 
> Thanks,
> Leonidas
> 

