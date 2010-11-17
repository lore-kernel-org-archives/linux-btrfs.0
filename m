From: Bart Kus <me@bartk.us>
Subject: Re: Update to Project_ideas wiki page
Date: Wed, 17 Nov 2010 10:41:01 -0800
Message-ID: <4CE421BD.7040105@bartk.us>
References: <m3hbfg3acu.fsf@pullcord.laptop.org>	<20101117143103.GA2401@selene>	<AANLkTi=YcVE44g9waRBHQPido4_xf1o5hE4zmTPqVBxN@mail.gmail.com> <20101117175657.GB2401@selene> <4CE419ED.3020209@bobich.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Gordan Bobic <gordan@bobich.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CE419ED.3020209@bobich.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 11/17/2010 10:07 AM, Gordan Bobic wrote:
> On 11/17/2010 05:56 PM, Hugo Mills wrote:
>> On Wed, Nov 17, 2010 at 04:12:29PM +0100, Bart Noordervliet wrote:
>>> Can I suggest we combine this new RAID level management with a
>>> modernisation of the terminology for storage redundancy, as has been
>>> discussed previously in the "Raid1 with 3 drives" thread of March this
>>> year? I.e. abandon the burdened raid* terminology in favour of
>>> something that makes more sense for a filesystem.
>>
>>     Well, our current RAID modes are:
>>
>>   * 1 Copy ("SINGLE")
>>   * 2 Copies ("DUP")
>>   * 2 Copies, different spindles ("RAID1")
>>   * 1 Copy, 2 Stripes ("RAID0")
>>   * 2 Copies, 2 Stripes [each] ("RAID10")
>>
>>     The forthcoming RAID5/6 code will expand on that, with
>>
>>   * 1 Copy, n Stripes + 1 Parity ("RAID5")
>>   * 1 Copy, n Stripes + 2 Parity ("RAID6")
>>
>>     (I'm not certain how "n" will be selected -- it could be a config
>> option, or simply selected on the basis of the number of
>> spindles/devices currently in the FS).
>>
>>     We could further postulate a RAID50/RAID60 mode, which would be
>>
>>   * 2 Copies, n Stripes + 1 Parity
>>   * 2 Copies, n Stripes + 2 Parity
>
> Since BTRFS is already doing some relatively radical things, I would 
> like to suggest that RAID5 and RAID6 be deemed obsolete. RAID5 isn't 
> safely usable for arrays bigger than about 5TB with disks that have a 
> specified error rate of 10^-14. RAID6 pushes that problem a little 
> further away, but in the longer term, I would argue that RAID (n+m) 
> would work best. We specify that of (n+m) disks in the array, we want 
> n data disks and m redundancy disks. If this is implemented in a 
> generic way, then there won't be a need to implement additional RAID 
> modes later.

Not to throw a wrench in the works, but has anyone given any thought as 
to how to best deal with SSD-based RAIDs?  Normal RAID algorithms will 
maximize synchronized failures of those devices.  Perhaps there's a 
chance here to fix that issue?

I like the RAID n+m mode of thinking though.  It'd also be nice to have 
spares which are spun-down until needed.

Lastly, perhaps there's also a chance here to employ SSD-based caching 
when doing RAID, as is done in the most recent RAID controllers?  
Exposure to media failures in the SSD does make me nervous about that 
though.  Does anyone know if those controllers write some sort of extra 
data to the SSD for redundancy/error recovery purposes?

--Bart

