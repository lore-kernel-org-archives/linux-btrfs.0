Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43818 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbbFPX7k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Jun 2015 19:59:40 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Z50km-0000IR-Mg
	for linux-btrfs@vger.kernel.org; Wed, 17 Jun 2015 01:58:52 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 01:58:52 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 01:58:52 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID10 Balancing Request for Comments and Advices
Date: Tue, 16 Jun 2015 23:58:13 +0000 (UTC)
Message-ID: <pan$966fb$92ec2f1c$291706f7$cf1b6c68@cox.net>
References: <1434456557.89597618@apps.rackspace.com>
	<20150616122545.GI9850@carfax.org.uk>
	<61CBE6C4-0D06-4F16-B522-4DBB756FBC31@up4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Vincent Olivier posted on Tue, 16 Jun 2015 09:34:29 -0400 as excerpted:


>> On Jun 16, 2015, at 8:25 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> 
>> On Tue, Jun 16, 2015 at 08:09:17AM -0400, Vincent Olivier wrote:
>>> 
>>> My first question is this : is it normal to have “single” blocks ?
>>> Why not only RAID10? I don’t remember the exact mkfs options I used
>>> but I certainly didn’t ask for “single” so this is unexpected.
>> 
>>  Yes. It's an artefact of the way that mkfs works. If you run a
>> balance on those chunks, they'll go away. (btrfs balance start
>> -dusage=0 -musage=0 /mountpoint)
> 
> Thanks! I did and it did go away, except for the "GlobalReserve, single:
> total=512.00MiB, used=0.00B”. But I suppose this is a permanent fixture,
> right?

Yes.  GlobalReserve is for short-term btrfs-internal use, reserved for 
times when btrfs needs to (temporarily) allocate some space in ordered to 
free space, etc.  It's always single, and you'll rarely see anything but 
0 used except perhaps in the middle of a balance or something.

>>  You don't need to balance after send/receive or rsync. If you find
>> that you have lots of data space allocated but not used (the first line
>> in btrfs fi df, above), *and* metadata close to usage (within, say, 700
>> MiB), *and* no unallocated space (btrfs fi show), then it's worth
>> running a filtered balance with -dlimit=3 or some similar small value
>> to free up some space that the metadata can expand into. Other than
>> that, it's pretty much entirely pointless.
> 
> Ok thanks. Is there a btrfs-utils way of automating the "if less than
> 1Gb free do balance -dlimit=3” ?

On a current kernel unlike older ones, btrfs actually automates entirely 
empty chunk reclaim, so this problem doesn't occur anything close to near 
as often as it used to.  However, it's still possible to have mostly but 
not entirely empty chunks that btrfs won't automatically reclaim.  A 
balance can be used to rewrite and combine these mostly empty chunks, 
reclaiming the space saved.  This is what Hugo was recommending.  Mostly-
empty chunk rebalance and reclaim is not (yet?) entirely automated, but 
in most use-cases it's not something you need to worry about that much.  
You do it if you notice a huge difference in available vs used in btrfs 
fi df, or if btrfs fi show drops below several gigs available, or if you 
start getting nospace errors, but otherwise, don't worry about it.

Tho of course you could script the check if desired, but then you'd 
simply script conditional logic to support your own special-case.

>>  For maintenance, I would suggest running a scrub regularly, to
>> check for various forms of bitrot. Typical frequencies for a scrub are
>> once a week or once a month -- opinions vary (as do runtimes).
> 
> 
> Yes. I cronned it weekly for now. Takes about 5 hours. Is it
> automatically corrected on RAID10 since a copy of it exist within the
> filesystem ? What happens for RAID0 ?

For raid10 (and the raid1 I use), yes, it's corrected, from the other 
existing copy, assuming it's good, tho if there are metadata checksum 
errors, there may be corresponding unverified checksums as well, where 
the verification couldn't be done because the metadata containing the 
checksums was bad.  Thus, if there are errors found and corrected, and 
you see unverified errors as well, rerun the scrub, so the newly 
corrected metadata can now be used to verify the previously unverified 
errors.

I'm presently getting a lot of experience with this as one of the ssds in 
my raid1 is gradually failing and rewriting sectors.  Generally what 
happens is that the ssd will take too long, triggering a SATA reset (30 
second timeout), and btrfs will call that an error.  The scrub then 
rewrites the bad copy on the unreliable device with the good copy from 
the more reliable device, with the write triggering a sector relocation 
on the bad device.  The newly written copy then checks out good, but if 
it was metadata, it very likely contained checksums for several other 
blocks, which couldn't be verified because the block containing their 
checksums was itself bad.  Typically I'll see dozens to a couple hundred 
unverified errors for every bad metadata block rewritten in this way.  
Rerunning the scrub then either verifies or fixes the previously 
unverified blocks, tho sometimes one of those in turn ends up bad and if 
it's a metadata block, I may end up rerunning the scrub another time or 
two, until everything checks out.

FWIW, on the bad device, smartctl -A reports (excerpted):

ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  5 Reallocated_Sector_Ct   0x0032   098   098   036    Old_age   Always       -       259
182 Erase_Fail_Count_Total  0x0032   100   100   000    Old_age   Always       -       132

While on the paired good device:

  5 Reallocated_Sector_Ct   0x0032   253   253   036    Old_age   Always       -       0
182 Erase_Fail_Count_Total  0x0032   253   253   000    Old_age   Always       -       0

Meanwhile, smartctl -H has already warned once that the device is 
failing, tho it went back to passing status again, but as of now it's 
saying failing, again.  The attribute that actually registers as failing, 
again from the bad device, followed by the good, is:

  1 Raw_Read_Error_Rate     0x000f   001   001   006    Pre-fail  Always   FAILING_NOW 3081

  1 Raw_Read_Error_Rate     0x000f   160   159   006    Pre-fail  Always       -       41                                                                   

When it's not actually reporting failing, the FAILING_NOW status is 
replaced with IN_THE_PAST.

250 Read_Error_Retry_Rate is the other attribute of interest, with values 
of 100 current and worst for both devices, threshold 0, but a raw value 
of 2488 for the good device and over 17,000,000 for the failing device. 
But with the "cooked" value never moving from 100 and with no real
guidance on how to interpret the raw values, while it's interesting, 
I am left relying on the others for indicators I can actually understand.

The 5 and 182 raw counts have been increasing gradually over time, and I 
scrub every time I do a major update, with another reallocated sector or 
two often appearing.  But as long as the paired good device keeps its zero 
count and I have backups (as I do!), btrfs is actually allowing me to 
continue using the unreliable device, relying on btrfs checksums and 
scrubbing to keep it usable.  And FWIW, I do have another device ready to 
go in when I decide I've had enough of this, but as long as I have 
backups and btrfs scrub keeps things fixed up, there's no real hurry 
unless I decide I'm tired of dealing with it.  Meanwhile, I'm having a 
bit of morbid fun watching as it slowly decays, getting experience of
the process in a reasonably controlled setting without serious danger
to my data, since it is backed up.


As for raid0 (and single), there's only one copy.  Btrfs detects checksum 
failure as it does above, but since there's only the one copy, if it's 
bad, well, for data you simply can't access that file any longer.  For 
metadata, you can't access whatever directories and files it referenced, 
any longer.  (FWIW for the truly desperate who hope that at least some of 
it can be recovered even if it's not a bit-perfect match, there's a btrfs 
command that wipes the checksum tree, which will let you access the 
previously bad-checksum files again, but it works on the entire 
filesystem so it's all or nothing, and of course with known corruption, 
there's no guarantees.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

