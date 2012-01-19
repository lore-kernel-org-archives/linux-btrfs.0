From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [RFC][PATCH 1/2] Btrfs: try to allocate new chunks with degenerated
 profile
Date: Thu, 19 Jan 2012 13:58:32 +0800
Message-ID: <4F17B108.1020103@cn.fujitsu.com>
References: <4F154738.8000709@cn.fujitsu.com> <20120117205815.GG3658@shiny> <4F169B04.3060200@jan-o-sch.net>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F169B04.3060200@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 	wed, 18 Jan 2012 11:12:20 +0100, Jan Schmidt wrote:
> On 17.01.2012 21:58, Chris Mason wrote:
>> These two didn't make my first pull request just because I wanted to get
>> something out the door.  I'll definitely have them in the next pull.
> 
> Please, don't do that! You can't just degenerate to DUP when RAID1 is
> out of space, that's entirely different.
> 
> It's debatable whether degeneration from RAID0 to single is acceptable,
> but that again has different characteristics.
> 
> ENOSPC is the best choice for both in my opinon.

I understand what you said, but in fact, the free space allocator can degenerate
the profile if it doesn't find enough free space. This patch just follows the
rule which exists in the current code.

Maybe adding a new mount option is another good option.

Thanks
Miao

> 
> -Jan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

