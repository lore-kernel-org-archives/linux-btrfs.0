From: dima <dolenin@parallels.com>
Subject: Re: Unable to mount (or, why not to work late at night).
Date: Fri, 28 Oct 2011 09:49:19 +0900
Message-ID: <4EA9FC0F.8060406@parallels.com>
References: <7d421a89143f5c4811d64e08c6820c29@www.jots.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Cc: <linux-btrfs@vger.kernel.org>
To: Ken D'Ambrosio <ken@jots.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <7d421a89143f5c4811d64e08c6820c29@www.jots.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 10/28/2011 09:32 AM, Ken D'Ambrosio wrote:
>> some of us make use of snapshot/clone, whether it's using btrfs or zfs :)
>
> No, this is just flat my fault: it doesn't matter what backup method you use if
> you do it wrong.  (I actually have three snapshots of each of my two
> partitions.)
>
>> What do you mean don't let you do anything? Can you mount it read-only
>> and copy the data off the disk?
>
> You can mount it on the older kernels, but, once you try any form of access,
> you can watch your load spike as it spews errors into dmesg.
>
>> I'd try 3.1. If you use 11.10 try
>> http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.1-oneiric/
>
> 3.1 is what the system had been running; it simply panics when trying to mount
> the FS.

Hello Ken,

Personally I would be very afraid to go from 3.1 to 2.6.x. There should 
be no incompatible changes, but still I would expect all sorts of 
trouble and instability at the very least. There are a few mount options 
that were added in 3.x and that will not work with older kernels. Might 
be you are hitting those as well if you used them (just wild guessing 
without any real grounds).

I would try getting the latest live CD with 3.1 from somewhere and try 
to mount your various snapshots from there. You might as well be lucky 
and be able to mount some of your snapshots.
The repair program from this list would be your last resort I think (

~d
