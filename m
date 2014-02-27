Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from hibox-130.abo.fi ([130.232.216.130]:45266 "EHLO centre.hibox.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685AbaB0AQR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Feb 2014 19:16:17 -0500
Message-ID: <530E83C7.5080101@iki.fi>
Date: Thu, 27 Feb 2014 02:16:07 +0200
From: Marcus Sundman <sundman@iki.fi>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: Josef Bacik <jbacik@fb.com>, Jim Salter <jim@jrs-s.net>,
        Hugo Mills <hugo@carfax.org.uk>
Subject: Re: No space left on device (again)
References: <530CC9B0.1080703@iki.fi> <530CDB7F.9020807@jrs-s.net> <20140225201921.GB13899@carfax.org.uk> <530CFCCE.5060707@iki.fi> <530CFD66.7060006@fb.com>
In-Reply-To: <530CFD66.7060006@fb.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25.02.2014 22:30, Josef Bacik wrote:
> On 02/25/2014 03:27 PM, Marcus Sundman wrote:
>> On 25.02.2014 22:19, Hugo Mills wrote:
>>> On Tue, Feb 25, 2014 at 01:05:51PM -0500, Jim Salter wrote:
>>>> 370GB of 410GB used isn't really "fine", it's over 90% usage.
>>>>
>>>> That said, I'd be interested to know why btrfs fi show
>>>> /dev/sda3 shows 412.54G used, but btrfs fi df /home shows 379G
>>>> used...
>>> This is an FAQ...
>>>
>>> btrfs fi show tells you how much is allocated out of the
>>> available pool on each disk. btrfs fi df then shows how much of
>>> that allocated space (in each category) is used.
>> What is the difference between the "used 371.11GB" and the "used
>> 412.54GB" displayed by "btrfs fi show"?
>>
>>> The problem here is also in the FAQ: the metadata is close to
>>> full -- typically something like 500-750 MiB of headroom is
>>> needed in metadata. The FS can't allocate more metadata because
>>> it's allocated everything already (total=used in btrfs fi show),
>>> so the solution is to do a filtered balance:
>>>
>>> btrfs balance start -dusage=5 /mountpoint
>> Of course that was the first thing I tried, and it didn't help *at*
>> *all*:
>>
> The -dusage=<number> is a means to an end, so if that doesn't work try
> a larger number, up to 100.  Really once you pass 50 and it's not
> working then it's time to just do a balance.  The next thing is to use
> compression (too late for this option really) or add another disk.

So it relocates some chunks. What will that do? Does it mean I can now 
use the remaining 45 GB? Or will it run out of "disk space" again after 
using a gig or two?
If it's the allocated metadata space that is the problem then how can I 
pre-allocate more of it so it won't run out of it?


- Marcus

