From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: wrong / too less space on raid
Date: Mon, 28 Nov 2011 09:36:22 +0800
Message-ID: <4ED2E596.7010309@cn.fujitsu.com>
References: <1322397922.11404.15.camel@master.beowulf.me>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: source <source@disable-microsoft.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1322397922.11404.15.camel@master.beowulf.me>
List-ID: <linux-btrfs.vger.kernel.org>

On sun, 27 Nov 2011 13:45:22 +0100, source wrote:
> before sending this mail, i tried to track down previous messages from
> the archive and found no similar entry. so either something went wrong
> on my machine only or maybe there are too less testers around.
> 
> about the real problem/bug :
> 
> i tried to create several btrfs filesystems with success and tests about
> performance and reliability but the free amount given to the system is
> far too small, one example :
> 
> #mkfs.btrfs -m raid0 -d raid0 /dev/sda8 /dev/sdb8 /dev/sdc8
> 
> WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
> WARNING! - see http://btrfs.wiki.kernel.org before using
> 
> adding device /dev/sdb8 id 2
> adding device /dev/sdc8 id 3
> fs created label (null) on /dev/sda8
> 	nodesize 4096 leafsize 4096 sectorsize 4096 size 131.44GB
> Btrfs Btrfs v0.19
> 
> # mkdir /test && mount /dev/sda8 /test
> # df
> Filesystem     1K-blocks      Used Available Use% Mounted on
> /dev/md0       292911488 174222808 118688680  60% /
> tmpfs               5120         4      5116   1% /lib/init/rw
> tmpfs             611976       544    611432   1% /run
> udev               10240         0     10240   0% /dev
> tmpfs            1223952        76   1223876   1% /run/shm
> /dev/md2       292833568     33312 292800256   1% /or
> /dev/md1       292833568 202533276  90300292  70% /root/workplace
> /dev/sdc1          90297     52782     32698  62% /boot
> myon400:/      976694528 485310720 491383808  50% /srv
> /dev/sda8      137821156        28  90827392   1% /test
> 
> in this case, you can see a raid0 setup for meta and data, also
> acknowledged by "sdb8 id2" and "sdc8 id3", the overall amount
> of 1k blocks in df = 137821156 but the available amount is 
> only 90827392 1-k blocks while 28 are in use. this looks like
> the calculation of raid0 outputs something i would assume 
> for raid5 or in other words just 2 of 3 raid-members usable.
> 
> maybe i misinterpreted something or made a mistake by creation
> however any documentation around gave me no idea.

This number is just a appraised number, not rigorous. It tells us
how much space we can use to make up raid0 block groups which are
used to store the file data.

Thanks
Miao

> 
> this test was made on a debian sid, using btrfs v0.19.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

