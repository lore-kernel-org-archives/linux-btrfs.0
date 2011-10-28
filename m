From: Stephane CHAZELAS <stephane_chazelas@yahoo.fr>
Subject: Re: btrfs fi defrag -c
Date: Fri, 28 Oct 2011 10:23:44 +0000 (UTC)
Message-ID: <slrnjal0lg.73o.stephane.chazelas@spam.is.invalid>
References: <20111027192022.GD4389@yahoo.fr> <4EAA12B2.8070007@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

2011-10-28, 10:25(+08), Li Zefan:
[...]
> # df . -h
> Filesystem            Size  Used Avail Use% Mounted on
> /home/lizf/tmp/a      2.0G  409M  1.4G  23% /mnt

OK, why are we not gaining space after compression though?


> And I was not suprised, as there's a regression.
>
> With this fix:
>
> http://marc.info/?l=linux-btrfs&m=131495014823121&w=2
[...]

Thanks. That's the one that's scheduled for 3.2 and maybe 3.1.x,
right?

-- 
Stephane

