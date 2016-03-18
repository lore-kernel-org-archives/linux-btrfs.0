Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48626 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755038AbcCRJRe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 05:17:34 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1agqX1-0001H6-Td
	for linux-btrfs@vger.kernel.org; Fri, 18 Mar 2016 10:17:20 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Mar 2016 10:17:19 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Mar 2016 10:17:19 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Snapshots slowing system
Date: Fri, 18 Mar 2016 09:17:12 +0000 (UTC)
Message-ID: <pan$24d34$c6dcbaed$b9940b06$c8b4f058@cox.net>
References: <201603142303.u2EN3qo3011695@phoenix.vfire>
	<pan$a0d0a$9f23433a$f19e4b84$b275dc3f@cox.net>
	<56E88CB2.6020300@petezilla.co.uk> <56E945E9.1050005@gmail.com>
	<56EB1CC7.2000602@petezilla.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Pete posted on Thu, 17 Mar 2016 21:08:23 +0000 as excerpted:

> Hmm.  Comments on ssd s set me googling.  Don't normally touch smartctl
> 
> root@phoenix:~# smartctl --attributes /dev/sdc
> <snip>
> 184 End-to-End_Error        0x0032   098   098   099    Old_age   Always
>   FAILING_NOW 2
> <snip>
>   1 Raw_Read_Error_Rate     0x000f   120   099   006    Pre-fail  Always
>       -       241052216
> 
> That figure seems to be on the move.  On /dev/sdb (the other half of my
> hdd raid1 btrfs it is zero).  I presume zero means either 'no errors,
> happy days' or 'not supported'.

This is very useful.  See below.

> Hmm.  Is this bad and/or possibly the smoking gun for slowness?  I will
> keep an eye on the number to see if it changes.
> 
> OK, full output:
> root@phoenix:~# smartctl --attributes /dev/sdc
> [...]
> === START OF READ SMART DATA SECTION ===
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE UPDATED 
> WHEN_FAILED RAW_VALUE
>   1 Raw_Read_Error_Rate     0x000f   120   099   006    Pre-fail  Always
>       -       241159856

This one's showing some issues, but is within tolerance as even the worst 
value of 99 is still _well_ above the failure threshold of 6.

But the fact that the raw value isn't simply zero means that it is having 
mild problems, they're just well within tolerance according to the cooked 
value and threshold.

(I've snipped a few of these...)

>   3 Spin_Up_Time            0x0003   093   093   000    Pre-fail  Always
>       -       0

On spinning rust this one's a strong indicator of one of the failure 
modes, a very long time to spin up.  Obviously that's not a problem with 
this device.  Even raw is zero.

>   4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always
>       -       83

Spinning up a drive is hard on it.  Laptops in particular often spin down 
their drives to save power, then spin them up again.  Wall-powered 
machines can and sometimes do, but it's not as common, and when they do, 
the spin-down time is often an hour or higher of idle, where on laptops 
it's commonly 15 minutes and may be as low as 5.

Obviously you're doing no spindowns except for power-offs, and thus have 
a very low raw count of 83, which hasn't dropped the cooked value from 
100 yet, so great on this one as well.

>   5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail  Always
>       -       0

This one is available on ssds and spinning rust, and while it never 
actually hit failure mode for me on an ssd I had that went bad, I watched 
over some months as the raw reallocated sector count increased a bit at a 
time.  (The device was one of a pair with multiple btrfs raid1 on 
parallel partitions on each, and the other device of the pair remains 
perfectly healthy to this day, so I was able to use btrfs checksumming 
and scrubs to keep the one that was going bad repaired based on the other 
one, and was thus able to run it for quite some time after I would have 
otherwise replaced it, simply continuing to use it out of curiosity and 
to get some experience with how it and btrfs behaved when failing.)

In my case, it started at 253 cooked with 0 raw, then dropped to a 
percentage (still 100 at first) as soon as the first sector was 
reallocated (raw count of 1).  It appears that your manufacturer treats 
it as a percentage from a raw count of 0.

What really surprised me was just how many spare sectors that ssd 
apparently had.  512 byte sectors, so half a KiB each.  But it was into 
the thousands of replaced sectors raw count, so Megabytes used, but the 
cooked count had only dropped to 85 or so by the time I got tired of 
constantly scrubbing to keep it half working as more and more sectors 
failed.   But threshold was 36, so I wasn't anywhere CLOSE to getting to 
reported failure here, despite having thousands of replaced sectors thus 
megabytes in size.

But the ssd was simply bad before its time, as it wasn't failing due to 
write-cycle wear-out, but due to bad flash, plain and simple.  With the 
other device (and the one I replaced it with as well, I actually had 
three of the same brand and size SSDs), there's still no replaced sectors 
at all.

But apparently, when ssds hit normal old-age and start to go bad from 
write-cycle failure, THAT is when those 128 MiB or so (as I calculated 
based on percentage and raw value failed at one point, or was it 256 MiB, 
IDR for sure) of replacement sectors start to be used.  And on SSDs, 
apparently when that happens, sectors often fail and are replaced faster 
than I was seeing, so it's likely people will actually get to failure 
mode on this attribute in that case.

I'd guess spinning rust has something less, maybe 64 MiB for multiple TB 
of storage, instead of the 128 or 256 MiB I saw on my 256 GiB SSDs.  That 
would be because spinning rust failure mode is typically different, and 
while a few sectors might die and be replaced over the life of the 
device, typically it's not that many, and failure is by some other means 
like mechanical failure (failure to spin up, or read heads getting out of 
tolerated sync with the cylinders on the device).

>   7 Seek_Error_Rate         0x000f   073   060   030    Pre-fail  Always
>       -       56166570022

Like the raw-read-error-rate attribute above, you're seeing minor issues 
as the raw number isn't 0, and in this case, the cooked value is 
obviously dropping significantly as well, but it's still within 
tolerance, so it's not failing yet.  That worst cooked value of 60 is 
starting to get close to that threshold of 30, however, so this one's 
definitely showing wear, just not failure... yet.

>   9 Power_On_Hours          0x0032   075   075   000    Old_age   Always
>       -       22098

Reasonable for a middle-aged drive, considering you obviously don't shut 
it down often (a start-stop-count raw of 80-something).  That's ~2.5 
years of power-on.

>  10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always
>       -       0

This one goes with spin-up time.  Absolutely no problems here.

>  12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Always
>       -       83

Matches start-stop-count.  Good. =:^)  Since you obviously don't spin 
down except at power-off, this one isn't going to be a problem for you.

