Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepi206.cox.net ([68.230.241.210]:39339 "EHLO
	eastrmfepi206.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbbJEPDy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Oct 2015 11:03:54 -0400
Received: from eastrmimpo306 ([68.230.241.238]) by eastrmfepo103.cox.net
          (InterMail vM.8.01.05.15 201-2260-151-145-20131218) with ESMTP
          id <20151005135920.XVRA7677.eastrmfepo103.cox.net@eastrmimpo306>
          for <linux-btrfs@vger.kernel.org>; Mon, 5 Oct 2015 09:59:20 -0400
Date: Mon, 5 Oct 2015 07:04:55 -0700
From: Duncan <1i5t5.duncan@cox.net>
To: Lionel Bouton <lionel-subscription@bouton.name>,
        linux-btrfs@vger.kernel.org
Subject: Re: BTRFS as image store for KVM?
Message-ID: <20151005070455.104464fe@ws>
In-Reply-To: <RPG31r00t34oj7R01PG5Us>
References: <55F88ECC.1040604@menke.ac>
 <201510021421.09558.russell@coker.com.au>
 <560E737C.7050206@gmail.com>
 <201510031832.17802.russell@coker.com.au>
 <pan$e9b6$f764fa8a$deeffa51$be52ef68@cox.net>
 <56111598.2080403@bouton.name>
 <RPG31r00t34oj7R01PG5Us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 5 Oct 2015 13:16:03 +0200
Lionel Bouton <lionel-subscription@bouton.name> wrote:

> To better illustrate my point.
> 
> According to Phoronix tests, BTRFS RAID-1 is even faster than md RAID1
> most of the time.
> 
> http://www.phoronix.com/scan.php?page=article&item=btrfs_raid_mdadm&num=1
> 
> The only case where md RAID1 was noticeably faster is sequential reads
> with FIO libaio.
> 
> So if you base your analysis on Phoronix tests

[Oops.  Actually send to the list too this time.]

FYI...

1) It's worth noting that while I personally think Phoronix has more
merit than sometimes given credit for, it does have a rather bad rep in
kernel circles, due to how results are (claimed to be) misused in
support of points they don't actually support at all, if you know how
to read the results taking into account the configuration used.

As such, Phoronix is about the last reference you want to be using if
trying to support points with kernel folks, because rightly or wrongly,
a lot of them will see that and simply shut down right there, having
already decided based on previous experience that there's little use
arguing with somebody quoting Phoronix, since they invariably don't
know how to read the results based on what was /actually/ tested given
the independent variable and the test configuration.

Tho I personally actually do find quite some use for various Phoronix
benchmark articles, reading them with the testing context in mind.  But
I definitely wouldn't be pulling them out to demonstrate a point to
kernel folks, unless it was near enough the end of a list of references
making a similar point, after I've demonstrated my ability to keep the
testing context in mind when looking at their results, because I know
based on the history, quoting Phoronix in support of something simply
isn't likely to get me anywhere with kernel folks.


As for the specific test you referenced...

2) At least the URL you pointed at was benchmarks for Intel
SSDs, not spinning rust.  The issues and bottlenecks in the case of
good SSDs are so entirely different than for spinning rust that it's an
entirely different debate.  Among other things, good SATA-based SSDs
are and have been for awhile now, so fast that if the tests really are
I/O bound, SATA-bus speed (thru SATA 3.0, 600 MB/s, anyway, SATA 3.2
aka SATA Express and M.2, 1969 MB/s, are fast enough to often put the
bottleneck on the device, again), not device speed, tends to be the
bottleneck. However, in many cases, because good SSDs and modern buses
are so fast, the bottleneck actually ends up being CPU, once again.

So in the case of good reasonably current SSDs, CPU is likely to be the
bottleneck.  Tho these aren't as current as might be expected...

The actual devices tested here are SATA 2, 300 MB/s bus speed, and are
rather dated given the Dec 2014 article date, as they're only rated 205
MB/s read, 45 MB/s write, so only read is anything near bus speed,
while bus speed itself is only SATA 2, 300 MB/s.

