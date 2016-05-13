Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:32846 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbcEMMON (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 May 2016 08:14:13 -0400
Received: by mail-ig0-f173.google.com with SMTP id c3so1769064igl.0
        for <linux-btrfs@vger.kernel.org>; Fri, 13 May 2016 05:14:13 -0700 (PDT)
Subject: Re: About in-band dedupe for v4.7
To: Mark Fasheh <mfasheh@suse.de>, dsterba@suse.cz,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, btrfs <linux-btrfs@vger.kernel.org>
References: <aae84f04-cb64-46f3-79ea-f2d84d79a3ba@cn.fujitsu.com>
 <20160510221119.GD7633@wotan.suse.de>
 <23ec14b4-deb3-4294-348c-1f0e4a7db169@cn.fujitsu.com>
 <20160511025211.GF7633@wotan.suse.de> <20160511173659.GI29353@suse.cz>
 <20160512205426.GL7633@wotan.suse.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <eb0c315c-cea0-276c-d9bb-d83883cd01a4@gmail.com>
Date: Fri, 13 May 2016 08:14:10 -0400
MIME-Version: 1.0
In-Reply-To: <20160512205426.GL7633@wotan.suse.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-12 16:54, Mark Fasheh wrote:
> On Wed, May 11, 2016 at 07:36:59PM +0200, David Sterba wrote:
>> On Tue, May 10, 2016 at 07:52:11PM -0700, Mark Fasheh wrote:
>>> Taking your history with qgroups out of this btw, my opinion does not
>>> change.
>>>
>>> With respect to in-memory only dedupe, it is my honest opinion that such a
>>> limited feature is not worth the extra maintenance work. In particular
>>> there's about 800 lines of code in the userspace patches which I'm sure
>>> you'd want merged, because how could we test this then?
>>
>> I like the in-memory dedup backend. It's lightweight, only a heuristic,
>> does not need any IO or persistent storage. OTOH I consider it a subpart
>> of the in-band deduplication that does all the persistency etc. So I
>> treat the ioctl interface from a broader aspect.
>
> Those are all nice qualities, but what do they all get us?
>
> For example, my 'large' duperemove test involves about 750 gigabytes of
> general purpose data - quite literally /home off my workstation.
>
> After the run I'm usually seeing between 65-75 gigabytes saved for a total
> of only 10% duplicated data. I would expect this to be fairly 'average' -
> /home on my machine has the usual stuff - documents, source code, media,
> etc.
>
> So if you were writing your whole fs out you could expect about the same
> from inline dedupe - 10%-ish. Let's be generous and go with that number
> though as a general 'this is how much dedupe we get'.
>
> What the memory backend is doing then is providing a cache of sha256/block
> calculations. This cache is very expensive to fill, and every written block
> must go through it. On top of that, the cache does not persist between
> mounts, and has items regularly removed from it when we run low on memory.
> All of this will drive down the amount of duplicated data we can find.
>
> So our best case savings is probably way below 10% - let's be _really_ nice
> and say 5%.
>
> Now ask yourself the question - would you accept a write cache which is
> expensive to fill and would only have a hit rate of less than 5%?
In-band deduplication is a feature that is not used by typical desktop 
users or even many developers because it's computationally expensive, 
but it's used _all the time_ by big data-centers and similar places 
where processor time is cheap and storage efficiency is paramount. 
Deduplication is more useful in general the more data you have.  5% of 1 
TB is 20 GB, which is not much.  5% of 1 PB is 20 TB, which is at least 
3-5 disks, which can then be used for storing more data, or providing 
better resiliency against failures.

To look at it another way, deduplicating an individual's home directory 
will almost never get you decent space savings, the majority of shared 
data is usually file headers and nothing more, which can't be 
deduplicated efficiently because of block size requirements. 
Deduplicating all the home directories on a terminal server with 500 
users usually will get you decent space savings, as there very likely 
are a number of files that multiple people have exact copies of, but 
most of them are probably not big files.  Deduplicating the entirety of 
a multi-petabyte file server used for storing VM disk images will 
probably save you a very significant amount of space, because the 
probability of having data that can be deduplicated goes up as you store 
more data, and there is likely to be a lot of data shared between the 
disk images.

This is exactly why I don't use deduplication on any of my personal 
systems.  On my laptop, the space saved is just not worth the time spent 
doing it, as I fall pretty solidly into the first case (most of the data 
duplication on my systems is in file headers).  On my home server, I'm 
not storing enough data with sufficient internal duplication that it 
would save more than 10-20 GB, which doesn't matter for me given that 
I'm using roughly half of the 2.2 TB of effective storage space I have. 
However, once we (eventually) get all the file servers where I work 
moved over to Linux systems running BTRFS, we will absolutely be using 
deduplication there, as we have enough duplication in our data that it 
will probably cut our storage requirements by around 20% on average.
