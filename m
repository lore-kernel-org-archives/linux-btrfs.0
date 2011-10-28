From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: btrfs fi defrag -c
Date: Fri, 28 Oct 2011 11:02:29 +0800
Message-ID: <4EAA1B45.7050700@cn.fujitsu.com>
References: <20111027192022.GD4389@yahoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111027192022.GD4389@yahoo.fr>
List-ID: <linux-btrfs.vger.kernel.org>

> When the FS is mounted with compress:
> 
> ~# mkfs.btrfs ./a
>         nodesize 4096 leafsize 4096 sectorsize 4096 size 2.00GB
> ~# mount -o compress ./a /mnt/1
> ~# cd /mnt/1
> /mnt/1# yes | head -c400M > a
> /mnt/1# sync
> /mnt/1# df -h .
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/loop1      2.0G   14M  1.8G   1% /mnt/1
> /mnt/1# btrfs fi defrag -c ./a
> (20)/mnt/1# sync
> /mnt/1# df -h .
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/loop1      2.0G   21M  1.4G   2% /mnt/1
> 
> Lost 400M?
> 
> /mnt/1# btrfs fi defrag ./a
> (20)/mnt/1# sync
> /mnt/1# df -h .
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/loop1      2.0G   21M  1.4G   2% /mnt/1
> 
> I take it it doesn't uncompress?
> 
> I'm a bit confused here.
> 

Yes, it won't be uncompressed if you mount with compress option.
