From: Robert =?iso-8859-1?q?F=F6rster?= <Dessa@gmake.de>
Subject: Re: Crash in __btrfs_reserve_extent
Date: Thu, 6 Aug 2009 16:57:50 +0200
Message-ID: <200908061657.50989.Dessa@gmake.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello, 

i thought i'd jump in since i have the same issue:
btrfs-show output:

Label: none  uuid: 7f4f3bcb-7ba1-49c5-8996-e897b5483c7c
        Total devices 1 FS bytes used 5.32GB
        devid    1 size 51.22GB used 51.22GB path /dev/sdb1

df -h output:

Filesystem            Size  Used Avail Use% Mounted on
rootfs                 52G  5,4G   46G  11% /

Robert
