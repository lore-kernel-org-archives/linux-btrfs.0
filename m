From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: hold enough space for global_rsv
Date: Fri, 09 Mar 2012 09:28:56 +0800
Message-ID: <4F595CD8.7000900@cn.fujitsu.com>
References: <1326793919-2712-1-git-send-email-liubo2009@cn.fujitsu.com>	<20120227142904.18c5df56@fem.tu-ilmenau.de>	<4F4C3696.8010804@cn.fujitsu.com>	<20120306145032.697641a3@fem.tu-ilmenau.de> <20120308202225.01ad2ffd@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120308202225.01ad2ffd@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 03/09/2012 03:22 AM, Johannes Hirte wrote:
> Am Tue, 6 Mar 2012 14:50:32 +0100
> schrieb Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>:
> 
>> I've backed up the filesystem, deleted the subvolumes, recreated them
>> and copied the data back. Now everything seems to work again. I've
>> also a full image of the damaged filesystem for further
>> investigation. If someone has an idea for testing, I'm happy to try
>> it.
> 
> It's much worse than I thought. After a short time the same error
> happened again (no space left on device). So recreated the filesystem
> (mkbtrfs with default values) and copied the data from the backup back,
> but the error still came back. I'm now on kernel 3.2 which seems to
> work. I'll try to bisect the bad commit. For info, df says:
> 

OK, plz show us the results after your bisect, let's narrow down where goes wrong.

thanks,
liubo

> Filesystem      Size  Used Avail Use% Mounted on
> rootfs          200G  128G   69G  66% /
> /dev/sda1       200G  128G   69G  66% /
> rc-svcdir       1.0M  128K  896K  13% /lib64/rc/init.d
> cgroup_root      10M   52K   10M   1% /sys/fs/cgroup
> udev             10M  168K  9.9M   2% /dev
> shm             2.0G     0  2.0G   0% /dev/shm
> /dev/sda1       200G  128G   69G  66% /home
> 
> and btrfs fi df:
> 
> Data: total=149.01GB, used=118.57GB
> System, DUP: total=8.00MB, used=24.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=6.38GB, used=4.55GB
> Metadata: total=8.00MB, used=0.0
> 
> Kernel 3.3-rc6 fails on this with "no space left on device".
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

