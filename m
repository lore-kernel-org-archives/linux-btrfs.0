From: Gordan Bobic <gordan@bobich.net>
Subject: Re: Update to Project_ideas wiki page
Date: Thu, 18 Nov 2010 08:36:37 +0000
Message-ID: <4CE4E595.5070304@bobich.net>
References: <m3hbfg3acu.fsf@pullcord.laptop.org>	<20101117143103.GA2401@selene>	<AANLkTi=YcVE44g9waRBHQPido4_xf1o5hE4zmTPqVBxN@mail.gmail.com>	<20101117175657.GB2401@selene> <4CE419ED.3020209@bobich.net> <4CE421BD.7040105@bartk.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CE421BD.7040105@bartk.us>
List-ID: <linux-btrfs.vger.kernel.org>

Bart Kus wrote:
> On 11/17/2010 10:07 AM, Gordan Bobic wrote:
>> On 11/17/2010 05:56 PM, Hugo Mills wrote:
>>> On Wed, Nov 17, 2010 at 04:12:29PM +0100, Bart Noordervliet wrote:
>>>> Can I suggest we combine this new RAID level management with a
>>>> modernisation of the terminology for storage redundancy, as has been
>>>> discussed previously in the "Raid1 with 3 drives" thread of March this
>>>> year? I.e. abandon the burdened raid* terminology in favour of
>>>> something that makes more sense for a filesystem.
>>>
>>>     Well, our current RAID modes are:
>>>
>>>   * 1 Copy ("SINGLE")
>>>   * 2 Copies ("DUP")
>>>   * 2 Copies, different spindles ("RAID1")
>>>   * 1 Copy, 2 Stripes ("RAID0")
>>>   * 2 Copies, 2 Stripes [each] ("RAID10")
>>>
>>>     The forthcoming RAID5/6 code will expand on that, with
>>>
>>>   * 1 Copy, n Stripes + 1 Parity ("RAID5")
>>>   * 1 Copy, n Stripes + 2 Parity ("RAID6")
>>>
>>>     (I'm not certain how "n" will be selected -- it could be a config
>>> option, or simply selected on the basis of the number of
>>> spindles/devices currently in the FS).
>>>
>>>     We could further postulate a RAID50/RAID60 mode, which would be
>>>
>>>   * 2 Copies, n Stripes + 1 Parity
>>>   * 2 Copies, n Stripes + 2 Parity
>>
>> Since BTRFS is already doing some relatively radical things, I would 
>> like to suggest that RAID5 and RAID6 be deemed obsolete. RAID5 isn't 
>> safely usable for arrays bigger than about 5TB with disks that have a 
>> specified error rate of 10^-14. RAID6 pushes that problem a little 
>> further away, but in the longer term, I would argue that RAID (n+m) 
>> would work best. We specify that of (n+m) disks in the array, we want 
>> n data disks and m redundancy disks. If this is implemented in a 
>> generic way, then there won't be a need to implement additional RAID 
>> modes later.
> 
> Not to throw a wrench in the works, but has anyone given any thought as 
> to how to best deal with SSD-based RAIDs?  Normal RAID algorithms will 
> maximize synchronized failures of those devices.  Perhaps there's a 
> chance here to fix that issue?

The wear-out failure of SSDs (the exact failure you are talking bout) is 
very predictable. Current generation of SSDs provide a reading via SMART 
of how much life (in %) there is left in the SSD. When this gets down to 
single figures, the disks should be replaced. Provided that the disks 
are correctly monitored, it shouldn't be an issue.

On a related issue, I am not convinced that wear-out based SSD failure 
is an issue provided that:

1) there is at least a rudimentary amount of wear leveling done in the 
firmware. This is the case even for cheap CF/SD card media, and is not 
hard to implement. And considering I recently got a number of cheap-ish 
32GB CF cards with lifetime warranty, it's safe to assume they will have 
wear leveling built in, or Kingston will rue the day they sold them with 
lifetime warranty. ;)

2) Reasonable effort is made to not put write-heavy things onto SSDs 
(think /tmp, /var/tmp, /var/lock, /var/run, swap, etc.). These can 
safely be put on tmpfs instead, and for swap you can use ramzswap 
(compcache). You'll get both better performance and prolong the life  of 
the SSD significantly. Switching off atime on the FS helps a lot, too. 
And switching off journaling can make a difference of over 50% on 
metadata-heavy operations.

And assuming that you write 40GB of data per day to your 40GB SSD 
(unlikely for most applications), you'll still get a 10,000 day life 
expectancy on that disk. That's 30 years. Does anyone still use any 
disks from 30 years ago? What about 20 years ago? 10? The rate of growth 
of RAM and storage in computers has increased by about 10x in the last 
10 years. It seems unlikely that even if our current generation of SSDs 
will be useful in 10 years time, let alone 30.

> I like the RAID n+m mode of thinking though.  It'd also be nice to have 
> spares which are spun-down until needed.
 >
> Lastly, perhaps there's also a chance here to employ SSD-based caching 
> when doing RAID, as is done in the most recent RAID controllers?  

Tiered storage capability would be nice. What would it take to keep 
statistics on how frequently various file blocks are accessed, and put 
the most frequently accessed file blocks on SSD? It would be nice if 
this could be done by the accesses/day with some reasonable limit on the 
number of days over which accesses are considered.

> Exposure to media failures in the SSD does make me nervous about that 
> though.

You'd need a pretty substantial churn rate for that to happen quickly. 
With the caching strategy I described above, churn should be much lower 
than the naive LRU while providing a much better overall hit rate.

> Does anyone know if those controllers write some sort of extra 
> data to the SSD for redundancy/error recovery purposes?

SSDs handle that internally. The predictability of failures due to 
wear-out on SSDs makes this relatively easy to handle.

Another thing that would be nice to have - defrag with ability to 
specify where particular files should be kept. One thing I've been 
pondering writing for ext2 when I have a month of spare time is a defrag 
utility that can be passed an ordered list of files to put at the very 
front of the disk.

Such a list could easily be generated using inotify. This would log all 
file accesses during the boot/login process. Defragging the disk in such 
a way that all files read-accessed from the disk are laid out 
sequentially with no gaps at the front of the disk would ensure that 
boot times are actually faster than on an SSD*.

*Access time on an decent SSD is about 100us. With pre-fetch on a 
rotating disk, most, if not all, of the data that is going to be 
accessed is going to get pre-cached by the time we even ask for it, so 
it might even be faster. This might actually provide higher performance.

Gordan