> 184 End-to-End_Error        0x0032   098   098   099    Old_age   Always
>   FAILING_NOW 2

I /think/ this one is a power-on head self-test head seek from one side 
of the device to the other, and back, covering both ways.

Assuming I'm correct on the above guess, the combination of this failing 
for you, and the not yet failing but a non-zero raw-value for raw-read-
error-rate and seek-error-rate, with the latter's cooked value being 
significantly down if not yet failing, is definitely concerning, as the 
three values all have to do with head seeking errors.

I'd definitely get your data onto something else as soon as possible, tho 
as much of it is backups, you're not in too bad a shape even if you lose 
them, as long as you don't lose the working copy at the same time.

But with all three seek attributes indicating at least some issue and one 
failing, at least get anything off it that is NOT backups ASAP.

And that very likely explains the slowdowns as well, as obviously, while 
all sectors are still readable, it's having to retry multiple times on 
some of them, and that WILL slow things down.

> 188 Command_Timeout         0x0032   100   099   000    Old_age   Always
>       -       8590065669

Again, a non-zero raw value indicating command timeouts, probably due to 
those bad seeks.  It'll have to retry those commands, and that'll 
definitely mean slowdowns.

Tho there's no threshold, but 99 worst-value cooked isn't horrible.

FWIW, on my spinning rust device this value actually shows a worst of 
001, here (100 current cooked value, tho), with a threshold of zero, 
however.  But as I've experienced no problems with it I'd guess that's an 
aberration.  I haven't the foggiest why/how/when it got that 001 worst.

> 189 High_Fly_Writes         0x003a   095   095   000    Old_age   Always
>       -       5

Again, this demonstrates a bit of disk wobble or head slop.  But with a 
threshold of zero and a value and worst of 95, it doesn't seem to be too 
bad.

> 193 Load_Cycle_Count        0x0032   001   001   000    Old_age   Always
>       -       287836

Interesting.  My spinning rust has the exact same value and worst of 1, 
threshold 0, and a relatively similar 237181 raw count.

But I don't really know what this counts unless it's actual seeks, and 
mine seems in good health still, certainly far better than the cooked 
value and worst of 1 might suggest.

> 240 Head_Flying_Hours       0x0000   100   253   000    Old_age Offline 
>     -       281032595099550

> OK, head flying hours explains it, drive is over 32 billion years old...
> 

While my spinning rust has this attribute and the cooked values are 
identical 100/253/0, the raw value is reported and formatted entirely 
differently, as 21122 (89 19 0).  I don't know what those values are, but 
presumably your big long value reports the others mine does, as well, 
only as a big long combined value.

Which would explain the apparent multi-billion years yours is reporting! 
=:^)  It's not a single value, it's multiple values somehow combined.

At least with my power-on hours of 23637, a head-flying hours of 21122 
seems reasonable.  (I only recently configured the BIOS to spin down that 
drive after 15 minutes I think, because it's only backups and my media 
partition which isn't mounted all the time anyway, so I might as well 
leave it off instead of idle-spinning when I might not use it for days at 
a time.  So a difference of a couple thousand hours between power-on and 
head-flying, on a base of 20K+ hours for both, makes sense given that I 
only recently configured it to spin down.)

