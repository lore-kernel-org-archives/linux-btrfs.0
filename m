From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: high CPU usage and low perf
Date: Tue, 27 Sep 2011 10:31:58 +0100
Message-ID: <20110927093158.GB4149@yahoo.fr>
References: <20110927091509.GA4149@yahoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110927091509.GA4149@yahoo.fr>
List-ID: <linux-btrfs.vger.kernel.org>

2011-09-27 10:15:09 +0100, Stephane Chazelas:
[...]
> a btrfs file system of mine started to behave very poorly with
> some btrfs kernel tasks taking 100% of CPU time.
> 
> # btrfs fi show /dev/sdb
> Label: none  uuid: b3ce8b16-970e-4ba8-b9d2-4c7de270d0f1
>         Total devices 3 FS bytes used 4.25TB
>         devid    2 size 2.73TB used 1.52TB path /dev/sdc
>         devid    1 size 2.70TB used 1.49TB path /dev/sda4
>         devid    3 size 2.73TB used 1.52TB path /dev/sdb
> 
> Btrfs v0.19-100-g4964d65
> 
> FS mounted with compress-force,noatime
> 
> (Can't do a "filesystem df" just now, as there's a umount
> running, there should be around 33% free).
[...]

The umount just returned.

# btrfs fi df /backup
Data, RAID0: total=4.20TB, used=4.20TB
Data: total=8.00MB, used=7.97MB
System, RAID1: total=8.00MB, used=344.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=162.75GB, used=59.30GB
Metadata: total=8.00MB, used=0.00

It's now running fine again after reload of btrfs module and
remount.

-- 
Stephane
