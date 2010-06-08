From: "J. David Beutel" <list@getsu.com>
Subject: Re: btrfs raid1 still recognized after being overwritten by md raid1
Date: Mon, 07 Jun 2010 23:18:12 -1000
Message-ID: <4C0E0AD4.3090902@getsu.com>
References: <4C0CB7FF.2080405@getsu.com> <4C0D9CDC.5010307@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: minskey guo <chaohong_guo@linux.intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C0D9CDC.5010307@linux.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/07/2010 03:29 PM, minskey guo wrote:
> On 06/07/2010 05:12 PM, J. David Beutel wrote:
>> I created an md raid1 on partitions that had a btrfs raid1, but btrfs is
>> still recognized on one of those partitions. (Is it finding some
>> left-over, redundant metadata?) I'm concerned this will confuse me or
>> btrfs in the future. How should I fix this?
>
>
> Seem that btrfs-show checks the 1st superblock only, running the 
> following can zap some part of that superblock,
>
>   dd if=/dev/zero of=/dev/sda7 seek=128 bs=512 count=1
>
> but probably, you need to zap the 2nd superblock as
>
>  dd if=/dev/zero of=/dev/sda7 seek=128k bs=512 count=1
>
>
> In case the block is being used, you can dump that block and
> search "_BHRfS_M" in that block before clear it.


Thanks!  Both of those blocks had "_BHRfS_M".  Zapping them stopped sda7 
from showing up in btrfs-show, while /proc/mdstat is unchanged and / 
still works.

Cheers,
11011011
