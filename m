From: Gordan Bobic <gordan@bobich.net>
Subject: Re: Update to Project_ideas wiki page
Date: Thu, 18 Nov 2010 15:06:30 +0000
Message-ID: <4CE540F6.7060701@bobich.net>
References: <m3hbfg3acu.fsf@pullcord.laptop.org>	<20101117143103.GA2401@selene>	<AANLkTi=YcVE44g9waRBHQPido4_xf1o5hE4zmTPqVBxN@mail.gmail.com>	<20101117175657.GB2401@selene> <4CE419ED.3020209@bobich.net> <AANLkTinKX6uULbK88WdkXhH-XjUboUDf2FV8qopjZPcC@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinKX6uULbK88WdkXhH-XjUboUDf2FV8qopjZPcC@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Bart Noordervliet wrote:
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

No. What I'm talking about the the probability of finding an error 
during the process of rebuilding a degraded array. With a 6TB (usable) 
array and disks with 10^-14 error rate, the probability of getting an 
unrecoverable read error exceeds 50%. n+1 RAID isn't fit for use with 
the current generation of drives where n > 1-5TB depending on how 
important your data and downtime are and how good your backups are.

And I don't put much stock in the manufacturer figures, either, so 
assume that 10^-14 is optimistic of it is reported. On high capacity 
drives (especially 1TB Seagates, both 3 and 4 platter variants) I am 
certainly seeing a higher error rate than that on a significant fraction 
of the disks.

Gordan
