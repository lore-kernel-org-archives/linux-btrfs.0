Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47568 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbaAZRTP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Jan 2014 12:19:15 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W7TMX-0002FH-Tw
	for linux-btrfs@vger.kernel.org; Sun, 26 Jan 2014 18:19:13 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Jan 2014 18:19:13 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Jan 2014 18:19:13 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Options for SSD - autodefrag etc?
Date: Sun, 26 Jan 2014 17:18:50 +0000 (UTC)
Message-ID: <pan$3b2b3$cc9fb70b$a75e7148$4cfd82fc@cox.net>
References: <52E2B73E.1050903@gmail.com>
	<7uuara-hf5.ln1@hurikhan77.spdns.de>
	<CAK5rZE6bF+z6Y9=X7SxtRPHE=1nNRPMmASC0VU8u90HQ_LbzVA@mail.gmail.com>
	<3664592.9YULOPb9vW@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald posted on Sat, 25 Jan 2014 15:01:13 +0100 as excerpted:

> Am Samstag, 25. Januar 2014, 15:33:08 schrieb Imran Geriskovan:
>> Every write on a SSD block reduces its data retension capability.
>> 
>> No concrete figures but it is assumed to be - 10 years for new devices
>> - 1 year at rated usage. (There are much lower figures around)
> 
> Where do you have these figures from?
> 
> For the Intel SSD 320 in this ThinkPad T520 I read about a minimal
> usable live of 5 years with 20 GB host writes each day in the tech
> specs. Thats 7300 GB a year or 7,3 TB. I assume metric system here.

The two of you are talking about two entirely different things.

1) SSD's limited write-cycle thing, which you're talking about, is widely 
known, and must be considered, but with modern wear-leveling it's not a 
/horrible/ concern under /reasonable/ (that is, not constant write/erase 
as if to benchmark or prove the point) usage.  While it's a real issue, I 
think it has been blown out of proportion, potentially by old-style 
spinning-rust manufacturers in ordered to maintain a market when it 
looked like SSD prices were going to drop to and below spinning rust 
prices within a few years (which they didn't do).

I don't remember the exact numbers I saw given at one point, but they 
were in the context of worry over using SSD for swap.  Suffice it to say 
that the level of constant writing to blow the write-cycle rating within 
a feasible swap-usage lifetime of 5 years was well beyond anything most 
people even with low memory would be doing.  Once I saw those numbers, I 
more or less quit /worrying/ about that, and started /considering/ it, 
but in a far more "yes, this is practical to use without excessive worry" 
context.

2) What (I think) Imran was talking about was something very different 
altho somewhat related, which has seemed to get far less attention, the 
actual memory cell on-the-shelf-archival data retention lifetime.

For comparison purposes and to make crystal clear that we're not talking 
about rewriting, it's well known that commercially pressed CDs have a 
useful lifetime of perhaps a few decades (15-25 years is what I've seen 
quoted) if treated /well/ (practically "well", still actually using them, 
not atmosphere-controlled file away for a decade and bring out to read 
once test then file away again data-archiving well), while CD-ROMs burnt 
at full rated 24x speed may retain their data for only perhaps 2-5 years, 
but reducing the write-speed to say 4x can often double or triple that, 
thus yielding a very reasonable decade or so of retention, midline, 
approaching commercial press lifetimes of a quarter century or so on the 
long end.

With current-use common SSD MLC-flash-memory technology, the cell-data-
retention lifetimes numbers I've seen are as Imran said, perhaps 10 years 
powered-off when new, a year at rated write-cycles, down as far as days 
or even hours past rating shortly before cell write failure.

*HOWEVER*, that's *UNPOWERED* data retention time.  Flash technology, 
like DRAM but on an order of hours/days/years instead of milliseconds, 
requires refreshing cell charge occasionally to maintain state.  Plug in 
that USB thumbdrive that you've written to a couple of times then 
forgotten until you find it again several years later, and it'll probably 
still work.  If the same thumbdrive was used as swap (impractical 
perhaps, but this is just a thought experiment example) on a low-memory 
machine for a year, such that it reached lifetime write rating, then 
unplugged and lost for a few years, then found and plugged in to see 
what's on it, very likely it'd be unreadable.

OTOH, plug that same thumbdrive into an internal USB connector on a 
regularly used machine, use it as swap for a year, then reconfigure not 
to use it as swap any longer but keep it in the machine and keep using 
the machine regularly, so the thumbdrive continues to receive power but 
isn't actually used to store anything for a few years, and when that 
machine dies and you're salvaging it before throwing out the dead hulk, 
and you find that forgotten thumb drive still plugged into its internal 
slot, the data from its last use may very well still be readable, because 
the thumb drive was regularly powered and the cells recharged the whole 
time it wasn't otherwise used.

Now apply that same idea to a standard SSD instead of a thumb drive.

But with SSDs still relatively expensive compared to spinning rust, such 
sit around unpowered for years, or even weeks, usage, just isn't that 
common.  And if the flash (in SSD or thumbdrive form) is regularly 
powered, the cells recharge and data should be retained.

So again, as long as SSDs remain more expensive and lower capacity than 
spinning rust (and as long as capacity doesn't reach petabytes for under 
$100 at near current data usage, such that the difference in cost is so 
trivial it ceases to be a factor), they're relatively unlikely to be used 
for archival storage where unpowered data retention under say a year is 
that much of a factor.  Sure, if unpowered retention life drops to weeks, 
someone might go on vacation and not power their work laptop for long 
enough to be a problem, but as long as unpowered retention remains a year 
or so at minimum, the issue isn't likely to hit the common person enough 
to hit the radar.

Still, as can be seen by Imram's post, it's a real concern for some, 
perhaps because the technology is new enough and unproven enough that 
they're worried the numbers aren't actually that good, and that they'll 
find themselves on the wrong end of an outlier, dead in the water after 
taking a week off.

But to quote you admittedly now out of context (since I happened to 
glance down and see your sentence, just waiting to be quoted in my new 
context! =:^) :

> So I am basically not concerned.

Particularly since I still have bootable spinning rust backups at this 
point in any case.  I might lose a few months of work as I'm not exactly 
keeping those backups current, but the risk is low enough and the work 
I'd lose uncritical enough, that's a risk I'm willing to take...


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

