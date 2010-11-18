From: Justin Ossevoort <justin@quarantainenet.nl>
Subject: Re: Update to Project_ideas wiki page
Date: Thu, 18 Nov 2010 16:02:19 +0100
Message-ID: <4CE53FFB.1050800@quarantainenet.nl>
References: <m3hbfg3acu.fsf@pullcord.laptop.org> <20101117143103.GA2401@selene> <AANLkTi=YcVE44g9waRBHQPido4_xf1o5hE4zmTPqVBxN@mail.gmail.com> <20101117175657.GB2401@selene> <4CE419ED.3020209@bobich.net> <AANLkTinKX6uULbK88WdkXhH-XjUboUDf2FV8qopjZPcC@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Gordan Bobic <gordan@bobich.net>, linux-btrfs@vger.kernel.org
To: Bart Noordervliet <bart@noordervliet.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinKX6uULbK88WdkXhH-XjUboUDf2FV8qopjZPcC@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 18/11/10 15:31, Bart Noordervliet wrote:
> On Wed, Nov 17, 2010 at 19:07, Gordan Bobic <gordan@bobich.net> wrote:
>> Since BTRFS is already doing some relatively radical things, I would like to
>> suggest that RAID5 and RAID6 be deemed obsolete. RAID5 isn't safely usable
>> for arrays bigger than about 5TB with disks that have a specified error rate
>> of 10^-14. RAID6 pushes that problem a little further away, but in the
>> longer term, I would argue that RAID (n+m) would work best. We specify that
>> of (n+m) disks in the array, we want n data disks and m redundancy disks. If
>> this is implemented in a generic way, then there won't be a need to
>> implement additional RAID modes later.
> 
> I presume you're talking about the uncaught read errors that makes
> many people avoid RAID5. Btrfs actually enables us to use it with
> confidence again, since using checksums it's able to detect these
> errors and prevent corruption of the array. So to the contrary, I see
> a lot of potential for parity-based redundancy in combination with
> btrfs.


No he's talking about the high chance of triggering another error during
the long time it takes to perform the recovery (and before your data is
redundant again). Often also attributed to multiple disks being from the
same batch and having the same flaws and lifetime expectancy.

But since btrfs would do this on a per object basis instead of the whole
array, only the objects whose blocks have gone are at risk (not
necessarily the whole filesystem). Furthermore, additional read errors
often only impact a subset of the files that were at risk.
Furthermore if recovery is half-way done when another error is triggerd
the already done part will still be available.

So the real strength is that corruptions are more likely only to impact
a small subset of the filesystem and that different objects can have
different amount of redundancy. So 'raid1' for metadata and other very
important files, no raid for unimportant data and raid5/6 for large
objects or for objects which only need a basic level of protection.

Regards,

    justin....