Given that, it's likely that write speed is device-bound, and while
raid isn't likely to slow it down despite the multi-time-writing
because it /is/ device-bound, it's unlikely to be faster than
single-device writing, either.

But this thread was addressing read-speed.  Read-speed is much closer
to the bus speed, and depending on the application, particularly for
raid, may well be CPU-bound.  Where it's CPU-bound, because the device
and bus speed are relatively high, the multiple devices of RAID aren't
likely to be of much benefit at all.

Meanwhile, what was the actual configuration on the devices themselves?

Here, we see that in both cases it was actually btrfs, btrfs with
defaults as installed (in single-device-mode, if reading between the
lines) on top of md/raid of the tested level for the md/raid side,
native btrfs raid of the tested level on the native btrfs raid side.

But... there's already so much that isn't known -- he says defaults
where not stated, but that's still ambiguous in some cases.

For instance, he does specifically state that in native mode, btrfs
detects the ssds, and activates ssd mode, but that it doesn't do so
when installed on the md/raid.  So we know for sure that he took the
detected ssd (or not) defaults there.

But...  we do NOT know... does btrfs native raid level mean for both
data and metadata, or only for (presumably) data, leaving metadata at
the defaults (which is raid1 for multi-device), or perhaps the
reverse, tested level metadata, defaults for data (which AFAIK is
single mode for multi-device).

And in single-device btrfs on top of md/raid mode, with the md/raid at
the tested level, we already know that it didn't detect ssd and enable
ssd mode, and he didn't enable it manually, but what we /don't/ know
for sure is how it was installed at mkfs.btrfs time and whether that
might have detected ssd.   If mkfs.btrfs detected ssd, it would have
created single-mode metadata by default, otherwise, dup mode metadata,
unless specifically told otherwise.

If he /really/ meant /defaults/ unless stated otherwise, then the btrfs
on top of md/raid was pretty obviously running with known
deoptimizations compared to what one would sanely run in that case.
For instance, the metadata will be dup on a single-device as far as
btrfs is concerned, due to the non-detection of ssd, while for raid1
and raid10 modes, that's actually duped again, *4*-way duped again, for
8-way-duped total, in the 4-way-md/raid-1 case.

And that's not even counting the effect of the lack of ssd on chunk
placement.

Meanwhile, on the native btrfs side, it's detecting ssd, and optimizing
accordingly.

So, it's /very/ /possible/ that the apparently bad for md/raid1 results
you see for the btrfs on top of md/raid1 case, aren't really due to
md/raid1 scheduling problems as compared to btrfs native raid1
scheduling, in the first place, but rather, due to a combination of the
obviously ssd-deoptimized btrfs defaults in that mode, and the
relatively high per-device read-speeds of ssd (even those ancient sata
2 ssds), along with zero-seek-time of ssd.

The way to disprove that would obviously be to run the same set of
tests, but with the btrfs configured for ssd mode at runtime so as not
to use the default, and both data and metadata modes specified,
presumably single for both, for the case where it's deployed over
md/raid1.

That in a thread where the previous context was spinning rust, with its
definitely *not* zero seek-times, and generally rather slower sequential
per-device I/O speeds, as well.  So even if there weren't massive
issues with the Phoronix tests as displayed in that article, with btrfs
so deoptimized in the on-md/raid case no real conclusions about a sane
configuration can be made, the fact that the article was reporting on
(rather old and slow for ssds, but still fast at reading compared to
spinning rust) ssds, while the discussion was in the context of more
traditional spinning rust, means that it shouldn't have been introduced
here, at least without big caveats that it was dealing with the ssd
use-case.

Hmm... I think I've begun to see the kernel folks point about people
quoting Phoronix in support of their points, when it's really not
apropos at all.  Yes, I do still consider Phoronix reports in context
to contain useful information, at some level.  However, one really must
be aware of what was actually tested in ordered to understand what the
results actually mean, and unfortunately, it seems most people quoting
it, including here, really can't properly do so in context, and thus
end up using it in support of points that simply are not supported by
the given evidence in the Phoronix articles people are attempting to
use.

-- 
Duncan - No HTML messages please; they are filtered as spam.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman
