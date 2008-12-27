From: Yan Zheng <ukernel@gmail.com>
Subject: Re: multiple device usage
Date: Sat, 27 Dec 2008 10:44:02 +0800
Message-ID: <49559672.7060204@gmail.com>
References: <556243856@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: devzero@web.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <556243856@web.de>
List-ID: <linux-btrfs.vger.kernel.org>

devzero@web.de wrote:
> hello,
> 
> i have some difficulty in understanding multi-device handling in depth.
> 
> as http://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices 
> tells,
> 
> btrfs can span over multiple devices at the same time. (great feature, btw !)
> 
> ok then:
>  
> mkfs.btrfs -m single -d single  /dev/sdb /dev/sdc - creates a btrfs spanning 
> over /dev/sdb and sdc
> 
> mount /dev/sdb /btrfs - mounts it
> 
> btrfs-vol -b /btrfs - does a rebalancing of all data and metadata
> 
> btrfs-vol -r /dev/sdc - removes one of the volumes and redistributes any 
> extends in use on sdc to sdb (killer feature!!!)
> 
> but what if i want to remove /dev/sdb ? (as that one is in use for the 
> mount)
>  

Devices in btrfs are equal, so you can do this. The only glitch is
/proc/mounts and mount(8) get confused.

Regards
Yan Zheng 
