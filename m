From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: btrfs raid1 degraded does not mount or fsck
Date: Sat, 30 Oct 2010 08:55:48 +0200
Message-ID: <201010300855.48938.kreijack@libero.it>
References: <20101029205340.GA10326@gypsyops.denof.sin>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101029205340.GA10326@gypsyops.denof.sin>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, 29 October, 2010, Vladi Gergov wrote:
> kernel: scratch git repo from today 10.29.10 @ 14:30 PST
> Btrfs v0.19-35-g1b444cd-dirty
> 
> >>> gypsyops @ /mnt > sudo btrfs filesystem show
> Label: 'das4'  uuid: d0e5137f-e5e7-49da-91f6-a9c4e4e72c6f
>     Total devices 3 FS bytes used 1.38TB
>     devid    3 size 1.82TB used 0.00 path /dev/sdb
>     devid    2 size 1.82TB used 1.38TB path /dev/sdc
>     *** Some devices missing
> 
> Btrfs v0.19-35-g1b444cd-dirty
> 
> >>> gypsyops @ /mnt > sudo mount -o degraded /dev/sdc das3/
> Password: 
> mount: wrong fs type, bad option, bad superblock on /dev/sdc,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so
> 
> [  684.577540] device label das4 devid 2 transid 107954 /dev/sdc
> [  684.595150] btrfs: allowing degraded mounts
> [  684.595594] btrfs: failed to read chunk root on sdb
> [  684.604110] btrfs: open_ctree failed
> 
> >>> gypsyops @ /mnt > sudo btrfsck /dev/sdc
> btrfsck: volumes.c:1367: btrfs_read_sys_array: Assertion `!(ret)' failed.
> 
> any help please?

did you execute 

	btrfs dev scan

before trying to mount the filesystem ?

> -- 
> 
> ,-| Vladi
> `-| Gergov
> 
> !DSPAM:4ccb39a9191821603519226!
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
