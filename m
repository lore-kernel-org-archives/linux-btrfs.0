From: Zoiled <zoiled@online.no>
Subject: Re: Will BTRFS repair or restore data if corrupted?
Date: Thu, 26 Jan 2012 20:16:23 +0100
Message-ID: <4F21A687.3010506@online.no>
References: <4F208FFD.4020508@online.no> <20120126085938.GC5531@carfax.org.uk> <4F211DCF.90707@giantdisaster.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Hugo Mills <hugo@carfax.org.uk>, Waxhead <waxhead@online.no>,
	linux-btrfs@vger.kernel.org
To: Stefan Behrens <sbehrens@giantdisaster.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F211DCF.90707@giantdisaster.de>
List-ID: <linux-btrfs.vger.kernel.org>

Stefan Behrens wrote:
> On 1/26/2012 9:59 AM, Hugo Mills wrote:
>> On Thu, Jan 26, 2012 at 12:27:57AM +0100, Waxhead wrote:
> [...]
>>> Will BTRFS try to repair the corrupt data or will it simply silently
>>> restore the data without the user knowing that a file has been
>>> "fixed"?
>>     No, it'll just return the good copy and report the failure in the
>> system logs. If you want to fix the corrupt data, you need to use
>> scrub, which will check everything and fix blocks with failed
>> checksums.
> Since 3.2, btrfs rewrites the corrupt disk block (commit 4a54c8c and
> f4a8e65 from Jan Schmidt), even without scrub.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
So if I for example edit a text file three times and store it I can get 
the following.
Version1: I currently like cheese
Version2: I currently like onions
Version3: I currently like apples
As far as I understand a disk corruption might result in me suddenly 
liking onions (or even cheese) instead of apples without any warning 
except in syslog.?! I really hope I have misunderstood the concept and 
that there is some error correction codes somewhere.
