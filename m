Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:32871 "EHLO
	mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbcCRLjv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 07:39:51 -0400
Received: by mail-qk0-f172.google.com with SMTP id s5so47543007qkd.0
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Mar 2016 04:39:51 -0700 (PDT)
Received: from [127.0.0.1] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id o128sm5769619qhb.34.2016.03.18.04.39.49
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Fri, 18 Mar 2016 04:39:49 -0700 (PDT)
Subject: Re: Snapshots slowing system
To: linux-btrfs@vger.kernel.org
References: <201603142303.u2EN3qo3011695@phoenix.vfire>
 <pan$a0d0a$9f23433a$f19e4b84$b275dc3f@cox.net>
 <56E88CB2.6020300@petezilla.co.uk> <56E945E9.1050005@gmail.com>
 <56EB1CC7.2000602@petezilla.co.uk>
 <pan$24d34$c6dcbaed$b9940b06$c8b4f058@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56EBE8B5.4090705@gmail.com>
Date: Fri, 18 Mar 2016 07:38:29 -0400
MIME-Version: 1.0
In-Reply-To: <pan$24d34$c6dcbaed$b9940b06$c8b4f058@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-03-18 05:17, Duncan wrote:
> Pete posted on Thu, 17 Mar 2016 21:08:23 +0000 as excerpted:
>>    5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail  Always
>>        -       0
>
> This one is available on ssds and spinning rust, and while it never
> actually hit failure mode for me on an ssd I had that went bad, I watched
> over some months as the raw reallocated sector count increased a bit at a
> time.  (The device was one of a pair with multiple btrfs raid1 on
> parallel partitions on each, and the other device of the pair remains
> perfectly healthy to this day, so I was able to use btrfs checksumming
> and scrubs to keep the one that was going bad repaired based on the other
> one, and was thus able to run it for quite some time after I would have
> otherwise replaced it, simply continuing to use it out of curiosity and
> to get some experience with how it and btrfs behaved when failing.)
>
> In my case, it started at 253 cooked with 0 raw, then dropped to a
> percentage (still 100 at first) as soon as the first sector was
> reallocated (raw count of 1).  It appears that your manufacturer treats
> it as a percentage from a raw count of 0.
>
> What really surprised me was just how many spare sectors that ssd
> apparently had.  512 byte sectors, so half a KiB each.  But it was into
> the thousands of replaced sectors raw count, so Megabytes used, but the
> cooked count had only dropped to 85 or so by the time I got tired of
> constantly scrubbing to keep it half working as more and more sectors
> failed.   But threshold was 36, so I wasn't anywhere CLOSE to getting to
> reported failure here, despite having thousands of replaced sectors thus
> megabytes in size.
This actually makes sense, as SSD's have spare 'sectors' in erase block 
size chunks, and most use a minimum 1MiB erase block size, with 4-8MiB 
being normal for most consumer devices.
>
> But the ssd was simply bad before its time, as it wasn't failing due to
> write-cycle wear-out, but due to bad flash, plain and simple.  With the
> other device (and the one I replaced it with as well, I actually had
> three of the same brand and size SSDs), there's still no replaced sectors
> at all.
>
> But apparently, when ssds hit normal old-age and start to go bad from
> write-cycle failure, THAT is when those 128 MiB or so (as I calculated
> based on percentage and raw value failed at one point, or was it 256 MiB,
> IDR for sure) of replacement sectors start to be used.  And on SSDs,
> apparently when that happens, sectors often fail and are replaced faster
> than I was seeing, so it's likely people will actually get to failure
> mode on this attribute in that case.
>
> I'd guess spinning rust has something less, maybe 64 MiB for multiple TB
> of storage, instead of the 128 or 256 MiB I saw on my 256 GiB SSDs.  That
> would be because spinning rust failure mode is typically different, and
> while a few sectors might die and be replaced over the life of the
> device, typically it's not that many, and failure is by some other means
> like mechanical failure (failure to spin up, or read heads getting out of
> tolerated sync with the cylinders on the device).
>
>>    7 Seek_Error_Rate         0x000f   073   060   030    Pre-fail  Always
>>        -       56166570022
>
> Like the raw-read-error-rate attribute above, you're seeing minor issues
> as the raw number isn't 0, and in this case, the cooked value is
> obviously dropping significantly as well, but it's still within
> tolerance, so it's not failing yet.  That worst cooked value of 60 is
> starting to get close to that threshold of 30, however, so this one's
> definitely showing wear, just not failure... yet.
>
>>    9 Power_On_Hours          0x0032   075   075   000    Old_age   Always
>>        -       22098
>
> Reasonable for a middle-aged drive, considering you obviously don't shut
> it down often (a start-stop-count raw of 80-something).  That's ~2.5
> years of power-on.
>
>>   10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always
>>        -       0
>
> This one goes with spin-up time.  Absolutely no problems here.
>
>>   12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Always
>>        -       83
>
> Matches start-stop-count.  Good. =:^)  Since you obviously don't spin
> down except at power-off, this one isn't going to be a problem for you.
>
>> 184 End-to-End_Error        0x0032   098   098   099    Old_age   Always
>>    FAILING_NOW 2
>
> I /think/ this one is a power-on head self-test head seek from one side
> of the device to the other, and back, covering both ways.
I believe you're correct about this, although I've never seen any 
definitive answer anywhere.
>
> Assuming I'm correct on the above guess, the combination of this failing
> for you, and the not yet failing but a non-zero raw-value for raw-read-
> error-rate and seek-error-rate, with the latter's cooked value being
> significantly down if not yet failing, is definitely concerning, as the
> three values all have to do with head seeking errors.
>
> I'd definitely get your data onto something else as soon as possible, tho
> as much of it is backups, you're not in too bad a shape even if you lose
> them, as long as you don't lose the working copy at the same time.
>
> But with all three seek attributes indicating at least some issue and one
> failing, at least get anything off it that is NOT backups ASAP.
>
> And that very likely explains the slowdowns as well, as obviously, while
> all sectors are still readable, it's having to retry multiple times on
> some of them, and that WILL slow things down.
>
>> 188 Command_Timeout         0x0032   100   099   000    Old_age   Always
>>        -       8590065669
>
> Again, a non-zero raw value indicating command timeouts, probably due to
> those bad seeks.  It'll have to retry those commands, and that'll
> definitely mean slowdowns.
>
> Tho there's no threshold, but 99 worst-value cooked isn't horrible.
>
> FWIW, on my spinning rust device this value actually shows a worst of
> 001, here (100 current cooked value, tho), with a threshold of zero,
> however.  But as I've experienced no problems with it I'd guess that's an
> aberration.  I haven't the foggiest why/how/when it got that 001 worst.
Such an occurrence is actually not unusual when you have particularly 
bad sectors on a 'desktop' rated HDD, as they will keep retrying for an 
insanely long time to read the bad sector before giving up.
>
>> 189 High_Fly_Writes         0x003a   095   095   000    Old_age   Always
>>        -       5
>
> Again, this demonstrates a bit of disk wobble or head slop.  But with a
> threshold of zero and a value and worst of 95, it doesn't seem to be too
> bad.
>
>> 193 Load_Cycle_Count        0x0032   001   001   000    Old_age   Always
>>        -       287836
>
> Interesting.  My spinning rust has the exact same value and worst of 1,
> threshold 0, and a relatively similar 237181 raw count.
>
> But I don't really know what this counts unless it's actual seeks, and
> mine seems in good health still, certainly far better than the cooked
> value and worst of 1 might suggest.
As far as I understand it, this is an indicator of the number of times 
the heads have been loaded and unloaded.  This is tracked separately as 
there are multiple reasons the heads might get parked without spinning 
down the disk (most disks will park them if they've been idle, so that 
they reduce the risk of a head crash, and many modern laptops will park 
them if they detect that they're in free fall to protect the disk when 
they impact whatever they fall onto).  It's not unusual to see values 
like that for similarly aged disks either though, so it's not too worrying.
>
>> 240 Head_Flying_Hours       0x0000   100   253   000    Old_age Offline
>>      -       281032595099550
>
>> OK, head flying hours explains it, drive is over 32 billion years old...
>>
>
> While my spinning rust has this attribute and the cooked values are
> identical 100/253/0, the raw value is reported and formatted entirely
> differently, as 21122 (89 19 0).  I don't know what those values are, but
> presumably your big long value reports the others mine does, as well,
> only as a big long combined value.
>
> Which would explain the apparent multi-billion years yours is reporting!
> =:^)  It's not a single value, it's multiple values somehow combined.
>
> At least with my power-on hours of 23637, a head-flying hours of 21122
> seems reasonable.  (I only recently configured the BIOS to spin down that
> drive after 15 minutes I think, because it's only backups and my media
> partition which isn't mounted all the time anyway, so I might as well
> leave it off instead of idle-spinning when I might not use it for days at
> a time.  So a difference of a couple thousand hours between power-on and
> head-flying, on a base of 20K+ hours for both, makes sense given that I
> only recently configured it to spin down.)
>
> But given your ~22K power-on hours, even simply peeling off the first 5
> digits of your raw value would be 28K head-flying, and that doesn't make
> sense for only 22K power-on, so obviously they're using a rather more
> complex formula than that.
This one is tricky, as it's not very clearly defined in the SMART spec. 
  Most manufacturers just count the total time the head has been loaded. 
  There are some however who count the time the heads have been loaded, 
multiplied by the number of heads.  This value still appears to be 
incorrect though, as combined with the Power_On_Hours, it implies well 
over 1024 heads, which is physically impossible on even a 5.25 inch disk 
using modern technology, even using multiple spindles.  The fact that 
this is so blatantly wrong should be a red flag regarding the disk 
firmware or on-board electronics, which just reinforces what Duncan 
already said about getting a new disk.
