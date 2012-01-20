From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [RFC][PATCH 1/2] Btrfs: try to allocate new chunks with degenerated
 profile
Date: Fri, 20 Jan 2012 11:36:48 +0100
Message-ID: <4F1943C0.9080404@jan-o-sch.net>
References: <4F154738.8000709@cn.fujitsu.com> <20120117205815.GG3658@shiny> <4F169B04.3060200@jan-o-sch.net> <4F17B108.1020103@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: miaox@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F17B108.1020103@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 19.01.2012 06:58, Miao Xie wrote:
> On 	wed, 18 Jan 2012 11:12:20 +0100, Jan Schmidt wrote:
>> On 17.01.2012 21:58, Chris Mason wrote:
>>> These two didn't make my first pull request just because I wanted to get
>>> something out the door.  I'll definitely have them in the next pull.
>>
>> Please, don't do that! You can't just degenerate to DUP when RAID1 is
>> out of space, that's entirely different.
>>
>> It's debatable whether degeneration from RAID0 to single is acceptable,
>> but that again has different characteristics.
>>
>> ENOSPC is the best choice for both in my opinon.
> 
> I understand what you said, but in fact, the free space allocator can degenerate
> the profile if it doesn't find enough free space. This patch just follows the
> rule which exists in the current code.

I'm not sure what you mean with "free space allocation". In my
understanding, new "free" space is made available by allocating a new
chunk, and that's what you're suggesting to change. What am I missing here?

Calculation of free space like for df output is known to be at least
unintuitive (I'd say wrong). We'd better fix that.

Space reservation may be wrongly assuming it can use the whole disk. If
that's the case, we must fix it.

> Maybe adding a new mount option is another good option.

I don't think so. If you want RAID-1, you get RAID-1, i.e. every stripe
on two disks. If you're okay with DUP, use DUP. But even with a mount
option, degeneration would still go silent and you'd never know which
part of your data would survive a single disk failure.

Think of degenration of your metadata profile to DUP: Suddenly, your
most recent extent tree wouldn't survive a single disk failure.

In my opinion, we're responsible not to offer any dangerous (mount)
options that can make users lose data eventually. Even if we can point
them to the documentation (which they didn't read) that explains the
risks of that option.

-Jan