But given your ~22K power-on hours, even simply peeling off the first 5 
digits of your raw value would be 28K head-flying, and that doesn't make 
sense for only 22K power-on, so obviously they're using a rather more 
complex formula than that.


So bottom line regarding that smartctl output, yeah, a new device is 
probably a very good idea at this point.  Those smart attributes indicate 
either head slop or spin wobble, and some errors and command timeouts and 
retries, which could well account for your huge slowdowns.  Fortunately, 
it's mostly backup, so you have your working copy, but if I'm not mixing 
up my threads, you have some media files, etc, on a different partition 
on it as well, and if you don't have backups elsewhere, getting them onto 
something else ASAP is a very good idea, because this drive does look to 
be struggling, and tho it could continue working in a low usage scenario 
for some time yet, it could also fail rather quickly, as well.

> As I am slowly producing this post raw_read_error_rate is now at
> 241507192.  But I did set  smartctl -t long /dev/sdc in motion if that
> is at all relevent.
> 
>>> <snip>
>>>
>>>> If I had 500 GiB SSDs like the one you're getting, I could put the
>>>> media partition on SSDs and be rid of the spinning rust entirely. 
>>>> But I seem to keep finding higher priorities for the money I'd spend
>>>> on a pair of them...
>>>
>>>
>>> I'm getting one, not two, so the system is raid0.  Data is more
>>> important (and backed up).
>> If you don't need the full terabyte of space, I would seriously suggest
>> using raid1 instead of raid0.  If you're using SSD's, then you won't
>> get much performance gain from BTRFS raid0 (because the I/O dispatching
>> is not particularly smart), and it also makes it more likely that you
>> will need to rebuild from scratch.
> 
> Confused.  I'm getting one SSD which I intend to use raid0.  Seems to me
> to make no sense to split it in two and put both sides of raid1 on one
> disk and I reasonably think that you are not suggesting that.  Or are
> you assuming that I'm getting two disks?  Or are you saying that buying
> a second SSD disk is strongly advised?  (bearing in mind that it looks
> like I might need another hdd if the smart field above is worth worrying
> about).

Well, raid0 normally requires two devices.  So either you mean single 
mode on a single device, or you're combining it with another device (or 
more than one more) to do raid0.

And if you're combining it with another device to do raid0, than the 
suggestion, unless you really need all the room from the raid0, is to do 
raid1, because the usual reason for raid0 is speed, and btrfs raid0 isn't 
yet particularly optimized so you don't get so much more speed than on a 
single device.  And raid0 has a much higher risk of failure because if 
any of the devices fail the whole filesystem is gone.

So raid0 really doesn't get you much besides the additional room of the 
multiple devices.

Meanwhile, in addition to the traditional device redundancy that you 
normally get with raid1, btrfs raid1 has some additional features as 
well, namely, data integrity due to checksumming, and the ability to 
repair a bad copy from the other one, assuming the other copy passes 
checksum verification.  While traditional raid1 lets you do a similar 
repair, because it doesn't have and verify the checksums like btrfs does, 
on traditional raid1, you're just as likely to be replacing the good copy 
with the bad one, as the other way around.  Btrfs' ability to actually 
repair bad data from a verified good second copy like that, is a very 
nice feature indeed, and having lived thru a failing ssd as I mentioned 
above, btrfs raid1 is not only what saved my data, it's what allowed me 
to continue playing with the failing ssd as I continued to use it well 
passed when I would have otherwise replaced it, so I could watch just how 
it behaved as it failed and get more experience with both that and 
working with btrfs raid1 recovery under that sort of situation.

So btrfs raid1 has data integrity and repair features that aren't 
available on normal raid1, and thus is highly recommended.

But, raid1 /does/ mean two copies of both data and metadata (assuming of 
course you make them both raid1, as I did), and if you simply don't have 
room to do it that way, you don't have room, highly recommended tho it 
may be.

Tho raid1 shouldn't be considered the same as a backup, because it's 
not.  In particular, while you do have reasonable protection against 
device failure, and with btrfs, against the data going bad, raid1, on its 
own, doesn't protect against fat-fingering, simply making a mistake and 
deleting something you shouldn't have, which as any admin knows, tends to 
be the greatest risk to data.  You need a real backup (or a snapshot) to 
recover from that.

Additionally, raid1 alone isn't going to help if the filesystem itself 
goes bad.  Neither will a snapshot, there.  You need a backup to recover 
in that case.

Similarly in the case of an electrical problem, robbery of the machine, 
or fire, since both/all devices in a raid1 will be affected together.  If 
you want to be able to recover your data in that case, better have a real 
backup, preferably kept offline except when actually making the backup, 
and even better, off-site.  For this sort of thing, in fact, the usual 
recommendation is at least two offsite backups, alternated such that if 
tragedy strikes when you're updating the one, taking it out as well, you 
still have the other one safe and sound, and will only lose the 
difference since that alternating backup, even when both your working 
copy and the other of the backups are both taken out at once.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

